import XCTest
import Combine

@MainActor
final class GenerateImageViewModelTests: XCTestCase {
    private var subscriptions = Set<AnyCancellable>()
    
    override func tearDown() {
        subscriptions.removeAll()
        
        super.tearDown()
    }
    
    func test_onAppear_showsToolbar() async {
        let sut = createSut()
        
        await setsExpected(value: [.tools], on: sut.$currentSubviews) {
            sut.onAppear()
        }
    }
    
    func test_tappedBackground_togglesToolbar() async {
        let sut = createSut()
        
        await setsExpected(value: [.tools], on: sut.$currentSubviews) {
            sut.tappedBackground()
        }
        
        await setsExpected(value: [], on: sut.$currentSubviews) {
            sut.tappedBackground()
        }
    }
    
    func test_tappedGenerateImage_withNoThemeSelection_setsErrorText() async {
        let sut = createSut()
        
        sut.selectedThemes = []
        
        await expectedError(in: sut) {
            sut.tapped(on: .generate)
        }
        
        XCTAssertEqual(sut.messageModel?.message, "A theme has to be selected.")
    }
    
    func test_selectedTheme_setsSelectedThemesToQuery() async {
        let mockImageGenerator = MockImageGenerator()
        let sut = createSut(imageGenerator: mockImageGenerator)
        
        let dummyThemes: Set<Theme> = [.cyberpunk, .nature]
        sut.selectedThemes = dummyThemes
        
        await expectedGeneratedImage(in: sut) {
            sut.tapped(on: .generate)
        }
        
        XCTAssertEqual(mockImageGenerator.passedImageQuery?.themes, dummyThemes)
    }
    
    func test_selectedColor_setsSelectedColorToQuery() async {
        let mockImageGenerator = MockImageGenerator()
        let sut = createSut(imageGenerator: mockImageGenerator)
        
        sut.selectedColor = .red
        
        await expectedGeneratedImage(in: sut) {
            sut.tapped(on: .generate)
        }
        
        XCTAssertEqual(mockImageGenerator.passedImageQuery?.color, "red")
    }
    
    func test_tappedGenerateImage_withSuccess_setsImage() async {
        let sut = createSut()
        
        await expectedGeneratedImage(in: sut) {
            sut.tapped(on: .generate)
        }
        
        XCTAssertNil(sut.messageModel)
        XCTAssertFalse(sut.isLoading)
    }
    
    func test_tappedGenerateImage_withError_setsErrorText() async {
        let mockImageGenerator = MockImageGenerator()
        let sut = createSut(imageGenerator: mockImageGenerator)
        let dummyError = ImageGeneratingError.incompleteQuery
        
        mockImageGenerator.generateImageError = dummyError
        
        await expectedError(in: sut) {
            sut.tapped(on: .generate)
        }
        
        XCTAssertNil(sut.generatedImage)
        XCTAssertEqual(sut.messageModel?.message, dummyError.errorDescription)
        XCTAssertFalse(sut.isLoading)
    }
    
    func test_tappedGenerateImage_resetsErrorText() async {
        let mockImageGenerator = MockImageGenerator()
        let sut = createSut(imageGenerator: mockImageGenerator)
        let dummyError = ImageGeneratingError.incompleteQuery
        
        mockImageGenerator.generateImageError = dummyError
        
        await expectedError(in: sut) {
            sut.tapped(on: .generate)
        }
        
        mockImageGenerator.generateImageError = nil
        
        await expectedGeneratedImage(in: sut) {
            sut.tapped(on: .generate)
        }
        
        XCTAssertNil(sut.messageModel)
    }
    
    func test_tappedGenerateImage_togglesIsLoading() {
        let sut = createSut()
        
        let expectation1 = XCTestExpectation(description: "enables isLoading")
        let expectation2 = XCTestExpectation(description: "disables isLoading")
        
        sut.$isLoading
            .dropFirst()
            .sink { value in
                if value {
                    expectation1.fulfill()
                } else {
                    expectation2.fulfill()
                }
            }
            .store(in: &subscriptions)
        
        sut.tapped(on: .generate)
        
        wait(for: [expectation1, expectation2], timeout: 0.1)
        
        XCTAssertFalse(sut.isLoading)
    }
    
    func test_tappedSaveImage() async {
        let mockImageSaver = MockImageSaver()
        let sut = createSut(imageSaver: mockImageSaver)
        
        await expectedGeneratedImage(in: sut) {
            sut.tapped(on: .generate)
        }
        
        await expectedValue(from: sut.$isLoading) {
            sut.tapped(on: .save)
        }
        
        XCTAssertEqual(mockImageSaver.saveToPhotoAlbumCallCount, 1)
        XCTAssertEqual(mockImageSaver.saveToPhotoAlbumImage, sut.generatedImage)
    }
}

// MARK: - Test helpers
extension GenerateImageViewModelTests {
    private func createSut(
        imageGenerator: ImageGenerating = MockImageGenerator(),
        imageSaver: ImageSaving = MockImageSaver(),
        router: GenerateImageRouting = MockGenerateImageRouter()
    ) -> GenerateImageViewModel {
        GenerateImageViewModel(
            imageGenerator: imageGenerator,
            imageSaver: imageSaver,
            router: router
        )
    }
    
    private func expectedError(in sut: GenerateImageViewModel, action: @escaping () -> Void) async {
        await expectedValue(from: sut.$messageModel, action: action)
    }
    
    private func expectedGeneratedImage(in sut: GenerateImageViewModel, action: @escaping () -> Void) async {
        await expectedValue(from: sut.$generatedImage, action: action)
    }
    
    private func expectedValue<T>(from publisher: Published<T>.Publisher, action: @escaping () -> Void) async {
        let expectation = XCTestExpectation(description: "sets value")
        
        publisher
            .dropFirst()
            .sink { _ in
                expectation.fulfill()
            }
            .store(in: &subscriptions)
        
        action()
        
        await fulfillment(of: [expectation], timeout: 0.1)
    }
}

final class MockImageSaver: NSObject, ImageSaving {
    private(set) var saveToPhotoAlbumImage: UIImage?
    private(set) var saveToPhotoAlbumCallCount = 0
    
    var saveToPhotoAlbumError: Error?
    
    func saveToPhotoAlbum(image: UIImage) async throws {
        saveToPhotoAlbumCallCount += 1
        saveToPhotoAlbumImage = image
        
        if let saveToPhotoAlbumError {
            throw saveToPhotoAlbumError
        }
    }
}

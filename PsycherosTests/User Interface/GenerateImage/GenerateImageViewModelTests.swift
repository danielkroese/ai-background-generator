import XCTest
import Combine

final class GenerateImageViewModelTests: XCTestCase {
    private var subscriptions = Set<AnyCancellable>()
    
    override func tearDown() {
        subscriptions.removeAll()
        
        super.tearDown()
    }
    
    func test_selectedTheme_withNoSelection_setsErrorText() async {
        let sut = createSut()
        
        await expectedError(in: sut) {
            sut.selected(themes: [])
        }
    }
    
    func test_selectedTheme_setsSelectedThemesToQuery() async {
        let mockImageGenerator = MockImageGenerator()
        let sut = createSut(imageGenerator: mockImageGenerator)
        
        let dummyThemes: Set<Theme> = [.cyberpunk, .nature]
        sut.selected(themes: dummyThemes)
        
        await expectedGeneratedImage(in: sut) {
            sut.tappedGenerateImage()
        }
        
        XCTAssertEqual(mockImageGenerator.passedImageQuery?.themes, dummyThemes)
    }
    
    func test_selectedColor_setsSelectedColorToQuery() async {
        let mockImageGenerator = MockImageGenerator()
        let sut = createSut(imageGenerator: mockImageGenerator)
        
        sut.selected(color: "red")
        
        await expectedGeneratedImage(in: sut) {
            sut.tappedGenerateImage()
        }
        
        XCTAssertEqual(mockImageGenerator.passedImageQuery?.color, "red")
    }
    
    func test_tappedGenerateImage_withSuccess_setsImage() async {
        let sut = createSut()
        
        await expectedGeneratedImage(in: sut) {
            sut.tappedGenerateImage()
        }
        
        XCTAssertNil(sut.errorText)
        XCTAssertFalse(sut.isLoading)
    }
    
    func test_tappedGenerateImage_withError_setsErrorText() async {
        let mockImageGenerator = MockImageGenerator()
        let sut = createSut(imageGenerator: mockImageGenerator)
        let dummyError = ImageGeneratingError.incompleteQuery
        
        mockImageGenerator.generateImageError = dummyError
        
        await expectedError(in: sut) {
            sut.tappedGenerateImage()
        }
        
        XCTAssertNil(sut.generatedImage)
        XCTAssertEqual(sut.errorText, dummyError.rawValue)
        XCTAssertFalse(sut.isLoading)
    }
    
    func test_tappedGenerateImage_resetsErrorText() async {
        let mockImageGenerator = MockImageGenerator()
        let sut = createSut(imageGenerator: mockImageGenerator)
        let dummyError = ImageGeneratingError.incompleteQuery
        
        mockImageGenerator.generateImageError = dummyError
        
        await expectedError(in: sut) {
            sut.tappedGenerateImage()
        }
        
        mockImageGenerator.generateImageError = nil
        
        await expectedGeneratedImage(in: sut) {
            sut.tappedGenerateImage()
        }
        
        XCTAssertNil(sut.errorText)
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
        
        sut.tappedGenerateImage()
        
        wait(for: [expectation1, expectation2], timeout: 0.1)
        
        XCTAssertFalse(sut.isLoading)
    }
}

// MARK: - Test helpers
extension GenerateImageViewModelTests {
    private func createSut(
        imageGenerator: ImageGenerating = MockImageGenerator()
    ) -> GenerateImageViewModel {
        GenerateImageViewModel(imageGenerator: imageGenerator)
    }
    
    private func expectedError(in sut: GenerateImageViewModel, action: @escaping () -> Void) async {
        await expectedValue(from: sut.$errorText, action: action)
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

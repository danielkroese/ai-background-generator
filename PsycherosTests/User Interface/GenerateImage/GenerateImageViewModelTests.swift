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
        let mockRouter = MockGenerateImageRouter()
        let sut = createSut(router: mockRouter)
        
        sut.onAppear()
        
        XCTAssertEqual(mockRouter.calledPresentCount, 1)
        XCTAssertEqual(mockRouter.calledPresentElement, .tools)
    }
    
    func test_tappedBackground_callsRouter() async {
        let mockRouter = MockGenerateImageRouter()
        let sut = createSut(router: mockRouter)
        
        sut.tappedBackground()
        
        XCTAssertEqual(mockRouter.calledTappedBackgroundCount, 1)
    }
    
    func test_tappedGenerateImage_callsRouterToCloseViews() async {
        let mockRouter = MockGenerateImageRouter()
        let sut = createSut(router: mockRouter)
        
        sut.tapped(on: .generate)
        
        XCTAssertEqual(mockRouter.calledDismissAllCount, 1)
        XCTAssertEqual(mockRouter.calledDismissAllExceptElement, .tools)
    }
    
    func test_tappedGenerateImage_withNoThemeSelection_setsErrorText() async {
        let sut = createSut()
        
        sut.selectedThemes = []
        sut.tapped(on: .generate)
        
        await imageTaskCompletion(in: sut)
        
        XCTAssertEqual(sut.messageModel?.message, "A theme has to be selected.")
    }
    
    func test_selectedTheme_setsSelectedThemesToQuery() async {
        let mockImageGenerator = MockImageGenerator()
        let sut = createSut(imageGenerator: mockImageGenerator)
        
        let dummyThemes: Set<Theme> = [.cyberpunk, .nature]
        sut.selectedThemes = dummyThemes
        sut.tapped(on: .generate)
        
        await imageTaskCompletion(in: sut)
        
        XCTAssertEqual(mockImageGenerator.passedImageQuery?.themes, dummyThemes)
    }
    
    func test_selectedColor_setsSelectedColorToQuery() async {
        let mockImageGenerator = MockImageGenerator()
        let sut = createSut(imageGenerator: mockImageGenerator)
        
        sut.selectedColor = .red
        sut.tapped(on: .generate)
        
        await imageTaskCompletion(in: sut)
        
        XCTAssertEqual(mockImageGenerator.passedImageQuery?.color, "red")
    }
    
    func test_tappedGenerateImage_withSuccess_setsImage() async {
        let sut = createSut()
        
        sut.tapped(on: .generate)
        
        await imageTaskCompletion(in: sut)
        
        XCTAssertNil(sut.messageModel)
        XCTAssertFalse(sut.isLoading)
    }
    
    func test_tappedGenerateImage_withError_setsErrorText() async {
        let mockImageGenerator = MockImageGenerator()
        let sut = createSut(imageGenerator: mockImageGenerator)
        let dummyError = ImageGeneratingError.incompleteQuery
        
        mockImageGenerator.generateImageError = dummyError
        
        sut.tapped(on: .generate)
        
        await imageTaskCompletion(in: sut)
        
        XCTAssertNil(sut.generatedImage)
        XCTAssertEqual(sut.messageModel?.message, dummyError.errorDescription)
        XCTAssertFalse(sut.isLoading)
    }
    
    func test_tappedGenerateImage_resetsErrorText() async {
        let mockImageGenerator = MockImageGenerator()
        let sut = createSut(imageGenerator: mockImageGenerator)
        let dummyError = ImageGeneratingError.incompleteQuery
        
        mockImageGenerator.generateImageError = dummyError
        
        sut.tapped(on: .generate)
        
        mockImageGenerator.generateImageError = nil
        
        sut.tapped(on: .generate)
        
        await imageTaskCompletion(in: sut)
        
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
        
        sut.tapped(on: .generate)
        
        await imageTaskCompletion(in: sut)
        
        sut.tapped(on: .save)
        
        await imageTaskCompletion(in: sut)
        
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
    
    private func imageTaskCompletion(in sut: GenerateImageViewModel) async {
        _ = await sut.imageTask?.result
    }
}

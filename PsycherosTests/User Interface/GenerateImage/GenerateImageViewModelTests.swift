import XCTest
import Combine

final class GenerateImageViewModelTests: XCTestCase {
    private var subscriptions = Set<AnyCancellable>()
    
    override func tearDown() {
        subscriptions.removeAll()
        
        super.tearDown()
    }
    
    func test_selectedTheme_withNoSelection_setsErrorText() {
        let sut = createSut()
        
        
        let expectation = XCTestExpectation(description: "sets error")
        
        sut.$errorText
            .dropFirst()
            .sink { _ in
                expectation.fulfill()
            }
            .store(in: &subscriptions)
        
        sut.selected(themes: [])
        
        wait(for: [expectation], timeout: 0.1)
    }
    
    func test_selectedTheme_setsSelectedThemesToQuery() async {
        let mockImageGenerator = MockImageGenerator()
        let sut = createSut(imageGenerator: mockImageGenerator)
        
        let dummyThemes: [Theme] = [.cyberpunk, .nature]
        sut.selected(themes: dummyThemes)
        
        await waitForGeneratedImage(in: sut)
        
        XCTAssertEqual(mockImageGenerator.passedImageQuery?.themes, dummyThemes)
    }
    
    func test_tappedGenerateImage_withSuccess_setsImage() async {
        let sut = createSut()
        
        await waitForGeneratedImage(in: sut)
        
        XCTAssertNil(sut.errorText)
        XCTAssertFalse(sut.isLoading)
    }
    
    func test_tappedGenerateImage_withError_setsErrorText() {
        let mockImageGenerator = MockImageGenerator()
        let sut = createSut(imageGenerator: mockImageGenerator)
        
        mockImageGenerator.generateImageError = ImageGeneratingError.incompleteQuery
        
        let expectation = XCTestExpectation(description: "sets error")
        
        sut.$errorText
            .dropFirst()
            .sink { _ in
                expectation.fulfill()
            }
            .store(in: &subscriptions)
        
        sut.tappedGenerateImage()
        
        wait(for: [expectation], timeout: 0.1)
        
        XCTAssertNil(sut.generatedImage)
        XCTAssertFalse(sut.isLoading)
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
    
    private func waitForGeneratedImage(in sut: GenerateImageViewModel) async {
        let expectation = XCTestExpectation(description: "sets image")
        
        sut.$generatedImage
            .dropFirst()
            .sink { _ in
                expectation.fulfill()
            }
            .store(in: &subscriptions)
        
        sut.tappedGenerateImage()
        
        await fulfillment(of: [expectation], timeout: 0.1)
    }
}

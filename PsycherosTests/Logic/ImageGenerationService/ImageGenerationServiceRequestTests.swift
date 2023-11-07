import XCTest

final class ImageGenerationServiceRequestTests: XCTestCase {
    func test_init_withEndpoint_setsRequestUrl() {
        let sut = ImageGenerationServiceRequest(endpoint: dummyUrl)
        
        XCTAssertEqual(dummyUrl, sut.request.url)
    }
    
    func test_prompt_setsExpectedBody() {
        do {
            let sut = try ImageGenerationServiceRequest(endpoint: dummyUrl)
                .prompt("scape, landscape, ecstatic, happy, color blue")
            
            let expectedHttpBody = ImageRequestModel(
                steps: 40,
                width: 1024,
                height: 1024,
                seed: 0,
                cfgScale: 5,
                samples: 1,
                textPrompts: [
                    .init(text: "scape, landscape, ecstatic, happy, color blue", weight: 1),
                    .init(text: "blurry, bad", weight: -1)
                ]
            )
            
            guard let sutHttpBody = sut.request.httpBody else {
                XCTFail("No http body set")
                return
            }
            
            let decodedHttpBody = try JSONDecoder().decode(ImageRequestModel.self, from: sutHttpBody)
            
            XCTAssertEqual(expectedHttpBody, decodedHttpBody)
        } catch {
            XCTFail("Unexpected error: \(error.localizedDescription)")
            return
        }
    }
}

extension ImageGenerationServiceRequestTests {
    private var dummyUrl: URL {
        guard let url = URL(string: "https://danielkroese.nl/") else {
            XCTFail("url unexpectedly nil")
            return .homeDirectory
        }
        
        return url
    }
}

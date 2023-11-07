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
            
            let expectedHttpBody: [String: Any] = [
                "steps": 40,
                "width": 1024,
                "height": 1024,
                "seed": 0,
                "cfg_scale": 5,
                "samples": 1,
                "text_prompts": [
                  ["text": "scape, landscape, ecstatic, happy, color blue", "weight": 1],
                  ["text": "blurry, bad, text", "weight": -1]
                ]
              ]
            
            let jsonData = try JSONSerialization.data(withJSONObject: expectedHttpBody, options: [])
            
            XCTAssertEqual(jsonData), sut.request.httpBody)
        } catch {
            XCTFail("could not encode dummy data")
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

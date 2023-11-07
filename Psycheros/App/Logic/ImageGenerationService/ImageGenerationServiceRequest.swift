import Foundation

protocol ImageGenerationServiceRequesting {
    var url: String { get }
}

struct ImageGenerationServiceRequest: ImageGenerationServiceRequesting {
    private(set) var url: String = "https://"
}


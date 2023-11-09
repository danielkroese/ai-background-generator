import Foundation

enum ImageRequestModelError: Error {
    case emptyPrompt,
         invalidSeed
}

struct ImageRequestModel: Codable, Equatable {
    let steps: Int
    let width: Int
    let height: Int
    let seed: Int
    let cfgScale: Int
    let samples: Int
    let textPrompts: [TextPrompt]
    
    struct TextPrompt: Codable, Equatable {
        let text: String
        let weight: Int
    }
    
    enum CodingKeys: String, CodingKey {
        case steps, width, height, seed, samples
        case cfgScale = "cfg_scale"
        case textPrompts = "text_prompts"
    }
    
    private enum Constants {
        static let steps = 40
        static let cfgScale = 5
        static let samples = 1
        static let seedRange = 0...4294967295
        static let negativePrompt = "blurry, bad, text"
    }
    
    init(prompt: String,
         seed: Int = Int.random(in: Constants.seedRange),
         size: ImageSize = .size1024x1024) throws {
        self.steps = Constants.steps
        self.width = size.width
        self.height = size.height
        self.seed = seed
        self.cfgScale = Constants.cfgScale
        self.samples = Constants.samples
        self.textPrompts = [
            .init(text: prompt, weight: 1),
            .init(text: Constants.negativePrompt, weight: -1)
        ]
        
        try validate()
    }
    
    private func validate() throws {
        guard (textPrompts.allSatisfy { $0.text.isNotEmpty }) else {
            throw ImageRequestModelError.emptyPrompt
        }
        
        guard (textPrompts.allSatisfy { $0.weight.isBetween(-1, and: 1) }) else {
            throw ImageRequestModelError.emptyPrompt
        }
        
        guard Constants.seedRange.contains(seed) else {
            throw ImageRequestModelError.invalidSeed
        }
    }
}

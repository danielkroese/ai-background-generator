import Foundation

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
         size: CGSize = CGSize(width: 1024, height: 1024)) {
        self.steps = Constants.steps
        self.width = Int(size.width)
        self.height = Int(size.height)
        self.seed = seed
        self.cfgScale = Constants.cfgScale
        self.samples = Constants.samples
        self.textPrompts = [
            .init(text: prompt, weight: 1),
            .init(text: Constants.negativePrompt, weight: -1)
        ]
    }
    
    var isValid: Bool {
        width > 0 &&
        height > 0 &&
        textPrompts.allSatisfy { $0.text.isEmpty == false }
    }
}

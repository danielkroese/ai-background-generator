struct ImageRequestModel: Codable, Equatable {
    let steps: Int
    let width: Int
    let height: Int
    let seed: Int
    let cfgScale: Double
    let samples: Int
    let textPrompts: [TextPrompt]
    
    enum CodingKeys: String, CodingKey {
        case steps, width, height, seed, samples
        case cfgScale = "cfg_scale"
        case textPrompts = "text_prompts"
    }
    
    struct TextPrompt: Codable, Equatable {
        let text: String
        let weight: Int
    }
}

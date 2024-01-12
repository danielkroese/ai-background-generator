import Foundation

protocol PromptGenerating {
    static func writePrompt(with query: ImageQuery) throws -> String
}

enum PromptGeneratingError: Error {
    case incompleteQuery
}

struct PromptGenerator: PromptGenerating {
    static func writePrompt(with query: ImageQuery) throws -> String {
        guard query.isNotEmpty else {
            throw PromptGeneratingError.incompleteQuery
        }
        
        return createPrompt(with: query)
    }
    
    private static func createPrompt(with query: ImageQuery) -> String {
        let themes = parse(themes: query.themes)
        
        return "\(themes), " +
        "with an overwhelming amount of the color \(query.color), " +
        "in an iphone portrait ratio"
    }
    
    private static func parse(themes: Set<Theme>) -> String {
        let strings = themes.map { theme in
            return switch theme {
            case .space:
                "outer space with galaxies and nebulas"
            case .island:
                "a beautiful island with blue waters"
            case .nature:
                "a lush tropical nature forest"
            case .cyberpunk:
                "a cyberpunk style landscape"
            }
        }
        
        
        return strings.joined(separator: ", with ")
    }
}

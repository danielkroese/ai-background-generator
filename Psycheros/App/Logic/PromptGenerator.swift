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
        let feelings = parse(feelings: query.feelings)
        
        return "Generate a motivational image " +
        "for someone who is feeling \(feelings), " +
        "using the color \(query.color) in an iphone ratio"
    }
    
    private static func parse(feelings: [Feeling]) -> String {
        let strings = feelings.map { $0.rawValue }
        
        return strings.joined(separator: ", ")
    }
}

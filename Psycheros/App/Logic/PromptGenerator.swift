import Foundation

protocol PromptGenerating {
    func writePrompt(with query: ImageQuery) throws -> String
}

enum PromptGeneratingError: Error {
    case incompleteQuery
}

final class PromptGenerator: PromptGenerating {
    func writePrompt(with query: ImageQuery) throws -> String {
        guard query.isEmpty == false else {
            throw PromptGeneratingError.incompleteQuery
        }
        
        return createPrompt(with: query)
    }
    
    private func createPrompt(with query: ImageQuery) -> String {
        let feelings = parse(feelings: query.feelings)
        
        return "Generate a motivational image " +
        "for someone who is feeling \(feelings), " +
        "using the color \(query.color) in an iphone ratio"
    }
    
    private func parse(feelings: [Feeling]) -> String {
        let strings = feelings.map { $0.rawValue }
        
        return strings.joined(separator: ", ")
    }
}

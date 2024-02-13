import SwiftUI

struct Message: ViewModifier {
    let message: String?
    
    func body(content: Content) -> some View {
        content
            .alert(message ?? "unknown error", isPresented: .constant(message != nil)) {
                Text("Close")
            } message: {
                Text("")
            }
    }
}

extension View {
    func message(_ text: String?) -> some View {
        modifier(Message(message: text))
    }
}

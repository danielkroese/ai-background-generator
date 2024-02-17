import SwiftUI

struct Message: ViewModifier {
    struct Model: Equatable {
        let title: String
        let message: String
    }
    
    let model: Model?
    
    func body(content: Content) -> some View {
        content
            .alert(model?.title ?? "", isPresented: .constant(model != nil)) {
                Text("Close")
            } message: {
                Text(model?.message ?? "")
            }
    }
}

extension View {
    func message(_ model: Message.Model?) -> some View {
        modifier(Message(model: model))
    }
}

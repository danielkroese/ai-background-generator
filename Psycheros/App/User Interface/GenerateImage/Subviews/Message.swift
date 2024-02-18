import SwiftUI

struct Message: ViewModifier {
    @Binding var model: MessageModel?
    
    func body(content: Content) -> some View {
        content
            .alert(model?.title ?? "", isPresented: .constant(model != nil)) {
                Button(role: .cancel) {
                    model = nil
                } label: {
                    Text("Close")
                }
                
            } message: {
                Text(model?.message ?? "")
            }
    }
}

extension View {
    func message(_ model: Binding<MessageModel?>) -> some View {
        modifier(Message(model: model))
    }
}

#Preview {
    Text("Hello")
        .message(.constant(.init(title: "title", message: "message")))
}

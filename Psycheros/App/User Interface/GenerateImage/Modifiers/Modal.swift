import SwiftUI

struct Modal<ModalContent: View>: ViewModifier {
    let isPresented: Bool
    
    @ViewBuilder let modalContent: () -> ModalContent
    
    @State private var modalContentSize: CGSize = .zero
    @State private var contentSize: CGSize = .zero
    
    func body(content: Content) -> some View {
        ZStack {
            content
                .geometryReader { contentSize = $0.size }
            
            RoundedRectangle(cornerRadius: 24)
                .fill(.background)
                .frame(
                    maxWidth: modalContentSize.width,
                    maxHeight: modalContentSize.height
                )
                .overlay {
                    modalContent()
                        .frame(
                            maxWidth: contentSize.width,
                            maxHeight: contentSize.height
                        )
                        .fixedSize()
                        .geometryReader { modalContentSize = $0.size }
                }
                .transition(.scale)
                .animation(.bouncy, value: isPresented)
                .offset(y: isPresented ? .zero : contentSize.height)
                .shadowModifier()
        }
    }
}

extension View {
    func modal(
        isPresented: Bool,
        @ViewBuilder modalContent: @escaping () -> some View
    ) -> some View {
        self.modifier(Modal(isPresented: isPresented, modalContent: modalContent))
    }
}

#Preview {
    Text("Hello, world!")
        .modal(isPresented: true) {
            HStack(spacing: 32) {
                Text("Hello modal!")
            }
        }
}

import SwiftUI

struct Modal<ModalContent: View>: ViewModifier {
    let isPresented: Bool
    
    @ViewBuilder let modalContent: () -> ModalContent
    
    @State private var modalContentSize: CGSize = .zero
    @State private var contentHeight = 0.0
    
    func body(content: Content) -> some View {
        ZStack {
            content
                .geometryReader { contentHeight = $0.size.height }
            
            RoundedRectangle(cornerRadius: 24)
                .fill(.background)
                .frame(
                    maxWidth: modalContentSize.width,
                    maxHeight: modalContentSize.height
                )
                .overlay {
                    modalContent()
                        .padding(32)
                        .fixedSize()
                        .geometryReader { modalContentSize = $0.size }
                }
                .transition(.scale)
                .animation(.bouncy, value: isPresented)
                .offset(y: isPresented ? .zero : contentHeight)
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

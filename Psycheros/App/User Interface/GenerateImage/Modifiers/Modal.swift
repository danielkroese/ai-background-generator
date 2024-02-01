import SwiftUI

struct Modal<ModalContent: View>: ViewModifier {
    let isPresented: Binding<Bool>
    
    @ViewBuilder let modalContent: () -> ModalContent
    
    @State private var modalContentSize: CGSize = .zero
    @State private var contentSize: CGSize = .zero
    
    func body(content: Content) -> some View {
        ZStack {
            content
                .geometryReader { contentSize = $0.size }
            
            RoundedRectangle(cornerRadius: 32)
                .fill(Material.regularMaterial)
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
                .clipShape(RoundedRectangle(cornerRadius: 32))
                .offset(y: isPresented.wrappedValue ? .zero : contentSize.height)
                .transition(.scale)
                .animation(.bouncy, value: isPresented.wrappedValue)
                .shadowModifier()
        }
    }
}

extension View {
    func modal(
        isPresented: Binding<Bool>,
        @ViewBuilder modalContent: @escaping () -> some View
    ) -> some View {
        self.modifier(Modal(isPresented: isPresented, modalContent: modalContent))
    }
}

#Preview {
    Text("Hello, world!")
        .modal(isPresented: .constant(true)) {
            HStack(spacing: 32) {
                Text("Hello modal!")
            }
        }
}

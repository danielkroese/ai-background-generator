import SwiftUI

struct Toolbar<ToolsContent: View>: ViewModifier {
    let isPresented: Binding<Bool>
    let alignment: VerticalAlignment
    
    @ViewBuilder let toolsContent: () -> ToolsContent
    
    @State var maxWidth = 0.0
    @State var toolsHeight = 0.0
    
    func body(content: Content) -> some View {
        ZStack {
            content
                .geometryReader { maxWidth = $0.size.width}
            
            toolsContent()
                .geometryReader { toolsHeight = $0.size.height }
                .frame(
                    maxWidth: maxWidth,
                    maxHeight: .infinity,
                    alignment: Alignment(horizontal: .center, vertical: alignment)
                )
                .offset(y: yOffset)
                .transition(.scale)
                .animation(.bouncy, value: isPresented.wrappedValue)
        }
    }
    
    private var yOffset: CGFloat {
        (isPresented.wrappedValue ? .zero : 2 * toolsHeight) * (alignment == .top ? -1 : 1)
    }
}

extension View {
    func toolbar(
        isPresented: Binding<Bool>,
        alignment: VerticalAlignment = .bottom,
        @ViewBuilder toolsContent: @escaping () -> some View
    ) -> some View {
        self.modifier(Toolbar(isPresented: isPresented, alignment: alignment, toolsContent: toolsContent))
    }
}

#Preview {
    Text("Hello, world!")
        .toolbar(isPresented: .constant(true)) {
            HStack(spacing: 32) {
                Text("Here be some tools!")
            }
            .padding(32)
        }
}

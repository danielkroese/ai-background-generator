import SwiftUI

struct Toolbar<ToolsContent: View>: ViewModifier {
    let isPresented: Binding<Bool>
    
    @ViewBuilder let toolsContent: () -> ToolsContent
    
    @State var toolsHeight = 0.0
    
    func body(content: Content) -> some View {
        ZStack {
            content
            
            toolsContent()
                .geometryReader { toolsHeight = $0.size.height }
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
                .offset(y: isPresented.wrappedValue ? .zero : 2 * toolsHeight)
                .transition(.scale)
                .animation(.bouncy, value: isPresented.wrappedValue)
        }
    }
}

extension View {
    func toolbar(
        isPresented: Binding<Bool>,
        @ViewBuilder toolsContent: @escaping () -> some View
    ) -> some View {
        self.modifier(Toolbar(isPresented: isPresented, toolsContent: toolsContent))
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

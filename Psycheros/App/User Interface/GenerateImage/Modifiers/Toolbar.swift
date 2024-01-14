import SwiftUI

struct Toolbar<ToolsContent: View>: ViewModifier {
    let isPresented: Bool
    
    @ViewBuilder let toolsContent: () -> ToolsContent
    
    @State var toolsHeight = 0.0
    
    func body(content: Content) -> some View {
        ZStack {
            content
            
            toolsContent()
                .geometryReader { toolsHeight = $0.size.height }
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
                .offset(y: isPresented ? .zero : 2 * toolsHeight)
                .transition(.scale)
                .animation(.bouncy, value: isPresented)
        }
    }
}

extension View {
    func toolbar(
        isPresented: Bool,
        @ViewBuilder toolsContent: @escaping () -> some View
    ) -> some View {
        self.modifier(Toolbar(isPresented: isPresented, toolsContent: toolsContent))
    }
}

#Preview {
    Text("Hello, world!")
        .toolbar(isPresented: true) {
            HStack(spacing: 32) {
                Text("Here be some tools!")
            }
            .padding(32)
        }
}

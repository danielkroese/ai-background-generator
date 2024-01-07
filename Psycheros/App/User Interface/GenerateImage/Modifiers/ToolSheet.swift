import SwiftUI

struct ToolSheet<ToolsContent: View>: ViewModifier {
    let isPresented: Bool
    
    @ViewBuilder let toolsContent: () -> ToolsContent
    
    func body(content: Content) -> some View {
        ZStack {
            content
            
            toolsContent()
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
                .offset(y: isPresented ? .zero : 350.0)
                .transition(.scale)
                .animation(.bouncy(duration: 1.5), value: isPresented)
        }
    }
}

extension View {
    func toolSheet(
        isPresented: Bool,
        @ViewBuilder toolsContent: @escaping () -> some View
    ) -> some View {
        self.modifier(ToolSheet(isPresented: isPresented, toolsContent: toolsContent))
    }
}

#Preview {
    Text("Hello, world!")
        .toolSheet(isPresented: true) {
            HStack(spacing: 32) {
                Text("Here be some tools!")
            }
            .padding(32)
        }
}

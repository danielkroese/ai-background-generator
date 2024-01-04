import SwiftUI

struct ToolSheet<ToolsContent: View>: ViewModifier {
    @Binding var isPresented: Bool
    
    @ViewBuilder let toolsContent: () -> ToolsContent
    
    @State private var sheetHeight = 0.0
    @State private var isAnimated = false
    
    func body(content: Content) -> some View {
        content
            .sheet(isPresented: $isPresented) {
                toolsContent()
                    .geometryReader { geometry in
                        if isAnimated {
                            sheetHeight = geometry.size.height
                        }
                    }
                    .interactiveDismissDisabled()
                    .presentationDragIndicator(.hidden)
                    .presentationDetents([.height(sheetHeight)])
                    .presentationCornerRadius(64)
                    .presentationBackgroundInteraction(.enabled)
                    .presentationBackground(.ultraThinMaterial)
                    .onAppear {
                        withAnimation {
                            isAnimated = true
                        }
                    }
            }
    }
}

extension View {
    func toolSheet(
        isPresented: Binding<Bool>,
        @ViewBuilder toolsContent: @escaping () -> some View
    ) -> some View {
        self.modifier(ToolSheet(isPresented: isPresented, toolsContent: toolsContent))
    }
}

#Preview {
    Text("Hello, world!")
        .toolSheet(isPresented: .constant(true)) {
            HStack(spacing: 32) {
                Text("Here be some tools!")
            }
            .padding(32)
        }
}

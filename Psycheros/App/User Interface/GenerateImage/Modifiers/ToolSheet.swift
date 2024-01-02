import SwiftUI

struct ToolSheet<ToolsContent: View>: ViewModifier {
    @Binding var isPresented: Bool
    
    @ViewBuilder let toolsContent: () -> ToolsContent
    
    @State private var toolsOffset = -400.0
    @State private var toolsDetent: PresentationDetent = .height(120)
    
    func body(content: Content) -> some View {
        content
            .sheet(isPresented: $isPresented) {
                VStack {
                    toolsContent()
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
                .ignoresSafeArea()
                .interactiveDismissDisabled()
                .presentationContentInteraction(.scrolls)
                .presentationDragIndicator(.hidden)
                .presentationDetents([.height(120), .medium], selection: $toolsDetent)
                .presentationCornerRadius(64)
                .presentationBackgroundInteraction(.enabled)
                .presentationBackground(.ultraThinMaterial)
            }
            .onAppear {
                withAnimation(.bouncy) {
                    toolsDetent = .height(120)
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

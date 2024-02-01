import SwiftUI

struct ColorModalContent: View {
    @Binding var selectedColor: AllowedColor
    
    private var columnItems: [GridItem] {
        Array(repeating: GridItem(.flexible()), count: 3)
    }
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: columnItems, spacing: 8) {
                ForEach(AllowedColor.allCases, id: \.self) { color in
                    Button {
                        selected(color)
                    } label: {
                        RoundedRectangle(cornerRadius: 32)
                            .fill(color.suiColor)
                            .frame(width: 64, height: 64)
                            .shadowModifier()
                            .modifier(
                                Shadow(
                                    color: color.suiColor,
                                    isActive: selectedColor == color
                                )
                            )
                    }
                    .padding(8)
                }
            }
            .padding()
        }
    }
    
    private func selected(_ color: AllowedColor) {
        selectedColor = color
    }
    
    private struct Shadow: ViewModifier {
        let color: Color
        let isActive: Bool
        
        func body(content: Content) -> some View {
            Group {
                if isActive {
                    content
                        .shadow(color: color, radius: 30)
                } else {
                    content
                }
            }
            .transition(.opacity)
        }
    }

}

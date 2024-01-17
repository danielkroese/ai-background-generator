import SwiftUI

struct ColorModalContent: View {
    @Binding var selectedColor: AllowedColor
    
    private var columnItems: [GridItem] {
        Array(repeating: GridItem(.flexible()), count: 3)
    }
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: columnItems, spacing: 32) {
                ForEach(AllowedColor.allCases, id: \.self) { color in
                    Button {
                        selectedColor = color
                    } label: {
                        RoundedRectangle(cornerRadius: 32)
                            .fill(color.suiColor)
                            .strokeBorder(
                                color == selectedColor ? .accent : .clear,
                                lineWidth: 4
                            )
                            .frame(width: 64, height: 64)
                            .shadowModifier()
                    }
                }
            }
            .padding(32)
        }
    }
}

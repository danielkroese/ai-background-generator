import SwiftUI

struct ThemeModalContent: View {
    @Binding var selectedThemes: Set<Theme>
    
    private var columnItems: [GridItem] {
        Array(repeating: GridItem(.flexible()), count: 2)
    }
    
    private func strokeBorder(for theme: Theme) -> Color {
        selectedThemes.contains(theme) ? .accentColor : .clear
    }
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: columnItems, spacing: 32) {
                ForEach(Theme.allCases, id: \.self) { theme in
                    Button {
                        selectedThemes.toggle(theme)
                    } label: {
                        RoundedRectangle(cornerRadius: 32)
                            .strokeBorder(strokeBorder(for: theme))
                            .frame(width: 128, height: 76)
                            .overlay {
                                Text(theme.rawValue)
                                    .font(.title2)
                            }
                            .shadowModifier()
                    }
                }
            }
            .padding(32)
        }
    }
}

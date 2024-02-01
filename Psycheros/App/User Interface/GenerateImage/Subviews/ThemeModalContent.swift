import SwiftUI

struct ThemeModalContent: View {
    @Binding var selectedThemes: Set<Theme>
    
    private var columnItems: [GridItem] {
        Array(repeating: GridItem(.flexible()), count: 2)
    }
    
    private func isActive(_ theme: Theme) -> Bool {
        selectedThemes.contains(theme)
    }
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: columnItems, spacing: 32) {
                ForEach(Theme.allCases, id: \.self) { theme in
                    Button {
                        selectedThemes.toggle(theme)
                    } label: {
                        RoundedRectangle(cornerRadius: 32)
                            .fill(isActive(theme) ? .accentColor : Color.clear)
                            .frame(width: 128, height: 76)
                            .overlay {
                                Text(theme.rawValue)
                                    .font(.title2)
                                    .foregroundStyle(isActive(theme) ? .white : .accentColor)
                            }
                            .shadowModifier()
                    }
                }
            }
            .padding(32)
        }
    }
}

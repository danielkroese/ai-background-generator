import SwiftUI

struct ToolbarContent: View {
    let isLoading: Bool
    let tappedSubviewButton: (GenerateImageElement) -> Void
    
    var body: some View {
        HStack(spacing: 12) {
            PillButton(rounded: .leading, imageName: "paintbrush.fill") {
                tappedSubviewButton(.colors)
            } label: {
                Text("Color")
                    .fixedSize(horizontal: true, vertical: false)
            }
            .disabled(isLoading)
            
            PillButton(rounded: .center, imageName: "scope") {
                tappedSubviewButton(.themes)
            } label: {
                Text("Theme")
                    .fixedSize(horizontal: true, vertical: false)
            }
            .disabled(isLoading)
            
            PillButton(
                rounded: .trailing,
                imageName: "wand.and.stars"
            ) {
                tappedSubviewButton(.generate)
            } label: {
                Text("Generate")
                    .fixedSize(horizontal: true, vertical: false)
            }
            .disabled(isLoading)
        }
        .transition(.scale)
        .animation(.bouncy(duration: 0.5), value: isLoading)
    }
}

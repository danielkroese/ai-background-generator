import SwiftUI

struct ToolbarContent: View {
    let errorText: String?
    let isLoading: Bool
    let tappedSubviewButton: (GenerateImageSubview) -> Void
    
    var body: some View {
        VStack {
            if let errorText {
                Text("Error: \(errorText)")
                    .foregroundStyle(.primary)
                    .font(.title)
                    .padding(32)
            }
            
            HStack(spacing: 16) {
                PillButton(rounded: .leading, imageName: "paintbrush.fill") {
                    tappedSubviewButton(.colors)
                }
                .disabled(isLoading)
                
                PillButton(rounded: .center, imageName: "scope") {
                    tappedSubviewButton(.themes)
                }
                .disabled(isLoading)
                
                PillButton(
                    rounded: .trailing,
                    imageName: "wand.and.stars",
                    isLoading: isLoading
                ) {
                    tappedSubviewButton(.generate)
                } label: {
                    if isLoading {
                        Text("Loading...")
                            .fixedSize(horizontal: true, vertical: false)
                    }
                }
                .disabled(isLoading)
            }
            .transition(.scale)
            .animation(.bouncy(duration: 0.5), value: isLoading)
        }
        .padding(.horizontal, 32)
    }
}

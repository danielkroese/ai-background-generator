import SwiftUI

struct PillButton: View {
    let rounded: PillButtonPart
    let imageName: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 16) {
                Image(systemName: imageName)
                    .resizable()
                    .frame(width: 32, height: 32)
            }
            .frame(maxWidth: .infinity, maxHeight: 32)
        }
        .buttonStyle(
            ShapeButtonStyle(
                shape: PillButtonShape(
                    rounded: rounded,
                    innerCornerRadius: 8,
                    outerCornerRadius: 32
                )
            )
        )
    }
}

struct LoadingPillButton: View {
    let rounded: PillButtonPart
    let imageName: String
    let isLoading: Bool
    var loadingText: String? = nil
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 16) {
                Image(systemName: imageName)
                    .resizable()
                    .frame(width: 32, height: 32)
                
                if isLoading, let loadingText {
                    Text(loadingText)
                        .fixedSize()
                }
            }
            .frame(maxWidth: .infinity, maxHeight: 32)
        }
        .buttonStyle(
            ShapeButtonStyle(
                isLoading: isLoading,
                shape: PillButtonShape(
                    rounded: rounded,
                    innerCornerRadius: 8,
                    outerCornerRadius: 32
                )
            )
        )
    }
}

enum PillButtonPart: CaseIterable {
    case leading,
         center,
         trailing,
         all,
         none
}

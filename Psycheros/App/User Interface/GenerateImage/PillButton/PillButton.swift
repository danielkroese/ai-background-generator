import SwiftUI

struct PillButton<Label>: View where Label: View{
    let rounded: PillButtonPart
    let imageName: String
    let action: () -> Void
    
    @ViewBuilder let label: () -> Label
    
    init(
        rounded: PillButtonPart,
        imageName: String,
        action: @escaping () -> Void,
        @ViewBuilder label: @escaping () -> Label = { EmptyView() }
    ) {
        self.rounded = rounded
        self.imageName = imageName
        self.action = action
        self.label = label
    }
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 12) {
                Image(systemName: imageName)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 16, height: 16)
                
                label()
            }
            .frame(maxHeight: 16)
        }
        .buttonStyle(
            ShapeButtonStyle(
                shape: PillButtonShape(
                    rounded: rounded,
                    innerCornerRadius: 8,
                    outerCornerRadius: 24
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

import SwiftUI

struct SaveButton: View {
    let action: () -> Void
    
    var body: some View {
        PillButton(
            rounded: .trailing,
            imageName: "square.and.arrow.down",
            action: action
        ) {
            Text("Save")
                .fixedSize(horizontal: true, vertical: false)
        }
    }
}

import SwiftUI

struct SaveButton: View {
    let action: () -> Void
    
    var body: some View {
        PillButton(
            rounded: .all,
            imageName: "square.and.arrow.down",
            action: action
        ) {
            Text("Save")
                .fixedSize(horizontal: true, vertical: false)
        }
    }
}

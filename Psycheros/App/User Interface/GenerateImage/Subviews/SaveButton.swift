import SwiftUI

struct SaveButton: View {
    let action: () -> Void
    
    var body: some View {
        PillButton(
            rounded: .all,
            imageName: "square.and.arrow.down",
            action: action
        )
        .frame(maxWidth: 64)
        .frame(maxWidth: .infinity, alignment: .trailing)
        .padding(32)
    }
}

import SwiftUI

struct NewEntryView: View {
    @Environment(\.modelContext) private var modelContext
    
    var body: some View {
        HStack {
            Text("Test")
        }
    }
}

#Preview {
    NewEntryView()
}

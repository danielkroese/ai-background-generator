import SwiftUI

struct GenerateImageView<ViewModel>: View where ViewModel: GenerateImageViewModeling & ObservableObject {
    @ObservedObject private(set) var viewModel: ViewModel
    
    var body: some View {
        ZStack {
            Button {
                viewModel.tappedGenerateImage()
            } label: {
                Image(systemName: "wand.and.stars")
                    .resizable()
                    .frame(width: 48, height: 48)
                    .padding()
                    .foregroundStyle(.white)
                    .background(Color.accentColor.opacity(0.8))
                    .clipShape(Circle())
            }
            .background(Color.accentColor.opacity(0.5))
            .clipShape(Circle())
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomTrailing)
            .padding(32)
            
            if let errorText = viewModel.errorText {
                Text(errorText)
                    .foregroundStyle(Color.accentColor)
                    .font(.headline)
                    .padding(32)
            }
            
            if let image = viewModel.generatedImage {
                image
                    .aspectRatio(contentMode: .fill)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
        }
        .background(Color.accentColor.opacity(0.3))
    }
}

#Preview {
    GenerateImageView(viewModel: GenerateImageViewModel())
}

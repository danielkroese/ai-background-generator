import SwiftUI

struct GenerateImageView<ViewModel>: View where ViewModel: GenerateImageViewModeling & ObservableObject {
    @ObservedObject private(set) var viewModel: ViewModel
    
    var body: some View {
        ZStack {
            if let errorText = viewModel.errorText {
                Text(errorText)
                    .foregroundStyle(Color.accentColor)
                    .font(.headline)
                    .padding(32)
            }
            
            Image(systemName: "wand.and.stars")
                .resizable()
                .frame(width: 48, height: 48)
                .circleButtonModifier(action: viewModel.tappedGenerateImage)
                .disabled(viewModel.isLoading)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomTrailing)
                .padding(32)
        }
        .background(background)
        .transition(.opacity)
        .animation(.easeInOut, value: viewModel.generatedImage)
    }
    
    @ViewBuilder
    private var background: some View {
        VStack {
            if let image = viewModel.generatedImage {
                image
                    .resizable()
                    .ignoresSafeArea()
                    .aspectRatio(contentMode: .fill)
            } else {
                Image(.dummyBackground)
                    .resizable()
                    .ignoresSafeArea()
                    .aspectRatio(contentMode: .fill)
//                Color.accentColor
//                    .opacity(0.3)
//                    .ignoresSafeArea()
            }
        }
        .transition(.opacity)
        .animation(.easeInOut, value: viewModel.generatedImage)
    }
}

#Preview {
    GenerateImageView(viewModel: GenerateImageViewModel())
}

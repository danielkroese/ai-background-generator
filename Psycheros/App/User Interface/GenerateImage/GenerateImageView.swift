import SwiftUI

struct GenerateImageView<ViewModel>: View where ViewModel: GenerateImageViewModeling & ObservableObject {
    @ObservedObject private(set) var viewModel: ViewModel
    
    var body: some View {
        background
            .transition(.opacity)
            .animation(.easeInOut, value: viewModel.generatedImage)
            .toolSheet(isPresented: .constant(true)) {
                HStack(spacing: 32) {
                    generateButton
                }
                .padding(32)
                .frame(maxWidth: .infinity, maxHeight: 196, alignment: .trailing)
                
                if let errorText = viewModel.errorText {
                    Text(errorText)
                        .foregroundStyle(Color.accentColor)
                        .font(.headline)
                        .padding(32)
                }
            }
    }
    
    private var generateButton: some View {
        Button(action: viewModel.tappedGenerateImage) {
            HStack(spacing: 16) {
                Image(systemName: "wand.and.stars")
                    .resizable()
                    .frame(width: 32, height: 32)
                
                if viewModel.isLoading {
                    Text("Loading...")
                }
            }
        }
        .disabled(viewModel.isLoading)
        .buttonStyle(
            ShapeButtonStyle(
                shape: PillButtonShape(
                    part: .trailing,
                    innerCornerRadius: 8,
                    outerCornerRadius: 32
                )
            )
        )
        .transition(.scale)
        .animation(.bouncy(duration: 0.5), value: viewModel.isLoading)
    }
    
    private var background: some View {
        VStack {
            if let image = viewModel.generatedImage {
                image
                    .resizable()
                    .animatedHue(isActive: viewModel.isLoading)
                    .ignoresSafeArea()
                    .aspectRatio(contentMode: .fill)
            } else {
                Image(.dummyBackground)
                    .resizable()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .animatedHue(isActive: viewModel.isLoading)
                    .ignoresSafeArea()
                    .aspectRatio(contentMode: .fill)
//                Color.accentColor
//                    .opacity(0.3)
//                    .animatedHue(isActive: viewModel.isLoading)
//                    .ignoresSafeArea()
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .transition(.opacity)
        .animation(.easeInOut, value: viewModel.generatedImage)
    }
}

#Preview {
    GenerateImageView(viewModel: GenerateImageViewModel())
}

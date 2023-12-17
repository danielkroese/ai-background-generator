import SwiftUI

struct GenerateImageView<ViewModel>: View where ViewModel: GenerateImageViewModeling & ObservableObject {
    @ObservedObject private(set) var viewModel: ViewModel
    
    @State var toolsOffset = -400.0
    
    var body: some View {
        ZStack {
            if let errorText = viewModel.errorText {
                Text(errorText)
                    .foregroundStyle(Color.accentColor)
                    .font(.headline)
                    .padding(32)
            }
            
            VStack {
                HStack(spacing: 32) {
                    generateButton
                }
                .padding(32)
                .frame(maxWidth: .infinity, maxHeight: 196, alignment: .topTrailing)
            }
            .blurBackground(effect: .systemThinMaterial)
            .clipShape(RoundedRectangle(cornerRadius: 64))
            .ignoresSafeArea()
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
            .offset(y: -toolsOffset)
            .animation(.bouncy(duration: 1.0), value: toolsOffset)
            .onAppear {
                toolsOffset = -86
            }
        }
        .background(background)
        .transition(.opacity)
        .animation(.easeInOut, value: viewModel.generatedImage)
    }
    
    @ViewBuilder
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
                shape: PillButtonShape(part: .trailing, innerCornerRadius: 8, outerCornerRadius: 32)
            )
        )
        .transition(.scale)
        .animation(.bouncy(duration: 0.5), value: viewModel.isLoading)
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
//                Image(.dummyBackground)
//                    .resizable()
//                    .ignoresSafeArea()
//                    .aspectRatio(contentMode: .fill)
                Color.accentColor
                    .opacity(0.3)
                    .ignoresSafeArea()
            }
        }
        .transition(.opacity)
        .animation(.easeInOut, value: viewModel.generatedImage)
    }
}

#Preview {
    GenerateImageView(viewModel: GenerateImageViewModel())
}

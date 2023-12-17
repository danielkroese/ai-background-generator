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
            
            VStack {
                HStack(spacing: 32) {
                    generateButton
                }
                .padding(32)
                .frame(maxWidth: .infinity, maxHeight: 200, alignment: .topTrailing)
            }
            .blurBackground(effect: .systemThinMaterial)
            .clipShape(RoundedRectangle(cornerRadius: 64))
            .ignoresSafeArea(.keyboard, edges: .all)
            .ignoresSafeArea()
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
            .offset(y: -toolsOffset)
            .animation(.bouncy(duration: 1.0), value: toolsOffset)
            .onAppear {
                toolsOffset = -100
            }
        }
        .background(background)
        .transition(.opacity)
        .animation(.easeInOut, value: viewModel.generatedImage)
    }
    
    @State var toolsOffset = -400.0
    
    @ViewBuilder
    private var generateButton: some View {
        Image(systemName: "wand.and.stars")
            .resizable()
            .frame(width: 32, height: 32)
            .shapeButtonModifier(shape: UnevenRoundedRectangle(cornerRadii: .init(topLeading: 8, bottomLeading: 8, bottomTrailing: 32, topTrailing: 32)), action: viewModel.tappedGenerateImage)
            .disabled(viewModel.isLoading)
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

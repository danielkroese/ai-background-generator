import SwiftUI

struct GenerateImageView<ViewModel>: View where ViewModel: GenerateImageViewModeling & ObservableObject {
    @ObservedObject private(set) var viewModel: ViewModel
    
    var body: some View {
        GeneratedImage(
            image: viewModel.generatedImage,
            isLoading: viewModel.isLoading
        )
        .onTapGesture {
            viewModel.tappedBackground()
        }
        .onAppear {
            viewModel.onAppear()
        }
        .toolbar(isPresented: viewModel.isPresenting(.tools)) {
            ToolbarContent(
                errorText: viewModel.errorText,
                isLoading: viewModel.isLoading,
                tappedSubviewButton: viewModel.tapped(on:)
            )
        }
        .modal(isPresented: viewModel.isPresenting(.colors)) {
            ColorModalContent(
                selectedColor: $viewModel.selectedColor
            )
        }
        .modal(isPresented: viewModel.isPresenting(.themes)) {
            ThemeModalContent(
                selectedThemes: $viewModel.selectedThemes
            )
        }
    }
}

#Preview {
    GenerateImageView(viewModel: GenerateImageViewModel())
}

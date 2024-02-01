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
        .toolbar(
            isPresented: .constant(viewModel.isPresenting(.tools)),
            alignment: .top
        ) {
            SaveButton {
                viewModel.tapped(on: .save)
            }
            .padding(32)
            .frame(maxWidth: .infinity, alignment: .trailing)
            
        }
        .toolbar(isPresented: .constant(viewModel.isPresenting(.tools))) {
            ToolbarContent(
                errorText: viewModel.errorText,
                isLoading: viewModel.isLoading,
                tappedSubviewButton: viewModel.tapped(on:)
            )
            .padding(32)
            .frame(maxWidth: .infinity)
        }
        .modal(isPresented: .constant(viewModel.isPresenting(.colors))) {
            ColorModalContent(
                selectedColor: $viewModel.selectedColor
            )
        }
        .modal(isPresented: .constant(viewModel.isPresenting(.themes))) {
            ThemeModalContent(
                selectedThemes: $viewModel.selectedThemes
            )
        }
        .preferredColorScheme(.dark)
    }
}

#Preview {
    GenerateImageView(viewModel: GenerateImageViewModel())
}

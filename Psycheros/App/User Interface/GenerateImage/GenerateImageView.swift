import SwiftUI

struct GenerateImageView: View {
    @ObservedObject private(set) var viewModel: GenerateImageViewModel
    
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
            HStack {
                PillButton(
                    rounded: .leading,
                    imageName: "square.and.arrow.up") { viewModel.tapped(on: .share)
                    } label: {
                        Text("Share")
                            .fixedSize(horizontal: true, vertical: false)
                    }
                
                SaveButton {
                    viewModel.tapped(on: .save)
                }
            }
            .padding()
            .frame(maxWidth: .infinity, alignment: .trailing)
            
        }
        .toolbar(isPresented: .constant(viewModel.isPresenting(.tools))) {
            ToolbarContent(isLoading: viewModel.isLoading) { element in
                viewModel.tapped(on: element)
            }
            .padding()
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
        .message($viewModel.messageModel)
        .loadingScreen(isActive: $viewModel.isLoading)
        .preferredColorScheme(.dark)
    }
}

#Preview {
    GenerateImageView(viewModel: GenerateImageViewModel())
}

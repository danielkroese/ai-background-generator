import SwiftUI

struct GenerateImageView<ViewModel, Router>: View where ViewModel: GenerateImageViewModeling & ObservableObject, Router: GenerateImageRouting {
    @ObservedObject private(set) var viewModel: ViewModel
    @ObservedObject private(set) var router: Router
    
    var body: some View {
        GeneratedImage(
            image: viewModel.generatedImage,
            isLoading: viewModel.isLoading
        )
        .toolbar(isPresented: router.isPresenting(.tools)) {
            ToolbarContent(
                errorText: viewModel.errorText,
                isLoading: viewModel.isLoading,
                tappedSubviewButton: tapped(on:)
            )
        }
        .modal(isPresented: router.isPresenting(.colors)) {
            ColorModalContent(selectedColor: $viewModel.selectedColor)
        }
        .modal(isPresented: router.isPresenting(.themes)) {
            ThemeModalContent(selectedThemes: $viewModel.selectedThemes)
        }
        .onAppear {
            router.present(.tools)
        }
        .onTapGesture {
            if viewModel.isLoading == false {
                router.dismissAll(except: .tools)
            }
        }
    }
    
    private func tapped(on subview: GenerateImageSubview) {
        router.dismissAll(except: .tools)
        
        switch subview {
        case .colors, .themes: router.toggle(subview)
        case .generate: viewModel.tappedGenerateImage()
        case .tools: break
        }
    }
}

#Preview {
    GenerateImageView(
        viewModel: GenerateImageViewModel(),
        router: GenerateImageRouter()
    )
}

import SwiftUI

struct GenerateImageView<ViewModel>: View where ViewModel: GenerateImageViewModeling & ObservableObject {
    @ObservedObject private(set) var viewModel: ViewModel
    
    @State private var isShowingTools = false
    @State private var selectedColor: Color = .blue
    @State private var selectedThemes: [Theme] = []
    
    var body: some View {
        background
            .transition(.opacity)
            .animation(.easeInOut, value: viewModel.generatedImage)
            .toolSheet(isPresented: isShowingTools) {
                toolsContent
            }
            .onAppear {
                isShowingTools = true
            }
    }
    
    private var toolsContent: some View {
        VStack {
            if let errorText = viewModel.errorText {
                Text("Error: \(errorText)")
                    .foregroundStyle(.primary)
                    .font(.title)
                    .padding(32)
            }
            
            HStack(spacing: 16) {
                PillButton(rounded: .leading, imageName: "paintbrush.fill") {
                    viewModel.selected(color: selectedColor)
                }
                .disabled(viewModel.isLoading)
                
                PillButton(rounded: .center, imageName: "scope") {
                    viewModel.selected(themes: selectedThemes)
                }
                .disabled(viewModel.isLoading)
                
                PillButton(
                    rounded: .trailing,
                    imageName: "wand.and.stars",
                    isLoading: viewModel.isLoading
                ) {
                    viewModel.tappedGenerateImage()
                } label: {
                    if viewModel.isLoading {
                        Text("Loading...")
                            .fixedSize()
                    }
                }
                .disabled(viewModel.isLoading)
            }
            .transition(.scale)
            .animation(.bouncy(duration: 0.5), value: viewModel.isLoading)
        }
        .padding(.horizontal, 32)
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
                Color.accentColor
                    .opacity(0.3)
                    .animatedHue(isActive: viewModel.isLoading)
                    .ignoresSafeArea()
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

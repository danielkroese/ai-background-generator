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
                VStack {
                    if let errorText = viewModel.errorText {
                        Text("Error: \(errorText)")
                            .foregroundStyle(.primary)
                            .font(.title)
                            .padding(32)
                    }
                    
                    HStack(spacing: 16) {
                        colorButton
                        themeButton
                        generateButton
                    }
                }
                .padding(.horizontal, 32)
            }
            .onAppear {
                isShowingTools = true
            }
    }
    
    private var colorButton: some View {
        Button {
            viewModel.selected(color: selectedColor)
        } label: {
            HStack(spacing: 16) {
                Image(systemName: "paintbrush.fill")
                    .resizable()
                    .frame(width: 32, height: 32)
            }
            .frame(maxWidth: .infinity, maxHeight: 32)
        }
        .disabled(viewModel.isLoading)
        .buttonStyle(
            ShapeButtonStyle(
                shape: PillButtonShape(
                    part: .leading,
                    innerCornerRadius: 8,
                    outerCornerRadius: 32
                )
            )
        )
        .transition(.scale)
        .animation(.bouncy(duration: 0.5), value: viewModel.isLoading)
    }
    
    private var themeButton: some View {
        Button {
            viewModel.selected(themes: selectedThemes)
        } label:  {
            HStack(spacing: 16) {
                Image(systemName: "scope")
                    .resizable()
                    .frame(width: 32, height: 32)
            }
            .frame(maxWidth: .infinity, maxHeight: 32)
        }
        .disabled(viewModel.isLoading)
        .buttonStyle(
            ShapeButtonStyle(
                shape: PillButtonShape(
                    part: .center,
                    innerCornerRadius: 8,
                    outerCornerRadius: 32
                )
            )
        )
        .transition(.scale)
        .animation(.bouncy(duration: 0.5), value: viewModel.isLoading)
    }
    
    private var generateButton: some View {
        Button(action: viewModel.tappedGenerateImage) {
            HStack(spacing: 16) {
                Image(systemName: "wand.and.stars")
                    .resizable()
                    .foregroundStyle(.blue)
                    .frame(width: 32, height: 32)
                
                if viewModel.isLoading {
                    Text("Loading...")
                        .fixedSize()
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
        .shimmer(viewModel.isLoading)
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

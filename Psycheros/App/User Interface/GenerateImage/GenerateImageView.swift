import SwiftUI

struct GenerateImageView<ViewModel>: View where ViewModel: GenerateImageViewModeling & ObservableObject {
    @ObservedObject private(set) var viewModel: ViewModel
    
    @State private var toolsOffset = -400.0
    @State private var toolsDetent: PresentationDetent = .height(120)
    
    var body: some View {
        background
            .transition(.opacity)
            .animation(.easeInOut, value: viewModel.generatedImage)
            .sheet(isPresented: .constant(true)) {
                VStack {
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
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
                .ignoresSafeArea()
                .interactiveDismissDisabled()
                .presentationContentInteraction(.scrolls)
                .presentationDragIndicator(.hidden)
                .presentationDetents([.height(120), .medium], selection: $toolsDetent)
                .presentationCornerRadius(64)
                .presentationBackgroundInteraction(.enabled)
                .presentationBackground(.ultraThinMaterial)
            }
            .onAppear {
                withAnimation(.bouncy) {
                    toolsDetent = .height(120)
                }
            }
            .onTapGesture {
                withAnimation(.bouncy) {
                    toolsDetent = .height(120)
                }
            }
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

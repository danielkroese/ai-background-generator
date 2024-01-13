import SwiftUI

struct GenerateImageView<ViewModel, Router>: View where ViewModel: GenerateImageViewModeling & ObservableObject, Router: GenerateImageRouting {
    @ObservedObject private(set) var viewModel: ViewModel
    @ObservedObject private(set) var router: Router
    
    @State private var selectedColor: AllowedColor = .blue
    @State private var selectedThemes = Set<Theme>()
    
    var body: some View {
        background
            .transition(.opacity)
            .animation(.easeInOut, value: viewModel.generatedImage)
            .toolSheet(isPresented: router.isPresenting(.tools)) {
                toolsContent
            }
            .modal(isPresented: router.isPresenting(.colors)) {
                ColorModalContent(selectedColor: $selectedColor)
            }
            .modal(isPresented: router.isPresenting(.themes)) {
                ThemeModalContent(selectedThemes: $selectedThemes)
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
                    router.dismissAll(except: .tools)
                    router.toggle(.colors)
                }
                .disabled(viewModel.isLoading)
                
                PillButton(rounded: .center, imageName: "scope") {
                    router.dismissAll(except: .tools)
                    router.toggle(.themes)
                }
                .disabled(viewModel.isLoading)
                
                PillButton(
                    rounded: .trailing,
                    imageName: "wand.and.stars",
                    isLoading: viewModel.isLoading
                ) {
                    router.dismissAll(except: .tools)
                    viewModel.selected(themes: selectedThemes)
                    viewModel.selected(color: selectedColor.rawValue)
                    viewModel.tappedGenerateImage()
                } label: {
                    if viewModel.isLoading {
                        Text("Loading...")
                            .fixedSize(horizontal: true, vertical: false)
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
    GenerateImageView(
        viewModel: GenerateImageViewModel(),
        router: GenerateImageRouter()
    )
}

import SwiftUI

struct GenerateImageView<ViewModel>: View where ViewModel: GenerateImageViewModeling & ObservableObject {
    @ObservedObject private(set) var viewModel: ViewModel
    
    private enum Subview {
        case tools, colors, themes
    }
    
    @State private var selectedColor: AllowedColor = .blue
    @State private var selectedThemes = Set<Theme>()
    @State private var visibleSubviews = Set<Subview>()
    
    var body: some View {
        background
            .transition(.opacity)
            .animation(.easeInOut, value: viewModel.generatedImage)
            .toolSheet(isPresented: isPresenting(.tools)) {
                toolsContent
            }
            .modal(isPresented: isPresenting(.colors)) {
                ColorModalContent(selectedColor: $selectedColor)
            }
            .modal(isPresented: isPresenting(.themes)) {
                ThemeModalContent(selectedThemes: $selectedThemes)
            }
            .onAppear {
                present(.tools)
            }
            .onTapGesture {
                if viewModel.isLoading == false {
                    closeAllExceptTools()
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
                    closeAllExceptTools()
                    toggle(.colors)
                }
                .disabled(viewModel.isLoading)
                
                PillButton(rounded: .center, imageName: "scope") {
                    closeAllExceptTools()
                    toggle(.themes)
                }
                .disabled(viewModel.isLoading)
                
                PillButton(
                    rounded: .trailing,
                    imageName: "wand.and.stars",
                    isLoading: viewModel.isLoading
                ) {
                    closeAllExceptTools()
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
    
    private func isPresenting(_ subview: Subview) -> Bool {
        visibleSubviews.contains(subview)
    }
    
    private func present(_ subview: Subview) {
        visibleSubviews.insert(subview)
    }
    
    private func dismiss(_ subview: Subview) {
        visibleSubviews.remove(subview)
    }
    
    private func toggle(_ subview: Subview) {
        visibleSubviews.toggle(subview)
    }
    
    private func closeAllExceptTools() {
        visibleSubviews = visibleSubviews.filter { $0 == .tools }
    }
    
    private struct ColorModalContent: View {
        @Binding var selectedColor: AllowedColor
        
        private var columnItems: [GridItem] {
            Array(repeating: GridItem(.flexible()), count: 3)
        }
        
        var body: some View {
            ScrollView {
                LazyVGrid(columns: columnItems, spacing: 32) {
                    ForEach(AllowedColor.allCases, id: \.self) { color in
                        Button {
                            selectedColor = color
                        } label: {
                            RoundedRectangle(cornerRadius: 32)
                                .fill(color.suiColor)
                                .frame(width: 64, height: 64)
                                .shadowModifier()
                        }
                    }
                }
                .padding(32)
            }
        }
    }
    
    private struct ThemeModalContent: View {
        @Binding var selectedThemes: Set<Theme>
        
        private var columnItems: [GridItem] {
            Array(repeating: GridItem(.flexible()), count: 2)
        }
        
        private func strokeBorder(for theme: Theme) -> Color {
            selectedThemes.contains(theme) ? .accentColor : .clear
        }
        
        var body: some View {
            ScrollView {
                LazyVGrid(columns: columnItems, spacing: 32) {
                    ForEach(Theme.allCases, id: \.self) { theme in
                        Button {
                            selectedThemes.toggle(theme)
                        } label: {
                            RoundedRectangle(cornerRadius: 32)
                                .strokeBorder(strokeBorder(for: theme))
                                .frame(width: 128, height: 76)
                                .overlay {
                                    Text(theme.rawValue)
                                        .font(.title2)
                                }
                                .shadowModifier()
                        }
                    }
                }
                .padding(32)
            }
        }
    }
}

#Preview {
    GenerateImageView(viewModel: GenerateImageViewModel())
}

extension Set {
    mutating func toggle(_ element: Element) {
        if contains(element) {
            remove(element)
        } else {
            insert(element)
        }
    }
}

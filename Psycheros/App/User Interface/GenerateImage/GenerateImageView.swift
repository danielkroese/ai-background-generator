import SwiftUI

enum AllowedColor: String, CaseIterable {
    case red, blue, green, black, white,
         gray, yellow, orange, pink, purple,
         teal, mint, indigo, brown, cyan

    var suiColor: Color {
        switch self {
        case .red: return .red
        case .blue: return .blue
        case .green: return .green
        case .black: return .black
        case .white: return .white
        case .gray: return .gray
        case .yellow: return .yellow
        case .orange: return .orange
        case .pink: return .pink
        case .purple: return .purple
        case .teal: return .teal
        case .mint: return .mint
        case .indigo: return .indigo
        case .brown: return .brown
        case .cyan: return .cyan
        }
    }
}

struct GenerateImageView<ViewModel>: View where ViewModel: GenerateImageViewModeling & ObservableObject {
    @ObservedObject private(set) var viewModel: ViewModel
    
    @State private var isShowingTools = false
    @State private var isShowingColors = false
    @State private var isShowingThemes = false
    
    @State private var selectedColor: Color = .blue
    @State private var selectedThemes: [Theme] = []
    
    var body: some View {
        background
            .transition(.opacity)
            .animation(.easeInOut, value: viewModel.generatedImage)
            .toolSheet(isPresented: isShowingTools) {
                toolsContent
            }
            .modal(isPresented: isShowingColors) {
                ColorModalContent { color in
                    viewModel.selected(color: color)
                    isShowingColors = false
                }
            }
            .modal(isPresented: isShowingThemes) {
                Text("Themes go here")
                    .padding(32)
            }
            .onAppear {
                isShowingTools = true
            }
            .onTapGesture {
                if viewModel.isLoading == false {
                    isShowingTools.toggle()
                }
            }
    }
    
    private struct ColorModalContent: View {
        let action: (String) -> Void
        
        private var columnItems: [GridItem] {
            Array(repeating: GridItem(.flexible()), count: 3)
        }
        
        var body: some View {
            ScrollView {
                LazyVGrid(columns: columnItems, spacing: 32) {
                    ForEach(AllowedColor.allCases, id: \.self) { color in
                        Button {
                            action(color.rawValue)
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
                    isShowingColors.toggle()
                }
                .disabled(viewModel.isLoading)
                
                PillButton(rounded: .center, imageName: "scope") {
                    isShowingThemes.toggle()
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
    GenerateImageView(viewModel: GenerateImageViewModel())
}

import SwiftUI

enum AllowedColor: String, CaseIterable {
    case red, blue, green, black, white,
         gray, yellow, orange, pink, purple,
         teal, mint, indigo, brown, cyan

    var suiColor: Color {
        switch self {
        case .red: .red
        case .blue: .blue
        case .green: .green
        case .black: .black
        case .white: .white
        case .gray: .gray
        case .yellow: .yellow
        case .orange: .orange
        case .pink: .pink
        case .purple: .purple
        case .teal: .teal
        case .mint: .mint
        case .indigo: .indigo
        case .brown: .brown
        case .cyan: .cyan
        }
    }
}

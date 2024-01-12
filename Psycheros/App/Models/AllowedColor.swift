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

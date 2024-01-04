import SwiftUI

struct GeoReader: ViewModifier {
    var proxy: (GeometryProxy) -> Void
    
    @State private var currentSize: CGSize = .zero

    func body(content: Content) -> some View {
        content
            .background(
                GeometryReader { geometryProxy in
                    Color.clear
                        .onAppear {
                            currentSize = geometryProxy.size
                            
                            self.proxy(geometryProxy)
                        }
                        .onChange(of: geometryProxy.size) { _, newSize in
                            if newSize != currentSize {
                                currentSize = newSize
                                
                                withAnimation {
                                    self.proxy(geometryProxy)
                                }
                            }
                        }
                }
            )
    }
}

extension View {
    func geometryReader(_ proxy: @escaping (GeometryProxy) -> Void) -> some View {
        self.modifier(GeoReader(proxy: proxy))
    }
}


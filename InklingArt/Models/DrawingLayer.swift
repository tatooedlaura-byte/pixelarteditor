import Foundation
import PencilKit

class DrawingLayer: Identifiable, ObservableObject {
    let id: UUID
    @Published var name: String
    @Published var isVisible: Bool
    @Published var opacity: CGFloat
    @Published var isMirror: Bool
    var drawing: PKDrawing

    init(name: String, isVisible: Bool = true, opacity: CGFloat = 1.0, isMirror: Bool = false) {
        self.id = UUID()
        self.name = name
        self.isVisible = isVisible
        self.opacity = opacity
        self.isMirror = isMirror
        self.drawing = PKDrawing()
    }
}

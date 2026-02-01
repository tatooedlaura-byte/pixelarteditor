import SwiftUI

struct ContentView: View {
    @State private var currentTool: Tool = .pencil
    @State private var currentColor: UIColor = .black
    @State private var gridSize: Int = 16
    @State private var undoTrigger: Int = 0
    @State private var redoTrigger: Int = 0
    @State private var selectedPaletteIndex: Int = 0
    @State private var templateGrid: PixelGrid?
    @StateObject private var canvasStore = CanvasStore()

    var body: some View {
        VStack(spacing: 0) {
            TopBarView(
                gridSize: $gridSize,
                undoTrigger: $undoTrigger,
                redoTrigger: $redoTrigger,
                templateGrid: $templateGrid,
                canvasStore: canvasStore
            )

            ZStack(alignment: .leading) {
                // Canvas
                CanvasView(
                    currentColor: $currentColor,
                    currentTool: $currentTool,
                    gridSize: $gridSize,
                    undoTrigger: $undoTrigger,
                    redoTrigger: $redoTrigger,
                    templateGrid: $templateGrid,
                    onPickColor: { color in
                        currentColor = color
                        currentTool = .pencil
                    },
                    canvasStore: canvasStore
                )
                .background(Color(.systemGray6))

                // Floating toolbar on the left
                ToolbarView(selectedTool: $currentTool)
                    .padding(.leading, 12)
            }

            ColorPaletteView(
                selectedColor: $currentColor,
                selectedPaletteIndex: $selectedPaletteIndex
            )
        }
        .ignoresSafeArea(.keyboard)
    }
}

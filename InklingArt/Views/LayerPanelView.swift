import SwiftUI

struct LayerPanelView: View {
    @Binding var layers: [DrawingLayer]
    @Binding var activeLayerIndex: Int
    var onLayerChanged: (() -> Void)?

    var body: some View {
        VStack(spacing: 0) {
            // Header
            HStack {
                Text("Layers")
                    .font(.headline)
                Spacer()
                Button {
                    addLayer()
                } label: {
                    Image(systemName: "plus")
                        .font(.title3)
                }
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 8)

            Divider()

            // Layer list (bottom-up order like Procreate: top layer shown first)
            ScrollView {
                VStack(spacing: 2) {
                    ForEach(layers.indices.reversed(), id: \.self) { index in
                        layerRow(index: index)
                    }
                }
                .padding(.vertical, 4)
            }
        }
        .frame(width: 200)
        .background(.ultraThinMaterial)
        .cornerRadius(14)
        .shadow(radius: 4)
    }

    private func layerRow(index: Int) -> some View {
        let layer = layers[index]
        let isActive = index == activeLayerIndex

        return HStack(spacing: 8) {
            // Layer name
            Text(layer.name)
                .font(.subheadline)
                .lineLimit(1)

            Spacer()

            // Visibility toggle
            Button {
                layers[index].isVisible.toggle()
                onLayerChanged?()
            } label: {
                Image(systemName: layer.isVisible ? "eye" : "eye.slash")
                    .font(.caption)
                    .foregroundColor(layer.isVisible ? .primary : .secondary)
            }
            .buttonStyle(.plain)

            // Delete button (only if >1 layer)
            if layers.count > 1 {
                Button {
                    deleteLayer(at: index)
                } label: {
                    Image(systemName: "trash")
                        .font(.caption)
                        .foregroundColor(.red.opacity(0.7))
                }
                .buttonStyle(.plain)
            }
        }
        .padding(.horizontal, 10)
        .padding(.vertical, 6)
        .background(isActive ? Color.accentColor.opacity(0.2) : Color.clear)
        .cornerRadius(6)
        .padding(.horizontal, 4)
        .contentShape(Rectangle())
        .onTapGesture {
            if activeLayerIndex != index {
                activeLayerIndex = index
                onLayerChanged?()
            }
        }
    }

    private func addLayer() {
        let newLayer = DrawingLayer(name: "Layer \(layers.count + 1)")
        layers.append(newLayer)
        activeLayerIndex = layers.count - 1
        onLayerChanged?()
    }

    private func deleteLayer(at index: Int) {
        guard layers.count > 1 else { return }
        layers.remove(at: index)
        if activeLayerIndex >= layers.count {
            activeLayerIndex = layers.count - 1
        } else if activeLayerIndex > index {
            activeLayerIndex -= 1
        }
        onLayerChanged?()
    }
}

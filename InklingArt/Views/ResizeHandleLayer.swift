import UIKit

enum ResizeHandle {
    case topLeft, topRight, bottomLeft, bottomRight
}

class ResizeHandleLayer: CAShapeLayer {
    private let handleSize: CGFloat = 12
    private let hitTargetSize: CGFloat = 44
    private var currentRect: CGRect = .zero

    func update(for rect: CGRect) {
        currentRect = rect
        let path = UIBezierPath()

        let corners = [
            CGPoint(x: rect.minX, y: rect.minY),
            CGPoint(x: rect.maxX, y: rect.minY),
            CGPoint(x: rect.minX, y: rect.maxY),
            CGPoint(x: rect.maxX, y: rect.maxY),
        ]

        for corner in corners {
            let handleRect = CGRect(
                x: corner.x - handleSize / 2,
                y: corner.y - handleSize / 2,
                width: handleSize,
                height: handleSize
            )
            path.append(UIBezierPath(rect: handleRect))
        }

        self.path = path.cgPath
        self.fillColor = UIColor.systemBlue.cgColor
        self.strokeColor = UIColor.white.cgColor
        self.lineWidth = 1.5
        self.isHidden = false
    }

    func hitTestHandle(point: CGPoint) -> ResizeHandle? {
        let halfHit = hitTargetSize / 2
        let corners: [(CGPoint, ResizeHandle)] = [
            (CGPoint(x: currentRect.minX, y: currentRect.minY), .topLeft),
            (CGPoint(x: currentRect.maxX, y: currentRect.minY), .topRight),
            (CGPoint(x: currentRect.minX, y: currentRect.maxY), .bottomLeft),
            (CGPoint(x: currentRect.maxX, y: currentRect.maxY), .bottomRight),
        ]

        for (corner, handle) in corners {
            let hitRect = CGRect(x: corner.x - halfHit, y: corner.y - halfHit,
                                 width: hitTargetSize, height: hitTargetSize)
            if hitRect.contains(point) {
                return handle
            }
        }
        return nil
    }

    static func adjustedRect(original: CGRect, dragging handle: ResizeHandle, from startPoint: CGPoint, to currentPoint: CGPoint) -> CGRect {
        // Proportional resize anchored at the opposite corner
        let anchor: CGPoint
        switch handle {
        case .topLeft:     anchor = CGPoint(x: original.maxX, y: original.maxY)
        case .topRight:    anchor = CGPoint(x: original.minX, y: original.maxY)
        case .bottomLeft:  anchor = CGPoint(x: original.maxX, y: original.minY)
        case .bottomRight: anchor = CGPoint(x: original.minX, y: original.minY)
        }

        let dx = currentPoint.x - anchor.x
        let dy = currentPoint.y - anchor.y

        guard original.width > 0, original.height > 0 else { return original }

        let aspectRatio = original.width / original.height

        // Determine scale based on the axis with greater movement
        let scaleX = abs(dx) / original.width
        let scaleY = abs(dy) / original.height
        let scale = max(scaleX, scaleY)
        guard scale > 0.05 else { return original }

        let newWidth = original.width * scale
        let newHeight = newWidth / aspectRatio

        let newX = dx >= 0 ? anchor.x : anchor.x - newWidth
        let newY = dy >= 0 ? anchor.y : anchor.y - newHeight

        return CGRect(x: newX, y: newY, width: newWidth, height: newHeight)
    }

    func hide() {
        self.path = nil
        self.isHidden = true
    }
}

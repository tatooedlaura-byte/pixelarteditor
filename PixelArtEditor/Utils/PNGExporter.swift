import UIKit

enum PNGExporter {
    static func renderImage(grid: PixelGrid, scale: Int = 1) -> UIImage? {
        let w = grid.width * scale
        let h = grid.height * scale

        UIGraphicsBeginImageContextWithOptions(CGSize(width: w, height: h), false, 1.0)
        guard let ctx = UIGraphicsGetCurrentContext() else { return nil }

        // Transparent background
        ctx.clear(CGRect(x: 0, y: 0, width: w, height: h))

        for row in 0..<grid.height {
            for col in 0..<grid.width {
                if let color = grid[row, col] {
                    ctx.setFillColor(color.cgColor)
                    ctx.fill(CGRect(x: col * scale, y: row * scale, width: scale, height: scale))
                }
            }
        }

        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }

    static func pngData(grid: PixelGrid, scale: Int = 1) -> Data? {
        return renderImage(grid: grid, scale: scale)?.pngData()
    }

    static func saveToPhotos(grid: PixelGrid, scale: Int = 1, completion: @escaping (Bool, String?) -> Void) {
        guard let image = renderImage(grid: grid, scale: scale) else {
            completion(false, "Could not render image")
            return
        }
        let saver = ImageSaver(completion: completion)
        objc_setAssociatedObject(image, "saver", saver, .OBJC_ASSOCIATION_RETAIN)
        UIImageWriteToSavedPhotosAlbum(image, saver, #selector(ImageSaver.image(_:didFinishSavingWithError:contextInfo:)), nil)
    }

    static func copyToClipboard(grid: PixelGrid, scale: Int = 1) {
        guard let image = renderImage(grid: grid, scale: scale) else { return }
        UIPasteboard.general.image = image
    }
}

private class ImageSaver: NSObject {
    let completion: (Bool, String?) -> Void

    init(completion: @escaping (Bool, String?) -> Void) {
        self.completion = completion
    }

    @objc func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        DispatchQueue.main.async {
            self.completion(error == nil, error?.localizedDescription)
        }
    }
}

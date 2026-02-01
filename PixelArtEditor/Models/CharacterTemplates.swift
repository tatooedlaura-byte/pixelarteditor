import UIKit

enum CharacterTemplates {

    private static let outline = UIColor.darkGray

    static func template(for size: Int) -> PixelGrid {
        switch size {
        case 8:  return template8()
        case 16: return template16()
        case 32: return template32()
        case 64: return template64()
        default: return PixelGrid(width: size, height: size)
        }
    }

    // MARK: - 8×8

    private static func template8() -> PixelGrid {
        let O = Optional(outline)
        let n: UIColor? = nil

        let data: [[UIColor?]] = [
            [n, n, O, O, O, n, n, n],
            [n, O, n, n, n, O, n, n],
            [n, O, n, n, n, O, n, n],
            [n, n, O, O, O, n, n, n],
            [n, O, O, O, O, O, n, n],
            [n, n, O, n, O, n, n, n],
            [n, n, O, n, O, n, n, n],
            [n, n, O, n, O, n, n, n],
        ]
        return gridFrom(data: data, size: 8)
    }

    // MARK: - 16×16

    private static func template16() -> PixelGrid {
        let O = Optional(outline)
        let n: UIColor? = nil

        let data: [[UIColor?]] = [
            [n,n,n,n,n, n, n, n, n, n, n,n,n,n,n,n],
            [n,n,n,n,n, O, O, O, O, O, n,n,n,n,n,n],
            [n,n,n,n, O, n, n, n, n, n, O,n,n,n,n,n],
            [n,n,n,n, O, n, n, n, n, n, O,n,n,n,n,n],
            [n,n,n,n, O, n, n, n, n, n, O,n,n,n,n,n],
            [n,n,n,n, n, O, n, n, n, O, n,n,n,n,n,n],
            [n,n,n,n, n, n, O, O, O, n, n,n,n,n,n,n],
            [n,n,n, O, O, O, O, O, O, O, O, O,n,n,n,n],
            [n,n, O, n, n, O, O, O, O, O, n, n, O,n,n,n],
            [n,n, n, n, n, O, O, O, O, O, n, n, n,n,n,n],
            [n,n,n, n, n, n, O, O, O, n, n, n,n,n,n,n],
            [n,n,n, n, n, O, O, n, O, O, n, n,n,n,n,n],
            [n,n,n, n, n, O, n, n, n, O, n, n,n,n,n,n],
            [n,n,n, n, n, O, n, n, n, O, n, n,n,n,n,n],
            [n,n,n, n, n, O, O, n, O, O, n, n,n,n,n,n],
            [n,n,n,n,n, n, n, n, n, n, n,n,n,n,n,n],
        ]
        return gridFrom(data: data, size: 16)
    }

    // MARK: - 32×32

    private static func template32() -> PixelGrid {
        var grid = PixelGrid(width: 32, height: 32)
        // Head outline
        strokeRect(&grid, x: 11, y: 2, w: 10, h: 10)
        // Neck
        grid[12, 15] = outline
        grid[12, 16] = outline
        // Body outline
        strokeRect(&grid, x: 9, y: 13, w: 14, h: 8)
        // Left arm
        strokeRect(&grid, x: 7, y: 13, w: 2, h: 6)
        // Right arm
        strokeRect(&grid, x: 23, y: 13, w: 2, h: 6)
        // Left leg
        strokeRect(&grid, x: 11, y: 21, w: 4, h: 7)
        // Right leg
        strokeRect(&grid, x: 17, y: 21, w: 4, h: 7)
        return grid
    }

    // MARK: - 64×64

    private static func template64() -> PixelGrid {
        var grid = PixelGrid(width: 64, height: 64)
        // Head outline
        strokeRect(&grid, x: 22, y: 4, w: 20, h: 18)
        // Neck
        for col in 30...33 {
            grid[22, col] = outline
            grid[23, col] = outline
        }
        // Body outline
        strokeRect(&grid, x: 18, y: 24, w: 28, h: 18)
        // Left arm
        strokeRect(&grid, x: 14, y: 24, w: 4, h: 14)
        // Right arm
        strokeRect(&grid, x: 46, y: 24, w: 4, h: 14)
        // Left leg
        strokeRect(&grid, x: 22, y: 42, w: 8, h: 14)
        // Right leg
        strokeRect(&grid, x: 34, y: 42, w: 8, h: 14)
        return grid
    }

    // MARK: - Helpers

    private static func gridFrom(data: [[UIColor?]], size: Int) -> PixelGrid {
        var grid = PixelGrid(width: size, height: size)
        for row in 0..<min(data.count, size) {
            for col in 0..<min(data[row].count, size) {
                grid[row, col] = data[row][col]
            }
        }
        return grid
    }

    private static func strokeRect(_ grid: inout PixelGrid, x: Int, y: Int, w: Int, h: Int) {
        for col in x..<(x + w) {
            grid[y, col] = outline
            grid[y + h - 1, col] = outline
        }
        for row in y..<(y + h) {
            grid[row, x] = outline
            grid[row, x + w - 1] = outline
        }
    }
}

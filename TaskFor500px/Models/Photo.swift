import CoreGraphics
import Foundation

// MARK: Photo
internal struct Photo: Codable {
    internal let id: Int
    internal let images: [ImageResource]
    internal let width: CGFloat
    internal let height: CGFloat
}

// MARK: computed properties
extension Photo {
    internal var size: CGSize {
        return CGSize(width: width, height: height)
    }
}

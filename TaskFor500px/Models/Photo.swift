import CoreGraphics
import Foundation

// MARK: Photo
internal struct Photo: Codable {
    internal enum CodingKeys: String, CodingKey {
        case id = "id"
        case images = "images"
        case width = "width"
        case height = "height"
        case name = "name"
        case createdAt = "created_at"
        case user = "user"
    }
    
    internal let id: Int
    internal let images: [ImageResource]
    internal let width: CGFloat
    internal let height: CGFloat
    internal let name: String
    internal let createdAt: ISO8601NetTime<String>
    internal let user: User
}

// MARK: computed properties
extension Photo {
    internal var size: CGSize {
        return CGSize(width: width, height: height)
    }
}

// MARK: helper functions
extension Photo {
    internal func imageURL(forSize size: ImageSize) -> URL? {
        return images.first(where: { $0.size == size.rawValue })?.url
    }
}

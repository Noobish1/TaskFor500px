import CoreGraphics
import Foundation

// MARK: ImageResource
internal struct ImageResource: Codable {
    internal enum CodingKeys: String, CodingKey {
        case format = "format"
        case size = "size"
        case url = "https_url"
    }
    
    internal let format: String
    internal let size: Int
    internal let url: URL
}

import Foundation

internal struct Photo: Codable {
    internal let id: Int
    internal let images: [ImageResource]
}

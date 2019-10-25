import Foundation

internal struct PopularPhotosResponse: Codable {
    internal enum CodingKeys: String, CodingKey {
        case currentPage = "current_page"
        case totalPages = "total_pages"
        case totalPhotos = "total_items"
        case photos = "photos"
    }
    
    internal let currentPage: Int
    internal let totalPages: Int
    internal let totalPhotos: Int
    internal let photos: [Photo]
}

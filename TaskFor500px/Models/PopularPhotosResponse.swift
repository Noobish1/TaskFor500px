import Foundation

internal struct PopularPhotosResponse: Codable {
    internal let currentPage: Int
    internal let totalPages: Int
    internal let totalPhotos: Int
    internal let photos: [Photo]
}

import Foundation

internal final class PhotosViewModel {
    // MARK: PageConfig
    internal struct PageConfig {
        internal let numberOfPages: Int
        
        internal init(response: PopularPhotosResponse) {
            self.numberOfPages = response.totalPages
        }
    }
    
    // MARK: properties
    internal let pageConfig: PageConfig
    private var pages: NonEmptyArray<PopularPhotosResponse>
    
    // MARK: computed properties
    internal var numberOfPhotos: Int {
        return pages.map { $0.photos.count }.reduce(0, +)
    }
    
    // MARK: init
    internal init(response: PopularPhotosResponse) {
        self.pageConfig = PageConfig(response: response)
        self.pages = NonEmptyArray(elements: response)
    }
    
    // MARK: adding pagees
    internal func addPage(with response: PopularPhotosResponse) -> [IndexPath] {
        let startingIndex = numberOfPhotos
        
        pages.append(response)
        
        return response.photos.indices.map { index in
            IndexPath(item: startingIndex + index, section: 0)
        }
    }
    
    // MARK: retrieving photos
    internal func photo(at indexPath: IndexPath) -> Photo {
        var item = indexPath.item
        
        // We do it this way because we don't want to make any assumptions about page sizes
        for page in pages {
            if item < page.photos.count {
                return page.photos[item]
            } else {
                item -= page.photos.count
            }
        }
        
        fatalError("item not found for indexPath \(indexPath)")
    }
    
    // MARK: retrieving image URLs
    internal func imageURL(for indexPath: IndexPath) -> URL? {
        return photo(at: indexPath).images.first(where: { $0.size == ImageSize.grid.rawValue })?.url
    }
    
    internal func validImageURLs(for indexPaths: [IndexPath]) -> [URL] {
        return indexPaths.compactMap { imageURL(for: $0) }
    }
}

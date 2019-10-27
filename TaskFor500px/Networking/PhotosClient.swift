import Foundation
import Moya
import RxSwift

internal final class PhotosClient {
    // MARK: properties
    private let photosProvider = MoyaProvider<PhotosService>()
    
    // MARK: init
    internal init() {}
    
    // MARK: API calls
    internal func popularPhotos(forPage page: Int) -> Single<PopularPhotosResponse> {
        return photosProvider.rx
            .request(.popularPhotos(page: page))
            .map(PopularPhotosResponse.self)
    }
}

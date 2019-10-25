import Foundation
import Moya
import RxSwift

internal final class PhotosClient {
    // MARK: properties
    private let photosProvider = MoyaProvider<PhotosService>()
    
    // MARK: init
    internal init() {}
    
    // MARK: API calls
    internal func popularPhotos() -> Single<PopularPhotosResponse> {
        return photosProvider.rx
            .request(.popularPhotos)
            .map(PopularPhotosResponse.self)
    }
}

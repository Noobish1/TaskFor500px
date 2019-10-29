import CoreLocation
import Foundation
import Moya

// MARK: PhotosService
internal enum PhotosService {
    case popularPhotos(page: Int)
}

// MARK: TargetType
extension PhotosService: TargetType {
    internal var baseURL: URL {
        return HardCodedURL("https://api.500px.com/v1/").url
    }

    internal var path: String {
        switch self {
            case .popularPhotos: return "photos"
        }
    }

    internal var method: Moya.Method {
        switch self {
            case .popularPhotos: return .get
        }
    }

    internal var sampleData: Data {
        switch self {
            case .popularPhotos:
                return R.file.popularPhotosJson().flatMap { try? Data(contentsOf: $0) } ?? Data()
        }
    }

    internal var task: Task {
        switch self {
            case .popularPhotos(page: let page):
                let parameters = PopularParameters(page: page).toDictionary(forHTTPMethod: .get)

                return .requestParameters(parameters: parameters, encoding: URLEncoding())
        }
    }

    internal var validationType: ValidationType {
        switch self {
            case .popularPhotos: return .successCodes
        }
    }

    // swiftlint:disable discouraged_optional_collection
    internal var headers: [String: String]? {
        return [
            "Content-type": "application/json",
            "Accept": "application/json",
            "Accept-Encoding": "gzip"
        ]
    }
    // swiftlint:enable discouraged_optional_collection
}

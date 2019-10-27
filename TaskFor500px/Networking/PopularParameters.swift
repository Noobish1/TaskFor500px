import Foundation
import KeyedAPIParameters
import Keys

// MARK: PopularParameters
internal struct PopularParameters: Equatable, Hashable, Codable {
    // MARK: properties
    private let feature = "popular"
    private let consumerKey = TaskFor500pxKeys().aPIKey
    private let imageSize = ImageSize.allCases.map { $0.rawValue }
    private let sort = "votes_count"
    private let page: Int
    internal let resultsPerPage = 50
    
    // MARK: init
    internal init(page: Int) {
        self.page = page
    }
}

// MARK: KeyedAPIParameters
extension PopularParameters: KeyedAPIParameters {
    internal enum Key: String, ParamJSONKey {
        case feature = "feature"
        case consumerKey = "consumer_key"
        case imageSize = "image_size"
        case sort = "sort"
        case page = "page"
        case resultsPerPage = "rpp"
    }

    internal func toKeyedDictionary() -> [Key: APIParamConvertible] {
        return [
            .feature: feature,
            .consumerKey: consumerKey,
            .imageSize: imageSize,
            .sort: sort,
            .page: page,
            .resultsPerPage: resultsPerPage
        ]
    }
}

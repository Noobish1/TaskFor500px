import Foundation
import KeyedAPIParameters
import Keys

internal struct PopularParameters: Equatable, Hashable, Codable {
    // MARK: properties
    private let feature = "popular"
    private let consumerKey = TaskFor500pxKeys().aPIKey
    private let imageSize = ImageSize.allCases.map { $0.rawValue }
    
    // MARK: init
    internal init() {}
}

extension PopularParameters: KeyedAPIParameters {
    internal enum Key: String, ParamJSONKey {
        case feature = "feature"
        case consumerKey = "consumer_key"
        case imageSize = "image_size"
    }

    internal func toKeyedDictionary() -> [Key: APIParamConvertible] {
        return [
            .feature: feature,
            .consumerKey: consumerKey,
            .imageSize: imageSize
        ]
    }
}

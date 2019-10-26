import Foundation
import KeyedAPIParameters
import Keys

public struct PopularParameters: Equatable, Hashable, Codable {
    // MARK: properties
    private let feature = "popular"
    private let consumerKey = TaskFor500pxKeys().aPIKey
    private let imageSize = [600, 1080]
    
    // MARK: init
    public init() {}
}

extension PopularParameters: KeyedAPIParameters {
    public enum Key: String, ParamJSONKey {
        case feature = "feature"
        case consumerKey = "consumer_key"
        case imageSize = "image_size"
    }

    public func toKeyedDictionary() -> [Key: APIParamConvertible] {
        return [
            .feature: feature,
            .consumerKey: consumerKey,
            .imageSize: imageSize
        ]
    }
}

import Foundation
import KeyedAPIParameters
import Keys

public struct PopularParameters: Equatable, Hashable, Codable {
    // MARK: init
    public init() {}
}

extension PopularParameters: KeyedAPIParameters {
    public enum Key: String, ParamJSONKey {
        case feature = "feature"
        case consumerKey = "consumer_key"
    }

    public func toKeyedDictionary() -> [Key: APIParamConvertible] {
        return [
            .feature: "popular",
            .consumerKey: TaskFor500pxKeys().aPIKey
        ]
    }
}

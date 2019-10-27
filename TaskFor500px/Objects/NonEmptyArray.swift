// Derived From: https://github.com/khanlou/NonEmptyArray
import Foundation

// Note: This is a type I use in most of the apps I've worked on

// MARK: NonEmptyArray
internal struct NonEmptyArray<Element> {
    // MARK: DecodingError
    internal enum DecodingError: Error {
        case emptyArray
    }
    
    // MARK: properties
    fileprivate var elements: [Element]

    // MARK: computed properties
    internal var count: Int {
        return elements.count
    }

    internal var first: Element {
        // swiftlint:disable force_unwrapping
        return elements.first!
        // swiftlint:enable force_unwrapping
    }

    internal var last: Element {
        // swiftlint:disable force_unwrapping
        return elements.last!
        // swiftlint:enable force_unwrapping
    }

    internal var isEmpty: Bool {
        return false
    }

    internal var nonEmptyIndices: NonEmptyArray<NonEmptyArray<Element>.Index> {
        let array = Array(self.indices)

        // swiftlint:disable force_unwrapping
        return NonEmptyArray<NonEmptyArray<Element>.Index>(array: array)!
        // swiftlint:enable force_unwrapping
    }

    // MARK: init
    internal init(elements: Element...) {
        self.elements = elements
    }

    internal init(firstElement: Element, rest: [Element]) {
        self.elements = [firstElement].byAppending(rest)
    }

    internal init?(array: [Element]) {
        guard !array.isEmpty else {
            return nil
        }
        self.elements = array
    }

    // MARK: insertion
    internal mutating func insert<C: Collection>(contentsOf collection: C, at index: Index) where C.Iterator.Element == Element {
        elements.insert(contentsOf: collection, at: index)
    }

    internal mutating func insert(_ newElement: Element, at index: Index) {
        elements.insert(newElement, at: index)
    }

    // MARK: appending
    internal mutating func append(_ newElement: Element) {
        elements.append(newElement)
    }

    internal func byAppending(_ newElement: Element) -> NonEmptyArray<Element> {
        var copy = self
        copy.append(newElement)
        return copy
    }

    // MARK: helpers
    internal func toArray() -> [Element] {
        return elements
    }

    internal mutating func removeLastElementAndAddElementToStart(_ element: Element) {
        elements.insert(element, at: 0)
        elements.removeLast()
    }

    internal mutating func removeFirstElementAndAddElementToEnd(_ element: Element) {
        elements.append(element)
        elements.removeFirst()
    }

    // MARK: mapping
    internal func map<T>(_ transform: (Element) throws -> T) rethrows -> NonEmptyArray<T> {
        // swiftlint:disable force_unwrapping
        return NonEmptyArray<T>(array: try elements.map(transform))!
        // swiftlint:enable force_unwrapping
    }

    // MARK: min/max
    internal func min(by areInIncreasingOrder: (Element, Element) throws -> Bool) rethrows -> Element {
        // swiftlint:disable force_unwrapping
        return try elements.min(by: areInIncreasingOrder)!
        // swiftlint:enable force_unwrapping
    }

    internal func max(by areInIncreasingOrder: (Element, Element) throws -> Bool) rethrows -> Element {
        // swiftlint:disable force_unwrapping
        return try elements.max(by: areInIncreasingOrder)!
        // swiftlint:enable force_unwrapping
    }

    // MARK: reversing
    internal func reversed() -> NonEmptyArray<Element> {
        // swiftlint:disable force_unwrapping
        return NonEmptyArray(array: elements.reversed())!
        // swiftlint:enable force_unwrapping
    }

    // MARK: Random
    internal func randomIndex() -> Int {
        return Int.random(in: 0...(self.count - 1))
    }

    internal func randomElement() -> Element {
        return elements[randomIndex()]
    }

    internal func randomSubArray() -> NonEmptyArray<Element> {
        let startIndex = Int.random(in: 0...(self.count - 1))
        let endIndex = Int.random(in: startIndex...(self.count - 1))

        // swiftlint:disable force_unwrapping
        return NonEmptyArray(array: Array(self[startIndex...endIndex]))!
        // swiftlint:enable force_unwrapping
    }

    // MARK: Sorting
    internal func sorted(by areInIncreasingOrder: (Element, Element) throws -> Bool) rethrows -> NonEmptyArray<Element> {
        // swiftlint:disable force_unwrapping
        return try NonEmptyArray(array: elements.sorted(by: areInIncreasingOrder))!
        // swiftlint:enable force_unwrapping
    }

    // MARK: subscripting
    internal subscript (safe index: Int) -> Element? {
        return elements[safe: index]
    }
}

// MARK: Element: Strideable, Element.Stride: SignedInteger
extension NonEmptyArray where Element: Strideable, Element.Stride: SignedInteger {
    internal init(range: CountableClosedRange<Element>) {
        self.elements = Array(range)
    }
}

// MARK: Element: Strideable
extension NonEmptyArray where Element: Strideable {
    internal init(stride: StrideTo<Element>) {
        self.elements = Array(stride)
    }

    internal init(stride: StrideThrough<Element>) {
        self.elements = Array(stride)
    }
}

// MARK: CustomStringConvertible
extension NonEmptyArray: CustomStringConvertible {
    internal var description: String {
        return elements.description
    }
}

// MARK: CustomDebugStringConvertible
extension NonEmptyArray: CustomDebugStringConvertible {
    internal var debugDescription: String {
        return elements.debugDescription
    }
}

// MARK: Collection
extension NonEmptyArray: Collection {
    internal typealias Index = Int

    internal var startIndex: Int {
        return 0
    }

    internal var endIndex: Int {
        return count
    }

    internal func index(after i: Int) -> Int {
        return i + 1
    }
}

// MARK: MutableCollection
extension NonEmptyArray: MutableCollection {
    internal subscript(_ index: Int) -> Element {
        get {
            return elements[index]
        }
        set {
            elements[index] = newValue
        }
    }
}

// MARK: Equtable elements
extension NonEmptyArray where Element: Equatable {
    internal mutating func replace(_ element: Element, with otherElement: Element) {
        elements.replace(element, with: otherElement)
    }

    internal func byReplacing(_ element: Element, with otherElement: Element) -> NonEmptyArray<Element> {
        var mutableSelf = self
        mutableSelf.replace(element, with: otherElement)

        return mutableSelf
    }
}

// MARK: Comparable elements
extension NonEmptyArray where Element: Comparable {
    internal func min() -> Element {
        // swiftlint:disable force_unwrapping
        return elements.min()!
        // swiftlint:enable force_unwrapping
    }

    internal func max() -> Element {
        // swiftlint:disable force_unwrapping
        return elements.max()!
        // swiftlint:enable force_unwrapping
    }

    internal func maxIndex() -> Int {
        let max = self.max()

        // swiftlint:disable force_unwrapping
        return self.firstIndex(of: max)!
        // swiftlint:enable force_unwrapping
    }

    internal mutating func sort() {
        elements.sort()
    }

    internal func sorted() -> NonEmptyArray<Element> {
        // swiftlint:disable force_unwrapping
        return NonEmptyArray(array: elements.sorted())!
        // swiftlint:enable force_unwrapping
    }
}

// MARK: Equatable
extension NonEmptyArray: Equatable where Element: Equatable {
    internal static func == (lhs: NonEmptyArray<Element>, rhs: NonEmptyArray<Element>) -> Bool {
        return lhs.elements == rhs.elements
    }
}

// MARK: Codable
extension NonEmptyArray: Codable where Element: Codable {
    internal init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let array = try container.decode([Element].self)
        
        if let nonEmptyArray = NonEmptyArray(array: array) {
            self = nonEmptyArray
        } else {
            throw DecodingError.emptyArray
        }
    }
    
    internal func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(toArray())
    }
}

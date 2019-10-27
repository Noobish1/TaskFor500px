import Foundation

// MARK: General extensions
extension Array {
    // MARK: appending
    internal func byAppending(_ element: Element) -> [Element] {
        var array = self
        array.append(element)

        return array
    }

    internal func byAppending(_ elements: [Element]) -> [Element] {
        var array = self
        array.append(contentsOf: elements)

        return array
    }
    
    // MARK: safe subscripting
    internal subscript (safe index: Int) -> Element? {
        return index < count ? self[index] : nil
    }
}

// MARK: Equatable extensions
extension Array where Element: Equatable {
    // MARK: replacing
    internal func byReplacing(_ element: Element, with otherElement: Element) -> [Element] {
        var array = self
        array.replace(element, with: otherElement)

        return array
    }

    internal mutating func replace(_ element: Element, with otherElement: Element) {
        guard let index = firstIndex(of: element) else { return }

        self[index] = otherElement
    }
}

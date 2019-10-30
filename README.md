# Notes


## Dependencies

I tried to use frameworks that the 500px app uses (I checked the Open Source Acknowledgements).


## Dependency manager

I used Cocoapods because I believe the 500px app does, I could've use SPM but I wanted to stick with some of the dev tools that I believe the 500px app is currently using. I left the Pods in git so its easier to run the app. I did however gitignore the `Pods/CocoapodsKeys` directory.

## Hiding the API key

I used [Cocoapods-keys](https://github.com/orta/cocoapods-keys) to hide the 500px API key.

## Networking/Rx

I used [RxSwift](https://github.com/ReactiveX/RxSwift) in combination with [Moya](https://github.com/Moya/Moya) and [Alamofire](https://github.com/Alamofire/Alamofire) because I've used them before and the 500px uses Alamofire & RxSwift.

## Pagination

I used [UIScrollView+InfiniteScroll](https://github.com/pronebird/UIScrollView-InfiniteScroll) for pagination as the 500px app uses it and I've used it before and liked it.

## AutoLayout

I use [SnapKit](https://github.com/SnapKit/SnapKit) for AutoLayout because the 500px app uses it and I use it in my own projects. I wrote all my UI in code as I prefer it (because of Git conflicts, one place for everything) and iOS development seems to be going that way with SwiftUI.

## UIView extensions

I use this extension because it couples adding a subview and configuring SnapKit constraints. This avoids the issue of making constraints before adding a subview. The subviews parameter lets me arrange subviews visually beneath their parents. You can end up with a "pyramid of doom" but at that point you probably want a `UIView` subclass anyway.

```swift
internal func add(subview: UIView, withConstraints constraints: (ConstraintMaker) -> Void, subviews: (UIView) -> Void) {
	...
}
```

## NonEmptyArray

I use a NonEmptyArray type based on [this implementation](https://github.com/khanlou/NonEmptyArray) because it is helpful sometimes to be sure something won't be empty. It's extremely helpful when an app has "empty views" for when a screen doesn't have data.


## Singular

A simple `dispatch_once`.

## Tagged

I use [Tagged](https://github.com/pointfreeco/swift-tagged) for more descriptive models.

For example the `createdAt` time on the `Photo` model.

```swift
internal struct Photo: Codable {
	...
    internal let createdAt: ISO8601NetTime<String>
	...
}
```

## CodingKeys

When specifying `CodingKeys` I always specify a raw value because otherwise you can accidentally rename a case which is used as a key in a model.

```swift
internal struct Photo: Codable {
    internal enum CodingKeys: String, CodingKey {
        case id = "id"
        case images = "images"
        case width = "width"
        case height = "height"
        case name = "name"
        case createdAt = "created_at"
        case user = "user"
    }
    ...
}
```

## R.swift

I use [R.swift](https://github.com/mac-cain13/R.swift) for accessing local assets as it avoids using strings everywhere and it is enforced by the compiler.

## Using a button on the PhotoDetailViewController

I'm a big fan of bottom-orientated design and a big button is basically the most discoverable UI element possible.


## States in PhotoContainerViewController

I like describing explicit states with enums, for example the one below in the `PhotosContainerViewController`.

```swift
internal final class PhotosContainerViewController: UIViewController {
    // MARK: State
    internal enum State {
        case loading(PhotosLoadingViewController)
        case loaded(PhotosViewController)
        case errored(PhotosErrorViewController)
        
        // MARK: computed properties
        internal var viewController: UIViewController {
            switch self {
                case .loading(let vc): return vc
                case .loaded(let vc): return vc
                case .errored(let vc): return vc
            }
        }
    }
    ...
}
```

## Then

I use the [Then](https://github.com/devxoul/Then) Cocoapod for configuring objects, mostly UIKit ones, like the below example because it groups code nicely.

```swift
private lazy var titleLabel = UILabel().then {
    $0.textColor = .darkGray
    $0.font = .preferredFont(forTextStyle: .title2)
    $0.text = photo.name
}
```

## SwiftLint

I use [SwiftLint](https://github.com/realm/SwiftLint) to lint my projects and keep my code style consistent, it's a really great tool. My Swiftlint config is in the `.swiftlint.yml` file at the root of this repo.

## Reveal

I use [Reveal](https://revealapp.com/) for view debugging, it's much more powerful than Xcode's built-in view debugging and worth buying.
import Then
import UIKit

// MARK: AppDelegate
@UIApplicationMain
internal final class AppDelegate: UIResponder {
    // MARK: properties
    internal var window: UIWindow?
}

// MARK: UIApplicationDelegate
extension AppDelegate: UIApplicationDelegate {
    internal func application(
        _ application: UIApplication,
        // swiftlint:disable discouraged_optional_collection
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
        // swiftlint:enable discouraged_optional_collection
    ) -> Bool {
        self.window = UIWindow(frame: UIScreen.main.bounds).then {
            $0.rootViewController = PhotosViewController()
            $0.makeKeyAndVisible()
        }
        
        return true
    }
}

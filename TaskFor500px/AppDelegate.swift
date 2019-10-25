import UIKit
import Then

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
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        self.window = UIWindow(frame: UIScreen.main.bounds).then {
            $0.rootViewController = ViewController()
            $0.makeKeyAndVisible()
        }
        
        return true
    }
}


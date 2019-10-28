import Kingfisher
import Then
import UIKit

// MARK: AppDelegate
@UIApplicationMain
internal final class AppDelegate: UIResponder {
    // MARK: properties
    internal var window: UIWindow?
    
    // MARK: setup
    private func setupImageCache() {
        let oneHundredMB = 100 * 1024 * 1024
        
        let costLimit = ProcessInfo.processInfo.physicalMemory / 4
        let memoryStorage = (costLimit > Int.max) ? Int.max : Int(costLimit)
        let actualMemoryStorage = min(oneHundredMB, memoryStorage)
        
        var config = MemoryStorage.Config(totalCostLimit: actualMemoryStorage, cleanInterval: 30)
        config.countLimit = 50
        
        ImageCache.default.memoryStorage.config = config
    }
}

// MARK: UIApplicationDelegate
extension AppDelegate: UIApplicationDelegate {
    internal func application(
        _ application: UIApplication,
        // swiftlint:disable discouraged_optional_collection
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
        // swiftlint:enable discouraged_optional_collection
    ) -> Bool {
        setupImageCache()
        
        let navController = UINavigationController(rootViewController: PhotosContainerViewController())
        navController.isNavigationBarHidden = true
        
        self.window = UIWindow(frame: UIScreen.main.bounds).then {
            $0.rootViewController = navController
            $0.makeKeyAndVisible()
        }
        
        return true
    }
}

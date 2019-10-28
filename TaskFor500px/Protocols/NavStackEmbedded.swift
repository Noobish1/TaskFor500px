import UIKit

internal protocol NavStackEmbedded: UIViewController {
    var navController: UINavigationController { get }
}

extension NavStackEmbedded {
    // MARK: computed properties
    internal var navController: UINavigationController {
        guard let navController = self.navigationController else {
            fatalError("\(self) should be embedded in a UINavigationController but is not")
        }

        return navController
    }
}

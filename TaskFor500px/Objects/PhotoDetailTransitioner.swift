import UIKit

// MARK: PhotoDetailTransitioner
internal final class PhotoDetailTransitioner: NSObject {}
 
// MARK: UIViewControllerTransitioningDelegate
extension PhotoDetailTransitioner: UIViewControllerTransitioningDelegate {
    internal func animationController(
        forPresented presented: UIViewController,
        presenting: UIViewController,
        source: UIViewController
    ) -> UIViewControllerAnimatedTransitioning? {
        return PhotoDetailPresentAnimator()
    }

    internal func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return PhotoDetailDismissAnimator()
    }

    internal func interactionControllerForPresentation(
        using animator: UIViewControllerAnimatedTransitioning
    ) -> UIViewControllerInteractiveTransitioning? {
        return nil
    }

    internal func interactionControllerForDismissal(
        using animator: UIViewControllerAnimatedTransitioning
    ) -> UIViewControllerInteractiveTransitioning? {
        return nil
    }

    internal func presentationController(
        forPresented presented: UIViewController,
        presenting: UIViewController?,
        source: UIViewController
    ) -> UIPresentationController? {
        return nil
    }
}

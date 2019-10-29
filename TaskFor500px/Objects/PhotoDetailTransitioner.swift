import UIKit

internal final class PhotoDetailTransitioner: NSObject {
    // MARK: properties
    internal var selectedImage: UIImage?
    internal var selectedFrame: CGRect?
}
 
extension PhotoDetailTransitioner: UIViewControllerTransitioningDelegate {
    internal func animationController(
        forPresented presented: UIViewController,
        presenting: UIViewController,
        source: UIViewController
    ) -> UIViewControllerAnimatedTransitioning? {
        guard let frame = selectedFrame else { return nil }
        guard let image = selectedImage else { return nil }
        
        return PhotoDetailPresentAnimator(originFrame: frame, image: image)
    }

    internal func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        guard let frame = selectedFrame else { return nil }
        guard let image = selectedImage else { return nil }
        
        return PhotoDetailDismissAnimator(originFrame: frame, image: image)
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

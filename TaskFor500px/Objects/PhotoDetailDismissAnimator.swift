import UIKit

// MARK: PhotoDetailDismissAnimator
internal final class PhotoDetailDismissAnimator: NSObject {}

// MARK: UIViewControllerAnimatedTransitioning
extension PhotoDetailDismissAnimator: UIViewControllerAnimatedTransitioning {
    internal func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.35
    }
    
    internal func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let fromVC = transitionContext.viewController(forKey: .from) as? PhotoDetailViewController else {
            fatalError("Could not find presentingViewController for the BottomAnchoredPresentAnimator")
        }
        guard let toVC = transitionContext.viewController(forKey: .to) else {
            fatalError("Could not find presentedViewController for the BottomAnchoredPresentAnimator")
        }
        let containerView = transitionContext.containerView

        self.dismiss(
            fromVC: fromVC,
            toVC: toVC,
            containerView: containerView,
            context: transitionContext
        )
    }
    
    private func dismiss(
        fromVC: PhotoDetailViewController,
        toVC: UIViewController,
        containerView: UIView,
        context: UIViewControllerContextTransitioning
    ) {
        fromVC.photoView.alpha = 0
        
        let transitionImageView = UIImageView(frame: containerView.convert(fromVC.photoView.frame, to: containerView).offsetBy(dx: 0, dy: containerView.safeAreaInsets.top))
        transitionImageView.image = fromVC.originImage

        containerView.addSubview(transitionImageView)
        
        fromVC.view.snp.remakeConstraints { make in
            make.leading.equalToSuperviewOrSafeAreaLayoutGuide()
            make.trailing.equalToSuperviewOrSafeAreaLayoutGuide()
            make.top.equalTo(containerView.snp.bottom)
        }

        UIView.animate(
            withDuration: self.transitionDuration(using: context),
            animations: {
                transitionImageView.frame = fromVC.originFrame
                containerView.layoutIfNeeded()
            },
            completion: { finished in
                context.completeTransition(finished)
                transitionImageView.removeFromSuperview()
                fromVC.photoView.alpha = 1
            }
        )
    }
}

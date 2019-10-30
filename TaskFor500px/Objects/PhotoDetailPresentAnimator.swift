import SnapKit
import UIKit

// MARK: PhotoDetailPresentAnimator
internal final class PhotoDetailPresentAnimator: NSObject {}
 
// MARK: UIViewControllerAnimatedTransitioning
extension PhotoDetailPresentAnimator: UIViewControllerAnimatedTransitioning {
    internal func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.35
    }
    
    internal func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let fromVC = transitionContext.viewController(forKey: .from) else {
            fatalError("Could not find presentingViewController for the BottomAnchoredPresentAnimator")
        }
        guard let toVC = transitionContext.viewController(forKey: .to) as? PhotoDetailViewController else {
            fatalError("Could not find presentedViewController for the BottomAnchoredPresentAnimator")
        }
        let containerView = transitionContext.containerView
        
        self.present(
            toVC,
            fromVC: fromVC,
            containerView: containerView,
            context: transitionContext
        )
    }

    private func present(
        _ toVC: PhotoDetailViewController,
        fromVC: UIViewController,
        containerView: UIView,
        context: UIViewControllerContextTransitioning
    ) {
        toVC.photoView.alpha = 0

        var topConstraint: Constraint?
        var heightConstraint: Constraint?
        
        containerView.add(subview: toVC.view, withConstraints: { make in
            topConstraint = make.top.equalTo(containerView.snp.bottom).constraint
            make.leading.equalToSuperviewOrSafeAreaLayoutGuide()
            make.trailing.equalToSuperviewOrSafeAreaLayoutGuide()
            heightConstraint = make.height.equalTo(containerView).constraint
        })

        let transitionImageView = UIImageView(frame: toVC.originFrame)
        transitionImageView.image = toVC.originImage

        containerView.addSubview(transitionImageView)
        
        containerView.layoutIfNeeded()

        heightConstraint?.deactivate()
        topConstraint?.deactivate()

        toVC.view.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        let endFrame = containerView.convert(toVC.photoView.frame, to: containerView).offsetBy(dx: 0, dy: 10)
        
        UIView.animate(
            withDuration: self.transitionDuration(using: context),
            animations: {
                transitionImageView.frame = endFrame
                containerView.layoutIfNeeded()
            },
            completion: { finished in
                toVC.photoView.alpha = 1
                transitionImageView.removeFromSuperview()
                
                context.completeTransition(finished)
            }
        )
    }
}

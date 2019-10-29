import SnapKit
import UIKit

// MARK: PhotoDetailPresentAnimator
internal final class PhotoDetailPresentAnimator: NSObject {
    // MARK: properties
    private let originFrame: CGRect
    private let image: UIImage
    
    // MARK: init
    internal init(originFrame: CGRect, image: UIImage) {
        self.originFrame = originFrame
        self.image = image
    }
}
 
// MARK: UIViewControllerAnimatedTransitioning
extension PhotoDetailPresentAnimator: UIViewControllerAnimatedTransitioning {
    internal func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.4
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

        let transitionImageView = UIImageView(frame: originFrame)
        transitionImageView.image = image

        containerView.addSubview(transitionImageView)
        
        containerView.layoutIfNeeded()

        heightConstraint?.deactivate()
        topConstraint?.deactivate()

        toVC.view.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        UIView.animate(
            withDuration: self.transitionDuration(using: context),
            animations: {
                transitionImageView.frame = containerView.convert(toVC.photoView.frame, to: containerView)
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

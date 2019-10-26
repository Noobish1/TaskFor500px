import SnapKit
import UIKit

// MARK: General extensions
extension UIView {
    // MARK: fullscreen views
    internal func add(fullscreenSubview: UIView) {
        add(subview: fullscreenSubview, withConstraints: { make in
            make.edges.equalToSuperview()
        })
    }

    internal func add(subview: UIView, withConstraints constraints: (ConstraintMaker) -> Void) {
        addSubview(subview)

        subview.snp.remakeConstraints(constraints)
    }

    internal func add(subview: UIView, withConstraints constraints: (ConstraintMaker) -> Void, subviews: (UIView) -> Void) {
        addSubview(subview)

        subview.snp.remakeConstraints(constraints)

        subviews(subview)
    }
}

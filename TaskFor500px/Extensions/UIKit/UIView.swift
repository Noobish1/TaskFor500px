import SnapKit
import UIKit

// MARK: General extensions
extension UIView {
    // MARK: fullscreen views
    public func add(fullscreenSubview: UIView) {
        add(subview: fullscreenSubview, withConstraints: { make in
            make.edges.equalToSuperview()
        })
    }

    public func add(subview: UIView, withConstraints constraints: (ConstraintMaker) -> Void) {
        addSubview(subview)

        subview.snp.remakeConstraints(constraints)
    }

    public func add(subview: UIView, withConstraints constraints: (ConstraintMaker) -> Void, subviews: (UIView) -> Void) {
        addSubview(subview)

        subview.snp.remakeConstraints(constraints)

        subviews(subview)
    }
}

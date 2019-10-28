import UIKit

internal struct CenterPointRange {
    // MARK: properties
    internal let xRange: ClosedRange<CGFloat>
    internal let yRange: ClosedRange<CGFloat>
    
    // MARK: init
    private init(xRange: ClosedRange<CGFloat>, yRange: ClosedRange<CGFloat>) {
        self.xRange = xRange
        self.yRange = yRange
    }
    
    internal init(view: UIView, containerView: UIView) {
        self.xRange = type(of: self).makeXCenterRange(forView: view, in: containerView)
        self.yRange = type(of: self).makeYCenterRange(forView: view, in: containerView)
    }
    
    // MARK: make center ranges
    private static func makeXCenterRange(
        forView view: UIView, in containerView: UIView
    ) -> ClosedRange<CGFloat> {
        if view.frame.width <= containerView.bounds.width {
            return (containerView.bounds.width / 2)...(containerView.bounds.width / 2)
        } else {
            let xCenterMin = containerView.bounds.width - (view.frame.width / 2)
            let xCenterMax = view.frame.width / 2
            
            return xCenterMin...xCenterMax
        }
    }
    
    private static func makeYCenterRange(
        forView view: UIView, in containerView: UIView
    ) -> ClosedRange<CGFloat> {
        if view.frame.height <= containerView.bounds.height {
            return (containerView.bounds.height / 2)...(containerView.bounds.height / 2)
        } else {
            let yCenterMin = containerView.bounds.height - (view.frame.height / 2)
            let yCenterMax = view.frame.height / 2
            
            return yCenterMin...yCenterMax
        }
    }
    
    // MARK: bounce
    internal func widen(byAmount amount: CGFloat) -> CenterPointRange {
        return CenterPointRange(
            xRange: xRange.widen(byAmount: amount), yRange: yRange.widen(byAmount: amount)
        )
    }
    
    // MARK: contains
    internal func contains(point: CGPoint) -> Bool {
        return xRange.contains(point.x) && yRange.contains(point.y)
    }
}

import CoreGraphics

extension CGPoint {
    internal func clamped(to range: CenterPointRange) -> CGPoint {
        var us = self
        us.x = us.x.clamped(to: range.xRange)
        us.y = us.y.clamped(to: range.yRange)
        
        return us
    }
    
    internal func translated(by translation: CGPoint) -> CGPoint {
        var us = self
        us.x += translation.x
        us.y += translation.y
        
        return us
    }
    
    internal func difference(to point: CGPoint) -> CGPoint {
        let xDiff = point.x - self.x
        let yDiff = point.y - self.y
        
        return CGPoint(x: xDiff, y: yDiff)
    }
}

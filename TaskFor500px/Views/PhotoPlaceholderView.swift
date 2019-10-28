import Kingfisher
import UIKit

internal final class PhotoPlaceholderView: UIView, Placeholder {
    // MARK: properties
    private let imageView = UIImageView(image: UIImage(color: .lightGray))
    
    // MARK: init
    internal init() {
        super.init(frame: .zero)
        
        setupViews()
    }
    
    @available(*, unavailable)
    internal required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: setup
    private func setupViews() {
        add(fullscreenSubview: imageView)
    }
}

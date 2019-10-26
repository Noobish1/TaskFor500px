import Then
import UIKit

internal final class PhotoCollectionCell: UICollectionViewCell {
    // MARK: properties
    private let imageView = UIImageView().then {
        $0.contentMode = .scaleAspectFit
    }
    
    // MARK: init
    internal override init(frame: CGRect) {
        super.init(frame: .zero)
        
        contentView.backgroundColor = UIColor(
            red: .random(in: 0...1),
            green: .random(in: 0...1),
            blue: .random(in: 0...1),
            alpha: 1
        )
        
        setupViews()
    }
    
    @available(*, unavailable)
    internal required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: setup
    private func setupViews() {
        contentView.add(fullscreenSubview: imageView)
    }
}

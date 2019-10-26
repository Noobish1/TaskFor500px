import Kingfisher
import Then
import UIKit

internal final class PhotoCollectionCell: UICollectionViewCell {
    // MARK: properties
    internal let imageView = UIImageView().then {
        $0.contentMode = .scaleAspectFit
    }
    
    // MARK: init
    internal override init(frame: CGRect) {
        super.init(frame: .zero)
                
        contentView.backgroundColor = .white
        
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
    
    // MARK: reuse
    internal override func prepareForReuse() {
        super.prepareForReuse()
        
        imageView.kf.cancelDownloadTask()
        imageView.image = nil
    }
}

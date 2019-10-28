import Kingfisher
import Then
import UIKit

internal final class PhotoCollectionCell: UICollectionViewCell {
    // MARK: properties
    internal let imageView = UIImageView().then {
        $0.contentMode = .scaleAspectFill
        $0.isOpaque = true
        $0.clipsToBounds = true
        $0.backgroundColor = .white
    }
    
    // MARK: init
    internal override init(frame: CGRect) {
        super.init(frame: .zero)

        self.isOpaque = true
        self.clipsToBounds = true
        self.backgroundColor = .white
        
        contentView.backgroundColor = .white
        contentView.clipsToBounds = true
        contentView.isOpaque = true
        
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
        
        imageView.kf.placeholder?.remove(from: imageView)
        imageView.kf.cancelDownloadTask()
        imageView.image = nil
    }
}

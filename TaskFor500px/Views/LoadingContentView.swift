import SnapKit
import UIKit

internal final class LoadingContentView: UIView {
    // MARK: properties
    private let titleLabel = UILabel().then {
        $0.textColor = .darkGray
        $0.textAlignment = .center
    }
    private let activityIndicator = UIActivityIndicatorView(style: .gray)

    // MARK: init/deinit
    internal init(title: String) {
        super.init(frame: .zero)

        titleLabel.text = title

        setupViews()
    }
    
    @available(*, unavailable)
    internal required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: setup
    private func setupViews() {
        add(subview: titleLabel, withConstraints: { make in
            make.top.equalToSuperview()
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
        })

        add(subview: activityIndicator, withConstraints: { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(8)
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview()
        })
    }

    // MARK: update
    internal func update(title: String) {
        titleLabel.text = title
    }

    // MARK: animating
    internal func startAnimating() {
        activityIndicator.startAnimating()
    }

    internal func stopAnimating() {
        activityIndicator.stopAnimating()
    }
}

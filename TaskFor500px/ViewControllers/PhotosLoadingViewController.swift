import SnapKit
import Then
import UIKit

internal final class PhotosLoadingViewController: UIViewController {
    // MARK: properties
    private let contentView: LoadingContentView

    // MARK: init/deinit
    internal init(title: String = NSLocalizedString("Loading", comment: "")) {
        self.contentView = LoadingContentView(title: title)

        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    internal required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: setup
    private func setupViews() {
        view.backgroundColor = .clear

        view.add(subview: contentView, withConstraints: { make in
            make.center.equalToSuperview()
        })
    }

    // MARK: UIViewController
    internal override func viewDidLoad() {
        super.viewDidLoad()

        setupViews()
    }

    internal override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        contentView.startAnimating()
    }

    internal override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        contentView.stopAnimating()
    }

    // MARK: update
    internal func update(title: String) {
        contentView.update(title: title)
    }
}

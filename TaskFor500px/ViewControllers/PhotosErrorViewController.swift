import Then
import UIKit

internal final class PhotosErrorViewController: UIViewController {
    // MARK: properties
    private let label = UILabel().then {
        $0.text = NSLocalizedString("Photos failed to load.\nTap to try again", comment: "")
        $0.numberOfLines = 2
        $0.textAlignment = .center
        $0.textColor = .darkGray
    }
    private let onTap: () -> Void
    private lazy var tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(viewTapped))

    // MARK: init
    internal init(onTap: @escaping () -> Void) {
        self.onTap = onTap

        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    internal required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: setup
    private func setupViews() {
        view.backgroundColor = .clear
        view.addGestureRecognizer(tapRecognizer)

        view.add(subview: label, withConstraints: { make in
            make.center.equalToSuperview()
        })
    }

    // MARK: UIViewController
    internal override func viewDidLoad() {
        super.viewDidLoad()

        setupViews()
    }

    // MARK: interface actions
    @objc
    private func viewTapped() {
        onTap()
    }
}

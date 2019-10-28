import Kingfisher
import UIKit

internal final class PhotoDetailViewController: UIViewController, NavStackEmbedded, UIGestureRecognizerDelegate {
    // MARK: properties
    private let photoContainerView = UIView().then {
        $0.backgroundColor = .white
        $0.clipsToBounds = true
    }
    private let photoView: UIImageView
    private let detailsView = UIView()
    private lazy var titleLabel = UILabel().then {
        $0.textColor = .black
        $0.font = .preferredFont(forTextStyle: .title1)
        $0.text = photo.name
    }
    private lazy var subtitleLabel = UILabel().then {
        $0.textColor = .black
        $0.font = .preferredFont(forTextStyle: .subheadline)
        $0.text = "by \(photo.user.fullName) · \(DateFormatters.relative.localizedString(for: photo.createdAt.date, relativeTo: .now))"
    }
    private let avatarImageSize: CGFloat = 40
    private lazy var avatarImageView = UIImageView().then {
        $0.layer.borderColor = UIColor.lightGray.cgColor
        $0.layer.borderWidth = 1
        $0.layer.cornerRadius = avatarImageSize / 2
        $0.clipsToBounds = true
        $0.kf.setImage(with: photo.user.avatarURL, placeholder: R.image.defaultAvatar())
    }
    private lazy var pinchRecognizer = UIPinchGestureRecognizer(
        target: self, action: #selector(pinchRecognized(recognizer:))
    ).then {
        $0.delegate = self
    }
    private lazy var tapRecognizer = UITapGestureRecognizer(
        target: self, action: #selector(tapRecognized)
    )
    private lazy var panRecognizer = UIPanGestureRecognizer(
        target: self, action: #selector(panRecognized)
    ).then {
        $0.delegate = self
    }
    
    private let scaleRange: ClosedRange<CGFloat> = 1...5
    
    private var scaleRangeWithBounce: ClosedRange<CGFloat> {
        return scaleRange.widen(byPercentage: 30.percent)
    }
    
    private let originalTransform: CGAffineTransform
    private let aspectRatio: CGFloat
    private let photo: Photo
    
    // MARK: init
    internal init(image: UIImage, forPhoto photo: Photo) {
        let photoView = UIImageView(image: image)
        
        self.photo = photo
        self.aspectRatio = image.size.aspectRatio
        self.photoView = photoView
        self.originalTransform = photoView.transform
        
        super.init(nibName: nil, bundle: nil)
        
        photoView.isUserInteractionEnabled = true
        setupGestureRecognizers()
    }
    
    @available(*, unavailable)
    internal required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        teardownGestureRecognizers()
    }
    
    // MARK: setup
    private func setupGestureRecognizers() {
        view.addGestureRecognizer(pinchRecognizer)
        view.addGestureRecognizer(tapRecognizer)
        view.addGestureRecognizer(panRecognizer)
    }
    
    private func teardownGestureRecognizers() {
        view.removeGestureRecognizer(pinchRecognizer)
        view.removeGestureRecognizer(tapRecognizer)
        view.removeGestureRecognizer(panRecognizer)
    }
    
    private func setupViews() {
        view.backgroundColor = .white
        
        view.add(
            subview: photoContainerView,
            withConstraints: { make in
                make.top.equalToSuperviewOrSafeAreaLayoutGuide()
                make.leading.equalToSuperviewOrSafeAreaLayoutGuide()
                make.trailing.equalToSuperviewOrSafeAreaLayoutGuide()
            },
            subviews: { container in
                container.add(subview: photoView, withConstraints: { make in
                    make.width.equalToSuperview()
                    make.height.equalTo(photoContainerView.snp.width).dividedBy(aspectRatio)
                    make.center.equalToSuperview()
                })
            }
        )
        
        view.add(
            subview: detailsView,
            withConstraints: { make in
                make.top.equalTo(photoContainerView.snp.bottom)
                make.leading.equalToSuperviewOrSafeAreaLayoutGuide().offset(10)
                make.trailing.equalToSuperviewOrSafeAreaLayoutGuide().inset(10)
                make.bottom.equalToSuperviewOrSafeAreaLayoutGuide()
            },
            subviews: { container in
                container.add(subview: titleLabel, withConstraints: { make in
                    make.top.equalToSuperview()
                    make.leading.equalToSuperview()
                })
                
                container.add(subview: subtitleLabel, withConstraints: { make in
                    make.top.equalTo(titleLabel.snp.bottom).offset(4)
                    make.leading.equalToSuperview()
                    make.bottom.equalToSuperview()
                })
                
                container.add(subview: avatarImageView, withConstraints: { make in
                    make.top.greaterThanOrEqualToSuperview()
                    make.leading.greaterThanOrEqualTo(titleLabel.snp.trailing).offset(10)
                    make.leading.greaterThanOrEqualTo(subtitleLabel.snp.trailing).offset(10)
                    make.trailing.equalToSuperview().inset(10)
                    make.bottom.lessThanOrEqualToSuperview()
                    make.centerY.equalToSuperview()
                    make.size.equalTo(avatarImageSize)
                })
            }
        )
    }
    
    // MARK: UIViewController
    internal override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
    }
    
    internal override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navController.setNavigationBarHidden(false, animated: true)
    }
    
    internal override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        navController.interactivePopGestureRecognizer?.require(toFail: panRecognizer)
    }
    
    // MARK: gestures
    @objc
    private func tapRecognized() {
        navController.setNavigationBarHidden(navController.isNavigationBarHidden.toggled(), animated: true)
    }
    
    @objc
    private func panRecognized(recognizer: UIPanGestureRecognizer) {
        switch recognizer.state {
            case .possible:
                break
            case .began, .changed:
                let centerRange = CenterPointRange(view: photoView, containerView: photoContainerView).widen(byAmount: 20)
                
                photoView.center = photoView.center
                    .translated(by: recognizer.translation(in: photoContainerView))
                    .clamped(to: centerRange)
                
                recognizer.setTranslation(.zero, in: photoContainerView)
            case .ended, .cancelled, .failed:
                let centerRange = CenterPointRange(view: photoView, containerView: photoContainerView)
                let newCenter = photoView.center.clamped(to: centerRange)
                
                UIView.animate(
                    withDuration: 0.2,
                    delay: 0,
                    options: [.allowUserInteraction, .beginFromCurrentState, .curveEaseInOut],
                    animations: {
                        self.photoView.center = newCenter
                    }
                )
            @unknown default:
                fatalError("@unknown UIGestureRecognizer.State")
        }
    }
    
    @objc
    private func pinchRecognized(recognizer: UIPinchGestureRecognizer) {
        switch recognizer.state {
            case .possible:
                break
            case .began, .changed:
                // Set center
                let pinchLocation = recognizer.location(in: photoContainerView)
                var diff = pinchLocation.difference(to: photoView.center)
                diff.x *= abs(recognizer.scale - 1)
                diff.y *= abs(recognizer.scale - 1)
                
                let centerRange = CenterPointRange(view: photoView, containerView: photoContainerView).widen(byAmount: 20)
                let newCenter = photoView.center.translated(by: diff).clamped(to: centerRange)
                
                photoView.center = newCenter
                
                // Set transform
                let newTransform = photoView.transform.scaledBy(x: recognizer.scale, y: recognizer.scale)
                let newFrame = photoView.bounds.applying(newTransform)
                let newScale = newFrame.width / photoView.bounds.width
                let scaleToUse = newScale.clamped(to: scaleRangeWithBounce)
                let endTransform = originalTransform.scaledBy(x: scaleToUse, y: scaleToUse)
                
                photoView.transform = endTransform
                recognizer.scale = 1.0
            case .ended, .cancelled, .failed:
                let currentScale = photoView.frame.width / photoView.bounds.width
                let centerRange = CenterPointRange(view: photoView, containerView: photoContainerView)
                let newCenter = photoView.center.clamped(to: centerRange)
                
                let animations: () -> Void
                
                if scaleRange.contains(currentScale) {
                    animations = { self.photoView.center = newCenter }
                } else {
                    let endScale = currentScale.clamped(to: scaleRange)
                    let newTransform = self.originalTransform.scaledBy(x: endScale, y: endScale)
                    
                    animations = {
                        self.photoView.transform = newTransform
                        self.photoView.center = newCenter
                    }
                }
            
                UIView.animate(
                    withDuration: 0.2,
                    delay: 0,
                    options: [.allowUserInteraction, .beginFromCurrentState, .curveEaseInOut],
                    animations: animations
                )
            @unknown default:
                fatalError("@unknown UIGestureRecognizer.State")
        }
    }

    // MARK: UIGestureRecognizerDelegate
    internal func gestureRecognizer(
        _ gestureRecognizer: UIGestureRecognizer,
        shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer
    ) -> Bool {
        return true
    }
}
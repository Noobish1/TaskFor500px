import Kingfisher
import UIKit

internal final class PhotoDetailViewController: UIViewController, UIGestureRecognizerDelegate {
    // MARK: properties
    private let photoContainerView = UIView().then {
        $0.backgroundColor = .white
        $0.clipsToBounds = true
    }
    internal let photoView: UIImageView
    private let detailsView: PhotoDetailsView
    private lazy var bottomButton = BottomAnchoredButton(
        bottomInset: self.view.safeAreaInsets.bottom,
        bgColor: UIColor.black.lighter(by: 20.percent),
        onTap: { [weak self] in
            self?.dismiss(animated: true)
        }
    ).then {
        $0.update(title: NSLocalizedString("Close", comment: ""))
    }
    private lazy var pinchRecognizer = UIPinchGestureRecognizer(
        target: self, action: #selector(pinchRecognized(recognizer:))
    ).then {
        $0.delegate = self
    }
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
    
    internal let originFrame: CGRect
    internal let originImage: UIImage
    
    // MARK: init
    internal init(image: UIImage, forPhoto photo: Photo, originFrame: CGRect) {
        self.originImage = image
        self.originFrame = originFrame
        
        let photoView = UIImageView(image: image)
        
        self.photo = photo
        self.aspectRatio = image.size.aspectRatio
        self.photoView = photoView
        self.detailsView = PhotoDetailsView(photo: photo)
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
        photoContainerView.addGestureRecognizer(pinchRecognizer)
        photoContainerView.addGestureRecognizer(panRecognizer)
    }
    
    private func teardownGestureRecognizers() {
        photoContainerView.removeGestureRecognizer(pinchRecognizer)
        photoContainerView.removeGestureRecognizer(panRecognizer)
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
        
        view.add(subview: detailsView, withConstraints: { make in
            make.top.equalTo(photoContainerView.snp.bottom)
            make.leading.equalToSuperviewOrSafeAreaLayoutGuide()
            make.trailing.equalToSuperviewOrSafeAreaLayoutGuide()
        })
        
        view.add(subview: bottomButton, withConstraints: { make in
            make.top.equalTo(detailsView.snp.bottom)
            make.leading.equalToSuperviewOrSafeAreaLayoutGuide()
            make.trailing.equalToSuperviewOrSafeAreaLayoutGuide()
            make.bottom.equalToSuperview()
            make.height.greaterThanOrEqualTo(44)
        })
    }
    
    // MARK: UIViewController
    internal override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
    }
    
    internal override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        loadHighResVersion()
    }
    
    internal override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        photoView.kf.cancelDownloadTask()
    }
    
    // MARK: loading
    private func loadHighResVersion() {
        if let highResImageURL = photo.imageURL(forSize: .fullSize) {
            photoView.kf.setImage(with: highResImageURL, placeholder: photoView.image)
        }
    }
    
    // MARK: gestures
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
    
    // MARK: inset updates
    internal override func viewSafeAreaInsetsDidChange() {
        bottomButton.update(bottomInset: view.safeAreaInsets.bottom)
    }
}

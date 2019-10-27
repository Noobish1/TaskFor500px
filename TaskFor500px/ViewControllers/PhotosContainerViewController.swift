import RxSwift
import UIKit

internal final class PhotosContainerViewController: UIViewController {
    // MARK: State
    internal enum State: Equatable {
        case loading(PhotosLoadingViewController)
        case loaded(PhotosViewController)
        case errored(PhotosErrorViewController)
        
        // MARK: computed properties
        internal var viewController: UIViewController {
            switch self {
                case .loading(let vc): return vc
                case .loaded(let vc): return vc
                case .errored(let vc): return vc
            }
        }
    }
    
    // MARK: properties
    private let disposeBag = DisposeBag()
    private let photosClient = PhotosClient()
    private var state: State = .loading(PhotosLoadingViewController())
    
    // MARK: computed property
    internal override var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }
    
    // MARK: setup
    private func setupViews() {
        view.backgroundColor = .white
        
        addChildViewController(state.viewController, toContainerView: view)
    }
    
    // MARK: UIViewController
    internal override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
    }
    
    internal override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        fetchPhotos()
    }
    
    // MARK: fetch
    private func fetchPhotos() {
        transition(to: .loading(PhotosLoadingViewController()))
        
        photosClient.popularPhotos(forPage: 1)
            .subscribe(
                onSuccess: { [weak self] response in
                    guard let strongSelf = self else { return }
                    
                    strongSelf.transition(to: .loaded(PhotosViewController(response: response)))
                },
                onError: { [weak self] _ in
                    self?.transition(to: .errored(PhotosErrorViewController(onTap: { [weak self] in
                        self?.fetchPhotos()
                    })))
                }
            )
            .disposed(by: disposeBag)
    }
    
    // MARK: adding/removing children
    internal func addChildViewController(
        _ viewController: UIViewController,
        toContainerView containerView: UIView
    ) {
        containerView.add(fullscreenSubview: viewController.view)

        self.addChild(viewController)

        viewController.didMove(toParent: self)
    }

    internal func removeChildViewController(_ viewController: UIViewController) {
        viewController.willMove(toParent: nil)
        viewController.view.removeFromSuperview()
        viewController.removeFromParent()
    }
    
    // MARK: transition
    internal func transition(to newState: State) {
        guard newState != state else {
            return
        }

        let fromVC = self.state.viewController
        let toVC = newState.viewController

        transitionFromViewController(fromVC, toViewController: toVC, containerView: view)

        self.state = newState
    }
    
    internal func transitionFromViewController(
        _ fromViewController: UIViewController,
        toViewController: UIViewController,
        containerView: UIView
    ) {
        addChildViewController(toViewController, toContainerView: containerView)
        removeChildViewController(fromViewController)
    }
}

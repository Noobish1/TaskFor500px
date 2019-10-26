import GreedoLayout
import Kingfisher
import RxSwift
import SnapKit
import UIKit

internal final class PhotosViewController: UIViewController {
    // MARK: properties
    private let cellIdentifier = "photoCell"
    private lazy var collectionView = UICollectionView(
        frame: UIScreen.main.bounds,
        collectionViewLayout: UICollectionViewFlowLayout().then {
            $0.minimumInteritemSpacing = 5
            $0.minimumLineSpacing = 5
            $0.sectionInset = UIEdgeInsets(top: 10, left: 5, bottom: 5, right: 5)
        }
    ).then {
        $0.backgroundColor = .white
        $0.dataSource = self
        $0.delegate = self
        $0.prefetchDataSource = self
        $0.register(PhotoCollectionCell.self, forCellWithReuseIdentifier: cellIdentifier)
    }
    private lazy var greedoLayout = GreedoCollectionViewLayout(collectionView: collectionView).then {
        $0.fixedHeight = false
        $0.rowMaximumHeight = collectionView.bounds.height / 3
        $0.dataSource = self
    }
    private let disposeBag = DisposeBag()
    private let photosClient = PhotosClient()
    private let imageDownloader = ImageDownloader.default
    private var response: PopularPhotosResponse?
    
    // MARK: status bar
    internal override var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }
    
    // MARK: init
    @available(*, unavailable)
    internal required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    internal init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    // MARK: UIViewController
    internal override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        view.add(subview: collectionView, withConstraints: { make in
            make.top.equalToSuperviewOrSafeAreaLayoutGuide()
            make.leading.equalToSuperviewOrSafeAreaLayoutGuide()
            make.trailing.equalToSuperviewOrSafeAreaLayoutGuide()
            make.bottom.equalToSuperview()
        })
    }
    
    internal override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        photosClient.popularPhotos()
            .subscribe(
                onSuccess: { [weak self] response in
                    print("popularPhotos: \(response)")
                    
                    guard let strongSelf = self else { return }
                    
                    strongSelf.response = response
                    
                    strongSelf.collectionView.reloadData()
                },
                onError: { error in
                    print("popularPhotos errored: \(error)")
                }
            )
            .disposed(by: disposeBag)
    }
    
    internal override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        greedoLayout.clearCache()
        
        collectionView.collectionViewLayout.invalidateLayout()
    }
}

// MARK: UICollectionViewDataSourcePrefetching
extension PhotosViewController: UICollectionViewDataSourcePrefetching {
    private func imageURL(for indexPath: IndexPath) -> URL? {
        return response?.photos[indexPath.item].images.first(where: { $0.size == ImageSize.grid.rawValue })?.url
    }
    
    private func validImageURLs(for indexPaths: [IndexPath]) -> [URL] {
        return indexPaths.compactMap { imageURL(for: $0) }
    }
    
    internal func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        validImageURLs(for: indexPaths).forEach { url in
            imageDownloader.downloadImage(with: url)
        }
    }

    internal func collectionView(_ collectionView: UICollectionView, cancelPrefetchingForItemsAt indexPaths: [IndexPath]) {
        validImageURLs(for: indexPaths).forEach { url in
            imageDownloader.cancel(url: url)
        }
    }
}

// MARK: UICollectionViewFlowLayoutDataSource
extension PhotosViewController: UICollectionViewDataSource {
    internal func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return response?.photos.count ?? 0
    }
    
    internal func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: PhotoCollectionCell = collectionView.n1_dequeueReusableCell(identifier: cellIdentifier, indexPath: indexPath)
        
        if let url = imageURL(for: indexPath) {
            if let image: UIImage = ImageCache.default.retrieveImageInMemoryCache(forKey: url.absoluteString) {
                cell.imageView.image = image
            } else {
                cell.imageView.kf.setImage(with: url)
            }
        }
        
        return cell
    }
}

// MARK: UICollectionViewDelegateFlowLayout
extension PhotosViewController: UICollectionViewDelegateFlowLayout {
    internal func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        return greedoLayout.sizeForPhoto(at: indexPath)
    }
}

// MARK: GreedoSizeCalculatorDataSource
extension PhotosViewController: GreedoCollectionViewLayoutDataSource {
    // swiftlint:disable implicitly_unwrapped_optional
    internal func greedoCollectionViewLayout(_ layout: GreedoCollectionViewLayout!, originalImageSizeAt indexPath: IndexPath!) -> CGSize {
    // swiftlint:enable implicitly_unwrapped_optional
        return response?.photos[safe: indexPath.item]?.size ?? CGSize(width: 0.1, height: 0.1)
    }
}

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
            $0.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        }
    ).then {
        $0.backgroundColor = .white
        $0.isOpaque = true
        $0.clipsToBounds = true
        $0.dataSource = self
        $0.delegate = self
        $0.prefetchDataSource = self
        $0.register(PhotoCollectionCell.self, forCellWithReuseIdentifier: cellIdentifier)
    }
    private lazy var greedoLayout = GreedoCalculator(
        rowMaximumHeight: collectionView.bounds.height / 3,
        originalSizeForIndexPath: { [unowned self] indexPath in
            self.viewModel.photo(at: indexPath)?.size ?? CGSize(width: 0.1, height: 0.1)
        }
    )
    private let disposeBag = DisposeBag()
    private let photosClient = PhotosClient()
    private let imageDownloader = ImageDownloader.default
    private let viewModel: PhotosViewModel
    
    // MARK: init
    @available(*, unavailable)
    internal required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    internal init(response: PopularPhotosResponse) {
        self.viewModel = PhotosViewModel(response: response)
        
        super.init(nibName: nil, bundle: nil)
    }
    
    // MARK: setup
    private func setupViews() {
        view.backgroundColor = .white
        
        view.add(subview: collectionView, withConstraints: { make in
            make.top.equalToSuperviewOrSafeAreaLayoutGuide()
            make.leading.equalToSuperviewOrSafeAreaLayoutGuide()
            make.trailing.equalToSuperviewOrSafeAreaLayoutGuide()
            make.bottom.equalToSuperview()
        })
    }
    
    // MARK: UIViewController
    internal override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
    }
    
    internal override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        greedoLayout.clearCache()
        
        collectionView.collectionViewLayout.invalidateLayout()
    }
    
    }
}

// MARK: UICollectionViewDataSourcePrefetching
extension PhotosViewController: UICollectionViewDataSourcePrefetching {
    internal func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        let urls = viewModel.validImageURLs(for: indexPaths)
            
        ImagePrefetcher(urls: urls).start()
    }

    internal func collectionView(_ collectionView: UICollectionView, cancelPrefetchingForItemsAt indexPaths: [IndexPath]) {
        viewModel.validImageURLs(for: indexPaths).forEach { url in
            ImageDownloader.default.cancel(url: url)
        }
    }
}

// MARK: UICollectionViewFlowLayoutDataSource
extension PhotosViewController: UICollectionViewDataSource {
    internal func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.numberOfPhotos
    }
    
    internal func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: PhotoCollectionCell = collectionView.n1_dequeueReusableCell(identifier: cellIdentifier, indexPath: indexPath)
        
        if let url = viewModel.imageURL(for: indexPath) {
            cell.imageView.kf.setImage(with: url, placeholder: PhotoPlaceholderView())
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
        return greedoLayout.sizeForPhoto(at: indexPath, collectionView: collectionView)
    }
}

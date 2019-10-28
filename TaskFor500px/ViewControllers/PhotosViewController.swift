import Kingfisher
import RxSwift
import SnapKit
import UIKit

internal final class PhotosViewController: UIViewController, NavStackEmbedded {
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
        
        $0.addInfiniteScroll { [weak self] _ in
            self?.fetchNextPage()
        }
    }
    private lazy var greedoLayout = GreedoCalculator(
        rowMaximumHeight: 200,
        originalSizeForIndexPath: { [unowned self] indexPath in
            self.viewModel.photo(at: indexPath)?.size ?? CGSize(width: 0.1, height: 0.1)
        }
    )
    private let disposeBag = DisposeBag()
    private let photosClient = PhotosClient()
    private let viewModel: PhotosViewModel
    private var currentPage: Int
    
    // MARK: init
    @available(*, unavailable)
    internal required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    internal init(response: PopularPhotosResponse) {
        self.currentPage = response.currentPage
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
    
    internal override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    internal override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        greedoLayout.clearCache()
        
        collectionView.collectionViewLayout.invalidateLayout()
    }
    
    // MARK: fetching
    private func fetchNextPage() {
        guard currentPage < viewModel.pageConfig.numberOfPages else {
            collectionView.finishInfiniteScroll()
            
            return
        }
        
        let previousPage = currentPage
        
        currentPage += 1
        
        photosClient.popularPhotos(forPage: currentPage)
            .subscribe(
                onSuccess: { [weak self] response in
                    guard let strongSelf = self else { return }
                    
                    let insertedIndexPaths = strongSelf.viewModel.addPage(with: response)
                    
                    strongSelf.collectionView.performBatchUpdates({
                        strongSelf.collectionView.insertItems(at: insertedIndexPaths)
                    }, completion: { _ in
                        strongSelf.collectionView.finishInfiniteScroll()
                    })
                },
                onError: { [weak self] _ in
                    guard let strongSelf = self else { return }
                    
                    strongSelf.currentPage = previousPage
                    
                    strongSelf.collectionView.finishInfiniteScroll()
                }
            )
            .disposed(by: disposeBag)
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
    internal func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        
        guard let cell = collectionView.cellForItem(at: indexPath) as? PhotoCollectionCell else {
            fatalError("No cell for indexPath: \(indexPath)")
        }
        
        guard let image = cell.imageView.image else {
            fatalError("No image for cell: \(cell)")
        }
        
        guard let photo = viewModel.photo(at: indexPath) else {
            fatalError("No photo at indexPath: \(indexPath)")
        }
        
        let vc = PhotoDetailViewController(image: image, forPhoto: photo)
        
        navController.pushViewController(vc, animated: true)
    }
    
    internal func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        return greedoLayout.sizeForPhoto(at: indexPath, collectionView: collectionView)
    }
}

import GreedoLayout
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
        $0.dataSource = self
        $0.delegate = self
        $0.register(PhotoCollectionCell.self, forCellWithReuseIdentifier: cellIdentifier)
    }
    private lazy var greedoLayout = GreedoCollectionViewLayout(collectionView: collectionView).then {
        $0.dataSource = self
    }
    private let disposeBag = DisposeBag()
    private let photosClient = PhotosClient()
    private var response: PopularPhotosResponse?
    
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
            make.top.equalToSuperview()
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

// MARK: UICollectionViewFlowLayoutDataSource
extension PhotosViewController: UICollectionViewDataSource {
    internal func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return response?.photos.count ?? 0
    }
    
    internal func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: PhotoCollectionCell = collectionView.n1_dequeueReusableCell(identifier: cellIdentifier, indexPath: indexPath)
        
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

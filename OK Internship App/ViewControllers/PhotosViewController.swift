import UIKit
import Photos

class PhotosViewController: UIViewController {
    
    // MARK: - let/var
    private var images = [PHAsset]()
    
    private let photoLibraryCollectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())

        return collectionView
    }()
    
    // MARK: - lifecycle funcs
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpPhotoLibraryCollectionView()
        populatePhotos()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        photoLibraryCollectionView.frame = view.bounds
        
        setView()
        setNavigationItems()
    }
    
    // MARK: - flow funcs
    private func setView() {
        title = "Photos"
        view.backgroundColor = .white
        
        view.addSubview(photoLibraryCollectionView)
    }
    
    private func setNavigationItems() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Log out", style: .done, target: self, action: #selector(logoutButtonPressed))
        
        let containerView = UIControl(frame: CGRect.init(x: 0, y: 0, width: 30, height: 30))
        containerView.addTarget(self, action: #selector(userImagePressed), for: .touchUpInside)
        let imageSearch = UIImageView(frame: CGRect.init(x: 0, y: 0, width: 30, height: 30))
        imageSearch.layer.cornerRadius = imageSearch.bounds.width / 2
        imageSearch.clipsToBounds = true
        imageSearch.image = UIImage(named: "default")
        containerView.addSubview(imageSearch)
        let searchBarButtonItem = UIBarButtonItem(customView: containerView)
        searchBarButtonItem.width = 20
        searchBarButtonItem.customView?.layer.cornerRadius = 20
        
        navigationItem.leftBarButtonItem = searchBarButtonItem
    }
    
    @IBAction private func userImagePressed() {
        
    }
    
    @IBAction private func logoutButtonPressed() {
        dismiss(animated: true)
    }
    
    private func populatePhotos() {
        PHPhotoLibrary.requestAuthorization { [weak self] status in
            if status == .authorized {
                let assets = PHAsset.fetchAssets(with: PHAssetMediaType.image, options: nil)
                assets.enumerateObjects { (object, count, _) in
                    self?.images.append(object)
                }
                
                self?.images.reverse()
                
                DispatchQueue.main.async {
                    self?.photoLibraryCollectionView.reloadData()
                }
                
            }
        }
    }
    
    private func setUpPhotoLibraryCollectionView() {
        photoLibraryCollectionView.register(PhotoLibraryCollectionViewCell.self,
                                            forCellWithReuseIdentifier: PhotoLibraryCollectionViewCell.identifier)
        photoLibraryCollectionView.dataSource = self
        photoLibraryCollectionView.delegate = self
    }
}

extension PhotosViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = photoLibraryCollectionView.dequeueReusableCell(withReuseIdentifier: PhotoLibraryCollectionViewCell.identifier, for: indexPath) as! PhotoLibraryCollectionViewCell
        
        let asset = self.images[indexPath.row]
        let manager = PHImageManager.default()
        
        manager.requestImage(for: asset, targetSize: PHImageManagerMaximumSize, contentMode: .aspectFill, options: nil) { image, _ in
            guard let image = image else { return }
            cell.configure(image: image)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (view.frame.size.width / 3) - 3, height: (view.frame.size.height / 3) - 3)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 1, left: 1, bottom: 1, right: 1)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        print("\(indexPath.row)")
    }
}

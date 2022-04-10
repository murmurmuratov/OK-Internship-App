import UIKit

class PhotoLibraryCollectionViewCell: UICollectionViewCell {
    static let identifier = "PhotoLibraryCollectionViewCell"
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(imageView)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        imageView.frame = contentView.bounds
    }
    
    public func configure(image: UIImage) {
        imageView.image = image
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
//        imageView.image = nil
    }
}

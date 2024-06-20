import UIKit
import SnapKit

protocol CustomCollectionCellDelegate: AnyObject {
  
    func imageTapped(feedUid: String)

}

class CustomCollectionViewCell: UICollectionViewCell {
    static let identifier = "CustomCollectionViewCell"
    
    
    var delegate: CustomCollectionCellDelegate?
    
    var feedUid: String?
    
    var image: UIImageView = {
        let image = UIImageView()
        image.backgroundColor = .lightGray.withAlphaComponent(0.2)
        image.isUserInteractionEnabled = true
        
        return image
        
    }()
    
    
    
    
    var squareImage: UIImageView = {
        let imageView = UIImageView(image: UIImage(systemName: "square.fill.on.square.fill"))
        imageView.tintColor = .white
        
        imageView.isHidden = true
        
        return imageView
        
        
        
    }()
  
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUI()
    }

    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUI() {
        
        let gesture = UITapGestureRecognizer(target: self, action: #selector(imageTapped))
        self.image.addGestureRecognizer(gesture)
        
        contentView.addSubview(self.image)
        contentView.addSubview(self.squareImage)
        
        self.image.snp.makeConstraints {
            $0.top.bottom.trailing.leading.equalTo(self.contentView)
        }
        self.squareImage.snp.makeConstraints {
            $0.trailing.top.equalTo(self.image).inset(6)
            $0.width.height.equalTo(20)
        }
    
    }
    
    @objc
    func imageTapped() {
        guard let feedUid = self.feedUid else {return}
        self.delegate?.imageTapped(feedUid: feedUid)
    }
    
    
}

import UIKit

protocol CustomCollectionCellDelegate {
  
    func imageTapped(feedUid:String)
}

class CustomCollectionViewCell: UICollectionViewCell {
    static let identifier = "CustomCollectionViewCell"
    
    
    var delegate : CustomCollectionCellDelegate?
    
    var feedUid : String?
    
    var image : UIImageView = {
        let image = UIImageView()
        image.backgroundColor = .lightGray.withAlphaComponent(0.2)
        image.translatesAutoresizingMaskIntoConstraints = false
        image.isUserInteractionEnabled = true
        
        return image
        
    }()
    
    
    
    
    var squareImage : UIImageView = {
        let imageView = UIImageView(image: UIImage(systemName: "square.fill.on.square.fill"))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.tintColor = .white
        
        imageView.isHidden = true
        
        return imageView
        
        
        
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUI()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUI() {
        
        let gesture = UITapGestureRecognizer(target: self, action: #selector(imageTapped))
        self.image.addGestureRecognizer(gesture)
        
        contentView.addSubview(self.image)
        contentView.addSubview(self.squareImage)
        
        
        
        NSLayoutConstraint.activate([
            self.image.topAnchor.constraint(equalTo: self.contentView.topAnchor),
            self.image.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor),
            self.image.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor),
            self.image.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor),
            
            self.squareImage.topAnchor.constraint(equalTo: self.image.topAnchor , constant: 6),
            self.squareImage.trailingAnchor.constraint(equalTo: self.image.trailingAnchor , constant: -6),
            self.squareImage.widthAnchor.constraint(equalToConstant: 20),
            self.squareImage.heightAnchor.constraint(equalToConstant: 20),
        
        ])
    }
    
    @objc
    func imageTapped(){
        guard let feedUid = self.feedUid else {return}
        self.delegate?.imageTapped(feedUid: feedUid)
    }
    
    
}

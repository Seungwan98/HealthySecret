import UIKit



class DummyCollectionCell: UICollectionViewCell {
    static let identifier = "DummyCollectionCell"
    
    
    private let backgroundImage = UIImageView(image: UIImage(named: "일반적.png"))
    
    public let backgroundLabel = UILabel()
  
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
        self.backgroundImage.translatesAutoresizingMaskIntoConstraints = false
        self.backgroundLabel.translatesAutoresizingMaskIntoConstraints = false
        
        
        backgroundLabel.font = .boldSystemFont(ofSize: 12)
        backgroundLabel.textAlignment = .center
        backgroundLabel.textColor = .lightGray.withAlphaComponent(0.8)
        
        
        
        self.addSubview(backgroundImage)
        self.addSubview(backgroundLabel)
        self.isHidden = true

        NSLayoutConstraint.activate([
        
            
            self.backgroundImage.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            self.backgroundImage.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            self.backgroundImage.widthAnchor.constraint(equalToConstant: 50),
            self.backgroundImage.heightAnchor.constraint(equalToConstant: 50),
        
            
            self.backgroundLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            self.backgroundLabel.topAnchor.constraint(equalTo: self.backgroundImage.bottomAnchor , constant: 2),
        ])
        
        
        
    }
    
    
}

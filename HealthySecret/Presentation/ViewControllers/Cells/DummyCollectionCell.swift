import UIKit
import SnapKit



class DummyCollectionCell: UICollectionViewCell {
    static let identifier = "DummyCollectionCell"
    
    
    private let backgroundImage = UIImageView(image: UIImage(named: "일반적.png"))
    
    public let backgroundLabel = UILabel()
  
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUI()
        self.backgroundColor = .black
      
    }
    required init?(coder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUI() {
        
        
        backgroundLabel.font = .boldSystemFont(ofSize: 12)
        backgroundLabel.textAlignment = .center
        backgroundLabel.textColor = .lightGray.withAlphaComponent(0.8)
        
        
        
        self.addSubview(backgroundImage)
        self.addSubview(backgroundLabel)
        self.isHidden = true

        self.backgroundImage.snp.makeConstraints {
            $0.center.equalTo(self)
            $0.width.height.equalTo(50)
        }
        self.backgroundLabel.snp.makeConstraints {
            $0.centerX.equalTo(self)
            $0.top.equalTo(self.backgroundImage.snp.bottom).offset(2)
        }
       
        
    }
    
    
}

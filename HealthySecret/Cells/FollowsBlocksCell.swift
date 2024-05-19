import UIKit


protocol FollowsBlocksCellDelegate {
    func didPressbutton(for index: String , like: Bool)
    func didPressProfile(for index: String)
}

class FollowsBlocksCell : UITableViewCell {
    
    
    let button : UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 15
        button.tintColor = .white
        button.titleLabel?.font = .boldSystemFont(ofSize: 12)
        button.isUserInteractionEnabled = true
        
        
        
        return button
        
        
    }()
    var nickname = UILabel()
    
    var profileImage : UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 20
        imageView.isUserInteractionEnabled = true
        
        
        return imageView
        
        
        
    }()
    var delegate: FollowsBlocksCellDelegate?
    var selector : Bool?
    var index : String?
    
    
    @objc func didPressedFollow(_ sender: UIButton) {
        
        print("touch")
        
        guard let index = self.index else {return}

        sender.isSelected = !sender.isSelected
        
        if sender.isSelected {
            
            delegate?.didPressbutton(for: index , like: true)

            
            followIsTouched = true
        }else {
            delegate?.didPressbutton(for: index , like: false)

            followIsTouched = false
            
        }

        
        
    } 
    
    @objc func didPressedBlock(_ sender: UIButton) {
        
        print("touch")
        
        guard let index = self.index else {return}

        sender.isSelected = !sender.isSelected
        
        if sender.isSelected {
            
            delegate?.didPressbutton(for: index , like: true)

            
            self.blockIsTouched = true
        }else {
            delegate?.didPressbutton(for: index , like: false)

            self.blockIsTouched = false
            
        }

        
        
    }
    
    @objc func didPressedProfile(_ sender: UIButton) {
        
        guard let index = self.index else {return}

        self.delegate?.didPressProfile(for: index)

        
        
    }
    var followIsTouched: Bool? {
        didSet {
            if followIsTouched == true {
                
                button.backgroundColor = .lightGray
                button.setTitle("팔로잉", for: .normal)
                
            }else{
                button.backgroundColor = .systemBlue
                button.setTitle("팔로우", for: .normal)
            }
        }
    }
    
    
    var blockIsTouched: Bool? {
        didSet {
            if blockIsTouched == true {
                
                button.backgroundColor = .systemBlue
                button.setTitle("차단해제", for: .normal)
                
            }else{
                button.backgroundColor = .black
                button.setTitle("차단", for: .normal)
            }
        }
    }
    
    func setBlockButton(){
        button.addTarget(self, action: #selector(didPressedBlock) , for: .touchUpInside )

    }
    
    func setFollowButton(){
        button.addTarget(self, action: #selector(didPressedFollow) , for: .touchUpInside )

    }
    
    
    
    required override init( style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier )
        
        
        
        

        let profileGesture = UITapGestureRecognizer(target: self, action: #selector(didPressedProfile))
        profileImage.addGestureRecognizer(profileGesture)
        
        layout()
        
    }
  
    
  
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    
    
    
    
    
    
    func layout() {
        
        
        
        self.button.translatesAutoresizingMaskIntoConstraints = false
        self.nickname.translatesAutoresizingMaskIntoConstraints = false
        self.profileImage.translatesAutoresizingMaskIntoConstraints = false
        
        self.nickname.font = .systemFont(ofSize: 18)
        
        self.addSubview(contentView)
        self.contentView.addSubview(self.button)
        self.contentView.addSubview(self.nickname)
        self.contentView.addSubview(self.profileImage)
        
        
        NSLayoutConstraint.activate([
            
            
            self.profileImage.widthAnchor.constraint(equalToConstant: 40),
            self.profileImage.heightAnchor.constraint(equalToConstant: 40),
            self.profileImage.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            self.profileImage.leadingAnchor.constraint(equalTo: self.leadingAnchor , constant: 16),
            
            
            self.button.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -12),
            self.button.centerYAnchor.constraint(equalTo: self.contentView.safeAreaLayoutGuide.centerYAnchor),
            self.button.widthAnchor.constraint(equalToConstant: 80),
            self.button.heightAnchor.constraint(equalToConstant: 30),
            
            
            self.nickname.leadingAnchor.constraint(equalTo: self.profileImage.trailingAnchor , constant: 10),
            self.nickname.centerYAnchor.constraint(equalTo: self.centerYAnchor ),
            self.nickname.trailingAnchor.constraint(equalTo: self.button.leadingAnchor , constant: -10 ),
            
            
        ])
        
        
        
        
        
        
    }
    
    
    
}


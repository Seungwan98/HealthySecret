import UIKit


protocol FollowsCellDelegate {
    func didPressFollows(for index: String , like: Bool)
    func didPressProfile(for index: String)
}

class FollowsCell : UITableViewCell {
    
    
    let followButton : UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 15
        // button.clipsToBounds = true
        button.tintColor = .white
        button.backgroundColor = .systemBlue
        button.setTitle("팔로우", for: .normal )
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
    var delegate: FollowsCellDelegate?
    var selector : Bool?
    var index : String?
    
    
    @objc func didPressedFollow(_ sender: UIButton) {
        
        print("touch")
        
        guard let index = self.index else {return}

        sender.isSelected = !sender.isSelected
        
        if sender.isSelected {
            
            delegate?.didPressFollows(for: index , like: true)

            isTouched = true
        }else {
            delegate?.didPressFollows(for: index , like: false)

            isTouched = false
            
        }

        
        
    } 
    
    @objc func didPressedProfile(_ sender: UIButton) {
        
        guard let index = self.index else {return}

        self.delegate?.didPressProfile(for: index)

        
        
    }
    var isTouched: Bool? {
        didSet {
            if isTouched == true {
                
                followButton.backgroundColor = .lightGray
                followButton.setTitle("팔로잉", for: .normal)
                
            }else{
                followButton.backgroundColor = .systemBlue
                followButton.setTitle("팔로우", for: .normal)
            }
        }
    }
    
    
    
    required override init( style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier )
        followButton.addTarget(self, action: #selector(didPressedFollow) , for: .touchUpInside )
        
        let profileGesture = UITapGestureRecognizer(target: self, action: #selector(didPressedProfile))
        profileImage.addGestureRecognizer(profileGesture)
        
        layout()
        
    }
    
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    
    
    
    
    
    
    func layout() {
        
        
        
        self.followButton.translatesAutoresizingMaskIntoConstraints = false
        self.nickname.translatesAutoresizingMaskIntoConstraints = false
        self.profileImage.translatesAutoresizingMaskIntoConstraints = false
        
        self.nickname.font = .systemFont(ofSize: 18)
        
        self.addSubview(contentView)
        self.contentView.addSubview(self.followButton)
        self.contentView.addSubview(self.nickname)
        self.contentView.addSubview(self.profileImage)
        
        
        NSLayoutConstraint.activate([
            
            
            self.profileImage.widthAnchor.constraint(equalToConstant: 40),
            self.profileImage.heightAnchor.constraint(equalToConstant: 40),
            self.profileImage.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            self.profileImage.leadingAnchor.constraint(equalTo: self.leadingAnchor , constant: 16),
            
            
            self.followButton.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -12),
            self.followButton.centerYAnchor.constraint(equalTo: self.contentView.safeAreaLayoutGuide.centerYAnchor),
            self.followButton.widthAnchor.constraint(equalToConstant: 80),
            self.followButton.heightAnchor.constraint(equalToConstant: 30),
            
            
            self.nickname.leadingAnchor.constraint(equalTo: self.profileImage.trailingAnchor , constant: 10),
            self.nickname.centerYAnchor.constraint(equalTo: self.centerYAnchor ),
            self.nickname.trailingAnchor.constraint(equalTo: self.followButton.leadingAnchor , constant: -10 ),
            
            
        ])
        
        
        
        
        
        
    }
    
    
    
}


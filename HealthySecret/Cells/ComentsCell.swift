import UIKit

protocol ComentsCellDelegate {
  
    func report(comentsUid : String)
    func delete(comentsUid : String)
    func profileTapped(comentsUuid : String)
}

class ComentsCell : UITableViewCell  {
    
    static let identifier = "ComentsCell"
    
    var delegate : ComentsCellDelegate?
    
    var comentsVC : ComentsVC?
    
    var comentUid : String?
    
    var mine : Bool?
    
    var comentsUuid : String?
    
    
    var profileImage : UIImageView = {
       let imageView = UIImageView()
        imageView.isUserInteractionEnabled = true

        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 15
        imageView.image = UIImage(named: "일반적.png")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.backgroundColor = .lightGray
        return imageView
    }()
    
    let nicknameLabel : UILabel = {
       let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.text = "승팔"
        return label
    }()
    
   
    
    
    
    let comentsLabel : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 14)
        label.isUserInteractionEnabled = true
        label.sizeToFit()
        label.numberOfLines = 0

        return label
    }()
    
   
    
    let dateLabel : UILabel = {
       let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .lightGray

        label.text = "2024.09.14"
        return label
        
        
    }()
     
    
    let topView : UIView = {
       let view = UIView()
        view.isUserInteractionEnabled = true

        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        return view
        
        
    }()
    
    let ownTitle : UILabel = {
       let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "작성자"
        label.textColor = .white
        label.font = .boldSystemFont(ofSize: 10)
        label.backgroundColor = .systemBlue
        label.layer.masksToBounds = true
        label.layer.cornerRadius = 4
        label.textAlignment = .center
        return label
        
    }()
    
    var ellipsis : UIButton = {
       let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(systemName: "ellipsis"), for: .normal)
        button.tintColor = .black
        button.contentVerticalAlignment = .center
        button.contentHorizontalAlignment = .center
        return button
    }()
  
    
 
  
    
    required override init( style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier )

        print("cell init")
        
        setUI()

    }
    
    
    
    
  
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func delete(){
        delegate?.delete(comentsUid: self.comentUid ?? "")
    }
    
    func report(){
        delegate?.report(comentsUid: self.comentUid ?? "")
        
    }
    
    @objc
    func profileTapped(tapGestureRecognizer: UITapGestureRecognizer){
        
        print("tapped")
        delegate?.profileTapped(comentsUuid: self.comentsUuid ?? "" )
        
    }

    
    
  
    
    
   
 
   
    
 
    
    
    
    private func setUI() {
        
        let gesture = UITapGestureRecognizer(target: self, action: #selector(profileTapped ))
        
        self.profileImage.addGestureRecognizer(gesture)
        
        
        
        self.contentView.isUserInteractionEnabled = true
        self.contentView.addSubview(self.topView)
        
        self.topView.addSubview(self.profileImage)
        self.topView.addSubview(self.nicknameLabel)
        self.topView.addSubview(self.ownTitle)
        self.topView.addSubview(self.ellipsis)
        self.contentView.addSubview(self.comentsLabel)
        self.contentView.addSubview(self.dateLabel)
    
        
        self.ellipsis.addTarget(self, action: #selector(actionSheetAlert), for: .touchUpInside )
     
        
        
        NSLayoutConstraint.activate([
   
            
            self.topView.topAnchor.constraint(equalTo: self.contentView.topAnchor , constant: 10),
            self.topView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor , constant: 10 ),
            self.topView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor ),
            self.topView.heightAnchor.constraint(equalToConstant: 30 ),
            
            
            self.profileImage.centerYAnchor.constraint(equalTo: self.topView.centerYAnchor),
            self.profileImage.leadingAnchor.constraint(equalTo: self.topView.leadingAnchor , constant: 10),
            self.profileImage.widthAnchor.constraint(equalToConstant: 30),
            self.profileImage.heightAnchor.constraint(equalToConstant: 30),
            
            
            self.ownTitle.centerYAnchor.constraint(equalTo: self.topView.centerYAnchor),
            self.ownTitle.leadingAnchor.constraint(equalTo: self.nicknameLabel.trailingAnchor , constant:6),
            self.ownTitle.heightAnchor.constraint(equalToConstant: 16),
            self.ownTitle.widthAnchor.constraint(equalToConstant: 30),
            

            self.nicknameLabel.centerYAnchor.constraint(equalTo: self.topView.centerYAnchor ),
            self.nicknameLabel.leadingAnchor.constraint(equalTo: self.profileImage.trailingAnchor , constant: 10 ),
            
            NSLayoutConstraint(item: self.nicknameLabel, attribute: .width, relatedBy: .lessThanOrEqual, toItem: self , attribute: .width, multiplier: 1.0, constant: -60),

            
            self.ellipsis.centerYAnchor.constraint(equalTo: self.topView.centerYAnchor ),
            self.ellipsis.trailingAnchor.constraint(equalTo: self.topView.trailingAnchor ),
            self.ellipsis.widthAnchor.constraint(equalToConstant: 40 ),
            self.ellipsis.heightAnchor.constraint(equalToConstant: 40 ),
 
            
            self.comentsLabel.topAnchor.constraint(equalTo: self.topView.bottomAnchor , constant: 10 ),
            self.comentsLabel.leadingAnchor.constraint(equalTo: self.nicknameLabel.leadingAnchor ),
            self.comentsLabel.trailingAnchor.constraint(equalTo: self.topView.trailingAnchor , constant: -60),
            
            
            self.dateLabel.topAnchor.constraint(equalTo: self.comentsLabel.bottomAnchor , constant: 10 ),
            self.dateLabel.leadingAnchor.constraint(equalTo: self.nicknameLabel.leadingAnchor ),
            self.dateLabel.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor , constant: -10),
            self.dateLabel.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor , constant: -10),
            self.dateLabel.heightAnchor.constraint(equalToConstant: 20),


            
            
            
            
        
            
          
            
            
           
            
            
          
            
                                                
            
            
        
        ])
    }
    
    
    

}
extension ComentsCell : UIImagePickerControllerDelegate , UINavigationControllerDelegate {
    @objc func actionSheetAlert( ){
        let alert = UIAlertController(title: nil , message: nil , preferredStyle: .actionSheet)
        
        let cancel = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        alert.addAction(cancel)
        alert.view.tintColor = .black

        guard let mine = self.mine else {return}
        
        if( mine ){
            let declaration = UIAlertAction(title: "삭제하기", style: .default) { [weak self] _ in
                self?.delete()
            }
        
            

            declaration.setValue(UIColor.red, forKey: "titleTextColor")
            
            alert.addAction(declaration)
        }else{
            let report = UIAlertAction(title: "신고하기", style: .default) { [weak self] _ in
                self?.report()
            }
            report.setValue(UIColor.red, forKey: "titleTextColor")

            alert.addAction(report)

        }
                
        comentsVC?.present(alert, animated: true, completion: nil)
        
    }
    
    
   
}


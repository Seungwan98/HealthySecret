import UIKit
import SnapKit

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
        return imageView
    }()
    
    let nicknameLabel : UILabel = {
       let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.text = "승팔"
        return label
    }()
    
   
    
    
    
    let comentsLabel : UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.isUserInteractionEnabled = true
        label.sizeToFit()
        label.numberOfLines = 0

        return label
    }()
    
   
    
    let dateLabel : UILabel = {
       let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .lightGray

        label.text = "2024.09.14"
        return label
        
        
    }()
     
    
    let topView : UIView = {
       let view = UIView()
        view.isUserInteractionEnabled = true

        view.backgroundColor = .white
        return view
        
        
    }()
    
    let ownTitle : UILabel = {
       let label = UILabel()
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
     
        
        
        self.topView.snp.makeConstraints{
            $0.top.leading.equalTo(self.contentView).inset(10)
            $0.trailing.equalTo(self.contentView)
            $0.height.equalTo(30)
        }
        self.profileImage.snp.makeConstraints{
            $0.width.height.equalTo(36)
            $0.centerY.equalTo(self.topView)
            $0.leading.equalTo(self.topView).inset(10)
        }
        self.ownTitle.snp.makeConstraints{
            $0.centerY.equalTo(self.topView)
            $0.leading.equalTo(self.nicknameLabel.snp.trailing).offset(6)
            $0.height.equalTo(16)
            $0.width.equalTo(30)
        }
        self.nicknameLabel.snp.makeConstraints{
            $0.centerY.equalTo(self.topView)
            $0.leading.equalTo(self.profileImage.snp.trailing).offset(10)
            $0.width.lessThanOrEqualTo(self).offset(-60)
        }
        self.ellipsis.snp.makeConstraints{
            $0.centerY.trailing.equalTo(self.topView)
            $0.width.height.equalTo(40)
        }
        self.comentsLabel.snp.makeConstraints{
            $0.top.equalTo(self.topView.snp.bottom).offset(10)
            $0.leading.equalTo(self.nicknameLabel)
            $0.trailing.equalTo(topView).offset(-60)
        }
        self.dateLabel.snp.makeConstraints{
            $0.height.equalTo(20)
            $0.trailing.bottom.equalTo(self.contentView).inset(10)
            $0.leading.equalTo(self.nicknameLabel)
            $0.top.equalTo(self.comentsLabel.snp.bottom).offset(10)
        }
        
        
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


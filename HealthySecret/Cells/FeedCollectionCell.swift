import UIKit
import SnapKit

protocol FeedCollectionCellDelegate {
    func didPressHeart(for index: String, like: Bool)
    
    func didPressComents(for index: String )
    
    func delete(for index: String)
    
    func report(for index: String)
    
    func update(for index: String)
        
    func didPressedProfile(for index: String)
    
    func didPressedLikes(for index: String)
}

class FeedCollectionCell: UITableViewCell , UIScrollViewDelegate {
    static let identifier = "FeedCollectionCell"
    
    var own : Bool?
    
    var commuVC : CommuVC?
    
    var mainImage : UIImageView = {
        let image = UIImageView()
        image.backgroundColor = .lightGray.withAlphaComponent(0.2)
        return image
        
    }()
    
    let topView = UIView()
    
    let bottomView : UIView = {
        let view = UIView()
        view.isUserInteractionEnabled = true
        
        
        return view
        
        
    }()
    
    var profileImage : UIImageView = {
       let imageView = UIImageView()
        imageView.layer.masksToBounds = true

        imageView.isUserInteractionEnabled = true

        imageView.layer.cornerRadius = 20
        imageView.backgroundColor = .clear
        
        return imageView
    }()
    
    let nicknameLabel : UILabel = {
       let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 18)
        return label
        
        
    }()
    
    var contentLabel : UILabel = {
        
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.isUserInteractionEnabled = true
        
        
        return label
    }()
    
    let likesButton : UIButton = {
        let button = UIButton()
        
        button.setImage( UIImage(systemName: "heart")  , for: .normal)
        button.contentVerticalAlignment = .fill
        button.contentHorizontalAlignment = .fill
        button.tintColor = .black
        
        button.snp.makeConstraints{
            $0.width.equalTo(30)
            $0.height.equalTo(26)
        }
   
        return button
    }()
    
    let comentsButton : UIButton = {
        let button = UIButton()
        
        button.setImage( UIImage(systemName: "message")  , for: .normal)
        
        button.contentVerticalAlignment = .fill
        button.contentHorizontalAlignment = .fill
        button.tintColor = .black

        button.snp.makeConstraints{
            $0.width.equalTo(30)
            $0.height.equalTo(26)
        }
   
        
        return button
    }()
    
    
    lazy var buttonStackView : UIStackView = {
        let stackview = UIStackView(arrangedSubviews: [self.likesButton , self.comentsButton])
        stackview.axis = .horizontal
        stackview.alignment = .center
        stackview.distribution = .fillProportionally
        stackview.spacing = 14
        return stackview
        
    }()
    
    let likesLabel : UILabel = {
       let label = UILabel()
        label.font = .boldSystemFont(ofSize: 16)
        label.text = "좋아요 0개"
        label.isUserInteractionEnabled = true

        return label
        
        
    }()
    
    let comentsLabel : UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16)
        label.text = "댓글 0개 보기"
        label.textColor = .lightGray
        label.isUserInteractionEnabled = true


        
        return label
    }()
    
    var pageControl = UIPageControl()
    var scrollView = UIScrollView()
    var imageViews = [UIImageView]()
    
    let dateLabel : UILabel = {
        let label = UILabel()
        label.textColor = .lightGray
        label.font = .systemFont(ofSize: 14)
        return label
    }()
    
    let ellipsis : UIButton = {
       let button = UIButton()
        button.setImage(UIImage(systemName: "ellipsis"), for: .normal)
        button.tintColor = .black
        button.contentVerticalAlignment = .center
        button.contentHorizontalAlignment = .center
        return button
    }()
    
   
     
     func addContentScrollView() {
         DispatchQueue.main.async {
             
             for i in 0..<self.imageViews.count {
                 print("iii")
                 
                 let xPos = self.scrollView.frame.width * CGFloat(i)
                 self.imageViews[i].frame = CGRect(x: xPos, y: 0, width: self.scrollView.bounds.width, height: self.scrollView.bounds.height)
                 
                 self.scrollView.addSubview(self.imageViews[i])
                 self.scrollView.contentSize.width = self.imageViews[i].frame.width * CGFloat(i + 1)
                 
                 
                 

             }
         }
     }
     
    func setPageControl(count : Int) {
             pageControl.numberOfPages = count
            
         
     }
     
     private func setPageControlSelectedPage(currentPage:Int) {
         print("\(currentPage) current Page")
         pageControl.currentPage = currentPage
     }
     
     func scrollViewDidScroll(_ scrollView: UIScrollView) {
         let value = scrollView.contentOffset.x/scrollView.frame.size.width
         setPageControlSelectedPage(currentPage: Int(round(value)))
     }
    
    var plusFeedsImage = UIImageView()
    
    
    var feedUid : String?
    
    var delegate : FeedCollectionCellDelegate?
    
    var likesCount : Int?
    
    var beforeContent : String?
    
    func setLikesLabel(count : Int){
        self.likesCount = count
        self.likesLabel.text = "좋아요 \(count)개"
        
    }
    
    func setContentLabel(){
        DispatchQueue.main.async {
            
            self.contentLabel.appendReadmore(after: self.beforeContent ?? "", trailingContent: .readmore)
            

            self.bottomView.invalidateIntrinsicContentSize()
            self.contentView.invalidateIntrinsicContentSize()

        }

        
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
    
        

        
            
    }
   
    
 
  
    
    required override init( style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier )

        print("cell init")
        
        setUI()

    }
    

   
    
    
  
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
  
    
    @objc
    func didTapLabel(_ sender: UITapGestureRecognizer) {

        guard let text = contentLabel.text else { return }
        
        
        print(text)
        

            let readmore = (text as NSString).range(of: TrailingContent.readmore.text)
            let readless = (text as NSString).range(of: TrailingContent.readless.text)
        if sender.didTap(label: contentLabel, inRange: readmore) {
            print("less")
            contentLabel.appendReadLess(after: beforeContent ?? "" , trailingContent: .readless)
            } else if  sender.didTap(label: contentLabel, inRange: readless) {
                print("more")
                contentLabel.appendReadmore(after: beforeContent ?? "" , trailingContent: .readmore)
            } else { return }
        

        UIView.setAnimationsEnabled(false)
        self.bottomView.invalidateIntrinsicContentSize()
        self.invalidateIntrinsicContentSize()
        UIView.setAnimationsEnabled(true)

        
        
            
        
        }
    
    @objc
    func didpressedProfile(_ sender : UITapGestureRecognizer) {
        delegate?.didPressedProfile(for: feedUid!)
    }
    
    @objc
    func didPressedComents(_ sender : UITapGestureRecognizer ){
        
        delegate?.didPressComents(for: feedUid!)
        print("dd")
        
    } 
    
    @objc
    func didpressedLikes(_ sender : UITapGestureRecognizer ){
        
        delegate?.didPressedLikes(for: feedUid!)
        print("dd")
        
    }
    
    
    @objc
    func didPressedHeart(_ sender: UIButton) {
        
        sender.isSelected = !sender.isSelected
        
        if sender.isSelected {
            let cnt = (self.likesCount ?? 0) + 1
            setLikesLabel(count: cnt)
            isTouched = true
            delegate?.didPressHeart(for: feedUid!, like: true)
        }else {
            let cnt = (self.likesCount ?? 1) - 1
            setLikesLabel(count: cnt)

            isTouched = false
            delegate?.didPressHeart(for: feedUid!, like: false)
        }
        
        
    }
    var isTouched: Bool? {
        didSet {
            if isTouched == true {
                likesButton.tintColor = .red
                likesButton.setImage(UIImage(systemName: "heart.fill", withConfiguration: UIImage.SymbolConfiguration(scale: .large)), for: .normal)
            }else{
                likesButton.tintColor = .black
                likesButton.setImage(UIImage(systemName: "heart", withConfiguration: UIImage.SymbolConfiguration(scale: .large)), for: .normal)
            }
        }
    }
   
    
    func delete(){
        delegate?.delete(for: self.feedUid!)
    }
    
    func report(){
        delegate?.report(for: self.feedUid!)
    }
    func update(){
        delegate?.update(for: self.feedUid!)
        
    }
 
    
    let mainView = UIView()
    
    private func setUI() {
        
        
        
        likesButton.addTarget(self, action: #selector(didPressedHeart), for: .touchUpInside)
        comentsButton.addTarget(self, action: #selector(didPressedComents), for: .touchUpInside)
        
        let contentLabelGesture = UITapGestureRecognizer(target: self, action: #selector(didTapLabel))
        contentLabel.addGestureRecognizer(contentLabelGesture)
        
        let comentsGesture = UITapGestureRecognizer(target: self, action: #selector(didPressedComents))
        comentsLabel.addGestureRecognizer(comentsGesture)
        
        let profileGesture = UITapGestureRecognizer(target: self, action: #selector(didpressedProfile))
        profileImage.addGestureRecognizer(profileGesture)
        
        let likesGesture = UITapGestureRecognizer(target: self , action: #selector(didpressedLikes))
        likesLabel.addGestureRecognizer(likesGesture)

        ellipsis.addTarget(self, action: #selector(actionSheetAlert), for: .touchUpInside)
        
        
        self.scrollView.isPagingEnabled = true
        self.scrollView.isScrollEnabled = true
        self.scrollView.showsHorizontalScrollIndicator = false
        self.scrollView.showsVerticalScrollIndicator = false
        self.scrollView.delegate = self
        
        
        contentView.addSubview(mainView)
        
        
        mainView.addSubview(self.scrollView)
        mainView.addSubview(self.pageControl)
        mainView.addSubview(self.topView)
        mainView.addSubview(self.bottomView)
        mainView.addSubview(self.mainImage)
        
        self.topView.addSubview(self.ellipsis)
        self.topView.addSubview(self.profileImage)
        self.topView.addSubview(self.nicknameLabel)
        self.bottomView.addSubview(self.dateLabel)
        self.bottomView.addSubview(self.contentLabel)
        self.bottomView.addSubview(self.buttonStackView)
        self.bottomView.addSubview(self.likesLabel)
        self.bottomView.addSubview(self.comentsLabel)
    
        
        self.mainView.snp.makeConstraints{
            $0.top.leading.trailing.bottom.equalTo(self.contentView)
        }
        self.topView.snp.makeConstraints{
            $0.top.leading.trailing.equalTo(self.contentView)
            $0.height.equalTo(60)
        }
        self.profileImage.snp.makeConstraints{
            $0.centerY.equalTo(topView)
            $0.leading.equalTo(topView).inset(10)
            $0.width.height.equalTo(40)
        }
        self.nicknameLabel.snp.makeConstraints{
            $0.centerY.equalTo(topView)
            $0.leading.equalTo(self.profileImage.snp.trailing).offset(10)
            $0.trailing.equalTo(self.ellipsis.snp.leading).offset(-10)
        }
        self.ellipsis.snp.makeConstraints{
            $0.centerY.trailing.equalTo(self.topView)
            $0.width.height.equalTo(40)
        }
        self.scrollView.snp.makeConstraints{
            $0.trailing.leading.equalTo(self.contentView)
            $0.top.equalTo(self.topView.snp.bottom)
            $0.height.equalTo(400)
        }
        self.pageControl.snp.makeConstraints{
            $0.trailing.leading.bottom.equalTo(self.scrollView)
            $0.height.equalTo(40)
        }
        self.bottomView.snp.makeConstraints{
            $0.top.equalTo(self.scrollView.snp.bottom).offset(10)
            $0.trailing.leading.equalTo(self.contentView).inset(10)
            $0.bottom.equalTo(self.contentView)
        }
        self.buttonStackView.snp.makeConstraints{
            $0.top.equalTo(self.bottomView)
            $0.height.equalTo(30)
        }
        self.dateLabel.snp.makeConstraints{
            $0.centerY.equalTo(self.buttonStackView)
            $0.trailing.equalTo(self.bottomView)
        }
        self.likesLabel.snp.makeConstraints{
            $0.leading.equalTo(self.bottomView)
            $0.top.equalTo(buttonStackView.snp.bottom).offset(12)
            $0.height.equalTo(20)
        }
        self.comentsLabel.snp.makeConstraints{
            $0.leading.trailing.equalTo(self.bottomView)
            $0.bottom.equalTo(self.bottomView)
            $0.height.equalTo(20)
        }
        self.contentLabel.snp.makeConstraints{
            $0.trailing.leading.equalTo(self.bottomView)
            $0.top.equalTo(self.likesLabel.snp.bottom).offset(12)
            $0.bottom.equalTo(self.comentsLabel.snp.top).offset(-12)
        }
       
    }
    
    
    

}


extension FeedCollectionCell :  UINavigationControllerDelegate {
    @objc func actionSheetAlert( ){
        let alert = UIAlertController(title: nil , message: nil , preferredStyle: .actionSheet)
        
        let cancel = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        alert.addAction(cancel)
        alert.view.tintColor = .black

        if(self.own!){
            let declaration = UIAlertAction(title: "삭제하기", style: .default) { [weak self] _ in
                AlertHelper.shared.showDeleteConfirmation(title: "피드를 삭제하시겠습니까?", message: "삭제한 피드는 되돌릴 수 없습니다", onConfirm: {
                    self?.delete()
                }, over: self?.commuVC ?? UIViewController())
                
                
            }
            let update = UIAlertAction(title: "수정하기", style: .default) { [weak self] _ in
                self?.update()
            }
            

            declaration.setValue(UIColor.red, forKey: "titleTextColor")
            alert.addAction(update)
            alert.addAction(declaration)
        }else{
            let report = UIAlertAction(title: "신고하기", style: .default) { [weak self] _ in
                self?.report()
            }
            report.setValue(UIColor.red, forKey: "titleTextColor")

            alert.addAction(report) 
            
           

        }
                
        commuVC?.present(alert, animated: true, completion: nil)
        
    }
    
    
   
}

import UIKit

protocol FeedCollectionCellDelegate {
    func didPressHeart(for index: String, like: Bool)
}

class FeedCollectionCell: UITableViewCell , UIScrollViewDelegate {
    static let identifier = "FeedCollectionCell"
    var mainImage : UIImageView = {
        let image = UIImageView()
        image.backgroundColor = .lightGray.withAlphaComponent(0.2)
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
        
    }()
    
    let topView : UIView = {
       let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        return view
        
        
    }()
    
    let bottomView : UIView = {
        let view = UIView()
        
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
        
        
    }()
    
    var profileImage : UIImageView = {
       let imageView = UIImageView()
        imageView.layer.masksToBounds = true

  
        imageView.layer.cornerRadius = 20
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
    
    var contentLabel : UILabel = {
        
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 16)
        label.isUserInteractionEnabled = true
        
        
        return label
    }()
    
    let likesButton : UIButton = {
        let button = UIButton()
        
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage( UIImage(systemName: "heart")  , for: .normal)
        button.contentVerticalAlignment = .fill
        button.contentHorizontalAlignment = .fill
        button.tintColor = .black
        
        
        button.widthAnchor.constraint(equalToConstant: 30).isActive = true
        button.heightAnchor.constraint(equalToConstant: 26).isActive = true
        return button
    }()
    
    let comentsButton : UIButton = {
        let button = UIButton()
        
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage( UIImage(systemName: "message")  , for: .normal)
        
        button.contentVerticalAlignment = .fill
        button.contentHorizontalAlignment = .fill
        button.tintColor = .black

        button.widthAnchor.constraint(equalToConstant: 30).isActive = true
        button.heightAnchor.constraint(equalToConstant: 26).isActive = true
        
        return button
    }()
    
    
    lazy var buttonStackView : UIStackView = {
        let stackview = UIStackView(arrangedSubviews: [self.likesButton , self.comentsButton])
        stackview.axis = .horizontal
        stackview.alignment = .center
        stackview.distribution = .fillProportionally
        stackview.spacing = 14
        stackview.translatesAutoresizingMaskIntoConstraints = false
        return stackview
        
    }()
    
    let likesLabel : UILabel = {
       let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .boldSystemFont(ofSize: 16)
        label.text = "좋아요 0개"
        return label
        
        
    }()
    
    let comentsLabel : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 16)
        label.text = "댓글 0개 보기"
        label.textColor = .lightGray
        
        return label
    }()
    
    var pageControl : UIPageControl = {
        let pageControl = UIPageControl()
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        return pageControl
        
        
    }()
    var scrollView = UIScrollView()
    var imageViews = [UIImageView]()
    
    let dateLabel : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .lightGray
        label.font = .systemFont(ofSize: 14)
        return label
    }()
    
   
     
     func addContentScrollView() {
         DispatchQueue.main.async {
             
             for i in 0..<self.imageViews.count {
                 
                 let xPos = self.scrollView.frame.width * CGFloat(i)
                 self.imageViews[i].frame = CGRect(x: xPos, y: 0, width: self.scrollView.bounds.width, height: self.scrollView.bounds.height)
                 
                 self.scrollView.addSubview(self.imageViews[i])
                 self.scrollView.contentSize.width = self.imageViews[i].frame.width * CGFloat(i + 1)
             }
         }
     }
     
     func setPageControl() {
             pageControl.numberOfPages = imageViews.count
            
         
     }
     
     private func setPageControlSelectedPage(currentPage:Int) {
         print("\(currentPage) current Page")
         pageControl.currentPage = currentPage
     }
     
     func scrollViewDidScroll(_ scrollView: UIScrollView) {
         let value = scrollView.contentOffset.x/scrollView.frame.size.width
         setPageControlSelectedPage(currentPage: Int(round(value)))
     }
    
    
    
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
            self.invalidateIntrinsicContentSize()
        }

        
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
        
        
        

            let readmore = (text as NSString).range(of: TrailingContent.readmore.text)
            let readless = (text as NSString).range(of: TrailingContent.readless.text)
        if sender.didTap(label: contentLabel, inRange: readmore) {
            print("less")
            contentLabel.appendReadLess(after: beforeContent ?? "" , trailingContent: .readless)
            } else if  sender.didTap(label: contentLabel, inRange: readless) {
                print("more")
                contentLabel.appendReadmore(after: beforeContent ?? "" , trailingContent: .readmore)
            } else { return }
        

        
        self.bottomView.invalidateIntrinsicContentSize()
        self.invalidateIntrinsicContentSize()
        
        
            
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
   
    
 
    
    
    
    private func setUI() {
        
        likesButton.addTarget(self, action: #selector(didPressedHeart), for: .touchUpInside)
        
        let labelGesture = UITapGestureRecognizer(target: self, action: #selector(didTapLabel))
        contentLabel.addGestureRecognizer(labelGesture)
        
        self.scrollView.isPagingEnabled = true
        self.scrollView.isScrollEnabled = true
        self.scrollView.showsHorizontalScrollIndicator = false
        self.scrollView.showsVerticalScrollIndicator = false
        self.scrollView.translatesAutoresizingMaskIntoConstraints = false
        self.scrollView.delegate = self
        

        

        
        
        contentView.addSubview(self.scrollView)
        contentView.addSubview(self.pageControl)
        contentView.addSubview(self.topView)
        contentView.addSubview(self.bottomView)
        
        self.topView.addSubview(self.profileImage)
        self.topView.addSubview(self.nicknameLabel)
        self.bottomView.addSubview(self.dateLabel)
        self.bottomView.addSubview(self.contentLabel)
        self.bottomView.addSubview(self.buttonStackView)
        self.bottomView.addSubview(self.likesLabel)
        self.bottomView.addSubview(self.comentsLabel)
    
        
        NSLayoutConstraint.activate([
            
            self.topView.topAnchor.constraint(equalTo: self.contentView.topAnchor ),
            self.topView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor ),
            self.topView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor ),
            self.topView.heightAnchor.constraint(equalToConstant: 60 ),
            
            self.profileImage.centerYAnchor.constraint(equalTo: self.topView.centerYAnchor),
            self.profileImage.leadingAnchor.constraint(equalTo: self.topView.leadingAnchor , constant: 10),
            self.profileImage.widthAnchor.constraint(equalToConstant: 40),
            self.profileImage.heightAnchor.constraint(equalToConstant: 40),
            
            
            
        
            self.nicknameLabel.centerYAnchor.constraint(equalTo: self.topView.centerYAnchor ),
            self.nicknameLabel.leadingAnchor.constraint(equalTo: self.profileImage.trailingAnchor , constant: 10 ),
            
          
            
            self.scrollView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor ),
            self.scrollView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor ),
            self.scrollView.topAnchor.constraint(equalTo: self.topView.bottomAnchor ),
            self.scrollView.heightAnchor.constraint(equalToConstant: 360),
            
            self.pageControl.trailingAnchor.constraint(equalTo: self.scrollView.trailingAnchor ),
            self.pageControl.leadingAnchor.constraint(equalTo: self.scrollView.leadingAnchor ),
            self.pageControl.heightAnchor.constraint(equalToConstant: 40),
            self.pageControl.bottomAnchor.constraint(equalTo: self.scrollView.bottomAnchor ),
            
            
            
            
            self.bottomView.topAnchor.constraint(equalTo:  self.scrollView.bottomAnchor , constant: 10),
            self.bottomView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor , constant: -10 ),
            self.bottomView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor , constant: 10 ),
            self.bottomView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor ),
            
            
            self.buttonStackView.topAnchor.constraint(equalTo: bottomView.topAnchor),
            self.buttonStackView.heightAnchor.constraint(equalToConstant: 30),
            
            self.dateLabel.centerYAnchor.constraint(equalTo: buttonStackView.centerYAnchor),
            self.dateLabel.trailingAnchor.constraint(equalTo: bottomView.trailingAnchor),
            
            
            self.likesLabel.leadingAnchor.constraint(equalTo: bottomView.leadingAnchor),
            self.likesLabel.topAnchor.constraint(equalTo: buttonStackView.bottomAnchor , constant: 12),
            self.likesLabel.heightAnchor.constraint(equalToConstant : 20),
            
            self.comentsLabel.bottomAnchor.constraint(equalTo: self.bottomView.bottomAnchor , constant: -12 ),
            self.comentsLabel.leadingAnchor.constraint(equalTo: self.bottomView.leadingAnchor),
            self.comentsLabel.trailingAnchor.constraint(equalTo: self.bottomView.trailingAnchor),
            self.comentsLabel.heightAnchor.constraint(equalToConstant: 20),
            
            
            self.contentLabel.topAnchor.constraint(equalTo: self.likesLabel.bottomAnchor , constant: 12),
            self.contentLabel.trailingAnchor.constraint(equalTo: self.bottomView.trailingAnchor),
            self.contentLabel.leadingAnchor.constraint(equalTo: self.bottomView.leadingAnchor),
            self.contentLabel.bottomAnchor.constraint(equalTo: self.comentsLabel.topAnchor , constant: -12 ),
            
          
            
            
           
            
            
          
            
                                                
            
            
        
        ])
    }
    
    
    

}

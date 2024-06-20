import UIKit
import Kingfisher
import RxCocoa
import RxSwift
import RxGesture
import SnapKit


class ProfileFeedVC: UIViewController, UIScrollViewDelegate {
    
    private var viewModel: ProfileFeedVM?
    
    var disposeBag = DisposeBag()
    
    init(viewModel: ProfileFeedVM) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    var mainScrollView = UIScrollView()
    
    var mainContentView = UIView()
    
    var mainImage: UIImageView = {
        let image = UIImageView()
        image.backgroundColor = .lightGray.withAlphaComponent(0.2)
        return image
        
    }()
    
    let topView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
        
        
    }()
    
    let bottomView: UIView = {
        let view = UIView()
        view.isUserInteractionEnabled = true
        
        return view
        
        
    }()
    
    var profileImage: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.masksToBounds = true
        
        imageView.isUserInteractionEnabled = true
        
        imageView.layer.cornerRadius = 20
        imageView.backgroundColor = .clear
        
        return imageView
    }()
    
    let nicknameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 18)
        return label
        
        
    }()
    
    var contentLabel: UILabel = {
        
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.isUserInteractionEnabled = true
        
        
        return label
    }()
    
    let likesButton: UIButton = {
        let button = UIButton()
        
        button.setImage( UIImage(systemName: "heart"), for: .normal)
        button.contentVerticalAlignment = .fill
        button.contentHorizontalAlignment = .fill
        button.tintColor = .black
        
        
        button.snp.makeConstraints {
            $0.width.equalTo(30)
            $0.height.equalTo(26)
        }
        
        return button
    }()
    
    let comentsButton: UIButton = {
        let button = UIButton()
        
        button.setImage( UIImage(systemName: "message"), for: .normal)
        
        button.contentVerticalAlignment = .fill
        button.contentHorizontalAlignment = .fill
        button.tintColor = .black
        
        button.snp.makeConstraints {
            $0.width.equalTo(30)
            $0.height.equalTo(26)
        }
        
        
        return button
    }()
    
    
    lazy var buttonStackView: UIStackView = {
        let stackview = UIStackView(arrangedSubviews: [self.likesButton, self.comentsButton])
        stackview.axis = .horizontal
        stackview.alignment = .center
        stackview.distribution = .fillProportionally
        stackview.spacing = 14
        return stackview
        
    }()
    
    let likesLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 16)
        label.text = "좋아요 0개"
        return label
        
        
    }()
    
    let comentsLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16)
        label.text = "댓글 0개 보기"
        label.textColor = .lightGray
        label.isUserInteractionEnabled = true
        
        
        
        return label
    }()
    
    var pageControl: UIPageControl = {
        let pageControl = UIPageControl()
        return pageControl
        
        
    }()
    var scrollView = UIScrollView()
    var imageViews = [UIImageView]()
    
    let dateLabel: UILabel = {
        let label = UILabel()
        label.textColor = .lightGray
        label.font = .systemFont(ofSize: 14)
        return label
    }()
    
    let ellipsis: UIButton = {
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
    
    func setPageControl(count: Int) {
        pageControl.numberOfPages = count
        
        
    }
    
    private func setPageControlSelectedPage(currentPage: Int) {
        print("\(currentPage) current Page")
        pageControl.currentPage = currentPage
    }
    
    
    
    
    
    var feedUid: String?
    
    
    var likesCount: Int?
    
    var beforeContent: String?
    
    var own: Bool?
    
    func setLikesLabel(count: Int) {
        
        
        
        self.likesCount = count
        self.likesLabel.text = "좋아요 \(count)개"
        
    }
    
    func setContentLabel() {
        DispatchQueue.main.async {
            self.contentLabel.appendReadmore(after: self.beforeContent ?? "", trailingContent: .readmore)
            
            
            self.bottomView.invalidateIntrinsicContentSize()
            self.view.invalidateIntrinsicContentSize()
        }
        
        
    }
    
    
    
    
    
    
    
    
    
    @objc
    func didTapLabel(_ sender: UITapGestureRecognizer) {
        
        guard let text = contentLabel.text else { return }
        
        
        
        
        let readmore = (text as NSString).range(of: TrailingContent.readmore.text)
        let readless = (text as NSString).range(of: TrailingContent.readless.text)
        if sender.didTap(label: contentLabel, inRange: readmore) {
            print("less")
            contentLabel.appendReadLess(after: beforeContent ?? "", trailingContent: .readless)
        } else if  sender.didTap(label: contentLabel, inRange: readless) {
            print("more")
            contentLabel.appendReadmore(after: beforeContent ?? "", trailingContent: .readmore)
        } else { return }
        
        
        
        self.bottomView.invalidateIntrinsicContentSize()
        self.mainContentView.invalidateIntrinsicContentSize()
        
        
        
        
    }
    
    
    
    
    
    @objc
    func didPressedHeart(_ sender: UIButton) {
        
        sender.isSelected = !sender.isSelected
        
        
        var cnt: Int
        if sender.isSelected {
            
            cnt = (self.likesCount ?? 0) + 1
            
            
            self.isTouched = true
            
        } else {
            cnt = (self.likesCount ?? 1) - 1
            
            
            self.isTouched = false
            
        }
        
        self.likesButtonTapped.onNext(self.isTouched!)
        self.likesCount = cnt
        setLikesLabel(count: cnt)
        
        
        
    }
    var isTouched: Bool? {
        didSet {
            if isTouched == true {
                likesButton.tintColor = .red
                likesButton.setImage(UIImage(systemName: "heart.fill", withConfiguration: UIImage.SymbolConfiguration(scale: .large)), for: .normal)
            } else {
                likesButton.tintColor = .black
                likesButton.setImage(UIImage(systemName: "heart", withConfiguration: UIImage.SymbolConfiguration(scale: .large)), for: .normal)
            }
        }
    }
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.authUid = UserDefaults.standard.string(forKey: "uid") ?? ""
        
        setUI()
        setBindings()
        
    }
    
    
    
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        self.navigationController?.navigationBar.backgroundColor = .clear
        
        
        
        
        
        
    }
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        
        
    }
    
    
    
    var likesCounts: [String] = []
    
    var authUid: String = ""
    
    var likesButtonTapped = PublishSubject<Bool>()
    
    var updateFeed = PublishSubject<Bool>()
    
    var reportFeed = PublishSubject<Bool>()
    
    var deleteFeed = PublishSubject<Bool>()
    
    
    
    
    let refreshControl = UIRefreshControl()
    
    
    private func setBindings() {
        
        let uid = UserDefaults.standard.string(forKey: "uid")
        
        let comentsTapped = Observable.merge( self.comentsButton.rx.tapGesture().when(.recognized).asObservable(), self.comentsLabel.rx.tapGesture().asObservable().when(.recognized) )
        
        let input = ProfileFeedVM.Input( viewWillApearEvent: self.rx.methodInvoked(#selector(viewWillAppear(_:))).map({ _ in }), likesButtonTapped: self.likesButtonTapped, comentsTapped: comentsTapped.asObservable(), deleteFeed: deleteFeed, reportFeed: reportFeed, updateFeed: updateFeed, profileTapped: self.profileImage.rx.tapGesture().when(.recognized).asObservable(), refreshControl: self.refreshControl.rx.controlEvent(.valueChanged).asObservable() )
        
        
        guard let output = viewModel?.transform(input: input, disposeBag: disposeBag) else {return}
        
        
        output.feedModel.subscribe(onNext: { feed in
            
            guard let feed = feed else {return}
            
            self.likesCounts = feed.likes
            
            self.setLikesLabel(count: feed.likes.count )
            
            
            
            
            if uid!.contains(feed.uuid) {
                
                self.own = true
            } else {
                self.own = false
            }
            
            
            if self.likesCounts.contains(self.authUid) == true {
                self.likesButton.isSelected = true
                self.isTouched = true
                
                
            } else {
                self.likesButton.isSelected = false
                self.isTouched = false
            }
            
            
            
            
            self.nicknameLabel.text = feed.nickname
            
            self.beforeContent = feed.contents
            
            self.comentsLabel.text = "댓글 \(String(describing: feed.coments.count))개 보기"
            
            
            
            let url = URL(string: feed.profileImage)
            
            
            
            
            DispatchQueue.main.async {
                
                let processor = DownsamplingImageProcessor(size: self.profileImage.bounds.size ) // 크기 지정 다운 샘플링
                // 모서리 둥글게
                self.profileImage.kf.indicatorType = .activity  // indicator 활성화
                self.profileImage.kf.setImage(
                    with: url,  // 이미지 불러올 url
                    placeholder: UIImage(named: "일반적.png"),  // 이미지 없을 때의 이미지 설정
                    options: [
                        .processor(processor),
                        .scaleFactor(UIScreen.main.scale),
                        .transition(.fade(0.5)),  // 애니메이션 효과
                        .cacheOriginalImage // 이미 캐시에 다운로드한 이미지가 있으면 가져오도록
                    ])
                
                
            }
            
            
            
            self.profileImage.layer.cornerRadius = 20
            
            
            
            
            
            
            
            var images: [UIImageView] = []
            
            
            _ = feed.mainImgUrl.map {
                if let url = URL(string: $0 ) {
                    let image = UIImageView()
                    let processor = DownsamplingImageProcessor(size: CGSize(width: self.view.bounds.width, height: self.scrollView.bounds.height) ) // 크기 지정 다운 샘플링
                    |> RoundCornerImageProcessor(cornerRadius: 0) // 모서리 둥글게
                    image.kf.indicatorType = .activity  // indicator 활성화
                    image.kf.setImage(
                        with: url,  // 이미지 불러올 url
                        placeholder: UIImage(),  // 이미지 없을 때의 이미지 설정
                        options: [
                            .processor(processor),
                            .scaleFactor(UIScreen.main.scale),
                            .transition(.fade(0.5)),  // 애니메이션 효과
                            .cacheOriginalImage // 이미 캐시에 다운로드한 이미지가 있으면 가져오도록
                        ])
                    
                    
                    images.append(image)
                    
                    
                }
                
                self.dateLabel.text = CustomFormatter.shared.getDifferDate(date: feed.date)
                
                
                
            }
            self.imageViews = images
            self.addContentScrollView()
            self.setContentLabel()
            
            
            
            
            if images.count > 1 {
                
                self.setPageControl(count: images.count)
                
            } else {
                
                self.setPageControl(count: 0)
            }
            
            
            
            
            
        }).disposed(by: disposeBag)
        
        output.endRefreshing.subscribe(onNext: { event in
            if event {
                self.refreshControl.endRefreshing()
            }
            
            
        }).disposed(by: disposeBag)
    }
    
    
    
    private func setUI() {
        
        
        self.view.backgroundColor = .white
        
        likesButton.addTarget(self, action: #selector(didPressedHeart), for: .touchUpInside)
        
        
        let contentLabelGesture = UITapGestureRecognizer(target: self, action: #selector(didTapLabel))
        contentLabel.addGestureRecognizer(contentLabelGesture)
        
        
        
        ellipsis.addTarget(self, action: #selector(actionSheetAlert), for: .touchUpInside)
        
        self.mainScrollView.showsHorizontalScrollIndicator = false
        self.mainScrollView.showsVerticalScrollIndicator = false
        
        
        
        self.scrollView.isPagingEnabled = true
        self.scrollView.isScrollEnabled = true
        self.scrollView.showsHorizontalScrollIndicator = false
        self.scrollView.showsVerticalScrollIndicator = false
        self.scrollView.delegate = self
        
        
        
        self.view.addSubview(self.mainScrollView)
        self.mainScrollView.addSubview(self.mainContentView)
        
        
        self.mainContentView.addSubview(self.scrollView)
        self.mainContentView.addSubview(self.pageControl)
        self.mainContentView.addSubview(self.topView)
        self.mainContentView.addSubview(self.bottomView)
        self.mainContentView.addSubview(self.mainImage)
        
        
        self.topView.addSubview(self.ellipsis)
        self.topView.addSubview(self.profileImage)
        self.topView.addSubview(self.nicknameLabel)
        self.bottomView.addSubview(self.dateLabel)
        self.bottomView.addSubview(self.contentLabel)
        self.bottomView.addSubview(self.buttonStackView)
        self.bottomView.addSubview(self.likesLabel)
        self.bottomView.addSubview(self.comentsLabel)
        
        
        self.scrollView.snp.makeConstraints {
            $0.trailing.leading.equalTo(self.mainContentView)
            $0.top.equalTo(self.topView.snp.bottom)
            $0.height.equalTo(360)
        }
        self.pageControl.snp.makeConstraints {
            $0.trailing.leading.bottom.equalTo(self.scrollView)
            $0.height.equalTo(40)
        }
        self.bottomView.snp.makeConstraints {
            $0.top.equalTo(self.scrollView.snp.bottom).offset(10)
            $0.trailing.leading.equalTo(self.mainContentView).inset(10)
            $0.bottom.equalTo(self.mainContentView)
        }
        self.buttonStackView.snp.makeConstraints {
            $0.top.equalTo(bottomView)
            $0.height.equalTo(30)
        }
        self.dateLabel.snp.makeConstraints {
            $0.centerY.equalTo(buttonStackView)
            $0.trailing.equalTo(bottomView)
        }
        self.mainScrollView.snp.makeConstraints {
            $0.top.leading.trailing.bottom.equalTo(self.view)
        }
        self.mainContentView.snp.makeConstraints {
            $0.top.leading.trailing.bottom.width.equalTo(self.mainScrollView)
        }
        self.topView.snp.makeConstraints {
            $0.top.leading.trailing.equalTo(self.mainContentView)
            $0.height.equalTo(60)
        }
        self.profileImage.snp.makeConstraints {
            $0.centerY.equalTo(self.topView)
            $0.width.height.equalTo(40)
            $0.leading.equalTo(self.topView).inset(10)
        }
        self.nicknameLabel.snp.makeConstraints {
            $0.centerY.equalTo(self.topView)
            $0.leading.equalTo(self.profileImage.snp.trailing).offset(10)
        }
        self.ellipsis.snp.makeConstraints {
            $0.centerY.trailing.equalTo(self.topView)
            $0.width.height.equalTo(40)
        }
        self.likesLabel.snp.makeConstraints {
            $0.leading.equalTo(bottomView)
            $0.top.equalTo(buttonStackView.snp.bottom).offset(12)
            $0.height.equalTo(20)
        }
        self.comentsLabel.snp.makeConstraints {
            $0.bottom.equalTo(self.bottomView).inset(12)
            $0.leading.trailing.equalTo(self.bottomView)
            $0.height.equalTo(20)
        }
        self.contentLabel.snp.makeConstraints {
            $0.top.equalTo(self.likesLabel.snp.bottom).offset(12)
            $0.leading.trailing.equalTo(self.bottomView)
            $0.bottom.equalTo(self.comentsLabel.snp.top).offset(-12)
        }
        
    }
    
    
    
    
}


extension ProfileFeedVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    @objc func actionSheetAlert() {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let cancel = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        alert.addAction(cancel)
        alert.view.tintColor = .black
        
        guard let own = self.own else {return}
        
        if own {
            let declaration = UIAlertAction(title: "삭제하기", style: .default) { [weak self] _ in
                self?.deleteFeed.onNext(true)
            }
            let update = UIAlertAction(title: "수정하기", style: .default) { [weak self] _ in
                
                
                self?.updateFeed.onNext(true)
            }
            
            
            
            declaration.setValue(UIColor.red, forKey: "titleTextColor")
            alert.addAction(update)
            alert.addAction(declaration)
        } else {
            
            
            
        }
        
        self.present(alert, animated: true, completion: nil)
        
    }
    
    
    
}

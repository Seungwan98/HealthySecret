


//
//  OtherProfileVC.swift
//  MovieProject
//
//  Created by 양승완 on 2023/10/04.
//

import UIKit
import RxCocoa
import RxSwift
import Kingfisher

class OtherProfileVC : UIViewController , CustomCollectionCellDelegate  {
    
    func imageTapped(feedUid: String) {
        
        self.imageTapped.onNext(feedUid)
    }
    
    
    
    let disposeBag = DisposeBag()
    
    var firstBind = true
    
    var loadControll = false
    
    private var viewModel : OtherProfileVM?
    
    
    init(viewModel : OtherProfileVM){
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    
    
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.scrollDirection = .vertical
        layout.sectionInset = UIEdgeInsets(top: 1, left: 0, bottom: 1, right: 0)
        layout.headerReferenceSize = CGSize(width: self.view.frame.width, height: 400)
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        
        collectionView.register(CustomCollectionViewCell.self, forCellWithReuseIdentifier: CustomCollectionViewCell.identifier)
        
        
        collectionView.register( ProfileHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: ProfileHeaderView.identifier)
        
        collectionView.allowsMultipleSelection = false
        
        collectionView.alwaysBounceVertical = true
        
        
        return collectionView
    }()
    
    let followButton : UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 30
        button.tintColor = .white
        button.backgroundColor = .systemBlue
        button.setTitle("팔로우", for: .normal )
        button.titleLabel?.font = .boldSystemFont(ofSize: 18)
        
        
        return button
        
        
    }()
    
    
    var outputFollows = PublishSubject<Bool>()
    
    var imageTapped = PublishSubject<String>()
    
    var outputProfileImage = BehaviorSubject<Data?>(value: nil)
    
    var headerAppearEvent = PublishSubject<Bool>()
    
    
    var loadingView = LoadingView()

    override func viewDidLoad() {
        super.viewDidLoad()
        loadingView.isLoading = true

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) {
            self.loadingView.isLoading = false
            self.navigationController?.setNavigationBarHidden(false, animated: false)
            self.navigationController?.navigationBar.backgroundColor = .clear
            
            self.headerAppearEvent.onNext(true)
          }
      
        
        self.collectionView.dataSource = self
        
        self.collectionView.delegate = self
        
        setUI()
        setBindings()
        addFollowButton()
        
    }
    
    
    
    
    
    
    let backgroundView = CustomBackgroundView()
    

    override func viewWillAppear(_ animated: Bool) {
      
        
        

        
    }
    override func viewWillDisappear(_ animated: Bool) {
        
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        

        
    }
    
    
    func addFollowButton() {
        
        
        
        
        
        
        
        
        self.view.addSubview(self.followButton)
        
        self.followButton.addTarget(self, action: #selector(self.didPressedFollowButton), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            
            self.followButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            self.followButton.widthAnchor.constraint(equalToConstant: 160 ),
            self.followButton.heightAnchor.constraint(equalToConstant: 60 ),
            self.followButton.bottomAnchor.constraint(equalTo: self.view.bottomAnchor , constant: -40)
            
            
            
            
        ])
        
        
        
        
    }
    
    func setUI(){
        self.loadingView.translatesAutoresizingMaskIntoConstraints = false
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "", image: UIImage(systemName: "ellipsis"), target: self, action: nil)
        self.collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        
        self.backgroundView.translatesAutoresizingMaskIntoConstraints = false
        self.backgroundView.backgroundLabel.text = "아직 피드가 없어요"
        
        
        view.addSubview(self.collectionView)
        
        view.addSubview(self.backgroundView)
        
        view.addSubview(self.loadingView)

        NSLayoutConstraint.activate([
            
            
            
            self.backgroundView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor ),
            self.backgroundView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor  ),
            self.backgroundView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor ),
            self.backgroundView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor ),
            
            self.collectionView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor ),
            self.collectionView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor  ),
            self.collectionView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor ),
            self.collectionView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor ),  
            
            self.loadingView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor ),
            self.loadingView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor  ),
            self.loadingView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor ),
            self.loadingView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor ),
            
            
        ])
        
        
        
        
        
        
        
        
        
    }
    
    let addButtonTapped = PublishSubject<Bool>()
    
    
    @objc
    func didPressedFollowers(_ sender: UITapGestureRecognizer){
        
        self.outputFollows.onNext(true)
        
    }
    
    @objc
    func didPressedFollowings(_ sender: UITapGestureRecognizer){
        
        self.outputFollows.onNext(false)
        
    }
    
    
    
    @objc
    func didPressedFollowButton(_ sender: UIButton) {
        
        sender.isSelected = !sender.isSelected
        
        let selected  = sender.isSelected
        
        print("selected")
        
        self.isTouched = selected
        
        self.setHeadersCount(selected: selected)
        
        self.addButtonTapped.onNext(selected)
        
        
        
        
        
        
        
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
    
    
    
    
    var followersCount : Int?
    
    var imagesArr : [[String]] = []
    
    var uidsArr : [String] = []
    
    var profileHeader : ProfileHeaderView?
    
    func setHeadersCount( selected : Bool ){
        
        var count =  self.followersCount ?? 0
        
        
        if(selected){
            count += 1
        }else{
            count -= 1
        }
        self.profileHeader?.feedInformValLabels[1].text = String(count)
        self.followersCount = count
        
    }
    
    
    
    func setHeaderBindings(header : ProfileHeaderView){
        
        
        
        
        
        let input = OtherProfileVM.HeaderInput( viewWillApearEvent: headerAppearEvent.asObservable()  ,  outputProfileImage: self.outputProfileImage.asObservable()   , outputFollows : Observable.merge( header.feedInformValLabels[1].rx.tapGesture().when(.recognized).asObservable() , header.feedInformValLabels[2].rx.tapGesture().when(.recognized).asObservable()  ) )
        
        
        guard let output = self.viewModel?.HeaderTransform(input: input, disposeBag: header.disposeBag) else { return }
        
        
        
        let size = CGSize(width: view.frame.width, height: CGFloat.infinity)
        
        let estimatedSize = header.introduceLabel.sizeThatFits(size)
        
        if let layout = self.collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.headerReferenceSize = CGSize(width: view.frame.width, height: estimatedSize.height + 310 )
            self.collectionView.layoutIfNeeded()
            
            
        }
        
        input.viewWillApearEvent.subscribe({ [weak self] _ in
            
            guard let self = self else {return}
            //will appear
            
            
        }).disposed(by: header.disposeBag)
        
        
        
        
        Observable.zip( output.calorie , output.goalWeight , output.nowWeight , output.name , output.introduce , output.profileImage ).subscribe(onNext: { [self] in
            
            
            
            header.calorieLabel.text = $0 + " kcal"
            header.goalWeight.text = $1 + " kg"
            header.nowWeight.text = $2 + " kg"
            header.introduceLabel.text = $4
            
            
            self.navigationController?.navigationBar.topItem?.title = $3
            
            
            
            let weight = (Double($1) ?? 0.0) - (Double($2) ?? 0.0)
            
            if weight > 0 {
                header.gramLabel.text = "+" + String(weight) + " kg"
            }else{
                header.gramLabel.text = String(weight) + " kg"
            }
            
            if let url = URL(string: $5 ?? ""){
                
                
                DispatchQueue.main.async {
                    
                    
                    let processor = DownsamplingImageProcessor(size: header.profileImage.bounds.size) // 크기 지정 다운 샘플링
                    // 모서리 둥글게
                    
                    header.profileImage.kf.indicatorType = .activity  // indicator 활성화
                    header.profileImage.kf.setImage(
                        with: url,  // 이미지 불러올 url
                        placeholder: UIImage(named: "일반적.png"),  // 이미지 없을 때의 이미지 설정
                        options: [
                            .processor(processor),
                            .scaleFactor(UIScreen.main.scale),
                            .transition(.fade(0.5)),  // 애니메이션 효과
                            .cacheOriginalImage // 이미 캐시에 다운로드한 이미지가 있으면 가져오도록
                        ])
                    
                    
                    
                    
                    
                    
                    
                }
                
                
                
                
            } else {
                
                
                header.profileImage.image = UIImage(named: "일반적.png")
                
                
                
            }
            
            header.feedInformValLabels[0].text = String(self.imagesArr.count)
            header.topImage.isHidden = false
            header.profileImage.layer.cornerRadius = 50
            
        }).disposed(by: header.disposeBag)
        
        
        output.followersSelected.subscribe(onNext: { [weak self] selected in
            
            guard let selected = selected else {return}
            
            self?.followButton.isSelected = selected
            self?.isTouched = selected
            
            
            
        }).disposed(by: disposeBag)
        
        output.followersCount.subscribe(onNext: { [weak self] count in
            
            header.feedInformValLabels[1].text = String(count)
            self?.followersCount = count
            
        }).disposed(by: header.disposeBag)
        
        output.followingsCount.subscribe(onNext: { [weak self] count in
            
            guard self != nil else {return}
            
            header.feedInformValLabels[2].text = String(count)
            
            
        }).disposed(by: header.disposeBag)
        
        output.followersEnable.subscribe(onNext: { [weak self] enable in
            
            print("enable \(enable)")
            
            self?.followButton.isHidden = enable
            
            
        }).disposed(by: header.disposeBag)
        
        
        
        
    }
    
    
    func setBindings() {
        print("setbind")
        
        
        
        let input = OtherProfileVM.Input(viewWillApearEvent: self.rx.methodInvoked(#selector(viewWillAppear(_:))).map({ _ in }).asObservable()  , outputProfileImage : outputProfileImage.asObservable(), imageTapped: self.imageTapped.asObservable() , addButtonTapped : addButtonTapped.asObservable()
                                         
        )
        
        guard let output = self.viewModel?.transform(input: input, disposeBag: self.disposeBag) else { return }
        
        
        
        
        
        
        
        
        output.feedImage.subscribe( onNext: { [weak self] imagesArr in
            guard let imagesArr = imagesArr else { return }
            
            
            self?.loadControll = true
            
            
            self?.imagesArr = imagesArr
            self?.collectionView.reloadData()
            
            
        }).disposed(by: disposeBag)
        
        
        output.feedUid.subscribe( onNext: { [weak self] uidsArr in
            guard let uidsArr = uidsArr else { return }
            
            self?.uidsArr = uidsArr
            
        }).disposed(by: disposeBag)
        
        
        
        
        
    }
    
    
    
    
    
    
    
    
    
}

extension OtherProfileVC :  UICollectionViewDataSource , UICollectionViewDelegate{
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(self.imagesArr[indexPath.row])
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: ProfileHeaderView.identifier, for: indexPath) as? ProfileHeaderView  else {
            
            return UICollectionViewCell()
        }
        
        
        
        if(firstBind){
            print("바인드")
            self.setHeaderBindings(header: header)
            
            firstBind = false
        }
        self.headerAppearEvent.onNext(true)
        
        self.profileHeader = header
        
        
        
        return header
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print(self.imagesArr.count)
        return self.imagesArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CustomCollectionViewCell.identifier, for: indexPath) as? CustomCollectionViewCell else {
            return UICollectionViewCell()
        }
        if let url = URL(string: self.imagesArr[indexPath.row].first ?? "" ){
            cell.delegate = self
            cell.feedUid = uidsArr[indexPath.row]
            
            if self.imagesArr[indexPath.row].count > 1 {
                cell.squareImage.isHidden = false
            }else{
                cell.squareImage.isHidden = true
            }
            
            DispatchQueue.main.async {
                
                let processor = DownsamplingImageProcessor(size: cell.image.bounds.size) // 크기 지정 다운 샘플링
                |> RoundCornerImageProcessor(cornerRadius: 0 ) // 모서리 둥글게
                cell.image.kf.indicatorType = .activity  // indicator 활성화
                cell.image.kf.setImage(
                    with: url,  // 이미지 불러올 url
                    placeholder: UIImage(),  // 이미지 없을 때의 이미지 설정
                    options: [
                        .processor(processor),
                        .scaleFactor(UIScreen.main.scale),
                        .transition(.fade(0.5)),  // 애니메이션 효과
                        .cacheOriginalImage // 이미 캐시에 다운로드한 이미지가 있으면 가져오도록
                    ])
            }
            
            
            
            
            
        }
        
        
        
        
        return cell
    }
    
}






extension OtherProfileVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = view.frame.size.width / 3
        
        return CGSize(width: width  , height: width  )
    }
}



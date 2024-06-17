


//
//  ViewController.swift
//  MovieProject
//
//  Created by 양승완 on 2023/10/04.
//

import UIKit
import RxCocoa
import RxSwift
import Kingfisher
import SnapKit

class MyProfileVC : UIViewController , CustomCollectionCellDelegate {
    
    func imageTapped(feedUid: String) {
        print("tappe")
        self.imageTapped.onNext(feedUid)
    }
    
    
    
    
    let disposeBag = DisposeBag()
    
    var firstBind = true
    var loadControll = false
    
    
    private var viewModel : MyProfileVM?
    
    
    init(viewModel : MyProfileVM){
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    let addButton : UIButton = {
        let button = UIButton()
        
        button.setImage(UIImage(systemName: "plus"), for: .normal)
        button.backgroundColor = .systemBlue
        button.layer.cornerRadius = 25
        button.tintColor = .white
        button.contentVerticalAlignment = .center
        button.contentHorizontalAlignment = .center
        
        
        
        
        return button
        
        
    }()
    
    
    
    
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        
        
        
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.scrollDirection = .vertical
        layout.sectionInset = UIEdgeInsets(top: 1, left: 0, bottom: 1, right: 0)
        layout.headerReferenceSize = CGSize(width: self.view.frame.width, height: 400)
        layout.footerReferenceSize  = CGSize(width: 400, height: 400)
        
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        
        collectionView.register(CustomCollectionViewCell.self, forCellWithReuseIdentifier: CustomCollectionViewCell.identifier)
        
        
        collectionView.register( ProfileHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: ProfileHeaderView.identifier)
        
        collectionView.register( DummyCollectionCell.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: DummyCollectionCell.identifier)
        
        collectionView.allowsMultipleSelection = false
        collectionView.alwaysBounceVertical = true
        
        
        
        return collectionView
    }()
    
    
    
    
    
    
    
    
    let leftBarLabel : UILabel = {
        let label = UILabel()
        label.frame = CGRect(x: 0, y: 0, width: 10, height: 10)
        label.font = .boldSystemFont(ofSize: 22)
        label.sizeToFit()
        label.layer.masksToBounds = true
        
        return label
        
    }()
    
    let leftBarView = UIView()
    
    let rightBarImage : UIImageView = {
        let view = UIImageView(image: UIImage(systemName: "gearshape"))
        
        
        view.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        view.tintColor = .black
        
        return view
        
    }()
    
    
    
    lazy var rightBarButton = UIBarButtonItem(customView: rightBarImage)
    
    lazy var leftBarButton = UIBarButtonItem(customView: leftBarView)
    
    var profileHeader : ProfileHeaderView?
    
    
    
    
    let leftBarImage = UIImageView(image: UIImage(named: "arrow.png"))
    
    let backgroundView = CustomBackgroundView()
    
    
    
    var outputProfileImage = BehaviorSubject<Data?>(value: nil)
    
    var outputFollows = PublishSubject<Bool>()
    
    var imageTapped = PublishSubject<String>()
    
    var headerAppearEvent = PublishSubject<Bool>()
    
    
    
    var HEADER_HEIGHT : CGFloat = 0
    
    var followersCount : Int?
    
    var imagesArr : [[String]] = []
    
    var uidsArr : [String] = []
    
    
    
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
    
    var loadingView = LoadingView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadingView.isLoading = true
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) {
            self.loadingView.isLoading = false
            self.navigationController?.navigationBar.topItem?.rightBarButtonItem = self.rightBarButton
            self.navigationController?.navigationBar.topItem?.leftBarButtonItem = self.leftBarButton
        }
        
        
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        
        
        
        setUI()
        setBindings()
        
        
        
        
        
        
    }
    
    
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(false)
        
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        self.navigationController?.navigationBar.backgroundColor = .clear
        
        
        self.headerAppearEvent.onNext(true)
        
        
        
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(false)
        
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        
        
    }
    
    
    @objc
    func didPressedFollowers(_ sender: UITapGestureRecognizer){
        
        self.outputFollows.onNext(true)
        
    }
    
    @objc
    func didPressedFollowings(_ sender: UITapGestureRecognizer){
        
        self.outputFollows.onNext(false)
        
    }
    
    func setUI(){
        
        self.view.backgroundColor = .white

        
        self.backgroundView.backgroundLabel.text = "아직 피드가 없어요"
        
        leftBarView.addSubview(leftBarLabel)
        leftBarView.addSubview(leftBarImage)

        view.addSubview(self.collectionView)
        view.addSubview(self.addButton)
        view.addSubview(self.loadingView)
        
        self.backgroundView.isHidden = false
        
        
        self.leftBarView.snp.makeConstraints{
            $0.width.equalTo(180)
            $0.height.equalTo(40)
        } 
        self.leftBarLabel.snp.makeConstraints{
            $0.centerY.leading.equalTo(leftBarView)
            $0.width.lessThanOrEqualTo(self.leftBarView).offset(-20)
        }
        self.leftBarImage.snp.makeConstraints{
            $0.height.width.equalTo(12)
            $0.centerY.equalTo(leftBarView)
            $0.leading.equalTo(leftBarLabel.snp.trailing).offset(2)
        }
        self.loadingView.snp.makeConstraints{
            $0.trailing.bottom.top.leading.equalTo(self.view)
        }
        self.collectionView.snp.makeConstraints{
            $0.trailing.bottom.top.leading.equalTo(self.view.safeAreaLayoutGuide)
        }
        self.addButton.snp.makeConstraints{
            $0.trailing.bottom.equalTo(self.view.safeAreaLayoutGuide).inset(20)
            $0.height.width.equalTo(50)
        }
      
        
        
        
        
        
        
        
        
    }
    
    
    func setHeaderBindings( header : ProfileHeaderView ){
        
        
        let input = MyProfileVM.HeaderInput( viewWillApearEvent: headerAppearEvent.asObservable()  , goalLabelTapped: header.goalLabel.rx.tapGesture().when(.recognized).asObservable(), changeProfile: header.profileImage.rx.tapGesture().when(.recognized).asObservable(), outputProfileImage: self.outputProfileImage.asObservable(),  outputFollows : Observable.merge( header.feedInformValLabels[1].rx.tapGesture().when(.recognized).asObservable() , header.feedInformValLabels[2].rx.tapGesture().when(.recognized).asObservable()  ) )
        
        
        guard let output = self.viewModel?.HeaderTransform(input: input, disposeBag: header.disposeBag) else { return }
        
        
        
        Observable.zip( output.calorie , output.goalWeight , output.nowWeight , output.name , output.introduce , output.profileImage ).subscribe(onNext: { [self] in
            
            
            
            header.calorieLabel.text = $0 + " kcal"
            
            header.goalWeight.text = $1 + " kg"
            
            header.nowWeight.text = $2 + " kg"
            
            header.introduceLabel.text = $4
            
            
            
            let size = CGSize(width: view.frame.width, height: CGFloat.infinity)
            
            let estimatedSize = header.introduceLabel.sizeThatFits(size)
            
            if let layout = self.collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
                layout.headerReferenceSize = CGSize(width: view.frame.width, height: estimatedSize.height + 310 )
                
                self.collectionView.layoutIfNeeded()
                print("estimatedSize \(estimatedSize)")
            }
            
            
            
            let a = $3
            
            
            
            self.leftBarLabel.text = a
            
            
            
            
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
            
            header.topImage.isHidden = false
            header.profileImage.layer.cornerRadius = 50
            header.feedInformValLabels[0].text =  String(self.imagesArr.count)
            
            
            
        }).disposed(by: header.disposeBag)
        
        
        
        output.followersCount.subscribe(onNext: { [weak self] count in
            
            header.feedInformValLabels[1].text = String(count)
            self?.followersCount = count
            
        }).disposed(by: header.disposeBag)
        
        output.followingsCount.subscribe(onNext: { [weak self] count in
            
            guard let self = self else {return}
            
            header.feedInformValLabels[2].text = String(count)
            
            
        }).disposed(by: header.disposeBag)
        
    }
    
    
    func setBindings() {
        print("setbind")
        
        
        
        
        
        let input = MyProfileVM.Input(viewWillApearEvent: self.rx.methodInvoked(#selector(viewWillAppear(_:))).map({ _ in }).asObservable()  , leftBarButton : leftBarView.rx.tapGesture().when(.recognized).asObservable() , settingTapped: rightBarImage.rx.tapGesture().when(.recognized).asObservable() , addButtonTapped : addButton.rx.tap.asObservable() , outputProfileImage : outputProfileImage.asObservable(), imageTapped: self.imageTapped.asObservable()
                                      
        )
        
        guard let output = self.viewModel?.transform(input: input, disposeBag: self.disposeBag) else { return }
        
        
        output.feedImage.subscribe( onNext: { [self] imagesArr in
            guard let imagesArr = imagesArr else { return }
            
            print("\(imagesArr) imagesArr")
            
            
            
            
            
            self.imagesArr = imagesArr
            
            var indexPathsToReload : [IndexPath] = []
            
            if( self.imagesArr.count == self.collectionView.numberOfItems(inSection: 0)){
                for i in 0..<self.imagesArr.count{
                    indexPathsToReload.append( IndexPath(row: i, section: 0) )
                }
                self.collectionView.reloadItems(at: indexPathsToReload)
                
                
            }else{
                self.collectionView.reloadData()
            }
            
            
            
            
            
            
            
            
        }).disposed(by: disposeBag)
        
        output.feedUid.subscribe( onNext: { [weak self] uidsArr in
            guard let uidsArr = uidsArr , let self = self else { return }
            self.loadControll = true
            
            self.uidsArr = uidsArr
            
        }).disposed(by: disposeBag)
        
        
        
        
        
    }
    
    
    
    
    
    
    
    
    
}

extension MyProfileVC :  UICollectionViewDataSource , UICollectionViewDelegate{
    
    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        cell.layer.removeAllAnimations()
    }
    
  
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        if kind == UICollectionView.elementKindSectionHeader {
            
            guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: ProfileHeaderView.identifier , for: indexPath) as? ProfileHeaderView  else {
                
                return UICollectionViewCell()
            }
            
            print("head start")
            
            
            if(firstBind){
                self.HEADER_HEIGHT = header.frame.height
                self.setHeaderBindings(header: header)
                
                firstBind = false
            }
            
            
            
            self.headerAppearEvent.onNext(true)
            
            self.profileHeader = header
            
            return header
        } else {
            
                guard let footer = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: DummyCollectionCell.identifier, for: indexPath) as? DummyCollectionCell else {
                    return UICollectionViewCell()
                    
                }
            
                
                return footer
            }
        
        
        
        
    }
    
    
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
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






extension MyProfileVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        
        
        let width = view.frame.size.width / 3
        
        return CGSize(width: width  , height: width  )
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
       
        if !(self.imagesArr.isEmpty) {
            return CGSize(width: 0 , height: 0 )
        }else{
            return CGSize(width: collectionView.frame.width, height: collectionView.frame.width)

        }
        
      
     }
}



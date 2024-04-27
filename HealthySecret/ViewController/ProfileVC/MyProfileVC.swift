


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

class MyProfileVC : UIViewController {
    
    
    
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
        button.translatesAutoresizingMaskIntoConstraints = false
        
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
 
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        
        collectionView.register(CustomCollectionViewCell.self, forCellWithReuseIdentifier: CustomCollectionViewCell.identifier)
        
        
        collectionView.register( ProfileHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: ProfileHeaderView.identifier)
        
        collectionView.allowsMultipleSelection = false
        collectionView.alwaysBounceVertical = true
        
        
        return collectionView
    }()
    
    
    
    
    
    
    
    
    let leftBarLabel : UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 22)
        label.bounds = CGRect(x: 0, y: 0, width: 150, height: 40)
        return label
        
    }()
    
    
    let rightBarImage : UIImageView = {
        let view = UIImageView(image: UIImage(systemName: "gearshape"))
        
        
        view.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        view.tintColor = .black
        
        return view
        
    }()
    
    lazy var rightBarButton = UIBarButtonItem(customView: rightBarImage)
    lazy var leftBarButton = UIBarButtonItem(customView: leftBarLabel)
    
    let imageAttachment = NSTextAttachment(image: UIImage(named: "arrow.png")!)
    
    var outputProfileImage = BehaviorSubject<Data?>(value: nil)
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        self.navigationController?.navigationBar.topItem?.rightBarButtonItem = self.rightBarButton
        self.navigationController?.navigationBar.topItem?.leftBarButtonItem = self.leftBarButton
        
        
        setUI()
        setBindings()
        
        
        
        
        
        
    }
    
    
    
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        self.navigationController?.navigationBar.backgroundColor = .clear
        
        
        
        
        
    }
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        
    }
    
    
    
    func setUI(){
        // collectionView.frame = view.bounds
        
        self.collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(self.collectionView)
        view.addSubview(self.addButton)
        
        
        NSLayoutConstraint.activate([
            
            self.collectionView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor ),
            self.collectionView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor  ),
            self.collectionView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor ),
            self.collectionView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor ),
            
            
            self.addButton.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor , constant: -20 ),
            self.addButton.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor , constant: -20 ),
            self.addButton.widthAnchor.constraint(equalToConstant: 50 ),
            self.addButton.heightAnchor.constraint(equalToConstant: 50),
            
            
            
            
            
        ])
        
        
        
        
        
        
        
        
        
    }
    var imagesArr : [[String]] = []
    func setHeaderBindings(header : ProfileHeaderView){
        
        
        let input = MyProfileVM.HeaderInput( viewWillApearEvent: header.appearEvent  , goalLabelTapped: Observable.merge(header.goalLabel.rx.tapGesture().when(.recognized).asObservable()), changeProfile: header.profileImage.rx.tapGesture().when(.recognized).asObservable(), outputProfileImage: self.outputProfileImage.asObservable() )
        
        
        guard let output = self.viewModel?.HeaderTransform(input: input, disposeBag: header.disposeBag) else { return }
        
        
        
        Observable.zip( output.calorie , output.goalWeight , output.nowWeight , output.name , output.introduce , output.profileImage ).subscribe(onNext: { [self] in
            
            
            
            header.calorieLabel.text = $0 + " kcal"
     
            
            
            header.goalWeight.text = $1 + " kg"
            header.nowWeight.text = $2 + " kg"
            header.introduceLabel.text = $4
            
            
            let size = CGSize(width: view.frame.width, height: CGFloat.infinity)
            
            let estimatedSize = header.introduceLabel.sizeThatFits(size)
            
            if let layout = self.collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
                print("layoutt \(estimatedSize)")
                layout.headerReferenceSize = CGSize(width: view.frame.width, height: max(estimatedSize.height + header.frame.height  , 400  ))
                self.collectionView.layoutIfNeeded() }
            
            
            
            let a = $3
            let attributedString = NSMutableAttributedString(string: "")
            attributedString.append(NSAttributedString(string: " "+a+" "))
            imageAttachment.bounds = CGRect(x: 0, y: 2, width: 12, height: 12)
            attributedString.append(NSAttributedString(attachment: imageAttachment))
            
            self.leftBarLabel.attributedText = attributedString
            
            
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
                
                header.profileImage.layer.cornerRadius = 60
                
            } else {
                header.profileImage.layer.cornerRadius = 0
                
                let bottomImage = UIImage(named: "일반적.png")
                let topImage = UIImage(named: "camera.png")
                
                
                let bottomSize = CGSize(width: 300, height: 300)
                let topSize = CGSize(width: 80, height: 80)
                UIGraphicsBeginImageContext(bottomSize)
                
                let areaSize = CGRect(x: 0, y: 0, width: bottomSize.width, height: bottomSize.height)
                let areaSize2 = CGRect(x: 212, y: 220, width: topSize.width, height: topSize.height)
                bottomImage!.draw(in: areaSize)
                
                topImage!.draw(in: areaSize2 , blendMode: .normal , alpha: 1)
                
                let newImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
                UIGraphicsEndImageContext()
                
                header.profileImage.image = newImage
                
                
                
                
                
            }
            
            
            
        }).disposed(by: header.disposeBag)
        
        
        // leftBarLabel.rx.tapGesture().when(.recognized).asObservable() ,
        
        
        
    }
    
    
    func setBindings() {
        print("setbind")
        
        
        
        let input = MyProfileVM.Input(viewWillApearEvent: self.rx.methodInvoked(#selector(viewWillAppear(_:))).map({ _ in }).asObservable()  , leftBarButton : leftBarLabel.rx.tapGesture().when(.recognized).asObservable() , settingTapped: rightBarImage.rx.tapGesture().when(.recognized).asObservable() , addButtonTapped : addButton.rx.tap.asObservable() , outputProfileImage : outputProfileImage.asObservable()
                                      
        )
        
        guard let output = self.viewModel?.transform(input: input, disposeBag: self.disposeBag) else { return }
        
        
        output.feedImage.subscribe( onNext: { [self] imagesArr in
            guard let imagesArr = imagesArr else { return }
            
            print("\(imagesArr) imagesArr")
            
            loadControll = true
            
            
            self.imagesArr = imagesArr
            self.collectionView.reloadData()
            
        }).disposed(by: disposeBag)
        
        
        
        
        
        
        
    }
    
    
    
    
    
    
    
    
    
}

extension MyProfileVC :  UICollectionViewDataSource , UICollectionViewDelegate{
    
  
    
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
        
        if(loadControll){
            header.appearEvent.onNext(true)
            loadControll = false
            
        }
        
        
        
        print("header reload")
        
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
}



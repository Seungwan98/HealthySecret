////
////  ViewController.swift
////  MovieProject
////
////  Created by 양승완 on 2023/10/04.
////
//
//import UIKit
//import RxCocoa
//import RxSwift
//
//class MyProfileVC : UIViewController {
//    
//    
//    let disposeBag = DisposeBag()
//    
//    var firstBind = true
//    
//    private var viewModel : MyProfileVM?
//    
//    
//    init(viewModel : MyProfileVM){
//        self.viewModel = viewModel
//        super.init(nibName: nil, bundle: nil)
//        
//    }
//    
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//    
//    var checkBoxButton: UIButton = {
//        let button = UIButton()
//        button.setImage(UIImage(systemName: "checkmark.circle.fill"), for: .normal)
//        button.isUserInteractionEnabled = false
//        
//        return button
//    }()
//    
//    
//    
//    
//    lazy var mainStackView : UIStackView = {
//        let stackView = UIStackView(arrangedSubviews: [testLabel1, stackView2, testImage])
//        stackView.translatesAutoresizingMaskIntoConstraints = false
//        stackView.axis = .vertical
//        stackView.alignment = .fill
//        
//        stackView.spacing = 8
//        stackView.distribution = .fillEqually
//        
//        return stackView
//        
//        
//    }()
//    
//    
//    lazy var stackView2 : UIStackView = {
//        let stackView =  UIStackView(arrangedSubviews: [checkBoxButton , logOutButton])
//        stackView.axis = .vertical
//        stackView.spacing = 8
//        stackView.distribution = .fillEqually
//        
//        
//        
//        return stackView
//        
//        
//        
//    }()
//    
//    
//    var goButton : UIButton = {
//        
//        let button = UIButton()
//        button.setTitle("식품검색", for: .normal)
//        button.setTitleColor(.black, for: .normal)
//        button.backgroundColor = .blue
//        
//        return button
//        
//    }()
//    
//    
//    var logOutButton : UIButton = {
//        
//        let button = UIButton()
//        button.setTitle("로그아웃", for: .normal)
//        button.setTitleColor(.black, for: .normal)
//        button.backgroundColor = .blue
//        
//        return button
//        
//    }()
//    
//    
//    
//    var testLabel1 : UILabel = {
//        let label = UILabel()
//        label.backgroundColor = .gray
//        label.text = "test1"
//        
//        return label
//        
//    }()
//    var testLabel2 : UILabel = {
//        let label = UILabel()
//        label.backgroundColor = .gray
//        label.text = "test2"
//        
//        return label
//        
//    }()
//    var testImage : UIImageView = {
//        let image = UIImageView()
//        image.translatesAutoresizingMaskIntoConstraints = false
//        return image
//        
//    }()
//    
//    private let collectionView: UICollectionView = {
//        let layout = UICollectionViewFlowLayout()
//        layout.minimumLineSpacing = 1
//        layout.minimumInteritemSpacing = 1
//        layout.scrollDirection = .vertical
//        layout.sectionInset = UIEdgeInsets(top: 1, left: 1, bottom: 1, right: 1)
//        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
//        collectionView.register(CustomCollectionViewCell.self, forCellWithReuseIdentifier: CustomCollectionViewCell.identifier)
//      
//        
//        
//        collectionView.alwaysBounceVertical = true
//        
//        return collectionView
//    }()
//    
//    
//    
//   
//    
//    
//    
//    let leftBarLabel : UILabel = {
//        let label = UILabel()
//        label.font = .boldSystemFont(ofSize: 22)
//        label.bounds = CGRect(x: 0, y: 0, width: 150, height: 40)
//        return label
//        
//    }()
//    
//    
//    let rightBarImage : UIImageView = {
//        let view = UIImageView(image: UIImage(systemName: "gearshape"))
//        
//        
//        view.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
//        view.tintColor = .black
//        
//        return view
//        
//    }()
//    
//    lazy var rightBarButton = UIBarButtonItem(customView: rightBarImage)
//    lazy var leftBarButton = UIBarButtonItem(customView: leftBarLabel)
//    
//    let imageAttachment = NSTextAttachment(image: UIImage(named: "arrow.png")!)
//    
//    
//    
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        self.collectionView.dataSource = self
//        self.collectionView.delegate = self
//        self.navigationController?.navigationBar.topItem?.rightBarButtonItem = self.rightBarButton
//        self.navigationController?.navigationBar.topItem?.leftBarButtonItem = self.leftBarButton
//        
//        
//        setUI()
//        setBindings()
//        
//        
//        
//        
//        
//        
//    }
//    
//    
//
//    
//    func setUI(){
//        
//        collectionView.frame = view.bounds
//        view.addSubview(collectionView)
//        
//        
//        collectionView.register( CustomHeaderCollectionView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: CustomHeaderCollectionView.identifier)
//        
//        
//        
//        
//    }
//    
//    var imagesArr : [UIImage] = []
//    func setHeaderBindings(header : CustomHeaderCollectionView){
//
//
//        let input = MyProfileVM.HeaderInput( viewWillApearEvent: header.appearEvent  , goalLabelTapped: Observable.merge(header.goalLabel.rx.tapGesture().when(.recognized).asObservable()), changeProfile: Observable.merge( header.profileImage.rx.tapGesture().when(.recognized).asObservable()) )
//                
//                guard let output = self.viewModel?.HeaderTransform(input: input, disposeBag: header.disposeBag) else { return }
//                
//                
//                
//                Observable.zip( output.calorie , output.goalWeight , output.nowWeight , output.name , output.introduce , output.profileImage ).subscribe(onNext: { [self] in
//                    
//                    
//                    
//                    header.calorieLabel.text = $0 + " kcal"
//                    header.goalWeight.text = $1 + " kg"
//                    header.nowWeight.text = $2 + " kg"
//                    header.introduceLabel.text = $4
//                    
//                    
//                    
//                    let a = $3
//                    let attributedString = NSMutableAttributedString(string: "")
//                    attributedString.append(NSAttributedString(string: " "+a+" "))
//                    imageAttachment.bounds = CGRect(x: 0, y: 2, width: 12, height: 12)
//                    attributedString.append(NSAttributedString(attachment: imageAttachment))
//                    
//                    self.leftBarLabel.attributedText = attributedString
//                    
//                    
//                    let weight = (Double($1) ?? 0.0) - (Double($2) ?? 0.0)
//                    
//                    if weight > 0 {
//                        header.gramLabel.text = "+" + String(weight) + " kg"
//                    }else{
//                        header.gramLabel.text = String(weight) + " kg"
//                    }
//                    
//                    if let data = $5 {
//                        header.profileImage.image = UIImage(data: data)
//                        header.profileImage.layer.cornerRadius = 60
//                        
//                        
//                    } else {
//                        header.profileImage.layer.cornerRadius = 0
//                        
//                        let bottomImage = UIImage(named: "일반적.png")
//                        let topImage = UIImage(named: "camera.png")
//                        
//                        
//                        let bottomSize = CGSize(width: 300, height: 300)
//                        let topSize = CGSize(width: 80, height: 80)
//                        UIGraphicsBeginImageContext(bottomSize)
//                        
//                        let areaSize = CGRect(x: 0, y: 0, width: bottomSize.width, height: bottomSize.height)
//                        let areaSize2 = CGRect(x: 212, y: 220, width: topSize.width, height: topSize.height)
//                        bottomImage!.draw(in: areaSize)
//                        
//                        topImage!.draw(in: areaSize2 , blendMode: .normal , alpha: 1)
//                        
//                        let newImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
//                        UIGraphicsEndImageContext()
//                        
//                        header.profileImage.image = newImage
//                        
//                        
//                        
//                    }
//                    
//                    
//                    
//                }).disposed(by: header.disposeBag)
//     
//        
//       // leftBarLabel.rx.tapGesture().when(.recognized).asObservable() ,
//       
//        
//        
//    }
//    
//    
//    func setBindings() {
//        print("setbind")
//    
//        
//        
//        let input = MyProfileVM.Input(viewWillApearEvent: self.rx.methodInvoked(#selector(viewWillAppear(_:))).map({ _ in }).asObservable()  , rightBarButton: leftBarButton.rx.tap.asObservable() , settingTapped: rightBarImage.rx.tapGesture().when(.recognized).asObservable()
//                                      
//        )
//        
//        guard let output = self.viewModel?.transform(input: input, disposeBag: self.disposeBag) else { return }
//        
//        
//        output.feedImage.subscribe( onNext: { [self] imagesArr in
//            guard let imagesArr = imagesArr else { return }
//            
//            self.imagesArr = imagesArr
//            
//            self.collectionView.reloadData()
//            
//            
//        }).disposed(by: disposeBag)
//        
//        
//       
//        
//        
//        
//        
//    }
//    
//    
//    
//    
//    
//    override func viewWillAppear(_ animated: Bool) {
//        self.navigationController?.setNavigationBarHidden(false, animated: false)
//        self.navigationController?.navigationBar.backgroundColor = .clear
//        
//        
//        
//        
//    }
//    override func viewWillDisappear(_ animated: Bool) {
//        self.navigationController?.setNavigationBarHidden(true, animated: true)
//        
//    }
//    
//    
//    
//    
//    
//    
//    
//    
//}
//
//extension MyProfileVC :  UICollectionViewDataSource , UICollectionViewDelegate{
//    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
//        
//        return CGSize(width: view.frame.size.width, height: 400)
//    }
//    
//    
//    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
//        guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: CustomHeaderCollectionView.identifier, for: indexPath) as? CustomHeaderCollectionView  else {
//            
//            return UICollectionViewCell()
//        }
//        
//        
//
//        if(firstBind){
//            print("바인드")
//            self.setHeaderBindings(header: header)
//            
//            firstBind = false
//        }
//        header.appearEvent.onNext(true)
//
//        
//        print("header reload")
//        
//        return header
//        
//    }
//    
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return self.imagesArr.count
//    }
//    
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CustomCollectionViewCell.identifier, for: indexPath) as? CustomCollectionViewCell else {
//            return UICollectionViewCell()
//        }
//        
//        cell.image.image = self.imagesArr[indexPath.row]
//        
//        return cell
//    }
//    
//}
//
//
//
//
//class CustomHeaderCollectionView: UICollectionReusableView  {
//    
//    let disposeBag = DisposeBag()
//    
//    
//    var appearEvent = BehaviorSubject<Bool>(value: false)
//    
//   var setBind = PublishSubject<Bool>()
//   
//    
//    static let identifier = "CustomHeaderCollectionView"
//    
//    let profileImage : UIImageView = {
//        let view = UIImageView()
//        view.translatesAutoresizingMaskIntoConstraints = false
//        view.layer.cornerRadius = 60
//        view.layer.masksToBounds = true
//        
//        view.tintColor = .white
//        
//        
//        return view
//        
//    }()
//    
//    let introduceLabel : UILabel = {
//        let label = UILabel()
//        label.text = "아직 소개글이 없어요."
//        label.textAlignment = .center
//        label.numberOfLines = 0
//        label.sizeToFit()
//        label.font =  .boldSystemFont(ofSize: 18 )
//        label.translatesAutoresizingMaskIntoConstraints = false
//        return label
//        
//        
//        
//    }()
//    
//    var goalLabel : UILabel = {
//        let label = UILabel()
//        let imageAttachment = NSTextAttachment(image: UIImage(named: "arrow.png")!)
//        label.translatesAutoresizingMaskIntoConstraints = false
//        label.font = .boldSystemFont(ofSize: 16)
//        let attributedString = NSMutableAttributedString(string: "")
//        attributedString.append(NSAttributedString(string: "나의 목표 "))
//        imageAttachment.bounds = CGRect(x: 0, y: 0.8, width: 10, height: 10)
//        
//        attributedString.append(NSAttributedString(attachment: imageAttachment))
//        
//        label.attributedText = attributedString
//        
//        return label
//        
//        
//    }()
//    
//    
//    let rightLabel : UILabel = {
//        let label = UILabel()
//        label.translatesAutoresizingMaskIntoConstraints = false
//        label.text = "목표까지"
//        label.font = .boldSystemFont(ofSize: 16)
//        
//        return label
//        
//        
//    }()
//    
//    let gramLabel : UILabel = {
//        let label = UILabel()
//        label.translatesAutoresizingMaskIntoConstraints = false
//        label.font = .boldSystemFont(ofSize: 16)
//        label.text = "80 kg"
//        label.textColor = .systemBlue
//        return label
//        
//        
//    }()
//    
//    
//    
//    var nowWeight = UILabel()
//    var calorieLabel = UILabel()
//    var goalWeight = UILabel()
//    let informLabel1 = UILabel()
//    let informLabel2 = UILabel()
//    let informLabel3 = UILabel()
//    lazy var informLabelArr = [informLabel1 , informLabel2 , informLabel3]
//    lazy var informDataArr = [nowWeight , calorieLabel , goalWeight]
//    lazy var informationView : UIView = {
//        let view = UIView()
//        
//        let stackView = UIStackView(arrangedSubviews: informLabelArr )
//        
//        view.addSubview(stackView)
//        
//        
//        view.backgroundColor = .lightGray.withAlphaComponent(0.2)
//        
//        stackView.translatesAutoresizingMaskIntoConstraints = false
//        stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor ,constant: 50).isActive = true
//        stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor ,constant: -50).isActive = true
//        stackView.heightAnchor.constraint(equalToConstant: 20).isActive = true
//        
//        stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor , constant:  -15).isActive = true
//        
//        
//        stackView.alignment = .center
//        stackView.spacing = 10
//        stackView.distribution = .equalCentering
//        
//        
//        
//        
//        view.layer.cornerRadius = 20
//        view.translatesAutoresizingMaskIntoConstraints = false
//        
//        
//        
//        return view
//        
//    }()
//    
//    
//    
//    
//    
//    override init(frame: CGRect ) {
//        super.init(frame: frame)
//        
//        setUI()
//
//        print("headerInit")
//    }
//
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//    
//    
//    
//  
//    
//    
//    
//    private func setUI() {
//        self.addSubview(informationView)
//        self.addSubview(profileImage)
//        self.addSubview(introduceLabel)
//        self.addSubview(goalLabel)
//        self.addSubview(rightLabel)
//        self.addSubview(gramLabel)
//        
//        
//        
//        
//        NSLayoutConstraint.activate([
//            
//            
//            
//            
//            profileImage.widthAnchor.constraint(equalToConstant: 120),
//            profileImage.heightAnchor.constraint(equalToConstant: 120),
//            profileImage.centerXAnchor.constraint(equalTo: self.centerXAnchor ),
//            profileImage.topAnchor.constraint(equalTo: self.topAnchor , constant: 40 ),
//            
//            introduceLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor , constant: 20 ),
//            introduceLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor , constant: -20 ),
//            introduceLabel.topAnchor.constraint(equalTo: self.profileImage.bottomAnchor , constant: 5 ),
//            introduceLabel.heightAnchor.constraint(equalToConstant: 60 ),
//            
//            
//            goalLabel.leadingAnchor.constraint(equalTo: informationView.leadingAnchor),
//            goalLabel.topAnchor.constraint(equalTo: introduceLabel.bottomAnchor , constant: 10),
//            
//            gramLabel.trailingAnchor.constraint(equalTo: informationView.trailingAnchor ),
//            gramLabel.centerYAnchor.constraint(equalTo: goalLabel.centerYAnchor ),
//            
//            rightLabel.trailingAnchor.constraint(equalTo: gramLabel.leadingAnchor , constant: -5),
//            rightLabel.centerYAnchor.constraint(equalTo: goalLabel.centerYAnchor ),
//            
//            
//            
//            informationView.leadingAnchor.constraint(equalTo: self.leadingAnchor , constant: 20),
//            informationView.trailingAnchor.constraint(equalTo: self.trailingAnchor , constant: -20),
//            informationView.topAnchor.constraint(equalTo: goalLabel.bottomAnchor , constant: 5),
//            informationView.heightAnchor.constraint(equalToConstant: 120),
//            
//            
//            
//            
//            
//            
//            
//            
//        ])
//        
//        let text = ["현재 체중" , "칼로리" , "목표 체중"]
//        for i in 0..<3{
//            informLabelArr[i].text = text[i]
//            informLabelArr[i].textColor = .lightGray.withAlphaComponent(0.8)
//            informLabelArr[i].font = .boldSystemFont(ofSize: 16)
//            
//            
//            self.addSubview(informDataArr[i])
//            informDataArr[i].translatesAutoresizingMaskIntoConstraints = false
//            informDataArr[i].font = .boldSystemFont(ofSize: 16)
//            informDataArr[i].textColor = .black
//            
//            
//            informDataArr[i].centerXAnchor.constraint(equalTo: informLabelArr[i].centerXAnchor).isActive = true
//            
//            
//            informDataArr[i].centerYAnchor.constraint(equalTo: informationView.centerYAnchor , constant: 15).isActive = true
//            
//            
//        }
//        
//    }
//    
//    
//    
//    
//    
//}
//
//
//
//extension MyProfileVC: UICollectionViewDelegateFlowLayout {
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        let width = view.frame.size.width / 3
//        return CGSize(width: width - 2, height: width - 2 )
//    }
//}
//
//

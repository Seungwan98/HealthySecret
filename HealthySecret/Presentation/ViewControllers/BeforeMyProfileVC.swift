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
//import RxGesture
//
//class MyProfileVC : UIViewController {
//
//    let disposeBag = DisposeBag()
//
//    private var viewModel : MyProfileVM?
//
//
//
//
//    private let contentScrollView: UIScrollView = {
//        let scrollView = UIScrollView()
//        scrollView.translatesAutoresizingMaskIntoConstraints = false
//        scrollView.showsVerticalScrollIndicator = false
//        return scrollView
//    }()
//
//    private let contentView : UIView = {
//        let view = UIView()
//        view.translatesAutoresizingMaskIntoConstraints = false
//        return view
//    }()
//
//    private let profileImage : UIImageView = {
//       let view = UIImageView()
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
//    private let introduceLabel : UILabel = {
//       let label = UILabel()
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
//    lazy var goalLabel : UILabel = {
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
//
//
////        var buttonConfiguration = UIButton.Configuration.plain()
////        let button = UIButton()
////        let image = UIImage(named: "arrow.png")
////        var container = AttributeContainer()
////        container.foregroundColor = UIColor.black
////        container.font = .boldSystemFont(ofSize: 16)
////
////
////
////        button.translatesAutoresizingMaskIntoConstraints = false
////
////
////        let size = CGSize(width: 10, height: 10)
////        let render = UIGraphicsImageRenderer(size: size)
////        let renderImage = render.image { context in
////            image!.draw(in: CGRect(origin: .zero, size: size))
////                }
////
////        buttonConfiguration.imagePlacement = .trailing
////        buttonConfiguration.attributedTitle = AttributedString("나의 목표" , attributes: container)
////        buttonConfiguration.image = renderImage
////
////        button.configuration = buttonConfiguration
////
////        button.backgroundColor = .red
//
////        button.setImage(renderImage, for: .normal)
////        button.setTitleColor(.black, for: .normal)
//        return label
//
//
//    }()
//
//
//    private let rightLabel : UILabel = {
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
//    private let gramLabel : UILabel = {
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
//    private let bottomView : UIView = {
//        let view = UIView()
//        view.translatesAutoresizingMaskIntoConstraints = false
//        view.backgroundColor = .lightGray.withAlphaComponent(0.2)
//        return view
//    }()
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
//       let view = UIView()
//
//        let stackView = UIStackView(arrangedSubviews: informLabelArr )
//
//        view.addSubview(stackView)
//
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
//
//
//    override func viewWillAppear(_ animated: Bool) {
//        self.navigationController?.setNavigationBarHidden(false, animated: false)
//
//        self.navigationController?.navigationBar.backgroundColor = .white
//
//    }
//    override func viewWillDisappear(_ animated: Bool) {
//        self.navigationController?.setNavigationBarHidden(true, animated: true)
//
//    }
//
//
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        setUI()
//        setBindings()
//
//    }
//
//
//
//
//    func setUI(){
//
//        self.view.addSubview(contentScrollView)
//
//        self.contentScrollView.addSubview(contentView)
//
//        self.contentView.addSubview(informationView)
//        self.contentView.addSubview(profileImage)
//        self.contentView.addSubview(introduceLabel)
//        self.contentView.addSubview(goalLabel)
//        self.contentView.addSubview(rightLabel)
//        self.contentView.addSubview(gramLabel)
//        self.contentView.addSubview(bottomView)
//        informationView.translatesAutoresizingMaskIntoConstraints = false
//
//
//
//        NSLayoutConstraint.activate([
//
//            contentScrollView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
//            contentScrollView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor),
//            contentScrollView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor),
//            contentScrollView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor),
//
//
//            contentView.topAnchor.constraint(equalTo: self.contentScrollView.topAnchor),
//            contentView.bottomAnchor.constraint(equalTo: self.contentScrollView.bottomAnchor),
//            contentView.leadingAnchor.constraint(equalTo: self.contentScrollView.leadingAnchor),
//            contentView.trailingAnchor.constraint(equalTo: self.contentScrollView.trailingAnchor),
//            self.contentView.widthAnchor.constraint(equalTo: self.contentScrollView.widthAnchor , multiplier: 1.0),
//
//
//            profileImage.widthAnchor.constraint(equalToConstant: 120),
//            profileImage.heightAnchor.constraint(equalToConstant: 120),
//            profileImage.centerXAnchor.constraint(equalTo: self.contentScrollView.centerXAnchor ),
//            profileImage.topAnchor.constraint(equalTo: self.contentScrollView.topAnchor , constant: 40 ),
//
//            introduceLabel.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor , constant: 20 ),
//            introduceLabel.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor , constant: -20 ),
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
//            informationView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor , constant: 20),
//            informationView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor , constant: -20),
//            informationView.topAnchor.constraint(equalTo: goalLabel.bottomAnchor , constant: 5),
//            informationView.heightAnchor.constraint(equalToConstant: 120),
//
//            bottomView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
//            bottomView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
//            bottomView.topAnchor.constraint(equalTo: informationView.bottomAnchor , constant: 20),
//            bottomView.heightAnchor.constraint(equalToConstant: 600),
//            bottomView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor ),
//
//
//
//
//
//
//        ])
//
//
//         let text = ["현재 체중" , "칼로리" , "목표 체중"]
//         for i in 0..<3{
//             informLabelArr[i].text = text[i]
//             informLabelArr[i].textColor = .lightGray.withAlphaComponent(0.8)
//             informLabelArr[i].font = .boldSystemFont(ofSize: 16)
//
//
//             view.addSubview(informDataArr[i])
//             informDataArr[i].translatesAutoresizingMaskIntoConstraints = false
//             informDataArr[i].font = .boldSystemFont(ofSize: 16)
//             informDataArr[i].textColor = .black
//
//
//             informDataArr[i].centerXAnchor.constraint(equalTo: informLabelArr[i].centerXAnchor).isActive = true
//
//
//             informDataArr[i].centerYAnchor.constraint(equalTo: informationView.centerYAnchor , constant: 15).isActive = true
//
//
//         }
//
//    }
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
//    func setBindings(){
//
//
//
//
//
//
//
//        self.navigationController?.navigationBar.topItem?.rightBarButtonItem = self.rightBarButton
//        self.navigationController?.navigationBar.topItem?.leftBarButtonItem = self.leftBarButton
//
//
//        let headerBind = BehaviorSubject(value: false)
//        let input = MyProfileVM.Input( viewWillApearEvent:  self.rx.methodInvoked(#selector(viewWillAppear(_:))).map({ _ in }).asObservable() , rightBarButton: leftBarButton.rx.tap.asObservable()  ,  changeProfile: Observable.merge(profileImage.rx.tapGesture().when(.recognized).asObservable() , leftBarLabel.rx.tapGesture().when(.recognized).asObservable() ), goalLabelTapped: goalLabel.rx.tapGesture().when(.recognized).asObservable() , settingTapped: rightBarImage.rx.tapGesture().when(.recognized).asObservable(), headerBind: headerBind)
//
//        guard let output = self.viewModel?.transform(input: input, disposeBag: self.disposeBag) else {return}
//
//        Observable.zip( output.calorie , output.goalWeight , output.nowWeight , output.name , output.introduce , output.profileImage ).subscribe(onNext: { [self] in
//
//
//
//            self.calorieLabel.text = $0 + " kcal"
//            self.goalWeight.text = $1 + " kg"
//            self.nowWeight.text = $2 + " kg"
//            self.introduceLabel.text = $4
//
//            let a = $3
//            let attributedString = NSMutableAttributedString(string: "")
//            attributedString.append(NSAttributedString(string: " "+a+" "))
//            imageAttachment.bounds = CGRect(x: 0, y: 2, width: 12, height: 12)
//            attributedString.append(NSAttributedString(attachment: imageAttachment))
//
//            self.leftBarLabel.attributedText = attributedString
//
//
//            let weight = (Double($1) ?? 0.0) - (Double($2) ?? 0.0)
//
//            if weight > 0 {
//                self.gramLabel.text = "+" + String(weight) + " kg"
//            }else{
//                self.gramLabel.text = String(weight) + " kg"
//            }
//
//            if let data = $5 {
//                self.profileImage.image = UIImage(data: data)
//                self.profileImage.layer.cornerRadius = 60
//
//
//            } else {
//                self.profileImage.layer.cornerRadius = 0
//
//                let bottomImage = UIImage(named: "일반적.png")
//                let topImage = UIImage(named: "camera.png")
//
//
//                let bottomSize = CGSize(width: 300, height: 300)
//                let topSize = CGSize(width: 80, height: 80)
//                UIGraphicsBeginImageContext(bottomSize)
//
//                let areaSize = CGRect(x: 0, y: 0, width: bottomSize.width, height: bottomSize.height)
//                let areaSize2 = CGRect(x: 212, y: 220, width: topSize.width, height: topSize.height)
//                bottomImage!.draw(in: areaSize)
//
//                topImage!.draw(in: areaSize2 , blendMode: .normal , alpha: 1)
//
//                let newImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
//                UIGraphicsEndImageContext()
//
//                self.profileImage.image = newImage
//
//
//            }
//
//
//        }).disposed(by: disposeBag)
//
//
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
//
//}
//
//
//
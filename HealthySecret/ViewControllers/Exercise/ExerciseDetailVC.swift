//
//  ExerciseDetailVC.swift
//  HealthySecret
//
//  Created by 양승완 on 2023/11/20.
//

import UIKit
import RxSwift

class ExerciseDetailVC: UIViewController {
    
    let viewModel : ExerciseDetailVM?
    let disposeBag = DisposeBag()
    init(viewModel: ExerciseDetailVM) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
 
    
    private let contentScrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.backgroundColor = .clear
        scrollView.showsVerticalScrollIndicator = false
        scrollView.delaysContentTouches = false
        
        return scrollView
    }()
    
    private let contentView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let exTimeTextField = UITextField()
    let exMemoTextField = UITextField()
    lazy var textFieldArr = [exTimeTextField , exMemoTextField]
    lazy var textFieldStackView : UIStackView = {
        let view =  UIStackView(arrangedSubviews: textFieldArr)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.axis = .vertical
        view.spacing = 20
        view.distribution = .fillEqually
        return view
        
        
    }()
    
    
    
    private let topView : UIView = {
        let view =  UIView()
        
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .systemBlue.withAlphaComponent(0.5)
        
        return view
        
    }()
    
    private let nameLabel : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.font = .boldSystemFont(ofSize: 30)
        label.textColor = .white
        return label
        
        
    }()
    
    private let calorieLabel : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "예상 칼로리는 0Kcal 입니다."
        
        return label
        
    }()
    
    private let imageView : UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "운동하는유미.png"))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        return imageView
        
    }()
    
    var rightLabelArr = [ UILabel(frame: CGRect(x:0 , y: 0, width: 100 , height: 50)) , UILabel(frame: CGRect(x:0 , y: 0, width: 100 , height: 50)) ]
    var leftLabelArr = [ UILabel(frame: CGRect(x: 30, y: 0, width: 80, height: 18)) ,  UILabel(frame: CGRect(x: 30, y: 0, width: 80, height: 18)) ]
    
    let bottomView : UIView = {
       let view = UIView()
       
       
       view.translatesAutoresizingMaskIntoConstraints = false
     
       return view
   }()
    
    private let addButton : UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        
        
        button.setTitle("추가하기", for: .normal)
        button.tintColor = .white
        button.layer.cornerRadius = 30
        return button
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()

        addSubView()
        setStackView()
        setBinds()
        
        
        
        self.setupKeyboardEvent()
    }
    
    
    func setBinds(){
        
        let input = ExerciseDetailVM.Input(viewWillApearEvent :  self.rx.methodInvoked(#selector(viewWillAppear(_:))).map({ _ in }).asObservable() , addBtnTapped: addButton.rx.tap.asObservable(), minuteTextField: exTimeTextField.rx.text.orEmpty.asObservable()  , memoTextField :exMemoTextField.rx.text.orEmpty.asObservable()  )
        
        guard let output = viewModel?.transform(input: input, disposeBag: disposeBag) else {return}
        
        output.nameLabel.subscribe(onNext: { text in
            self.nameLabel.text = text
            
        }).disposed(by: disposeBag)
        
        output.guessLabel.subscribe(onNext: { text in
            self.calorieLabel.text = "예상 칼로리는 \(text)Kcal 입니다."
            
            
            
        }).disposed(by: disposeBag)
        
        output.buttonEnable.subscribe(onNext: { val in
            
            if(val){
                self.addButton.backgroundColor = .lightGray.withAlphaComponent(0.2)
                self.addButton.isEnabled = !val
                self.rightLabelArr[0].textColor = .lightGray
            }
            else{
                self.addButton.backgroundColor = .systemBlue.withAlphaComponent(0.7)
                self.addButton.isEnabled = !val
                self.rightLabelArr[0].textColor = .black

            }
            
            
        }).disposed(by: disposeBag)
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {

        self.navigationController?.setNavigationBarHidden(false, animated: false)

        self.navigationController?.view.backgroundColor = .white
        
    
        self.navigationController?.navigationBar.backgroundColor = .systemBlue.withAlphaComponent(0.5)

      
    }
    override func viewWillDisappear(_ animated: Bool) {
//        self.navigationController?.hidesBottomBarWhenPushed = false

        self.navigationController?.setNavigationBarHidden(true, animated: false)
        
    }
    
    func setStackView() {
        let leftArr =  ["운동시간" , "상세기록"]
        let rightArr = ["분" , ""]
        let placeholderArr = ["0" , "ex) 횟수 , 거리"]
        var index = 0
        _ = textFieldArr.map{ (textField : UITextField) in
            
            if(index == 0){
                textField.keyboardType = .numberPad

            }
            
            textField.tintColor = .black
            textField.textAlignment = .right
            textField.placeholder = placeholderArr[index]
            
            
            
            let rightView = UIView(frame: CGRect(x: -30  , y: 0, width: 50 - (index * 15 )  , height: 50))
            let leftView = UIView(frame: CGRect(x: 30, y: 0, width: 100, height: 18))
            
            
      
            
            self.rightLabelArr[index].font = .boldSystemFont(ofSize: 18)
            self.rightLabelArr[index].text = rightArr[index]
            
            self.leftLabelArr[index].text = leftArr[index]
            self.leftLabelArr[index].font = .boldSystemFont(ofSize: 18)
            
            
            rightView.addSubview(rightLabelArr[index])
            leftView.addSubview(leftLabelArr[index])
            
            
            
            textField.translatesAutoresizingMaskIntoConstraints = false
            textField.backgroundColor = .lightGray.withAlphaComponent(0.6)
            textField.layer.cornerRadius = 20
            textField.rightViewMode = .always
            textField.leftViewMode = .always
            textField.rightView = rightView
            textField.leftView = leftView
            
            index += 1
            
        }
        
        
        
    }
    
    func addSubView(){
        
        self.view.backgroundColor = .white
        
        self.view.addSubview(contentScrollView)
        self.view.addSubview(bottomView)
        contentScrollView.addSubview(contentView)
        

        
        self.contentView.addSubview(topView)
        self.contentView.addSubview(nameLabel)
        self.contentView.addSubview(imageView)
        self.contentView.addSubview(textFieldStackView)
        self.contentView.addSubview(calorieLabel)
        
        
        bottomView.addSubview(addButton)

        NSLayoutConstraint.activate([
            
            bottomView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            bottomView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            bottomView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            bottomView.heightAnchor.constraint(equalToConstant: 100),
            

            
            addButton.leadingAnchor.constraint(equalTo:bottomView.leadingAnchor , constant: 20),
            addButton.trailingAnchor.constraint(equalTo: bottomView.trailingAnchor, constant: -20 ),
            addButton.heightAnchor.constraint(equalToConstant: 60),
            addButton.centerYAnchor.constraint(equalTo: bottomView.centerYAnchor , constant: -10 ),

            

            
            
            
            
           
            
            
            contentScrollView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            contentScrollView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            contentScrollView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            contentScrollView.bottomAnchor.constraint(equalTo: self.bottomView.topAnchor),
            
            
            contentView.topAnchor.constraint(equalTo: contentScrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: contentScrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: contentScrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: contentScrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: contentScrollView.widthAnchor , multiplier: 1.0),
            
            
            topView.topAnchor.constraint(equalTo: contentView.topAnchor),
            topView.heightAnchor.constraint(equalToConstant: 300),
            topView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            topView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            
            calorieLabel.centerYAnchor.constraint(equalTo: textFieldStackView.centerYAnchor  , constant: 120),
            calorieLabel.centerXAnchor.constraint(equalTo: textFieldStackView.centerXAnchor),
            
            
            imageView.centerXAnchor.constraint(equalTo: topView.centerXAnchor),
            imageView.bottomAnchor.constraint(equalTo: topView.bottomAnchor ,constant: 5),
            imageView.widthAnchor.constraint(equalToConstant: 120),
            imageView.heightAnchor.constraint(equalToConstant: 120),
            
            nameLabel.centerXAnchor.constraint(equalTo: topView.centerXAnchor),
            nameLabel.centerYAnchor.constraint(equalTo: topView.centerYAnchor , constant: -35),
            nameLabel.widthAnchor.constraint(equalTo: topView.widthAnchor , constant: -40),
            
            
            textFieldStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor , constant: 16),
            textFieldStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor , constant: -16) ,
            textFieldStackView.topAnchor.constraint(equalTo: topView.bottomAnchor , constant: 40),
            textFieldStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            textFieldStackView.heightAnchor.constraint(equalToConstant: 150),
            
        ])
    }
    
}


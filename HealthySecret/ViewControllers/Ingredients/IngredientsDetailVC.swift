//
//  IngredientsDetailVC.swift
//  HealthySecret
//
//  Created by 양승완 on 2023/11/20.
//

import UIKit
import RxSwift
import RxRelay

class CustomSegment : UISegmentedControl {
    override init(items : [Any]?){
        super.init(items: items)
        selectedSegmentIndex = 0
        
        
        
    }
    let font = UIFont.boldSystemFont(ofSize: 16)
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.layer.cornerRadius = 30
        self.tintColor = .white
        self.layer.masksToBounds = true
        self.clipsToBounds = true
        self.backgroundColor = .white
        
        self.selectedSegmentTintColor = .brown.withAlphaComponent(0.4)
      

        
        self.setTitleTextAttributes([NSAttributedString.Key.font: font , .foregroundColor : UIColor.white], for: .normal)

    }
    
}

class IngredientsDetailVC: UIViewController {
    
    let viewModel : IngredientsDetailVM?
    var disposeBag = DisposeBag()
    init(viewModel: IngredientsDetailVM ) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }


    private let addButton : UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        
        
        button.setTitle("추가하기", for: .normal)
        button.tintColor = .white
        button.titleLabel?.font = .boldSystemFont(ofSize: 18)
        button.layer.cornerRadius = 30
        button.backgroundColor = .systemBlue.withAlphaComponent(0.8)
        
        return button
    }()
    
    private let contentScrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
       
        scrollView.backgroundColor = UIColor.brown.withAlphaComponent(0.5)
        scrollView.showsVerticalScrollIndicator = false
        
        return scrollView
    }()
    
    private let contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    
    let leftButton : UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("1인분", for: .normal)
        button.titleLabel?.font = .boldSystemFont(ofSize: 18)
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 30
        button.isSelected = false
        button.tag = 0
        return button
    }()

    let rightButton : UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("g", for: .normal)
        button.titleLabel?.font = .boldSystemFont(ofSize: 18)
        button.backgroundColor = .brown.withAlphaComponent(0.2)

        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 30
        button.isSelected = true
        button.tag = 1
        return button
    }()
    lazy var radioButtons : [UIButton] = [leftButton , rightButton]
    lazy var radioStackView : UIStackView = {
        let view = UIStackView(arrangedSubviews: radioButtons)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.distribution = .fillEqually
        view.backgroundColor = UIColor.brown.withAlphaComponent(0.2)
        view.layer.cornerRadius = 30

        return view

    }()
    
    
    
    
    
    
    
    
    
    
    let minusButton : UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(systemName: "minus"), for: .normal)
        button.tintColor = .white
        return button
    }()
    
    let plusButton : UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(systemName: "plus"), for: .normal)
        button.tintColor = .white
        

        return button
    }()
    
    
    
    let selectTextField : UITextField = {
        let textField = UITextField()
        textField.layer.cornerRadius = 30

        textField.tintColor = .white
        textField.textColor = .white
        textField.textAlignment = .center
        textField.keyboardType = .numberPad
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField

    }()

    let textFieldView : UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.brown.withAlphaComponent(0.2)
        view.layer.cornerRadius = 30
        return view
    }()
   
    
    lazy var selectArr = [radioStackView , textFieldView]
    lazy var selectStackView : UIStackView = {
        let view =  UIStackView(arrangedSubviews: selectArr)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.axis = .vertical
        view.spacing = 20
        view.distribution = .fillEqually
        return view
        
        
    }()
    
    

    private let nameLabel : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        
        label.font = .boldSystemFont(ofSize: 30)
        label.textColor = .white
        label.text = ""
        return label
        
        
    }()
    
    
    
   
    @objc
    func buttonsAction(_ sender : UIButton ){
     
            self.radioButtons.forEach {
                // sender로 들어온 버튼과 tag를 비교
                if $0.tag == sender.tag {
                    if(!$0.isSelected){
                        self.outputSelect.onNext($0.tag+2)
                        $0.backgroundColor = .brown.withAlphaComponent(0.2)
                        $0.isSelected = true
                        


                        
                    }
                    
                } else {
                    // 다른 tag이면 색이 없는 동그라미로 변경
                    $0.backgroundColor = .clear
                    $0.isSelected = false
                }
            }
        
        


    }
  
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.hideKeyboardWhenTappedAround()
        self.setupKeyboardEvent()

        setUI()
        addInformView()
        setStackView()
        setBinds()
    }
    
    var outputText = PublishSubject<String>()
    let outputSelect = BehaviorSubject<Int>(value: 1)
    let testIsSelected = PublishSubject<Bool>()
    
    
    func setBinds(){
        
        self.plusButton.rx.tap.subscribe(onNext: { _ in
            if let text = self.selectTextField.text{
                self.selectTextField.text = String((Int(text) ?? 0)+1)
                self.outputText.onNext(String((Int(text) ?? 0)+1))
            }
            
            
           
            
            
        }).disposed(by: disposeBag)
        
        
        
        
        self.minusButton.rx.tap.subscribe(onNext: { _ in
            if let text = self.selectTextField.text{
                
                if text != "0" && text != "" {
                    self.selectTextField.text = String((Int(text) ?? 0)-1)
                    self.outputText.onNext(String((Int(text) ?? 0)-1))
                }
                
                
            }
            
            
           
            
            
        }).disposed(by: disposeBag)
       
        
        
       
        
        
        let input = IngredientsDetailVM.Input(viewWillApearEvent: self.rx.methodInvoked(#selector(viewWillAppear(_:)))
            .map( { _ in }).asObservable(), addBtnTapped: self.addButton.rx.tap.asObservable(), selectTextField: Observable.merge(self.selectTextField.rx.text.orEmpty.distinctUntilChanged().asObservable(), self.outputText    ), selectButton: self.outputSelect.asObservable()
                                              
        )
        
        
        
        
        
        
        
        
        
        guard let output = viewModel?.transform(input: input, disposeBag: self.disposeBag ) else {return}
        
        
//
//        output.buttonEnable.subscribe(onNext: { event in
//            self.addButton.isEnabled = event
//
//        }).disposed(by: disposeBag)
        
        output.calorieLabel.subscribe(onNext: { text in
            self.calorieLabel.text = text
            
        }).disposed(by: disposeBag)
        
        output.nameLabel.subscribe(onNext: { text in
            self.nameLabel.text = text
            
        }).disposed(by: disposeBag)
        
        let a = output.carbohydratesLabel
        let b = output.proteinLabel
        let c = output.provinceLabel
        Observable.zip( a , b , c ).subscribe( onNext : {
            self.informDataArr[0].text = $0
            self.informDataArr[1].text = $1
            self.informDataArr[2].text = $2
            
            
            
        }).disposed(by: disposeBag)
        
        output.firstTextToField.subscribe(onNext: { first in
            self.selectTextField.text = first
            
        }).disposed(by: disposeBag)

        

    }
    
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        print("willAppear")


        self.navigationController?.navigationBar.backgroundColor = UIColor.brown.withAlphaComponent(0.5)
        
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        
        
        
        
    }
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        
    }
    
    let bottomView : UIView = {
       let view = UIView()
       view.translatesAutoresizingMaskIntoConstraints = false
       return view
   }()
    
    let calorieLabel : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .boldSystemFont(ofSize: 22)
        label.textColor = .white
        label.text = "kcal"
        
        return label
        
    }()
    
 
    var goalLabel = UILabel()
    var eatLabel = UILabel()
    var consumeLabel = UILabel()
    let informLabel1 = UILabel()
    let informLabel2 = UILabel()
    let informLabel3 = UILabel()
    let informCircle1 = UIView()
    let informCircle2 = UIView()
    let informCircle3 = UIView()
    lazy var informCircleArr = [ informCircle1 , informCircle2 , informCircle3  ]
    lazy var informLabelArr = [informLabel1 , informLabel2 , informLabel3]
    lazy var informDataArr = [goalLabel , eatLabel , consumeLabel]
    
    lazy var labelStackView : UIStackView = {
       let stackView  = UIStackView(arrangedSubviews: informLabelArr)
        
        
       

        stackView.translatesAutoresizingMaskIntoConstraints = false

        
        stackView.alignment = .center
        stackView.spacing = 20
        stackView.distribution = .fillEqually
        
        return stackView
    }()
    lazy var informationView : UIView = {
       let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        
        
        
        return view
        
    }()
    
    
    
    func setStackView() {
        
        
        
        textFieldView.addSubview(selectTextField)
        textFieldView.addSubview(minusButton)
        textFieldView.addSubview(plusButton)
        
        
        
        
        NSLayoutConstraint.activate([
            
            selectTextField.topAnchor.constraint(equalTo: textFieldView.topAnchor),
            selectTextField.bottomAnchor.constraint(equalTo: textFieldView.bottomAnchor),
            selectTextField.widthAnchor.constraint(equalToConstant: 80),
            selectTextField.centerXAnchor.constraint(equalTo: textFieldView.centerXAnchor),
            
            minusButton.leadingAnchor.constraint(equalTo:textFieldView.leadingAnchor , constant: 15 ),
            minusButton.widthAnchor.constraint(equalToConstant: 50 ),
            minusButton.heightAnchor.constraint(equalTo: textFieldView.heightAnchor ),
            
            plusButton.trailingAnchor.constraint(equalTo:textFieldView.trailingAnchor , constant: -15 ),
            plusButton.widthAnchor.constraint(equalToConstant: 50 ),
            plusButton.heightAnchor.constraint(equalTo: textFieldView.heightAnchor ),
            
            
            
            
        
        ])

    
 
 

            
            
        
        
        
        
    }
//    let testColor : [UIColor] = [   UIColor(red: 0.686, green: 0.776, blue: 1, alpha: 1),  UIColor(red: 0.487, green: 1, blue: 0.448, alpha: 1) , UIColor(red: 1, green: 0.886, blue: 0.8, alpha: 1) ]
    func addInformView(){
        let text = ["탄수화물" , "단백질" , "지방"]
      
        let circleColor : [UIColor] = [   UIColor(red: 0.686, green: 0.776, blue: 0.627, alpha: 1),  UIColor(red: 0.487, green: 0.555, blue: 0.448, alpha: 1) , UIColor(red: 0.835, green: 0.886, blue: 0.8, alpha: 1) ]
        


     
            
        self.informationView.addSubview(nameLabel)
        self.informationView.addSubview(informCircleArr[0])
        self.informationView.addSubview(informCircleArr[2])
        self.informationView.addSubview(informCircleArr[1])
        
        self.informationView.addSubview(labelStackView)
        
        self.informationView.addSubview(calorieLabel)

    
        
        
        for i in 0..<3{
            
            self.informCircleArr[i].addSubview(informDataArr[i])

            
            informCircleArr[i].translatesAutoresizingMaskIntoConstraints = false
            informCircleArr[i].layer.cornerRadius = 60
            informCircleArr[i].backgroundColor = circleColor[i]


            informLabelArr[i].text = text[i]
            informLabelArr[i].textColor = .white
            informLabelArr[i].font = .boldSystemFont(ofSize: 14)
            informLabelArr[i].textAlignment = .center
            
            
            informDataArr[i].translatesAutoresizingMaskIntoConstraints = false
            informDataArr[i].font = .boldSystemFont(ofSize: 18)
            informDataArr[i].textColor = .white
            informDataArr[i].textAlignment = .center
            informDataArr[i].text = "1200g"
            
            NSLayoutConstraint.activate([

          
            


            
            informCircleArr[i].centerXAnchor.constraint(equalTo: informLabelArr[i].centerXAnchor),
            informCircleArr[i].centerYAnchor.constraint(equalTo: informLabelArr[i].centerYAnchor , constant: 10 ),
            informCircleArr[i].widthAnchor.constraint(equalToConstant: 120 ),
            informCircleArr[i].heightAnchor.constraint(equalToConstant: 120 ),
            
            
            
            informDataArr[i].centerXAnchor.constraint(equalTo: informLabelArr[i].centerXAnchor),
            informDataArr[i].centerYAnchor.constraint(equalTo: informLabelArr[i].centerYAnchor , constant: 20),

                        
            ])
            
           

            
        }
        NSLayoutConstraint.activate([
            
            nameLabel.leadingAnchor.constraint(equalTo: informCircle1.leadingAnchor ,constant: 0),
            nameLabel.topAnchor.constraint(equalTo: informationView.topAnchor ,constant: 10),

            labelStackView.leadingAnchor.constraint(equalTo: informationView.leadingAnchor ,constant: 40),
            labelStackView.trailingAnchor.constraint(equalTo: informationView.trailingAnchor ,constant: -40),
            labelStackView.heightAnchor.constraint(equalToConstant: 20),
          
            labelStackView.centerYAnchor.constraint(equalTo: informationView.centerYAnchor , constant:  0),
      
            calorieLabel.leadingAnchor.constraint(equalTo: informCircle1.leadingAnchor ,constant: 0),
            calorieLabel.topAnchor.constraint(equalTo: informCircle1.bottomAnchor ,constant: 20),

          
        ])


       

    }
    
    func setUI(){
        
        
        leftButton.addTarget(self, action: #selector(buttonsAction( _:)), for: .touchUpInside)
        rightButton.addTarget(self, action: #selector(buttonsAction( _:)), for: .touchUpInside)

        
        self.view.addSubview(bottomView)
        self.view.addSubview(contentScrollView)
        
        self.contentScrollView.addSubview(self.contentView)
        
        
        self.contentView.addSubview(informationView)
        self.contentView.addSubview(selectStackView)
        self.bottomView.addSubview(addButton)
        
       
        
        

        
        
        
        NSLayoutConstraint.activate([
            
            
            bottomView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            bottomView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            bottomView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            bottomView.heightAnchor.constraint(equalToConstant: 100),
            
            
            addButton.heightAnchor.constraint(equalToConstant: 60),
            addButton.leadingAnchor.constraint(equalTo: bottomView.leadingAnchor , constant: 20 ),
            addButton.trailingAnchor.constraint(equalTo: bottomView.trailingAnchor , constant: -20 ),
            addButton.centerYAnchor.constraint(equalTo: bottomView.centerYAnchor , constant: -10 ),


            
            
            informationView.topAnchor.constraint(equalTo: contentView.topAnchor),
            informationView.heightAnchor.constraint(equalToConstant: 300),
            informationView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            informationView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            
            
            
            
            
        
            
            
            selectStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor , constant: 16),
            selectStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor , constant: -16) ,
            selectStackView.topAnchor.constraint(equalTo: informationView.bottomAnchor , constant: 20),
            selectStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            selectStackView.heightAnchor.constraint(equalToConstant: 150),
            
            
            
            
            

            
            contentScrollView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            contentScrollView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor),
            contentScrollView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor),
            contentScrollView.bottomAnchor.constraint(equalTo: self.bottomView.topAnchor),
            
            
            contentView.topAnchor.constraint(equalTo: contentScrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: contentScrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: contentScrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: contentScrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: contentScrollView.widthAnchor , multiplier: 1.0),
 
            
            
            
        ])
    }
    
}



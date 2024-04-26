//
//  ChangeSignUpVC.swift
//  HealthySecret
//
//  Created by 양승완 on 2023/11/20.
//

import UIKit
import RxSwift
class ChangeSignUpVC : UIViewController {
    
  
    let viewModel : ChangeSignUpVM?
    let disposeBag = DisposeBag()
    
    init(viewModel: ChangeSignUpVM) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    
    private let contentScrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.showsVerticalScrollIndicator = false
        
        return scrollView
    }()
    
    let contentView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 0.949, green: 0.918, blue: 0.886, alpha: 1)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    
    var index = 0

    
    
    var firstView : UIView = {
        let view = UIView()
        view.layer.borderColor = UIColor.black.cgColor

        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    var secondView : UIView = {
        let view = UIView()
        view.layer.borderColor = UIColor.black.cgColor

        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    var thirdView : UIView = {
        let view = UIView()
        view.layer.borderColor = UIColor.black.cgColor

        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    
    
    lazy var questionStackView: UIStackView = {
        let stackview = UIStackView(arrangedSubviews:  [firstView , secondView , thirdView ])
       
        stackview.translatesAutoresizingMaskIntoConstraints = false
        stackview.axis = .vertical
        stackview.spacing = 15
        stackview.distribution = .fillEqually
        stackview.layer.borderColor = UIColor.black.cgColor
                
        
        return stackview
        
    }()
    
    
    
    let nextButton : UIButton = {
       let button = UIButton()
        
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("다음", for: .normal)
        button.tintColor = .white
        button.titleLabel?.font = .boldSystemFont(ofSize: 20)
        button.layer.cornerRadius = 30
        button.backgroundColor =  .black
        
        return button
    }()
    
    
    var ageTextField = UITextField()
    var tallTextField = UITextField()
    var startWeightTextField = UITextField()
    var goalWeightTextField = UITextField()
    
    
    var subTextFields : [UITextField] = []
    
  
    var ageText = BehaviorSubject<String>(value: "")
    var tallText = BehaviorSubject<String>(value: "")
    var startWeightText = BehaviorSubject<String>(value: "")
    var goalWeightText = BehaviorSubject<String>(value: "")
    
    func setBindings(){
        
        ageTextField.rx.text.orEmpty.bind(to: ageText).disposed(by: disposeBag)
        tallTextField.rx.text.orEmpty.bind(to: tallText).disposed(by: disposeBag)
        startWeightTextField.rx.text.orEmpty.bind(to: startWeightText).disposed(by: disposeBag)
        goalWeightTextField.rx.text.orEmpty.bind(to: goalWeightText).disposed(by: disposeBag)
        
        
        
        let input = ChangeSignUpVM.Input( sexInput: sexInput , exerciseInput: exerciseInput , ageInput : ageText.asObservable() , tallInput: tallText.asObservable() , startWeight: startWeightText.asObservable(), goalWeight: goalWeightText.asObservable() , nextButtonTapped: self.nextButton.rx.tap.asObservable() )
        
        guard let output = viewModel?.transform(input: input, disposeBag: disposeBag) else {return}
      
        
        
        
        
        output.nextButtonEnable.subscribe(onNext: { event in
            print(event)
            self.nextButton.isEnabled = event
            
            if event {
                self.nextButton.backgroundColor = .black
            }else{
                self.nextButton.backgroundColor = .lightGray

            }
            
            
            
        }).disposed(by: disposeBag)
        
        Observable.zip(output.ageOutput , output.exerciseOutput , output.goalWeight, output.startWeight , output.sexOutput , output.tallOutput ).subscribe( onNext: { [self] in
            let age = $0
            let exercise = $1
            let goalWeight = $2
            let startWeight = $3
            let sex = $4
            let tall = $5
            
            print("zip")
            
            self.ageTextField.text = age
      
            self.exerciseButtonAction(thirdViewButtons[exercise])
            self.goalWeightTextField.text = goalWeight
            self.startWeightTextField.text = startWeight
            self.sexButtonAction(sexButtons[sex])
            self.tallTextField.text = tall
            
            self.goalWeightText.onNext(goalWeight)
            self.startWeightText.onNext(startWeight)
            self.tallText.onNext(tall)
            self.ageText.onNext(age)
            
            
            
        }).disposed(by: disposeBag)
        
    }
    
    
    let sexButtons = [ UIButton() , UIButton() ]

   
   
    
    
    let thirdViewButtons = [ UIButton() , UIButton() , UIButton() ]
    let thirdViewButtonImages = [UIImage(named: "활동적음.png"),UIImage(named: "일반적.png"),UIImage(named: "활동많음.png")]
    let thirdViewButtonImagesFill = [UIImage(named: "활동적음_fill.png"),UIImage(named: "일반적_fill.png"),UIImage(named: "활동많음_fill.png")]
    
    
    
    let topLabel : UILabel = {
       let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "나만의 다이어트 설정"
        label.font = .boldSystemFont(ofSize: 25)
        return label
        
    }()
    
    
    let firstLabel : UILabel = {
        let label = UILabel()
        label.text = "성별"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 18)
        return label
    }()
  
    
    let subStackViews = [UIStackView() , UIStackView() ,UIStackView() ,UIStackView() ]
    
    
    var sexInput = BehaviorSubject<Int>(value: 2)
    var exerciseInput = BehaviorSubject<Int>(value: 3)
    
    
    
    
    
    
     let bottomView : UIView = {
        let view = UIView()
        
        
        view.translatesAutoresizingMaskIntoConstraints = false
      
        return view
    }()

    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: true)

        
        
    }
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(red: 0.949, green: 0.918, blue: 0.886, alpha: 1)

        addSubView()
        setInformationStack()

        setBindings()
        
    }
    
    
    
    
    
    
    func setInformationStack(){
        
       subTextFields = [ageTextField , tallTextField , startWeightTextField , goalWeightTextField ]
        
        sexButtons[0].setImage(UIImage(named: "menButton.png"), for: .normal)
        sexButtons[1].setImage(UIImage(named: "womenButton.png"), for: .normal)
        
        _ = sexButtons.map({ btn in
             
             self.firstView.addSubview(btn)
             btn.translatesAutoresizingMaskIntoConstraints = false
            btn.backgroundColor = .lightGray.withAlphaComponent(0.6)
            btn.layer.cornerCurve = .circular
            btn.layer.cornerRadius = 60
            btn.tag = index
            btn.addTarget(self, action: #selector(sexButtonAction(_ :)), for: .touchUpInside )
             
            
            index += 1
            

             
             NSLayoutConstraint.activate([
             btn.centerYAnchor.constraint(equalTo: firstView.centerYAnchor , constant: 50),
             btn.widthAnchor.constraint(equalToConstant: 120),
             btn.heightAnchor.constraint(equalToConstant: 120),
             
             
         ])
             
         })
     
        index = 0
        

        
        _ = subStackViews.map({ (value : UIStackView)  in
            value.axis = .horizontal
            value.distribution = .fillEqually
            value.translatesAutoresizingMaskIntoConstraints = false
            
    
        })
        
        

        
        
        
  
        let subLabels = [UILabel() ,UILabel() ,UILabel() ,UILabel() ]
       
        let texts = ["나이" , "키" , "시작 체중" , "목표 체중"]

   
       
        let rightTexts = ["세" , "cm" , "kg" , "kg"]
        
       
       _ = subTextFields.map{ textField in
            
            
            
            
            let rightView = UIView(frame: CGRect(x: 0, y: 0, width: 35, height: 50))
            let leftView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: 50))
            
            let rightLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 26, height: 50))
            rightLabel.text = rightTexts[index]
            rightLabel.font = .boldSystemFont(ofSize: 18)
            
            
            
            rightView.addSubview(rightLabel)
            
            if(index < 2){
                textField.placeholder = "0"
            }else{
                textField.placeholder = "0.0"
            }
            
            index += 1
            
            textField.translatesAutoresizingMaskIntoConstraints = false
            textField.backgroundColor = .lightGray.withAlphaComponent(0.6)
            textField.layer.cornerRadius = 10
            textField.rightViewMode = .always
            textField.leftViewMode = .always
            textField.rightView = rightView
            textField.leftView = leftView
            
        }
        index = 0
        
        
  
     
        subLabels.forEach { label in
            
            subStackViews[index].spacing = 10
            
            
            label.text = texts[index]
            label.font = UIFont.boldSystemFont(ofSize: 18)
            
            
            let textField = subTextFields[index]
            
            if(index < 2 ){
                subStackViews[0].addArrangedSubview(label)
                subStackViews[1].addArrangedSubview(textField)
            }
            else{
                subStackViews[2].addArrangedSubview(label)
                subStackViews[3].addArrangedSubview(textField)
            }
            index += 1
        }
        

        
        
        let informationStackView : UIStackView = {
            let stackView = UIStackView(arrangedSubviews: subStackViews)
            stackView.axis = .vertical
            stackView.distribution = .fillEqually
            stackView.translatesAutoresizingMaskIntoConstraints = false
            
            
            
            
            return stackView
        }()
   
      
        
        let thirdLabel : UILabel = {
           let label = UILabel()
            label.text = "평소 활동량"
            label.font = .boldSystemFont(ofSize: 18)
            label.translatesAutoresizingMaskIntoConstraints = false
            
            return label
        }()
        
        
        
      
        
        let thirdStackView : UIStackView = {
            let stackview = UIStackView()
            stackview.translatesAutoresizingMaskIntoConstraints = false
            stackview.axis = .horizontal
            stackview.alignment = .center
            stackview.distribution = .equalSpacing
            
            return stackview
        }()
        
      
        
        
        
        

        
        
        
        index = 0
        
        _ = thirdViewButtons.map({ button in
            
            button.setImage(thirdViewButtonImages[index], for: .normal)
            button.tag = index
            button.addTarget(self, action: #selector(exerciseButtonAction), for: .touchUpInside)
            
            button.translatesAutoresizingMaskIntoConstraints = false
            
            button.widthAnchor.constraint(equalToConstant: 50).isActive = true
            button.heightAnchor.constraint(equalToConstant: 50).isActive = true
            
            thirdStackView.addArrangedSubview(button)
            index += 1
            
        })
      
        
        
        
        
      
 
        
        
        
   

        self.firstView.addSubview(topLabel)
        self.firstView.addSubview(firstLabel)
        self.secondView.addSubview(informationStackView)
        self.thirdView.addSubview(thirdLabel)
        self.thirdView.addSubview(thirdStackView)
        
        
        index = 0
        let thirdLabels = [UILabel() , UILabel() , UILabel() ]
        let thirdLabelTexts = ["활동 적음" , "일반적" , "활동 많음" ]
        _ = thirdLabels.map({ label in
            thirdView.addSubview(label)
            label.text = thirdLabelTexts[index]
            label.translatesAutoresizingMaskIntoConstraints = false
            label.font = .boldSystemFont(ofSize: 15)
            label.textColor = .lightGray.withAlphaComponent(0.6)
            
            
            NSLayoutConstraint.activate([
                
                
                
                label.centerXAnchor.constraint(equalTo: thirdViewButtons[index].centerXAnchor),
                label.topAnchor.constraint(equalTo: thirdViewButtons[index].bottomAnchor , constant: 1),
            
            ])
           
            
            index += 1
            
            
        })
        
        
        
        
        
        NSLayoutConstraint.activate([
            
            topLabel.topAnchor.constraint(equalTo: firstView.topAnchor  , constant: 10),
            topLabel.leadingAnchor.constraint(equalTo: firstView.leadingAnchor ),
            topLabel.trailingAnchor.constraint(equalTo: firstView.trailingAnchor ),
            
            
            firstLabel.topAnchor.constraint(equalTo: firstView.topAnchor , constant: 70),
            firstLabel.leadingAnchor.constraint(equalTo: firstView.leadingAnchor ),
            
            
            
            sexButtons[0].centerXAnchor.constraint(equalTo: firstView.centerXAnchor , constant: -80),
            sexButtons[1].centerXAnchor.constraint(equalTo: firstView.centerXAnchor , constant: 80),
            
            
            informationStackView.topAnchor.constraint(equalTo: secondView.topAnchor),
            informationStackView.bottomAnchor.constraint(equalTo: secondView.bottomAnchor),
            informationStackView.leadingAnchor.constraint(equalTo: secondView.leadingAnchor),
            informationStackView.trailingAnchor.constraint(equalTo: secondView.trailingAnchor),
            
            
            thirdLabel.topAnchor.constraint(equalTo: thirdView.topAnchor , constant: 50),
            thirdLabel.leadingAnchor.constraint(equalTo: thirdView.leadingAnchor ),
            
            thirdStackView.leadingAnchor.constraint(equalTo: thirdView.leadingAnchor , constant: 50),
            thirdStackView.trailingAnchor.constraint(equalTo: thirdView.trailingAnchor , constant: -50 ),
            thirdStackView.centerYAnchor.constraint(equalTo: thirdView.centerYAnchor , constant: 20 ),
            
            
            
            //thirdStackView.topAnchor.constraint(equalTo: thirdView.topAnchor , constant: 40 ),
          //  thirdStackView.bottomAnchor.constraint(equalTo: thirdView.bottomAnchor , constant: -30 ),
            
            
        ])
        
        
        
    }

    @objc
    func exerciseButtonAction(_ sender : UIButton ){
        
        self.thirdViewButtons.forEach {
            // sender로 들어온 버튼과 tag를 비교
            if $0.tag == sender.tag {
                // 같은 tag이면 색이 찬 동그라미로 변경
                $0.setImage(thirdViewButtonImagesFill[$0.tag], for: .normal)
            } else {
                // 다른 tag이면 색이 없는 동그라미로 변경
                $0.setImage(thirdViewButtonImages[$0.tag], for: .normal)
            }
        }
        self.exerciseInput.onNext(sender.tag)

    }
    
    @objc
    func sexButtonAction(_ sender : UIButton ){
     
            
            self.sexButtons.forEach {
                // sender로 들어온 버튼과 tag를 비교
                if $0.tag == sender.tag {
                    // 같은 tag이면 색이 찬 동그라미로 변경
                    $0.backgroundColor = .systemBlue.withAlphaComponent(0.5)
                } else {
                    // 다른 tag이면 색이 없는 동그라미로 변경
                    $0.backgroundColor = .lightGray.withAlphaComponent(0.6)
                }
            }
            self.sexInput.onNext(sender.tag)


    }
    
    
   
    
    func addSubView(){
        
        self.view.addSubview(contentScrollView)
        self.view.addSubview(bottomView)
        bottomView.addSubview(nextButton)
        self.contentScrollView.addSubview(contentView)
        
        self.contentView.addSubview(questionStackView)
        
        
        
        NSLayoutConstraint.activate([
            
            
            bottomView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            bottomView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            bottomView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            bottomView.heightAnchor.constraint(equalToConstant: 100),
            
           
            contentScrollView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            contentScrollView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            contentScrollView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            contentScrollView.bottomAnchor.constraint(equalTo: self.bottomView.topAnchor),
            
            
            contentView.topAnchor.constraint(equalTo: contentScrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: contentScrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: contentScrollView.trailingAnchor),
            contentView.trailingAnchor.constraint(equalTo: contentScrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: contentScrollView.bottomAnchor),
            //스크롤 방향
            contentView.widthAnchor.constraint(equalTo: contentScrollView.widthAnchor),
            
            
            nextButton.heightAnchor.constraint(equalToConstant: 60),
            nextButton.trailingAnchor.constraint(equalTo: bottomView.trailingAnchor , constant: -15),
            nextButton.leadingAnchor.constraint(equalTo: bottomView.leadingAnchor , constant: 15),
            nextButton.centerYAnchor.constraint(equalTo: bottomView.centerYAnchor , constant: -10 ),
            
            
            
            
            questionStackView.topAnchor.constraint(equalTo: contentView.topAnchor , constant: 20),
            questionStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor , constant: 15),
            questionStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor , constant: -15 ),
            
            questionStackView.heightAnchor.constraint(equalToConstant: 680),
            questionStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
           
            
            
            
        ])
    }
    
}


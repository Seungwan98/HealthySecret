//
//  IngredientsDetailVC.swift
//  HealthySecret
//
//  Created by 양승완 on 2023/11/20.
//

import UIKit
import RxSwift
import RxRelay
import SnapKit

class CustomSegment: UISegmentedControl {
    override init(items: [Any]?) {
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
        
        
        
        self.setTitleTextAttributes([NSAttributedString.Key.font: font, .foregroundColor: UIColor.white], for: .normal)
        
    }
    
}

class IngredientsDetailVC: UIViewController {
    
    let viewModel: IngredientsDetailVM?
    var disposeBag = DisposeBag()
    init(viewModel: IngredientsDetailVM ) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private let addButton: UIButton = {
        let button = UIButton()
        
        
        button.setTitle("추가하기", for: .normal)
        button.tintColor = .white
        button.titleLabel?.font = .boldSystemFont(ofSize: 18)
        button.layer.cornerRadius = 30
        button.backgroundColor = .systemBlue.withAlphaComponent(0.8)
        
        return button
    }()
    
    private let contentScrollView: UIScrollView = {
        let scrollView = UIScrollView()
        
        scrollView.backgroundColor = UIColor.brown.withAlphaComponent(0.5)
        scrollView.showsVerticalScrollIndicator = false
        
        return scrollView
    }()
    
    private let contentView: UIView = {
        let view = UIView()
        return view
    }()
    
    
    let leftButton: UIButton = {
        let button = UIButton()
        button.setTitle("1인분", for: .normal)
        button.titleLabel?.font = .boldSystemFont(ofSize: 18)
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 30
        button.isSelected = false
        button.tag = 0
        return button
    }()
    
    let rightButton: UIButton = {
        let button = UIButton()
        button.setTitle("g", for: .normal)
        button.titleLabel?.font = .boldSystemFont(ofSize: 18)
        button.backgroundColor = .brown.withAlphaComponent(0.2)
        
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 30
        button.isSelected = true
        button.tag = 1
        return button
    }()
    lazy var radioButtons: [UIButton] = [leftButton, rightButton]
    lazy var radioStackView: UIStackView = {
        let view = UIStackView(arrangedSubviews: radioButtons)
        view.distribution = .fillEqually
        view.backgroundColor = UIColor.brown.withAlphaComponent(0.2)
        view.layer.cornerRadius = 30
        
        return view
        
    }()
    
    
    
    
    
    
    
    
    
    
    let minusButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "minus"), for: .normal)
        button.tintColor = .white
        return button
    }()
    
    let plusButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "plus"), for: .normal)
        button.tintColor = .white
        
        
        return button
    }()
    
    
    
    let selectTextField: UITextField = {
        let textField = UITextField()
        textField.layer.cornerRadius = 30
        
        textField.tintColor = .white
        textField.textColor = .white
        textField.textAlignment = .center
        textField.keyboardType = .numberPad
        return textField
        
    }()
    
    let textFieldView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.brown.withAlphaComponent(0.2)
        view.layer.cornerRadius = 30
        return view
    }()
    
    
    lazy var selectArr = [radioStackView, textFieldView]
    lazy var selectStackView: UIStackView = {
        let view =  UIStackView(arrangedSubviews: selectArr)
        view.axis = .vertical
        view.spacing = 20
        view.distribution = .fillEqually
        return view
        
        
    }()
    
    
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        
        label.font = .boldSystemFont(ofSize: 30)
        label.textColor = .white
        label.text = ""
        return label
        
        
    }()
    
    
    
    
    @objc
    func buttonsAction(_ sender: UIButton ) {
        
        self.radioButtons.forEach {
            // sender로 들어온 버튼과 tag를 비교
            if $0.tag == sender.tag {
                if !$0.isSelected {
                    self.outputSelect.onNext($0.tag + 2)
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
    
    
    func setBinds() {
        
        self.plusButton.rx.tap.subscribe(onNext: { _ in
            if let text = self.selectTextField.text {
                self.selectTextField.text = String((Int(text) ?? 0)+1)
                self.outputText.onNext(String((Int(text) ?? 0)+1))
            }
            
            
            
            
            
        }).disposed(by: disposeBag)
        
        
        
        
        self.minusButton.rx.tap.subscribe(onNext: { _ in
            if let text = self.selectTextField.text {
                
                if text != "0" && text.isEmpty {
                    self.selectTextField.text = String((Int(text) ?? 0)-1)
                    self.outputText.onNext(String((Int(text) ?? 0)-1))
                }
                
                
            }
            
            
            
            
            
        }).disposed(by: disposeBag)
        
        
        
        
        
        
        let input = IngredientsDetailVM.Input(viewWillApearEvent: self.rx.methodInvoked(#selector(viewWillAppear(_:)))
            .map( { _ in }).asObservable(), addBtnTapped: self.addButton.rx.tap.asObservable(), selectTextField: Observable.merge(self.selectTextField.rx.text.orEmpty.distinctUntilChanged().asObservable(), self.outputText    ), selectButton: self.outputSelect.asObservable()
                                              
        )
        
        
        
        
        
        
        
        
        
        guard let output = viewModel?.transform(input: input, disposeBag: self.disposeBag ) else {return}
        
        
        output.calorieLabel.subscribe(onNext: { text in
            self.calorieLabel.text = text
            
        }).disposed(by: disposeBag)
        
        output.nameLabel.subscribe(onNext: { text in
            self.nameLabel.text = text
            
        }).disposed(by: disposeBag)
        
        let a = output.carbohydratesLabel
        let b = output.proteinLabel
        let c = output.provinceLabel
        Observable.zip( a, b, c ).subscribe( onNext: {
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
    
    let bottomView: UIView = {
        let view = UIView()
        return view
    }()
    
    let calorieLabel: UILabel = {
        let label = UILabel()
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
    lazy var informCircleArr = [ informCircle1, informCircle2, informCircle3  ]
    lazy var informLabelArr = [informLabel1, informLabel2, informLabel3]
    lazy var informDataArr = [goalLabel, eatLabel, consumeLabel]
    
    lazy var labelStackView: UIStackView = {
        let stackView  = UIStackView(arrangedSubviews: informLabelArr)
        
        
        
        
        
        
        stackView.alignment = .center
        stackView.spacing = 20
        stackView.distribution = .fillEqually
        
        return stackView
    }()
    lazy var informationView = UIView()
    
    
    func setStackView() {
        
        
        
        textFieldView.addSubview(selectTextField)
        textFieldView.addSubview(minusButton)
        textFieldView.addSubview(plusButton)
        
        
        self.selectTextField.snp.makeConstraints {
            $0.top.bottom.centerX.equalTo(textFieldView)
            $0.width.equalTo(80)
        }
        self.minusButton.snp.makeConstraints {
            $0.leading.equalTo(textFieldView).inset(15)
            $0.width.equalTo(50)
            $0.height.equalTo(textFieldView)
        }
        self.plusButton.snp.makeConstraints {
            $0.trailing.equalTo(textFieldView).inset(15)
            $0.width.equalTo(50)
            $0.height.equalTo(textFieldView)
        }
        
        
        
        
        
        
        
        
        
    }
    //    let testColor: [UIColor] = [   UIColor(red: 0.686, green: 0.776, blue: 1, alpha: 1),  UIColor(red: 0.487, green: 1, blue: 0.448, alpha: 1), UIColor(red: 1, green: 0.886, blue: 0.8, alpha: 1) ]
    func addInformView() {
        let text = ["탄수화물", "단백질", "지방"]
        
        let circleColor: [UIColor] = [ UIColor(red: 0.686, green: 0.776, blue: 0.627, alpha: 1), UIColor(red: 0.487, green: 0.555, blue: 0.448, alpha: 1), UIColor(red: 0.835, green: 0.886, blue: 0.8, alpha: 1) ]
        
        
        
        
        
        self.informationView.addSubview(nameLabel)
        self.informationView.addSubview(informCircleArr[0])
        self.informationView.addSubview(informCircleArr[2])
        self.informationView.addSubview(informCircleArr[1])
        
        self.informationView.addSubview(labelStackView)
        
        self.informationView.addSubview(calorieLabel)
        
        
        
        
        for i in 0..<3 {
            
            self.informCircleArr[i].addSubview(informDataArr[i])
            
            
            informCircleArr[i].layer.cornerRadius = 60
            informCircleArr[i].backgroundColor = circleColor[i]
            
            
            informLabelArr[i].text = text[i]
            informLabelArr[i].textColor = .white
            informLabelArr[i].font = .boldSystemFont(ofSize: 14)
            informLabelArr[i].textAlignment = .center
            
            
            informDataArr[i].font = .boldSystemFont(ofSize: 18)
            informDataArr[i].textColor = .white
            informDataArr[i].textAlignment = .center
            informDataArr[i].text = "1200g"
            
            informCircleArr[i].snp.makeConstraints {
                $0.centerX.equalTo(informLabelArr[i])
                $0.centerY.equalTo(informLabelArr[i]).offset(10)
                $0.width.equalTo(120)
                $0.height.equalTo(120)
            }
            informDataArr[i].snp.makeConstraints {
                $0.centerX.equalTo(informLabelArr[i])
                $0.centerY.equalTo(informLabelArr[i]).offset(20)
            }
            
            nameLabel.snp.makeConstraints {
                $0.leading.equalTo(informCircle1)
                $0.top.equalTo(informationView).inset(10)
            }
            labelStackView.snp.makeConstraints {
                $0.leading.trailing.equalTo(informationView).inset(40)
                $0.height.equalTo(20)
                $0.centerY.equalTo(informationView)
            }
            calorieLabel.snp.makeConstraints {
                $0.leading.equalTo(informCircle1)
                $0.top.equalTo(informCircle1.snp.bottom).offset(20)
            }
            
            
            
            
        }
        
        
    }
    
    func setUI() {
        
        
        leftButton.addTarget(self, action: #selector(buttonsAction( _:)), for: .touchUpInside)
        rightButton.addTarget(self, action: #selector(buttonsAction( _:)), for: .touchUpInside)
        
        
        self.view.addSubview(bottomView)
        self.view.addSubview(contentScrollView)
        
        self.contentScrollView.addSubview(self.contentView)
        
        
        self.contentView.addSubview(informationView)
        self.contentView.addSubview(selectStackView)
        self.bottomView.addSubview(addButton)
        
        
        
        
        
        
        
        self.bottomView.snp.makeConstraints {
            $0.leading.trailing.bottom.equalTo(self.view)
            $0.height.equalTo(100)
        }
        self.addButton.snp.makeConstraints {
            $0.leading.trailing.equalTo(bottomView).inset(20)
            $0.centerY.equalTo(bottomView).offset(-10)
            $0.height.equalTo(60)
        }
        self.informationView.snp.makeConstraints {
            $0.top.leading.trailing.equalTo(contentView)
            $0.height.equalTo(300)
        }
        self.selectStackView.snp.makeConstraints {
            $0.leading.trailing.equalTo(contentView).inset(16)
            $0.top.equalTo(informationView.snp.bottom).offset(20)
            $0.bottom.equalTo(contentView)
            $0.height.equalTo(150)
        }
        
        self.contentScrollView.snp.makeConstraints {
            $0.top.leading.trailing.equalTo(self.view.safeAreaLayoutGuide)
            $0.bottom.equalTo(self.bottomView.snp.top)
        }
        self.contentView.snp.makeConstraints {
            $0.top.leading.trailing.bottom.width.equalTo(contentScrollView)
        }
        
    }
    
}

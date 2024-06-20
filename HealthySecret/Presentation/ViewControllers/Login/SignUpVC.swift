//
//  ChangeSignUpVC.swift
//  HealthySecret
//
//  Created by 양승완 on 2023/11/20.
//

import UIKit
import RxSwift
import SnapKit

class SignUpVC: UIViewController {
    
    
    let viewModel: SignUpVM?
    let disposeBag = DisposeBag()
    
    init(viewModel: SignUpVM) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    
    private let contentScrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsVerticalScrollIndicator = false
        
        return scrollView
    }()
    
    let contentView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 0.949, green: 0.918, blue: 0.886, alpha: 1)
        return view
    }()
    
    
    var index = 0
    
    
    
    var firstView: UIView = {
        let view = UIView()
        view.layer.borderColor = UIColor.black.cgColor
        
        return view
    }()
    var secondView: UIView = {
        let view = UIView()
        view.layer.borderColor = UIColor.black.cgColor
        
        return view
    }()
    var thirdView: UIView = {
        let view = UIView()
        view.layer.borderColor = UIColor.black.cgColor
        
        return view
    }()
    
    
    
    lazy var questionStackView: UIStackView = {
        let stackview = UIStackView(arrangedSubviews:  [firstView, secondView, thirdView ])
        
        stackview.axis = .vertical
        stackview.spacing = 15
        stackview.distribution = .fillEqually
        stackview.layer.borderColor = UIColor.black.cgColor
        
        
        return stackview
        
    }()
    
    
    
    let nextButton: UIButton = {
        let button = UIButton()
        
        button.setTitle("완료", for: .normal)
        button.tintColor = .white
        button.layer.cornerRadius = 30
        button.backgroundColor =  .black
        
        return button
    }()
    
    
    var ageTextField = UITextField()
    var tallTextField = UITextField()
    var startWeightTextField = UITextField()
    var goalWeightTextField = UITextField()
    
    
    var subTextFields: [UITextField] = []
    
    
    
    func setBindings() {
        let input = SignUpVM.Input( sexInput: sexInput, exerciseInput: exerciseInput, ageInput: ageTextField.rx.text.orEmpty.asObservable(), tallInput: tallTextField.rx.text.orEmpty.asObservable(), startWeight: startWeightTextField.rx.text.orEmpty.asObservable(), goalWeight: goalWeightTextField.rx.text.orEmpty.asObservable(), nextButtonTapped: self.nextButton.rx.tap.asObservable() )
        
        guard let output = viewModel?.transform(input: input, disposeBag: disposeBag) else {return}
        
        output.nextButtonEnable.subscribe(onNext: { event in
            self.nextButton.isEnabled = event
            if event {
                
                self.nextButton.backgroundColor = .black
                
            } else {
                self.nextButton.backgroundColor = .lightGray
                
            }
            
            
        }).disposed(by: disposeBag)
        
    }
    
    
    let sexButtons = [ UIButton(), UIButton() ]
    
    
    
    
    
    let thirdViewButtons = [ UIButton(), UIButton(), UIButton() ]
    let thirdViewButtonImages = [UIImage(named: "활동적음.png"), UIImage(named: "일반적.png"), UIImage(named: "활동많음.png")]
    let thirdViewButtonImagesFill = [UIImage(named: "활동적음_fill.png"), UIImage(named: "일반적_fill.png"), UIImage(named: "활동많음_fill.png")]
    
    
    
    let topLabel: UILabel = {
        let label = UILabel()
        label.text = "나만의 다이어트 설정"
        label.font = .boldSystemFont(ofSize: 25)
        return label
        
    }()
    
    
    let firstLabel: UILabel = {
        let label = UILabel()
        label.text = "성별"
        label.font = UIFont.boldSystemFont(ofSize: 18)
        return label
    }()
    
    
    let subStackViews = [UIStackView(), UIStackView(), UIStackView(), UIStackView() ]
    
    
    var sexInput = BehaviorSubject<Int>(value: 2)
    var exerciseInput = BehaviorSubject<Int>(value: 4)
    
    
    
    
    
    
    let bottomView = UIView()
    
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        self.view.backgroundColor = UIColor(red: 0.949, green: 0.918, blue: 0.886, alpha: 1)
        
        
        
    }
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        
        addSubView()
        setInformationStack()
        setBindings()
        
    }
    
    
    
    
    
    
    func setInformationStack() {
        
        subTextFields = [ageTextField, tallTextField, startWeightTextField, goalWeightTextField ]
        
        sexButtons[0].setImage(UIImage(named: "menButton.png"), for: .normal)
        sexButtons[1].setImage(UIImage(named: "womenButton.png"), for: .normal)
        
        _ = sexButtons.map({ btn in
            
            self.firstView.addSubview(btn)
            btn.backgroundColor = .lightGray.withAlphaComponent(0.6)
            btn.layer.cornerCurve = .circular
            btn.layer.cornerRadius = 60
            btn.tag = index
            btn.addTarget(self, action: #selector(sexButtonAction(_:)), for: .touchUpInside )
            
            index += 1
            
            
            btn.snp.makeConstraints {
                $0.centerY.equalTo(firstView).offset(50)
                $0.width.height.equalTo(120)
            }
            
        })
        index = 0
        
        
        
        _ = subStackViews.map({ (value: UIStackView)  in
            value.axis = .horizontal
            value.distribution = .fillEqually
            
            
        })
        
        
        
        
        
        
        
        let subLabels = [UILabel(), UILabel(), UILabel(), UILabel() ]
        
        let texts = ["나이", "키", "시작 체중", "목표 체중"]
        
        
        
        let rightTexts = ["세", "cm", "kg", "kg"]
        
        
        _ = subTextFields.map { textField in
            
            
            
            
            let rightView = UIView(frame: CGRect(x: 0, y: 0, width: 35, height: 50))
            let leftView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: 50))
            
            let rightLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 28, height: 50))
            rightLabel.text = rightTexts[index]
            rightLabel.font = .boldSystemFont(ofSize: 18)
            
            
            
            rightView.addSubview(rightLabel)
            
            if index < 2 {
                textField.placeholder = "0"
            } else {
                textField.placeholder = "0.0"
            }
            
            index += 1
            
            textField.backgroundColor = .lightGray.withAlphaComponent(0.6)
            textField.layer.cornerRadius = 10
            textField.rightViewMode = .always
            textField.leftViewMode = .always
            textField.rightView = rightView
            textField.leftView = leftView
            textField.keyboardType = .numberPad
            textField.delegate = self
            
        }
        index = 0
        
        
        
        
        subLabels.forEach { label in
            
            subStackViews[index].spacing = 10
            
            
            label.text = texts[index]
            label.font = UIFont.boldSystemFont(ofSize: 18)
            
            
            let textField = subTextFields[index]
            
            if index < 2 {
                subStackViews[0].addArrangedSubview(label)
                subStackViews[1].addArrangedSubview(textField)
            } else {
                subStackViews[2].addArrangedSubview(label)
                subStackViews[3].addArrangedSubview(textField)
            }
            index += 1
        }
        
        
        
        
        let informationStackView: UIStackView = {
            let stackView = UIStackView(arrangedSubviews: subStackViews)
            stackView.axis = .vertical
            stackView.distribution = .fillEqually
            
            
            
            
            return stackView
        }()
        
        
        
        let thirdLabel: UILabel = {
            let label = UILabel()
            label.text = "평소 활동량"
            label.font = .boldSystemFont(ofSize: 18)
            
            return label
        }()
        
        
        
        
        
        let thirdStackView: UIStackView = {
            let stackview = UIStackView()
            stackview.axis = .horizontal
            stackview.alignment = .center
            stackview.distribution = .equalCentering
            
            return stackview
        }()
        
        
        
        
        
        
        
        
        
        index = 0
        
        _ = thirdViewButtons.map({ button in
            button.setImage(thirdViewButtonImages[index], for: .normal)
            button.tag = index
            button.addTarget(self, action: #selector(exerciseButtonAction), for: .touchUpInside)
            
            
            if index == 2 {
                button.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: -3)
            }
            
            button.snp.makeConstraints {
                $0.width.height.equalTo(50)
            }
            
            thirdStackView.addArrangedSubview(button)
            
            index += 1
            
        })
        
        
        
        
        
        
        
        
        
        
        
        
        self.firstView.addSubview(topLabel)
        self.firstView.addSubview(firstLabel)
        self.secondView.addSubview(informationStackView)
        self.thirdView.addSubview(thirdLabel)
        self.thirdView.addSubview(thirdStackView)
        
        
        index = 0
        let thirdLabels = [UILabel(), UILabel(), UILabel() ]
        let thirdLabelTexts = ["활동 적음", "일반적", "활동 많음" ]
        _ = thirdLabels.map({ label in
            thirdView.addSubview(label)
            label.text = thirdLabelTexts[index]
            label.font = .boldSystemFont(ofSize: 15)
            label.textColor = .lightGray.withAlphaComponent(0.6)
            
            
            label.snp.makeConstraints {
                $0.centerX.equalTo(thirdViewButtons[index])
                $0.top.equalTo(thirdViewButtons[index].snp.bottom).offset(1)
            }
            
            
            index += 1
            
            
        })
        
        
        
        
        
        
        topLabel.snp.makeConstraints {
            $0.top.equalTo(firstView).inset(10)
            $0.leading.trailing.equalTo(firstView)
        }
        firstLabel.snp.makeConstraints {
            $0.top.equalTo(firstView).inset(70)
            $0.leading.equalTo(firstView)
        }
        sexButtons[0].snp.makeConstraints {
            $0.centerX.equalTo(firstView).offset(-80)
        }
        sexButtons[1].snp.makeConstraints {
            $0.centerX.equalTo(firstView).offset(80)
        }
        informationStackView.snp.makeConstraints {
            $0.top.bottom.leading.trailing.equalTo(secondView)
        }
        thirdLabel.snp.makeConstraints {
            $0.top.equalTo(thirdView).inset(50)
            $0.leading.equalTo(thirdView)
        }
        thirdStackView.snp.makeConstraints {
            $0.leading.trailing.equalTo(thirdView).inset(50)
            $0.centerY.equalTo(thirdView).offset(20)
            
        }
        
        
        
    }
    
    @objc
    func exerciseButtonAction(_ sender: UIButton ) {
        
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
        print(sender.tag)
        self.exerciseInput.onNext(sender.tag)
        
    }
    
    @objc
    func sexButtonAction(_ sender: UIButton ) {
        
        
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
        print(sender.tag)
        self.sexInput.onNext(sender.tag)
        
        
    }
    
    
    
    
    func addSubView() {
        
        self.view.addSubview(contentScrollView)
        self.view.addSubview(bottomView)
        bottomView.addSubview(nextButton)
        self.contentScrollView.addSubview(contentView)
        
        self.contentView.addSubview(questionStackView)
        
        
        self.bottomView.snp.makeConstraints {
            $0.leading.trailing.bottom.equalTo(self.view)
            $0.height.equalTo(100)
        }
        self.contentScrollView.snp.makeConstraints {
            $0.top.leading.trailing.equalTo(self.view.safeAreaLayoutGuide)
            $0.bottom.equalTo(self.bottomView.snp.top)
        }
        self.contentView.snp.makeConstraints {
            $0.top.leading.trailing.bottom.width.equalTo(self.contentScrollView)
        }
        self.nextButton.snp.makeConstraints {
            $0.leading.trailing.equalTo(self.bottomView).inset(20)
            $0.height.equalTo(60)
            $0.centerY.equalTo(bottomView).offset(-10)
        }
        self.questionStackView.snp.makeConstraints {
            $0.edges.equalTo(contentView).inset(UIEdgeInsets(top: 20, left: 15, bottom: 0, right: 15))
            $0.height.equalTo(680)
        }
        
    }
    
}


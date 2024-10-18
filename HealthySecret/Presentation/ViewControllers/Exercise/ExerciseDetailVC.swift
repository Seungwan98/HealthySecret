//
//  ExerciseDetailVC.swift
//  HealthySecret
//
//  Created by 양승완 on 2023/11/20.
//

import UIKit
import RxSwift
import SnapKit

class ExerciseDetailVC: UIViewController {
    
    let viewModel: ExerciseDetailVM?
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
        scrollView.backgroundColor = .clear
        scrollView.showsVerticalScrollIndicator = false
        scrollView.delaysContentTouches = false
        
        return scrollView
    }()
    
    private let contentView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()
    
    let exTimeTextField = UITextField()
    let exMemoTextField = UITextField()
    lazy var textFieldArr = [exTimeTextField, exMemoTextField]
    lazy var textFieldStackView: UIStackView = {
        let view =  UIStackView(arrangedSubviews: textFieldArr)
        view.axis = .vertical
        view.spacing = 20
        view.distribution = .fillEqually
        return view
        
        
    }()
    
    
    
    private let topView: UIView = {
        let view =  UIView()
        
        view.backgroundColor = .systemBlue.withAlphaComponent(0.5)
        
        return view
        
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = .boldSystemFont(ofSize: 30)
        label.textColor = .white
        return label
        
        
    }()
    
    private let calorieLabel: UILabel = {
        let label = UILabel()
        label.text = "예상 칼로리는 0Kcal 입니다."
        
        return label
        
    }()
    
    private let imageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "운동하는유미.png"))
        
        return imageView
        
    }()
    
    var rightLabelArr = [ UILabel(frame: CGRect(x: 0, y: 0, width: 100, height: 50)), UILabel(frame: CGRect(x: 0, y: 0, width: 100, height: 50)) ]
    var leftLabelArr = [ UILabel(frame: CGRect(x: 30, y: 0, width: 80, height: 18)), UILabel(frame: CGRect(x: 30, y: 0, width: 80, height: 18)) ]
    
    let bottomView = UIView()
    
    private let addButton: UIButton = {
        let button = UIButton()
        
        
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
    
    
    func setBinds() {
        
        let input = ExerciseDetailVM.Input(viewWillApearEvent: self.rx.methodInvoked(#selector(viewWillAppear(_:))).map({ _ in }).asObservable(), addBtnTapped: addButton.rx.tap.asObservable(), minuteTextField: exTimeTextField.rx.text.orEmpty.asObservable(), memoTextField: exMemoTextField.rx.text.orEmpty.asObservable()  )
        
        guard let output = viewModel?.transform(input: input, disposeBag: disposeBag) else {return}
        
        output.nameLabel.subscribe(onNext: { text in
            self.nameLabel.text = text
            
        }).disposed(by: disposeBag)
        
        output.guessLabel.subscribe(onNext: { text in
            self.calorieLabel.text = "예상 칼로리는 \(text)Kcal 입니다."
            
            
            
        }).disposed(by: disposeBag)
        
        output.buttonEnable.subscribe(onNext: { val in
            
            if val {
                self.addButton.backgroundColor = .lightGray.withAlphaComponent(0.2)
                self.addButton.isEnabled = !val
                self.rightLabelArr[0].textColor = .lightGray
            } else {
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
        let leftArr =  ["운동시간", "상세기록"]
        let rightArr = ["분", ""]
        let placeholderArr = ["0", "ex) 횟수, 거리"]
        var index = 0
        _ = textFieldArr.map { (textField: UITextField) in
            
            if index == 0 {
                textField.keyboardType = .numberPad
                
            }
            
            textField.tintColor = .black
            textField.textAlignment = .right
            textField.placeholder = placeholderArr[index]
            
            
            
            let rightView = UIView(frame: CGRect(x: -30, y: 0, width: 50 - ( index * 15 ), height: 50))
            let leftView = UIView(frame: CGRect(x: 30, y: 0, width: 100, height: 18))
            
            
            
            
            self.rightLabelArr[index].font = .boldSystemFont(ofSize: 18)
            self.rightLabelArr[index].text = rightArr[index]
            
            self.leftLabelArr[index].text = leftArr[index]
            self.leftLabelArr[index].font = .boldSystemFont(ofSize: 18)
            
            
            rightView.addSubview(rightLabelArr[index])
            leftView.addSubview(leftLabelArr[index])
            
            
            
            textField.backgroundColor = .lightGray.withAlphaComponent(0.6)
            textField.layer.cornerRadius = 20
            textField.rightViewMode = .always
            textField.leftViewMode = .always
            textField.rightView = rightView
            textField.leftView = leftView
            
            index += 1
            
        }
        
        
        
    }
    
    func addSubView() {
        
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
        
        self.bottomView.snp.makeConstraints {
            $0.leading.trailing.bottom.equalTo(self.view)
            $0.height.equalTo(100)
        }
        self.addButton.snp.makeConstraints {
            $0.leading.trailing.equalTo(bottomView).inset(20)
            $0.height.equalTo(60)
            $0.centerY.equalTo(bottomView).offset(-10)
        }
        self.contentScrollView.snp.makeConstraints {
            $0.top.leading.trailing.equalTo(self.view.safeAreaLayoutGuide)
            $0.bottom.equalTo(self.bottomView.snp.top)
        }
        self.contentView.snp.makeConstraints {
            $0.top.leading.trailing.bottom.width.equalTo(contentScrollView)
        }
        self.topView.snp.makeConstraints {
            $0.top.leading.trailing.equalTo(contentView)
            $0.height.equalTo(300)
        }
        self.calorieLabel.snp.makeConstraints {
            $0.centerY.equalTo(textFieldStackView).offset(120)
            $0.centerX.equalTo(textFieldStackView)
        }
        self.imageView.snp.makeConstraints {
            $0.centerX.equalTo(topView)
            $0.bottom.equalTo(topView).inset(5)
            $0.width.height.equalTo(120)
        }
        self.nameLabel.snp.makeConstraints {
            $0.centerX.equalTo(topView)
            $0.centerY.equalTo(topView).offset(-35)
            $0.width.equalTo(topView).offset(-40)
        }
        self.textFieldStackView.snp.makeConstraints {
            $0.leading.trailing.equalTo(contentView).inset(16)
            $0.top.equalTo(topView.snp.bottom).offset(40)
            $0.bottom.equalTo(contentView)
            $0.height.equalTo(150)
        }
        
    }
}

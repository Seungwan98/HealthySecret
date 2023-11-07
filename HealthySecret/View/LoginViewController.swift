

import UIKit

protocol LoginViewControllerDelegate {
    func login()
}

class LoginViewController : UIViewController {
    
    weak var loginCoordinator : LoginCoordinator?
    var delegate: LoginViewControllerDelegate?
  
    
    
    
    lazy var stackView : UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [emailView  , passwordView , loginButton])
        stackView.spacing = 8
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        return stackView
        
    }()
    
   
    
    let mainLoginImage : UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "testImage")
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
        
    }()
    
    
    lazy var emailView : UIView = {
        let view = UIView()
        
        
        
        view.translatesAutoresizingMaskIntoConstraints = false
        view.frame.size.height = 48
        view.backgroundColor = .gray
        view.layer.cornerRadius = 5
        view.clipsToBounds = true
        view.addSubview(emailField)
        view.addSubview(emailInfoLabel)
        
        return view
    }()
    
    lazy var passwordView : UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.frame.size.height = 48
        
        view.backgroundColor = .gray
        view.layer.cornerRadius = 5
        view.clipsToBounds = true
        
        view.addSubview(passwordField)
        view.addSubview(passwordInfoLabel)
        return view
    }()
    
    
    
    
    
    
    let emailInfoLabel : UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.text = "email"
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    let passwordInfoLabel : UILabel = {
        
        let label = UILabel()
        label.textColor = .white
        label.text = "password"
        
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    
    var emailField : UITextField = {
        
        let textField = UITextField()
        textField.frame.size.height = 48
        textField.backgroundColor = .clear
        textField.textColor = .white
        textField.tintColor = .white
        textField.autocapitalizationType = .none  // 자동으로 입력값의 첫 번째 문자를 대문자로 변경
        textField.autocorrectionType = .no        // 틀린 글자가 있는 경우 자동으로 교정 (해당 기능은 off)
        textField.spellCheckingType = .no
        textField.keyboardType =
            .emailAddress
        
        textField.translatesAutoresizingMaskIntoConstraints = false
        
        return textField
        
    }()
    
    
    var passwordField : UITextField = {
        var textField = UITextField()
        textField.frame.size.height = 48  // 높이 설정
        textField.backgroundColor = .clear  // 투명색
        textField.textColor = .white
        textField.tintColor = .white  // passWordText를 눌렀을 때 흰색으로 살짝 변함
        textField.autocapitalizationType = .none  // 자동으로 입력값의 첫 번째 문자를 대문자로 변경
        textField.autocorrectionType = .no  // 틀린 글자가 있는 경우 자동으로 교정 (해당 기능은 off)
        textField.spellCheckingType = .no   // 스펠링 체크 기능 (해당 기능은 off)
        textField.isSecureTextEntry = true  // 비밀번호를 가리는 기능 (비밀번호 입력시 "ㆍㆍㆍ"으로 표시)
        textField.clearsOnBeginEditing = true  // 텍스트 필드 터치시 내용 삭제 (해당 기능은 off)
        textField.translatesAutoresizingMaskIntoConstraints = false
        
        return textField
        
   
    }()
    
    let loginButton : UIButton = {
        let button = UIButton()
      
        button.backgroundColor = .gray
        button.setTitle("login", for: .normal)
        button.tintColor = .black
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(.white, for: .normal)

        return button
    }()
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
       
    }
    
   
    
    func setUI(){
        let HEIGHT : CGFloat = 48
        view.addSubview(stackView)
        view.addSubview(mainLoginImage)
        loginButton.addTarget(self, action: #selector(nextPage), for: .touchUpInside )

        
        
        NSLayoutConstraint.activate([
            
//            loginButton.heightAnchor.constraint(equalToConstant: HEIGHT),
            
            
            
            mainLoginImage.heightAnchor.constraint(equalToConstant: 100),
            mainLoginImage.widthAnchor.constraint(equalToConstant: 100),
            mainLoginImage.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            mainLoginImage.bottomAnchor.constraint(equalTo:  stackView.topAnchor , constant: -30),
            
            emailInfoLabel.leadingAnchor.constraint(equalTo: emailView.leadingAnchor , constant: 8),
            emailInfoLabel.trailingAnchor.constraint(equalTo: emailView.trailingAnchor , constant:  8),
            emailInfoLabel.centerYAnchor.constraint(equalTo: emailView.centerYAnchor),
            
            emailField.leadingAnchor.constraint(equalTo: emailView.leadingAnchor , constant: 8),
            emailField.trailingAnchor.constraint(equalTo: emailView.trailingAnchor , constant:  8),
            emailField.bottomAnchor.constraint(equalTo: emailView.bottomAnchor),
            emailField.topAnchor.constraint(equalTo: emailView.topAnchor),
            
            passwordField.leadingAnchor.constraint(equalTo: passwordView.leadingAnchor  , constant: 8),
            passwordField.trailingAnchor.constraint(equalTo: passwordView.trailingAnchor , constant: 8),
            passwordField.topAnchor.constraint(equalTo: passwordView.topAnchor),
            passwordField.bottomAnchor.constraint(equalTo: passwordView.bottomAnchor),
            
            passwordInfoLabel.leadingAnchor.constraint(equalTo: passwordView.leadingAnchor , constant: 8),
            passwordInfoLabel.trailingAnchor.constraint(equalTo: passwordView.trailingAnchor , constant: 8),
            passwordInfoLabel.centerYAnchor.constraint(equalTo: passwordView.centerYAnchor),
            
            
            loginButton.trailingAnchor.constraint(equalTo: stackView.trailingAnchor , constant: -40),
            loginButton.leadingAnchor.constraint(equalTo: stackView.leadingAnchor , constant:  40),
            
            
            
            stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant:  30),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant:  -30),
            stackView.heightAnchor.constraint(equalToConstant: HEIGHT * 3 + 36)
            
            
            
            
            
            
            
        ])
        
        
    }
    
    @objc
    func nextPage() {
        self.delegate?.login()
    }
    
     
    
    
    
}

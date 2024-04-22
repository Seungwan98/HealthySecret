

import UIKit
import RxSwift
import RxCocoa
import KakaoSDKAuth
import KakaoSDKUser
import FirebaseAuth

class LoginViewController : UIViewController {
    
    
    
    fileprivate var currentNonce: String?
    
    lazy var emailInfoLabelY = emailInfoLabel.centerYAnchor.constraint(equalTo: emailField.centerYAnchor)
    lazy var passwordInfoLabelY = passwordInfoLabel.centerYAnchor.constraint(equalTo: passwordField.centerYAnchor)
    
    
    var appleLogin = PublishSubject<OAuthCredential>()
    
    
    /// 버튼
    ///
    ///
    
    var kakaoButton : UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: "kakao_login.png"), for: .normal)
        button.layer.cornerRadius = 5
        return button
    }()
    
    var appleButton : UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: "apple_login.png"), for: .normal)
        button.layer.cornerRadius = 5
        return button
    }()
    
    let loginButton : UIButton = {
        let button = UIButton()
        
        button.backgroundColor = UIColor(red: 0.686, green: 0.776, blue: 0.627, alpha: 1)
        
        button.setTitle("로그인", for: .normal)
        button.tintColor = .black
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 5
        return button
    }()
    
    var signUpButton : UIButton = {
        let button = UIButton()
        button.tintColor = .black
        button.backgroundColor = .white
        button.setTitle("회원가입" , for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor( UIColor(red: 0.686, green: 0.776, blue: 0.627, alpha: 1), for: .normal )
        button.layer.cornerRadius = 5
        return button
    }()
    
    
    
    
    
    
    
    /// 스택뷰
    ///
    ///
    lazy var stackView : UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [emailView  , passwordView  ])
        
        stackView.spacing = 15
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        return stackView
        
    }()
    lazy var loginStackView : UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [ loginButton , kakaoButton ,appleButton ])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 15
        stackView.distribution = .fillEqually
        stackView.alignment = .fill
        
        
        
        
        return stackView
        
        
    }()
    
    
    
    
    
    ///이미지
    ///
    ///
    let mainLoginImage : UIImageView = {
        let image = UIImageView()
        image.layer.borderColor = UIColor.black.cgColor
        image.layer.borderWidth = 1
        
        
        image.image = UIImage(named: "testImage")
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
        
    }()
    
    
    
    
    
    
    
    
    /// 필드 뷰
    ///
    ///
    lazy var emailView : UIView = {
        let view = UIView()
        
        
        
        view.translatesAutoresizingMaskIntoConstraints = false
        view.frame.size.height = 48
        view.backgroundColor = .lightGray
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
        
        view.backgroundColor = .lightGray
        view.layer.cornerRadius = 5
        view.clipsToBounds = true
        
        view.addSubview(passwordField)
        view.addSubview(passwordInfoLabel)
        return view
    }()
    
    
    
    
    
    ///라벨
    ///
    ///
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
    
    
    
    
    
    /// 텍스트 필드
    ///
    ///
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
    
    
    private var viewModel: LoginVM?
    let disposeBag = DisposeBag()
    weak var loginCoordinator : LoginCoordinator?
    
    
    init(viewModel : LoginVM){
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("loginViewCOntroller")
        
        emailField.delegate = self
        passwordField.delegate = self
        self.setUI()
        self.setBindings()
        appleButton.addTarget(self, action: #selector(AppleLoginTapped), for: .touchUpInside)
        
        
        
    }
    
    @objc
    func AppleLoginTapped(){
        
        self.startSignInWithAppleFlow()
    }
    
    
    func setUI(){
        let HEIGHT : CGFloat = 40
        view.addSubview(stackView)
        view.addSubview(mainLoginImage)
        view.addSubview(loginStackView)
        view.addSubview(signUpButton)
        
        
        
        
        
        
        NSLayoutConstraint.activate([
            
            
            
            
            
            mainLoginImage.heightAnchor.constraint(equalToConstant: 100),
            mainLoginImage.widthAnchor.constraint(equalToConstant: 100),
            mainLoginImage.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            mainLoginImage.bottomAnchor.constraint(equalTo:  stackView.topAnchor , constant: -30),
            
            emailInfoLabel.leadingAnchor.constraint(equalTo: emailView.leadingAnchor , constant: 8),
            emailInfoLabel.trailingAnchor.constraint(equalTo: emailView.trailingAnchor , constant:  8),
            
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
            
            
            
            
            stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor , constant: -100),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant:  30),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant:  -30),
            stackView.heightAnchor.constraint(equalToConstant: HEIGHT * 2 + 15 ),
            
            
            emailView.leadingAnchor.constraint(equalTo: stackView.leadingAnchor ),
            emailView.trailingAnchor.constraint(equalTo: stackView.trailingAnchor ),
            passwordView.leadingAnchor.constraint(equalTo: stackView.leadingAnchor ),
            passwordView.trailingAnchor.constraint(equalTo: stackView.trailingAnchor ),
            
            loginStackView.heightAnchor.constraint(equalToConstant: HEIGHT * 3 + 70),
            loginStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loginStackView.topAnchor.constraint(equalTo: stackView.bottomAnchor , constant: 40),
            loginStackView.leadingAnchor.constraint(equalTo: stackView.leadingAnchor),
            loginStackView.trailingAnchor.constraint(equalTo: stackView.trailingAnchor),
            
            signUpButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            signUpButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -50),
            
            emailInfoLabelY,
            passwordInfoLabelY
        ])
        
        
        
        
    }
    
    func setBindings(){
        
        
        
        
        let input = LoginVM.Input(emailText: emailField.rx.text.orEmpty.asObservable(),
                                  passwordText: passwordField.rx.text.orEmpty.asObservable(),
                                  loginButtonTapped: loginButton.rx.tap.asObservable(),
                                  signUpButtonTapped: signUpButton.rx.tap.asObservable(), kakaoLoginButtonTapped: kakaoButton.rx.tap.asObservable() , appleLogin : appleLogin.asObservable())
        
        guard let output = self.viewModel?.transform(input: input, disposeBag: self.disposeBag) else {return}
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
}

extension LoginViewController : UITextFieldDelegate {
    
    
    
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        
        
        
        let textField = textField
        
        print("textField controller incoming")
        
        if textField == emailField {
            emailInfoLabel.font = UIFont.systemFont(ofSize: 11)
            
            // 오토레이아웃 업데이트
            emailInfoLabelY.constant = -12
            
        }
        else {
            passwordInfoLabel.font = UIFont.systemFont(ofSize: 11)
            
            // 오토레이아웃 업데이트
            passwordInfoLabelY.constant = -12
            
        }
        UIView.animate(withDuration: 0.3) {
            textField.superview?.layoutIfNeeded()      // Textfield의 슈퍼뷰를 업데이트
            //      self.view.layoutIfNeeded()                           // viewcontroller의 뷰를 업데이트 (상황에 맞게 사용)
        }
        
        return true
    }
    
    
    
}



import CryptoKit
import AuthenticationServices


extension LoginViewController {
    
    func startSignInWithAppleFlow() {
        let nonce = randomNonceString()
        currentNonce = nonce
        
        
        let request = ASAuthorizationAppleIDProvider().createRequest()
        request.requestedScopes = [.fullName, .email ]
        
        let controller = ASAuthorizationController(authorizationRequests: [request])
        controller.delegate = self as? ASAuthorizationControllerDelegate
        controller.presentationContextProvider = self as? ASAuthorizationControllerPresentationContextProviding
        controller.performRequests()
        
        
        
        request.nonce = sha256(nonce)
        
    }
    
    func randomNonceString(length: Int = 32) -> String {
        precondition(length > 0)
        var randomBytes = [UInt8](repeating: 0, count: length)
        let errorCode = SecRandomCopyBytes(kSecRandomDefault, randomBytes.count, &randomBytes)
        if errorCode != errSecSuccess {
            fatalError(
                "Unable to generate nonce. SecRandomCopyBytes failed with OSStatus \(errorCode)"
            )
        }
        let charset: [Character] =
        Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")
        let nonce = randomBytes.map { byte in
            // Pick a random character from the set, wrapping around if needed.
            charset[Int(byte) % charset.count]
        }
        return String(nonce)
    }
    
    func sha256(_ input: String) -> String {
        let inputData = Data(input.utf8)
        let hashedData = SHA256.hash(data: inputData)
        let hashString = hashedData.compactMap {
            String(format: "%02x", $0)
        }.joined()
        
        return hashString
    }
}

extension LoginViewController : ASAuthorizationControllerDelegate {
    
    
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
            guard let nonce = currentNonce else {
                fatalError("Invalid state: A login callback was received, but no login request was sent.")
            }
            guard let appleIDToken = appleIDCredential.identityToken else {
                print("Unable to fetch identity token")
                return
            }
            guard let idTokenString = String(data: appleIDToken, encoding: .utf8) else {
                print("Unable to serialize token string from data: \(appleIDToken.debugDescription)")
                return
            }
            
            
            
            
            let credential = OAuthProvider.credential(withProviderID: "apple.com", idToken: idTokenString , rawNonce: nonce)
            self.appleLogin.onNext(credential)
            
            
          
            
            
            
            
            
            
            
                        }
        }
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        // Handle error.
        print("Sign in with Apple errored: \(error)")
    }
   

extension LoginViewController: ASAuthorizationControllerPresentationContextProviding {
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        // Apple 로그인 인증 창 띄우기
        return self.view.window ?? UIWindow()
    }
}




import UIKit
import RxSwift
import RxCocoa
import KakaoSDKAuth
import KakaoSDKUser
import FirebaseAuth
import SnapKit

class LoginViewController: UIViewController {
    
    
    
    fileprivate var currentNonce: String?
    
    
    
    var appleLogin = PublishSubject<OAuthCredential>()
    
    
    /// 버튼
    ///
    ///
    ///
    
    var kakaoButton: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 254 / 255, green: 229 / 255, blue: 0 / 255, alpha: 1)
        view.layer.cornerRadius = 30
        
        let label = UILabel()
        label.text = "카카오로 로그인"
        label.textAlignment = .center
        label.font = .boldSystemFont(ofSize: 18 )
        
        let image = UIImageView(image: UIImage(named: "kakaoLogin.png"))
        
        view.addSubview(label)
        view.addSubview(image)
        
        
        label.snp.makeConstraints {
            $0.center.equalTo(view)
        }
        image.snp.makeConstraints {
            $0.width.height.equalTo(20)
            $0.leading.equalTo(view).inset(20)
            $0.centerY.equalTo(view)
        }
        
        
        
        
        return view
    }()
    
    var appleButton: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        view.layer.cornerRadius = 30
        
        let label = UILabel()
        label.text = "Apple로 로그인"
        label.textColor = .white
        label.textAlignment = .center
        label.font = .boldSystemFont(ofSize: 18 )
        
        
        let image = UIImageView(image: UIImage(named: "appleLogin.png"))
        
        
        view.addSubview(label)
        view.addSubview(image)
        
        
        label.snp.makeConstraints {
            $0.center.equalTo(view)
        }
        image.snp.makeConstraints {
            $0.width.equalTo(20)
            $0.height.equalTo(22)
            $0.leading.equalTo(view).inset(20)
            $0.centerY.equalTo(view).offset(-2)
        }
        
        return view
    }()
    
    
    
    
    
    
    
    
    lazy var loginStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [ kakaoButton, appleButton ])
        stackView.axis = .vertical
        stackView.spacing = 15
        stackView.distribution = .fillEqually
        stackView.alignment = .fill
        
        
        
        
        
        return stackView
        
        
    }()
    
    
    
    
    
    /// 이미지
    ///
    ///
    let mainLoginImage: UIImageView = {
        let image = UIImageView(image: UIImage(named: "mainImage.jpeg"))
        
        return image
        
    }()
    
    let mainView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemBlue.withAlphaComponent(0.5)
        view.layer.cornerRadius = 8
        
        return view
        
    }()
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    private var viewModel: LoginVM?
    let disposeBag = DisposeBag()
    weak var loginCoordinator: LoginCoordinator?
    
    
    init(viewModel: LoginVM) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        self.setUI()
        self.setBindings()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(AppleLoginTapped))
        appleButton.addGestureRecognizer(tapGesture)
        
        
        
    }
    
    @objc
    func AppleLoginTapped() {
        
        self.startSignInWithAppleFlow()
    }
    
    
    func setUI() {
        let HEIGHT: CGFloat = 60
        
        
        view.addSubview(mainView)
        view.addSubview(mainLoginImage)
        view.addSubview(loginStackView)
        
        
        
        self.mainView.snp.makeConstraints {
            $0.top.bottom.trailing.leading.equalTo(self.view)
        }
        self.mainLoginImage.snp.makeConstraints {
            $0.width.height.equalTo(240)
            $0.center.equalTo(self.view)
        }
        self.loginStackView.snp.makeConstraints {
            $0.height.equalTo( HEIGHT * 2 + 15 )
            $0.leading.trailing.equalTo(self.view).inset(20)
            $0.bottom.equalTo(self.view.safeAreaLayoutGuide).inset(60)
        }
        
        
        
        
        
    }
    
    func setBindings() {
        
        
        
        
        let input = LoginVM.Input( kakaoLoginButtonTapped: kakaoButton.rx.tapGesture().when(.recognized), appleLogin: appleLogin.asObservable())
        
        guard let output = self.viewModel?.transform(input: input, disposeBag: self.disposeBag) else {return}
        
        output.alert.subscribe(onNext: { _ in
            
            AlertHelper.shared.showResult(title: "계정 정지", message: "신고 누적으로 계정이 정지되었습니다", over: self)
            
        }).disposed(by: disposeBag)
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

extension LoginViewController: ASAuthorizationControllerDelegate {
    
    
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
            guard let nonce = currentNonce else {
                fatalError("Invalid state: A login callback was received, but no login request was sent.")
            }
            guard let appleIDToken = appleIDCredential.identityToken else {
                print("Unable to fetch identity token")
                return
            }
            guard let idTokenString = String(data: appleIDToken, encoding: .utf8) else { return }
            
            
            let given = appleIDCredential.fullName?.givenName ?? ""
            let family = appleIDCredential.fullName?.familyName ?? ""
            
            
            UserDefaults.standard.set( "\(family)\(given)", forKey: "name")
            let credential = OAuthProvider.credential(withProviderID: "apple.com", idToken: idTokenString, rawNonce: nonce)
            
       
            
            
            
            
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

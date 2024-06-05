//
//  ChangeProfileVC.swift
//  MovieProject
//
//  Created by 양승완 on 2023/10/04.
//

import UIKit
import RxCocoa
import RxSwift
import RxGesture
import AuthenticationServices
import FirebaseAuth
import SnapKit

class SettingVC : UIViewController {
    
    let disposeBag = DisposeBag()
    
    fileprivate var currentNonce: String?

    private var viewModel : MyProfileVM?
    
    var codeString = PublishSubject<String>()
    var userId = PublishSubject<String>()
    var OAuthCredential = PublishSubject<OAuthCredential>()

    
    
    private let contentScrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsVerticalScrollIndicator = false
        return scrollView
    }()
    
    private let contentView = UIView()

    private let logoutButton : UIView = {
        let view = UIView()
        view.frame = CGRect(x: 0, y: 0, width: 0, height: 20)

        return view
    }()
    private let secessionButton : UIView = {
        let view = UIView()
        view.frame = CGRect(x: 0, y: 0, width: 0, height: 80)


        return view
        
    }() 
    
    private let blockListButton : UIView = {
        let view = UIView()
        view.frame = CGRect(x: 0, y: 0, width: 0, height: 80)


        return view
        
    }()


    
    private lazy var stackViewValues : [UIView] = [logoutButton , secessionButton , blockListButton ]
    
    private lazy var informationView : UIStackView = {
        let view = UIStackView(arrangedSubviews: stackViewValues)
        view.axis = .vertical
        view.spacing = 5
        view.distribution = .fillProportionally
        return view
        
    }()

    

    
    init(viewModel : MyProfileVM){
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
   

    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.topItem?.title = "설정"
        self.navigationController?.setNavigationBarHidden(false, animated: false)

        self.navigationController?.navigationBar.backgroundColor = .white

    }
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: false)

    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
        setStackView()
        setBindings()
        
    }
    
    let texts = ["로그아웃" , "회원탈퇴" , "차단목록"]
    var idx = 0
    func setStackView(){
       _ = stackViewValues.map{
           
           let value = $0
           let label = UILabel()
           let image = UIImageView(image : UIImage(named: "arrow.png"))

           
           value.addSubview(label)
           value.addSubview(image)
           
           label.backgroundColor = .white
           label.text = texts[idx]
           idx = idx + 1
           label.textAlignment = .left
           label.font = .boldSystemFont(ofSize: 16)
           
           
           label.snp.makeConstraints{
               $0.centerY.equalTo(value)
               $0.leading.equalTo(value).inset(5)
               
           }
           image.snp.makeConstraints{
               $0.width.height.equalTo(14)
               $0.centerY.equalTo(value)
               $0.trailing.equalTo(value).inset(5)
           }
         
           
         
           
         
           
     
           

           
           
            
        }
    }

    
    func setUI(){
        
        self.view.backgroundColor = .white
        
        self.view.addSubview(contentScrollView)

        self.contentScrollView.addSubview(contentView)
     
       
        
        self.contentView.addSubview(informationView)

            
          
        
        self.contentScrollView.snp.makeConstraints{
            $0.top.leading.trailing.equalTo(self.view.safeAreaLayoutGuide)
            $0.bottom.equalTo(self.view)
        }
        self.contentView.snp.makeConstraints{
            $0.top.bottom.leading.trailing.width.equalTo(contentScrollView)
            $0.height.equalTo(900)
        }
        self.informationView.snp.makeConstraints{
            $0.leading.trailing.equalTo(contentView).inset(20)
            $0.top.equalTo(contentView).inset(10)
            $0.height.equalTo(150)
        }
        
       
      
  
    }
   
    
    
    
    
    func setBindings(){
        
        let values = Observable.zip(self.codeString.asObservable() , self.userId.asObservable() )

        let scessionTapped = PublishSubject<Bool>()
        
        secessionButton.rx.tapGesture().when(.recognized).subscribe({ [weak self] _ in
            guard let self = self else {return}
            
            AlertHelper.shared.showRevoke(title: "회원을 탈퇴 하시겠습니까?", message: "탈퇴한 회원의 정보는 되돌릴 수 없습니다", onConfirm: {
                
                scessionTapped.onNext(true)

                
            } , over: self)
            
        }).disposed(by: disposeBag)
        
        let input = MyProfileVM.SettingInput(viewWillApearEvent: self.rx.methodInvoked(#selector(viewWillAppear(_:))).map({ _ in }).asObservable() , logoutTapped: logoutButton.rx.tapGesture().when(.recognized).asObservable(), secessionTapped: scessionTapped , values : values ,
                                             OAuthCredential: self.OAuthCredential.asObservable() , blockListTapped : blockListButton.rx.tapGesture().when(.recognized).asObservable())

        
        
        
        guard let output = viewModel?.settingTransform(input: input, disposeBag: self.disposeBag) else { return }
        
        output.appleSecession.subscribe(onNext: { event in
          
            
            AlertHelper.shared.showRevoke(title: "재 로그인 하시겠습니까?", message: "회원 탈퇴를 위해 Apple 재 로그인을 진행합니다", onConfirm: {
                
                self.startSignInWithAppleFlow()

                
            } , over: self)

            
        }).disposed(by: disposeBag)
    }
    
 
  
    
   
    




}
import CryptoKit
import AuthenticationServices
import SnapKit
extension SettingVC : ASAuthorizationControllerDelegate {
    
    
    func startSignInWithAppleFlow() {
        
        let nonce = randomNonceString()
        currentNonce = nonce
        
        let request = ASAuthorizationAppleIDProvider().createRequest()
        request.requestedScopes = []
        
        
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
            
            if let authorizationCode = appleIDCredential.authorizationCode, let codeString = String(data: authorizationCode, encoding: .utf8) {
                
                self.codeString.onNext(codeString)
                self.userId.onNext(appleIDCredential.user)
                self.OAuthCredential.onNext(credential)
                
               
                
                
            }else{
                    print("else")
                }
            
            
            
        }
        
        
    }
    
}


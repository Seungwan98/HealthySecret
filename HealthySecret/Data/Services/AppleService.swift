import Foundation
import RxSwift
import AuthenticationServices
import FirebaseAuth

final class AppleService {
    
    private var disposeBag = DisposeBag()
    
    func removeAccount(refreshToken: String?, userId: String?) -> Completable {
        return Completable.create { completable in
            
            
            
            if let token = refreshToken {
                let url = URL(string: "https://us-central1-healthysecrets-f1b20.cloudfunctions.net/revokeToken?refresh_token=\(token)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "https://apple.com")!
                let task = URLSession.shared.dataTask(with: url) {(data, _, _) in
                    guard data != nil else { return }
                    
                    
                    
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                        let appleIDProvider = ASAuthorizationAppleIDProvider()
                        
                        appleIDProvider.getCredentialState(forUserID: userId ?? "") { (credentialState, _) in
                            switch credentialState {
                            case .authorized:
                                print("authorized")
                                self.removeAccount(refreshToken: refreshToken, userId: userId).subscribe({ event in
                                    
                                    switch event {
                                    case .completed:
                                        completable(.completed)
                                    case .error(let err):
                                        print(err)
                                        
                                    }
                                    
                                    
                                }).disposed(by: self.disposeBag)
                                
                                
                            case .revoked:
                                print("revoked")
                                completable(.completed)
                            case .notFound:
                                // The Apple ID credential is either revoked or was not found, so show the sign-in UI.
                                print("notFound")
                                completable(.completed)
                                
                                
                            default:
                                break
                            }
                        }                    }
                    
                    
                }
                task.resume()  }
            
            return Disposables.create()
        }
    }
}

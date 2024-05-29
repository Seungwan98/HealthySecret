//
//  LoginUseCase.swift
//  HealthySecret
//
//  Created by 양승완 on 5/27/24.
//

import Foundation
import RxSwift
import FirebaseAuth


enum LoginStatus {
    case logIn
    case main
    case signUp
}


class LoginUseCase {
  

    
    
    
    private let disposeBag = DisposeBag()
    private let loginRepository : LoginRepository
    private let userRepository : UserRepository
    
    init( loginRepository : LoginRepository , userRepository : UserRepository ){
        self.loginRepository = loginRepository
        self.userRepository = userRepository
        
        
    }
    
  
    func loginKakao() -> Completable {
        return loginRepository.login()
        
    }
    
    func loginApple(credential : OAuthCredential) -> Completable {
        return loginRepository.login(credential: credential)
        
    }
    
    func loginStatus() -> Single<LoginStatus> {
        
        Single.create{ [weak self] single in
            guard let self = self else {return Disposables.create()}
            
            
            self.loginRepository.getCurrentUser().subscribe({ event in
                switch event {
                    
                case .success(let user):
                    var email : String?
                    var uid : String?
                    
                    if user.uid.isEmpty {
                        
                        
                        self.loginRepository.signOut().subscribe({ event in
                            switch(event) {
                            case.completed:
                                
                                single(.success(.logIn)  )
                                
                                
                            case.error(let err):
                                print(err)
                            }
                            
                            
                        }).disposed(by: self.disposeBag)
                        

                    }else{
                        email = user.email
                        uid = user.uid
                        
                    }
                    
                    self.userRepository.getUser().subscribe({ event in
                        
                        switch event {
                        case.success(let user):
                            
                                if( !CustomFormatter.shared.dateCompare(targetString: user.freezeDate ?? "")  ) {
                                    //self.freeze.onNext(true)
                                    single(.success(.logIn))

                                   

                                }else{
                                    
                                    print("getFure")
                                    
                                    UserDefaults.standard.set( email , forKey: "email")
                                    UserDefaults.standard.set( uid , forKey: "uid")
                                    
                                    
                                    UserDefaults.standard.set( user.name  , forKey: "name")
                                    UserDefaults.standard.set( user.loginMethod , forKey: "loginMethod")
                                    UserDefaults.standard.set( user.profileImage  , forKey: "profileImage")
                                    
                                    
                                    single(.success(.main))
                                }
                        case.failure(let err):
                            self.loginRepository.signOut().subscribe({ event in
                                switch(event) {
                                case.completed:
                                    
                                    single(.success(.signUp))

                                    
                                case.error(let err):
                                    single(.failure(err))
                                }
                                
                                
                            }).disposed(by: self.disposeBag)
                        }
                        
                        
                    }).disposed(by: self.disposeBag)
                   
                    
                 
                    
                    
                case .failure(let error):
                    print("fail lets Login \(error)")

                
                }
            }).disposed(by: disposeBag)
            
            
            return Disposables.create()
        }
        
        
        
    }
    
    
    
}

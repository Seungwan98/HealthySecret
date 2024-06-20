//
//  LoginVM.swift
//  HealthySecret
//
//  Created by 양승완 on 2023/11/20.
//

import RxSwift
import RxRelay
import RxCocoa
import Foundation
import FirebaseAuth

class LoginVM: ViewModel {
    
    
    
    
    private let loginUseCase: LoginUseCase
    
    var disposeBag = DisposeBag()
    var loginCoordinator: LoginCoordinator?
    
    
    
    struct Input {
        
        
        let kakaoLoginButtonTapped: Observable<UITapGestureRecognizer>
        let appleLogin: Observable<OAuthCredential>
        
        
    }
    
    struct Output {
        var alert = PublishSubject<Bool>()
        
    }
    
    
    init( loginUseCase: LoginUseCase, loginCoordinator: LoginCoordinator ) {
        
        self.loginUseCase =  loginUseCase
        self.loginCoordinator = loginCoordinator
        
        
        
    }
    
    func transform(input: Input, disposeBag: DisposeBag ) -> Output {
        let output = Output()
        
        
        
        input.appleLogin.subscribe(onNext: { credential in
            
            
            UserDefaults.standard.set("apple", forKey: "loginMethod")
            
            
            self.loginUseCase.loginApple(credential: credential ).subscribe({ completable in
                switch completable {
                    
                case.completed:
                    print("complete")
                    
                    self.loginCoordinator?.login()
                case.error(let err):
                    
                    if err as? CustomError == CustomError.freeze {
                        output.alert.onNext(true)
                        
                    } else {
                        self.loginCoordinator?.pushSignUpVC()
                    }
                    
                }
                
                
                
            }).disposed(by: disposeBag)
            
            
        }).disposed(by: disposeBag)
        
        
        
        
        input.kakaoLoginButtonTapped.subscribe(onNext: { _ in
            UserDefaults.standard.set("kakao", forKey: "loginMethod")
            
            self.loginUseCase.loginKakao().subscribe({ completable in
                
                switch completable {
                case.completed:
                    
                    self.loginCoordinator?.login()
                case.error(let err):
                    
                    if err as? CustomError == CustomError.freeze {
                        output.alert.onNext(true)
                        
                    } else {
                        self.loginCoordinator?.presentModal()
                    }
                    
                }
                
                
                
            }).disposed(by: disposeBag)
            
            
            
            
        }).disposed(by: disposeBag)
        
        
        
        return output
    }
    
    
    
    
    
}

//
//  LoginVM.swift
//  HealthySecret
//
//  Created by 양승완 on 2023/11/20.
//

import UIKit
import RxSwift
import RxRelay
import RxCocoa
import Foundation

class LoginVM : ViewModel {

    
    
    
    var disposeBag = DisposeBag()
    var firebaseService : FirebaseService?
    var loginCoordinator : LoginCoordinator?
    let kakaoService : KakaoService?
  
  
    
    struct Input {
        
        let emailText : Observable<String>?
        let passwordText : Observable<String>?
        let loginButtonTapped : Observable<Void>
        let signUpButtonTapped : Observable<Void>
        let kakaoLoginButtonTapped : Observable<Void>

    }
    
    struct Output {
        
    }

    
    init(firebaseService : FirebaseService  , loginCoordinator : LoginCoordinator , kakaoService : KakaoService ){
        
        self.firebaseService =  firebaseService
        self.loginCoordinator = loginCoordinator
        self.kakaoService = kakaoService
        
        
    }
    
    func transform(input: Input , disposeBag : DisposeBag ) -> Output {
        let output = Output()
        
        input.signUpButtonTapped.subscribe(onNext: {
            _ in
            print("signUp")
            self.loginCoordinator?.pushSignUpVC()
            
        }).disposed(by: disposeBag)
            
        input.loginButtonTapped.subscribe(onNext: {
            
            Observable.zip( input.emailText! , input.passwordText! ).subscribe(onNext: {
                
                
                self.firebaseService?.signIn(email: $0 , pw: $1 ).subscribe(
                 onCompleted: {
                 self.loginCoordinator?.login()


                },
                 onError: { error in


                 }).disposed(by: disposeBag)
 
            }).disposed(by: disposeBag)
 
        }).disposed(by: disposeBag)
        
        input.kakaoLoginButtonTapped.subscribe(onNext : {
            _ in
            print("touch")
            self.kakaoService?.kakaoLogin().subscribe({
                event in
                switch event{
                case .success( let inform ):
                    print("\(inform) 인폼")
                
                        self.firebaseService?.signIn(email:inform["email"] ?? "" ,
                                                     pw:inform["pw"] ?? "" ).subscribe({event in
                            switch event{
                            case .completed:
                                self.loginCoordinator?.login()
                                
                            case .error(_):
                                UserDefaults.standard.set(inform["email"], forKey: "email")
                                UserDefaults.standard.set(inform["pw"], forKey: "password")
                                UserDefaults.standard.set(inform["name"], forKey: "name")
                                
                                self.loginCoordinator?.pushSignUpVC()
                            }
                            
                            
                            
                        }).disposed(by: disposeBag)
                    
                case .failure(_):
                    print("failure")
                }
                
                
            }).disposed(by: disposeBag)
            
        }).disposed(by : disposeBag)
        
        
  
        return output
    }
 
    
    
    
    
}

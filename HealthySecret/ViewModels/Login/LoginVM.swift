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
import FirebaseAuth

class LoginVM : ViewModel {

    
    
    
    var disposeBag = DisposeBag()
    var firebaseService : FirebaseService?
    var loginCoordinator : LoginCoordinator?
    let kakaoService : KakaoService?
  
  
    
    struct Input {
        

        let kakaoLoginButtonTapped : Observable<UITapGestureRecognizer>
        let appleLogin : Observable<OAuthCredential>


    }
    
    struct Output {
        var alert = PublishSubject<Bool>()
        
    }

    
    init(firebaseService : FirebaseService  , loginCoordinator : LoginCoordinator , kakaoService : KakaoService ){
        
        self.firebaseService =  firebaseService
        self.loginCoordinator = loginCoordinator
        self.kakaoService = kakaoService
        
        
    }
    
    func transform(input: Input , disposeBag : DisposeBag ) -> Output {
        let output = Output()
        
       
        
        input.appleLogin.subscribe(onNext: { credential in
            
            
            UserDefaults.standard.set("apple",forKey: "loginMethod")
            
            self.firebaseService?.signInCredential(credential: credential).subscribe({ event in
                switch(event){
                    
                case.completed:
                    self.loginCoordinator?.login()
                    
                    
                case.error(let err):
                    if(err as? CustomError == CustomError.freeze){
                        output.alert.onNext(true)
                    }else{
                        self.loginCoordinator?.pushSignUpVC()
                    }
                }
                
                
            }).disposed(by: disposeBag)
            
            
            
        }).disposed(by: disposeBag)
        
            
      
        
        input.kakaoLoginButtonTapped.subscribe(onNext : {
            _ in
            UserDefaults.standard.set("kakao",forKey: "loginMethod")

            print("touch")
            
            self.kakaoService?.kakaoLogin().subscribe({
                event in
                switch event{
                case .success( let inform ):
                    
                    UserDefaults.standard.set(inform["email"], forKey: "email")

                
                        self.firebaseService?.signIn(email:inform["email"] ?? "" ,
                                                     pw:inform["pw"] ?? "" ).subscribe({ event in
                            switch event{
                            case .completed: 
                                self.loginCoordinator?.login()
                                
                                
                            case .error(let err):
                                
                                if(err as! CustomError == CustomError.freeze){
                                    
                                    output.alert.onNext(true)
                                    
                                }else{
                                    
                                    
                                    UserDefaults.standard.set("kakao",forKey: "loginMethod")
                                    UserDefaults.standard.set(inform["email"], forKey: "email")
                                    UserDefaults.standard.set(inform["name"], forKey: "name")
                                    UserDefaults.standard.set(inform["pw"], forKey: "password")
                                    
                                    
                                    self.loginCoordinator?.presentModal()
                                }
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

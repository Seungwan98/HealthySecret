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
  
  
    
    struct Input {
        
        let emailText : Observable<String>?
        let passwordText : Observable<String>?
        let loginButtonTapped : Observable<Void>
        let signUpButtonTapped : Observable<Void>

    }
    
    struct Output {
        
    }

    
    init(firebaseService : FirebaseService  , loginCoordinator : LoginCoordinator){
        
        self.firebaseService =  firebaseService
        self.loginCoordinator = loginCoordinator
        
        
        
    }
    
    func transform(input: Input , disposeBag : DisposeBag ) -> Output {
        let output = Output()
        
        input.signUpButtonTapped.subscribe(onNext: {
            _ in
            
            self.loginCoordinator?.pushSignUpVC()
            
        }).disposed(by: disposeBag)
            
        input.loginButtonTapped.subscribe(onNext: {
            
            Observable.zip( input.emailText! , input.passwordText! ).subscribe(onNext: {
                
                
                self.firebaseService?.signIn(email: $0 , pw: $1 ).subscribe(
                 onCompleted: {
                 self.loginCoordinator?.login()


                },
                 onError: { error in

                     print("Completed with an error: \(error.localizedDescription)")

                 }).disposed(by: disposeBag)
 
            }).disposed(by: disposeBag)
 
        }).disposed(by: disposeBag)
  
        return output
    }
 
    
    
    
    
}

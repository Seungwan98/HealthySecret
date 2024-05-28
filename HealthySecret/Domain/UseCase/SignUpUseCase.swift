//
//  SignUpUseCase.swift
//  HealthySecret
//
//  Created by 양승완 on 5/27/24.
//

import Foundation
import RxSwift

class SignUpUseCase  {
    
    
    
    
    private let disposeBag = DisposeBag()
    private let loginRepository : LoginRepository
    private let userRepository : UserRepository
    
    init( userRepository : UserRepository , loginRepository : LoginRepository ){
        self.userRepository = userRepository
        self.loginRepository = loginRepository
        
        
    }
    
    func SignUp(signUpModel: SignUpModel) -> Completable {
        
        let loginMethod = UserDefaults.standard.string(forKey: "loginMethod") ?? ""
        let name : String = UserDefaults.standard.string(forKey: "name") ?? ""
        let pw = UserDefaults.standard.string(forKey: "password") ?? ""
        let email = UserDefaults.standard.string(forKey: "email") ?? ""
       
 
        
     
        var userModel = signUpModel.toData()
        userModel.loginMethod = loginMethod
        userModel.name = name

        return Completable.create{ [weak self] completable in
            guard let self = self else {return Disposables.create()}

            
            
            
               if loginMethod == "kakao" || loginMethod == "normal" {
                   
                   
                   self.loginRepository.signUp(email: email, pw: pw).subscribe({  event in
                       
                       switch(event){
                           
                       case(.completed):
                           self.loginRepository.login().subscribe({ event in
                               switch(event){
                               case.completed:
                                let uid = UserDefaults.standard.string(forKey: "uid") ?? ""
                                   userModel.uuid = uid
                                   
                           self.userRepository.setUser(userModel: userModel).subscribe({ event in
                               switch(event){
                               case.completed:
                                   
                                   
                                           completable(.completed)
                                           
                                           
                                       case.error(let err):
                                           completable(.error(err))
                                       }
                                       
                                       
                                   }).disposed(by: self.disposeBag)
                                   
                               case.error(let err):
                                   completable(.error(err))
                               
                                   
                               }
                               
                               
                           }).disposed(by: self.disposeBag)
                       case.error(let err): completable(.error(err))
                           
                           
                       }
                       
                      
                       
                       }).disposed(by: disposeBag)
                   
         
               
                   

                   
                   
                   
               }
               else if(loginMethod == "apple"){
                   
                   self.userRepository.setUser(userModel: userModel).subscribe({ [weak self] event in
                       guard let self = self else {return}
                       completable(event)
                       
                       
                   }).disposed(by: disposeBag)
                   

                   
               }

            
            
            
            return Disposables.create()
        }

       }
        
        
        
        
        
        
    
}

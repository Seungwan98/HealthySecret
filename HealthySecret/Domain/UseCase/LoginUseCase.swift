//
//  LoginUseCase.swift
//  HealthySecret
//
//  Created by 양승완 on 5/27/24.
//

import Foundation
import RxSwift
import FirebaseAuth



class LoginUseCase {
    

  

    
    
    
    private let disposeBag = DisposeBag()
    private let loginRepository : LoginRepository
    
    init( loginRepository : LoginRepository ){
        self.loginRepository = loginRepository
        
        
    }
    
  
    func loginKakao() -> Completable {
        return loginRepository.login()
        
    }
    
    func loginApple(credential : OAuthCredential) -> Completable {
        return loginRepository.login(credential: credential)
        
    }
    
    
    
}

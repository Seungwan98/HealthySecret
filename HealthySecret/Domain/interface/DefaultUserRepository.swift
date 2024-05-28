//
//  DefaultUserRepository.swift
//  HealthySecret
//
//  Created by 양승완 on 5/27/24.
//

import Foundation
import RxSwift
import Firebase


class DefaultUserRepository : UserRepository{
 
    
    
    
    
    private let firebaseService : FirebaseService

    
    private let disposeBag = DisposeBag()
    
    init( firebaseService : FirebaseService   ) {
        self.firebaseService = firebaseService
        
        
    }


    func setUser(userModel : UserModel) -> Completable {
        
        return self.firebaseService.createUsers(model: userModel)
            
            

    }
    
    
    
    
    
}

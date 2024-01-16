//
//  HomeVM.swift
//  HealthySecret
//
//  Created by 양승완 on 2023/11/28.
//

import Foundation
import RxCocoa
import RxSwift


class signUpVM : ViewModel {
    
    
    var disposeBag = DisposeBag()
        
    
    struct Input {
      
    }
    
    struct Output {

        
    }
    
    
    weak var coordinator : LoginCoordinator?
    
    private var firebaseService : FirebaseService
    
    init( coordinator : LoginCoordinator , firebaseService : FirebaseService ){
        self.coordinator =  coordinator
        self.firebaseService =  firebaseService
        
    }
    
    
    func transform(input: Input, disposeBag: DisposeBag ) -> Output {
        let output = Output()
        
        
     
        
        return output
    }
    
    
    
    
    
    
    
}

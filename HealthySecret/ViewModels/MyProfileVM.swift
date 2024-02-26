//
//  HomeVM.swift
//  HealthySecret
//
//  Created by 양승완 on 2023/11/28.
//

import Foundation
import RxCocoa
import RxSwift


class MyProfileVM : ViewModel {
    
    
    var disposeBag = DisposeBag()
    
    
    struct Input {
        
    }
    
    struct Output {
        
    }
    
    
    weak var coordinator : MyProfileCoordinator?
    
    private var firebaseService : FirebaseService
    
    init( coordinator : MyProfileCoordinator , firebaseService : FirebaseService ){
        self.coordinator =  coordinator
        self.firebaseService =  firebaseService
        
    }
    
    
    func transform(input: Input, disposeBag: DisposeBag ) -> Output {
        
        
        
        let output = Output()
        
        
        
        
        return output
    }
    
    
    
    
    
    
    
}

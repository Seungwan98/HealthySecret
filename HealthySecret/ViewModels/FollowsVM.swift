//
//  FollowsVM.swift
//  HealthySecret
//
//  Created by 양승완 on 2023/11/28.
//

import Foundation
import RxCocoa
import RxSwift


class FollowsVM : ViewModel {
    
    var follow : Bool?
    var uid : String?
   // var coreMotionService = CoreMotionService.shared
    
    var disposeBag = DisposeBag()
    

    
    struct Input {
        let viewWillApearEvent : Observable<Void>

    }
    
    struct Output {
        
        var userModels = BehaviorSubject<[UserModel]>(value: [])

        
    }
    
    
    weak var coordinator : FollowsCoordinator?
    
    
    
    
    private var firebaseService : FirebaseService
    
    init( coordinator : FollowsCoordinator , firebaseService : FirebaseService ){
        self.coordinator =  coordinator
        self.firebaseService =  firebaseService
        
    }
    
    
    
    func transform(input: Input, disposeBag: DisposeBag ) -> Output {
        
        guard let uid = self.uid else { print("uid nil") }
        
        let output = Output()
        
        input.viewWillApearEvent.subscribe({ _ in
            
            
            
            self.firebaseService.getDocument(key: uid).subscribe({ [weak self] _ in
                
                
                
            }).disposed(by: disposeBag )
            
            
            
        }).disposed(by: disposeBag)
        
        output.userModels.onNext(testModels)
        
        
        
        
        

        
       
        
        
        return output
    }
    
    
    
    
    
    
    
}

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
        let viewWillApearEvent : Observable<Void>

    }
    
    struct Output {
        var calorie = BehaviorSubject(value: "")
        var goalWeight = BehaviorSubject(value: "")
        var nowWeight = BehaviorSubject(value: "")
        var name = BehaviorSubject(value: "")
        
        
    }
    
    
    weak var coordinator : MyProfileCoordinator?
    
    private var firebaseService : FirebaseService
    
    init( coordinator : MyProfileCoordinator , firebaseService : FirebaseService ){
        self.coordinator =  coordinator
        self.firebaseService =  firebaseService
        
    }
    
    
    func transform(input: Input, disposeBag: DisposeBag ) -> Output {
        
        let id = UserDefaults.standard.string(forKey: "email") ?? ""
        
        let output = Output()
        
        
        
        input.viewWillApearEvent.subscribe(onNext: {  _ in
            
            self.firebaseService.getDocument(key: id ).subscribe{
                event in
                switch(event){
                case.success(let user):
                    print(user)
                    output.goalWeight.onNext(String(user.goalWeight))
                    output.nowWeight.onNext(String(user.nowWeight))
                    output.calorie.onNext(String(user.calorie))
                    output.name.onNext(user.name)
                    
                    
                case .failure(_):
                    print("fail to get Doc")
                }
                
                
            }.disposed(by: disposeBag)
            
        }).disposed(by: disposeBag)
        
        
        
        
        return output
    }
    
    
    
    
    
    
    
}

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
    
   // var coreMotionService = CoreMotionService.shared
    
    var disposeBag = DisposeBag()
    

    
    struct Input {
        let viewWillApearEvent : Observable<Void>

    }
    
    struct Output {
        
        var userModels = BehaviorSubject<[UserModel]>(value: [])

        
    }
    
    
    weak var coordinator : AppCoordinator?
    
    
    
    
    private var firebaseService : FirebaseService
    
    init( coordinator : AppCoordinator , firebaseService : FirebaseService ){
        self.coordinator =  coordinator
        self.firebaseService =  firebaseService
        
    }
    
    
    
    func transform(input: Input, disposeBag: DisposeBag ) -> Output {
        var model1 = UserModel.init(uuid: "", id: "", name: "양승완", tall: "", age: "", sex: "", calorie: 1902, nowWeight:12 , goalWeight: 12, ingredients: [], exercise: [], diarys: [])
        var model2 = UserModel.init(uuid: "", id: "", name: "양승완", tall: "", age: "", sex: "", calorie: 1902, nowWeight:12 , goalWeight: 12, ingredients: [], exercise: [], diarys: [])
        var model3 = UserModel.init(uuid: "", id: "", name: "양승완", tall: "", age: "", sex: "", calorie: 1902, nowWeight:12 , goalWeight: 12, ingredients: [], exercise: [], diarys: [])
        var model4 = UserModel.init(uuid: "", id: "", name: "양승완", tall: "", age: "", sex: "", calorie: 1902, nowWeight:12 , goalWeight: 12, ingredients: [], exercise: [], diarys: [])
        
        var testModels = [model1 , model2 , model3 , model4]

        
        let output = Output()
        
        output.userModels.onNext(testModels)
        
        
        
        
        

        
       
        
        
        return output
    }
    
    
    
    
    
    
    
}

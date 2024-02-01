//
//  EditExerciseVM.swift
//  HealthySecret
//
//  Created by 양승완 on 2023/11/28.
//

import Foundation
import RxCocoa
import RxSwift


class EditExerciseVM : ViewModel {
    
    var model : Data?
    
    var disposeBag = DisposeBag()
    
    var exercises : [Exercise]
    
    struct Input {
        let viewWillApearEvent : Observable<Void>
        let edmitButtonTapped : Observable<Void>
        let inputArr : Observable<[Exercise]>
        let addButtonTapped : Observable<Void>
    }
    
    struct Output {
        var exerciseArr = BehaviorSubject<[Exercise]>(value: [])
        

    }
    
    
    weak var coordinator : DiaryCoordinator?
    
    private var firebaseService : FirebaseService
    
    init( coordinator : DiaryCoordinator , firebaseService : FirebaseService , exercises : [Exercise]){
        self.coordinator =  coordinator
        self.firebaseService =  firebaseService
        self.exercises =  exercises
        
    }
    
    
    
    func transform(input: Input, disposeBag: DisposeBag ) -> Output {
        
       

        let output = Output()

        output.exerciseArr.onNext(self.exercises)

        input.edmitButtonTapped.subscribe(onNext: { _ in
            input.inputArr.subscribe(onNext : { arr in
                self.firebaseService.updateExercise(exercise: arr, key: UserDefaults.standard.string(forKey: "email") ?? "").subscribe({ event in
                    switch event {
                    case.completed:
                        
                        self.coordinator?.finishChild()
      
                    case .error(_):
                        print("error")
                    }
                    
                    
                }).disposed(by: disposeBag)
           
                

            }).disposed(by: DisposeBag.init())
            
        }).disposed(by: disposeBag )
        
        input.addButtonTapped.subscribe(onNext: { _ in
            self.coordinator?.pushExerciseVC()
            
        }).disposed(by: disposeBag)
       
        
        return output
    }
    
   
    
    
    
    
}

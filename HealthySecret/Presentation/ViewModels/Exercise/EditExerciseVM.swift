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
        
    var disposeBag = DisposeBag()
    
    var exercises : [ExerciseModel]
    
    struct Input {
        let viewWillApearEvent : Observable<Void>
        let edmitButtonTapped : Observable<Void>
        let inputArr : Observable<[ExerciseModel]>
        let addButtonTapped : Observable<Void>
    }
    
    struct Output {
        var exerciseArr = BehaviorSubject<[ExerciseModel]>(value: [])
        

    }
    
    
    weak var coordinator : ExerciseCoordinator?
    
    private var firebaseService : FirebaseService
    
    init( coordinator : ExerciseCoordinator , firebaseService : FirebaseService , exercises : [ExerciseModel]){
        self.coordinator =  coordinator
        self.firebaseService =  firebaseService
        self.exercises =  exercises
        
    }
    
    
    
    func transform(input: Input, disposeBag: DisposeBag ) -> Output {
        
       

        let output = Output()

        output.exerciseArr.onNext(self.exercises)

        input.edmitButtonTapped.subscribe(onNext: { _ in
            input.inputArr.subscribe(onNext : { arr in
                self.firebaseService.updateExercise(exercise: arr, key: UserDefaults.standard.string(forKey: "uid") ?? "").subscribe({ event in
                    switch event {
                    case.completed:
                        
                        self.coordinator?.finish()
      
                    case .error(_):
                        print("error")
                    }
                    
                    
                }).disposed(by: disposeBag)
           
                

            }).disposed(by: DisposeBag.init())
            
        }).disposed(by: disposeBag )
        
        input.addButtonTapped.subscribe(onNext: { _ in
            
            self.coordinator?.pushExerciseVC(exercises: self.exercises)
            
        }).disposed(by: disposeBag)
       
        
        
        
        return output
    }
    
   
    
    
    
    
}

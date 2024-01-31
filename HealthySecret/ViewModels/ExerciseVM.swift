//
//  ExerciseVM.swift
//  HealthySecret
//
//  Created by 양승완 on 2023/11/28.
//

import Foundation
import RxCocoa
import RxSwift


class ExerciseVM : ViewModel {
    
    
    var disposeBag = DisposeBag()
    
    
    struct Input {
        let viewWillApearEvent : Observable<Void>
        let cellTapped : Observable<Data>
        
    }
    
    struct Output {
        let exerciseArr = BehaviorSubject<[Data]>(value: [] )

    }
    
    
    weak var coordinator : ExerciseCoordinator?
    
    private var firebaseService : FirebaseService
    
    init( coordinator : ExerciseCoordinator , firebaseService : FirebaseService ){
        self.coordinator =  coordinator
        self.firebaseService =  firebaseService
        
    }
    
    
    var exerciseArr : ExerciseModel?
    
    func transform(input: Input, disposeBag: DisposeBag ) -> Output {
        
        let output = Output()

        input.viewWillApearEvent.subscribe(onNext: {
            
            self.firebaseService.getExercise().subscribe({
                        single in
                        
                        switch single{
                        case.success(let exercise):
                            output.exerciseArr.onNext(exercise.data)
                            
                            
                            
                            
                        case.failure(_):
                            print("exercise fail")
                        }
                        
                        
                    }).disposed(by: disposeBag)
            
            
            
            
        }).disposed(by: disposeBag)
        
        input.cellTapped.subscribe(onNext:{
            model in
            self.coordinator?.pushDetailVC(model : model)
            
        }).disposed(by: disposeBag)
     
        
        
    
     
        
        
        return output
    }
    
    
    
    
    
    
    
}

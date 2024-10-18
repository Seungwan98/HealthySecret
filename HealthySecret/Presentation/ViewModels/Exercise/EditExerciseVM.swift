//
//  EditExerciseVM.swift
//  HealthySecret
//
//  Created by 양승완 on 2023/11/28.
//

import Foundation
import RxCocoa
import RxSwift


class EditExerciseVM: ViewModel {
    
    var disposeBag = DisposeBag()
    
    var exercises: [ExerciseModel]
    
    struct Input {
        let viewWillApearEvent: Observable<Void>
        let edmitButtonTapped: Observable<Void>
        let inputArr: Observable<[ExerciseModel]>
        let addButtonTapped: Observable<Void>
    }
    
    struct Output {
        var exerciseArr = BehaviorSubject<[ExerciseModel]>(value: [])
        
        
    }
    
    
    weak var coordinator: ExerciseCoordinator?
    private let exerciseUseCase: ExerciseUseCase
    
    
    
    init( coordinator: ExerciseCoordinator, exercises: [ExerciseModel], exerciseUseCase: ExerciseUseCase) {
        self.coordinator =  coordinator
        self.exercises =  exercises
        self.exerciseUseCase = exerciseUseCase
        
    }
    
    
    
    func transform(input: Input, disposeBag: DisposeBag ) -> Output {
        
        
        
        let output = Output()
        
        output.exerciseArr.onNext(self.exercises)
        
        input.edmitButtonTapped.subscribe(onNext: { [weak self] _ in guard let self = self else {return}
            input.inputArr.subscribe(onNext: { exercises in
                
                self.exerciseUseCase.updateUsersExercise(exercises: exercises).subscribe({ _ in
                    self.coordinator?.finish()
                    
                }).disposed(by: disposeBag)
                
                
                
                
                
                
            }).disposed(by: DisposeBag.init())
            
        }).disposed(by: disposeBag )
        
        input.addButtonTapped.subscribe(onNext: { [weak self]  _ in guard let self = self else {return}
            
            self.coordinator?.pushExerciseVC(exercises: self.exercises)
            
        }).disposed(by: disposeBag)
        
        
        
        
        return output
    }
    
    
    
    
    
    
}

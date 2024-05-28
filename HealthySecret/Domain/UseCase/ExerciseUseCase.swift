//
//  LoginUseCase.swift
//  HealthySecret
//
//  Created by 양승완 on 5/27/24.
//

import Foundation
import RxSwift
import FirebaseAuth



class ExerciseUseCase {
    

  

    
    
    
    private let disposeBag = DisposeBag()
    private let exerciseRepository : ExerciseRepository
    
    init( exerciseRepository : ExerciseRepository ){
        self.exerciseRepository = exerciseRepository
        
        
    }
    
    
    func getExerciseList() -> Single<[ExerciseModel]> {
     
        return exerciseRepository.getExerciseList()
        
        
    }

    
    
    
}

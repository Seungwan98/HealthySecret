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
    private let exerciseRepository: ExerciseRepository
    private let userRepository: UserRepository
    
    init( exerciseRepository: ExerciseRepository, userRepository: UserRepository ) {
        self.exerciseRepository = exerciseRepository
        self.userRepository = userRepository
        
    }
    
    
    func getExerciseList() -> Single<[ExerciseModel]> {
     
        return self.exerciseRepository.getExerciseList()
        
        
    }
    
    
    func updateUsersExercise(exercises: [ExerciseModel]) -> Completable {
        
        return self.userRepository.updateUsersExercises(exercises: exercises)
    }

    
    
    
}

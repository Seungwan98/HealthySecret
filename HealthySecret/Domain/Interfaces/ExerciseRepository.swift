//
//  UserRepository.swift
//  HealthySecret
//
//  Created by 양승완 on 5/27/24.
//

import Foundation
import RxSwift

protocol ExerciseRepository {
    
  
    func getExerciseList() -> Single<[ExerciseModel]>
    
    
}

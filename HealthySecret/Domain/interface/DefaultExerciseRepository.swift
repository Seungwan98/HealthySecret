//
//  DefaultIngredientsRepository.swift
//  HealthySecret
//
//  Created by 양승완 on 5/28/24.
//

import Foundation
import RxSwift

class DefaultExerciseRepository : ExerciseRepository {

    
    private let firebaseService : FirebaseService

    
    private let disposeBag = DisposeBag()
    
    init( firebaseService : FirebaseService   ) {
        self.firebaseService = firebaseService
        
        
    }
    
    func getExerciseList() -> Single<[ExerciseModel]> {
        Single.create{ [weak self] single in guard let self = self else {return single(.failure(CustomError.isNil)) as! Disposable}
            
            self.firebaseService.getExercise().subscribe({ event in
                switch(event){
                    
                case.success(let exerciseDTO):
                    single(.success(exerciseDTO.data.map{ $0.toDomain() }))
                
                case.failure(let err):
                    single(.failure(err))
                    
                    
                }
                
                
            }).disposed(by: disposeBag)
            
            
            return Disposables.create()
        }
        
        

        
    }
    
    
    
    
    
}

//
//  DefaultIngredientsRepository.swift
//  HealthySecret
//
//  Created by 양승완 on 5/28/24.
//

import Foundation
import RxSwift
class DefaultIngredientsRepository : IngredientsRepository {
    
    private let firebaseService : FirebaseService

    
    private let disposeBag = DisposeBag()
    
    init( firebaseService : FirebaseService   ) {
        self.firebaseService = firebaseService
        
        
    }
    
    func getIngredients() -> Single<[IngredientsModel]> {
    
        return Single.create{ [weak self] single in
            
            guard let self = self else {return single(.failure(CustomError.isNil)) as! Disposable}
            self.firebaseService.getIngredientsList().subscribe({ event in
                
                switch(event){
                case.success(let dtos):
                    single(.success(dtos.map{ $0.toDomain()  }))
                case.failure(let err):
                    single(.failure(err))
                }
                
                
            }).disposed(by: disposeBag)
            
            return Disposables.create()
        }
       
        
    }
    
    
    
    
}

//
//  UserRepository.swift
//  HealthySecret
//
//  Created by 양승완 on 5/27/24.
//

import Foundation
import RxSwift

protocol IngredientsRepository {
    
  
    func getIngredients() -> Single<[IngredientsModel]>
    
    
}

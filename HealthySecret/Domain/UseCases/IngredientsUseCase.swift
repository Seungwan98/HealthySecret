//
//  IngredientsUseCase.swift
//  HealthySecret
//
//  Created by 양승완 on 5/27/24.
//

import Foundation
import RxSwift
import FirebaseAuth



class IngredientsUseCase {
    

  

    
    
    
    private let disposeBag = DisposeBag()
    private let ingredientsRepository: IngredientsRepository
    private let userRepository: UserRepository
    
    init( ingredientsRepository: IngredientsRepository, userRepository: UserRepository ) {
        self.ingredientsRepository = ingredientsRepository
        self.userRepository = userRepository
        
    }
    
  

    
    func getIngredientsList() -> Single<[IngredientsModel]> {
     
        return ingredientsRepository.getIngredients()
        
        
    }
    
    
    func updateUsersIngredients(models: [IngredientsModel]) -> Completable {
        
        
        return Completable.create { [weak self] completable in
            guard let meal = UserDefaults.standard.string(forKey: "meal"), let date = UserDefaults.standard.string(forKey: "date"), let self = self else {return completable(.error(CustomError.isNil)) as! Disposable}
            
            self.userRepository.getUser().subscribe({ event in
                switch event {
                case.success(let user):
                    var userIngredients  = user.ingredients
                    var userIngredient = Ingredients(date: date, morning: [], lunch: [], dinner: [], snack: [])
                    
                    var count = 0
                    userIngredients.forEach({
                        if $0.date == date {
                            userIngredient = $0
                            userIngredients.remove(at: count)
                        }
                        count += 1
                    })
                    
                    switch meal {
                    case "아침식사":
                        userIngredient.morning = models
                    case "점심식사":
                        userIngredient.lunch = models
                        
                    case "저녁식사":
                        userIngredient.dinner = models
                    case "간식":
                        userIngredient.snack = models
               
                    default:
                        break
                    }
                    
                    userIngredients.append(userIngredient)
                    self.userRepository.updateUsersIngredients(ingredients: userIngredients).subscribe({ event in
                        
                        completable(event)
                        
                        
                    }).disposed(by: self.disposeBag)
                  
                case.failure(let err): completable(.error(err))
                    
                }
                
            }).disposed(by: disposeBag)
            
            
            return Disposables.create()
            
        }
        
        
  
        
        
       
        
        
        
    }
    
    
    
    
    
    
    
    
}

//
//  LoginUseCase.swift
//  HealthySecret
//
//  Created by 양승완 on 5/27/24.
//

import Foundation
import RxSwift
import FirebaseAuth
import RxCocoa



class DiaryUseCase {
    
    
    
    
    
    
    
    private let disposeBag = DisposeBag()
    private let userRepository: UserRepository
    
    var finalIngredientsModel: IngredientsModel?
    
    
    var getUsersGoalCal = BehaviorSubject<String>(value: "")
    
    var getMorning = BehaviorSubject<[IngredientsModel]>(value: [])
    var getLunch = BehaviorSubject<[IngredientsModel]>(value: [])
    var getDinner = BehaviorSubject<[IngredientsModel]>(value: [])
    var getSnack = BehaviorSubject<[IngredientsModel]>(value: [])
    
    var getExercises = BehaviorRelay<[ExerciseModel]>(value: [])
    var getExTime = BehaviorRelay<String>(value: "")
    var getExCalorie = BehaviorRelay<String>(value: "")
    
    
    
    
    init( userRepository: UserRepository ) {
        self.userRepository = userRepository
        
        
    }
    
    
    
    
    func getUser(pickedDate: String) -> Single<IngredientsModel> {
        
        return Single.create { single in
            
            self.userRepository.getUser().subscribe({ [weak self] event in
                guard let self = self else {return}
                
                
                print("getUser")
                
                let ingTotalCal: Int = 0
                
                var morning = [IngredientsModel]()
                var lunch = [IngredientsModel]()
                var dinner = [IngredientsModel]()
                var snack = [IngredientsModel]()
                var total = [IngredientsModel]()
                
                
                var ingredientsModel = IngredientsModel( num: "", descKor: "", carbohydrates: 0.0, calorie: 0, protein: 0.0, province: 0.0, sugars: 0.0, sodium: 0.0, cholesterol: 0.0, fattyAcid: 0.0, transFat: 0.0, servingSize: 0.0, addServingSize: 0.0)
                
                
                
                switch event {
                case .success(let user):
                    
                    
                    UserDefaults.standard.set(user.goalWeight, forKey: "weight")
                    
                    print(user.calorie)
                    self.getUsersGoalCal.onNext(String(user.calorie))
                    
                    
                    
                    
                    let exercises = user.exercise.filter({
                        
                        $0.date == pickedDate
                        
                    })
                    
                    self.getExercises.accept(exercises)
                    
                    
                    
                    let totalTime = exercises.map({ $0.time }).reduce(0) { Int($0) + (Int($1) ?? 0) }
                    let totalCalorie = exercises.map({ $0.finalCalorie }).reduce(0) { Int($0) + (Int($1) ?? 0) }
                    
                    self.setExTime(totalTime: totalTime)
                    self.getExCalorie.accept(String(totalCalorie))
                    
                    
                    
                    
                    
                    
                    
                    
                    
                    let ingredients = user.ingredients.filter {(
                        $0.date == pickedDate
                        
                    )}
                    
                    
                    if let ingredient = ingredients.first {
                        
                        
                        morning =  ingredient.morning ?? []
                        lunch =  ingredient.lunch ?? []
                        dinner =  ingredient.dinner ?? []
                        snack =  ingredient.snack ?? []
                        total = morning + lunch + dinner + snack
                        
                        self.getMorning.onNext(morning)
                        self.getLunch.onNext(lunch)
                        self.getDinner.onNext(dinner)
                        self.getSnack.onNext(snack)
                        
                        
                        for ingredient in total {
                            
                            
                            
                            ingredientsModel.carbohydrates += CustomMath().getDecimalSecond(data: ingredient.carbohydrates)
                            ingredientsModel.calorie += ingredient.calorie
                            ingredientsModel.protein += CustomMath().getDecimalSecond(data: ingredient.protein)
                            ingredientsModel.province += CustomMath().getDecimalSecond(data: ingredient.province)
                            ingredientsModel.cholesterol += CustomMath().getDecimalSecond(data: ingredient.cholesterol)
                            ingredientsModel.fattyAcid += CustomMath().getDecimalSecond(data: ingredient.fattyAcid)
                            ingredientsModel.sugars += CustomMath().getDecimalSecond(data: ingredient.sugars)
                            ingredientsModel.transFat += CustomMath().getDecimalSecond(data: ingredient.transFat)
                            ingredientsModel.sodium += CustomMath().getDecimalSecond(data: ingredient.sodium)
                            
                            
                            
                        }
                        
                        
                        
                        
                        
                        
                        
                        
                        
                    }
                    self.finalIngredientsModel?.calorie = Int(ingTotalCal)
                    
                    self.finalIngredientsModel = ingredientsModel
                    single(.success(ingredientsModel))
                    
                    
                    
                    
                    
                    
                    
                    
                    
                    
                    
                    
                case.failure(let err):
                    single(.failure(err))
                    
                }
                
                
                
                
                
                
                
                
                
                
                
                
                
                
                
                
                
            }).disposed(by: self.disposeBag)
            
            return Disposables.create()
            
            
        }
    }
    
    
    
    func setExTime(totalTime: Int) {
        var outputTime = ""
        if totalTime/60 > 1 {
            outputTime = "\(totalTime/60)시간 \(totalTime%60)"
        } else {
            outputTime = String(totalTime)
        }
        
        self.getExTime.accept(outputTime)
        
    }
    
    
}

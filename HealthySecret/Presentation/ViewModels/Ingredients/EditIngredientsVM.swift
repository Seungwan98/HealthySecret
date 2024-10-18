//
//  EditIngredientsVM.swift
//  HealthySecret
//
//  Created by 양승완 on 2023/11/28.
//

import Foundation
import RxCocoa
import RxSwift


class EditIngredientsVM: ViewModel {
    
    
    var disposeBag = DisposeBag()
    
    var Ingredients: [IngredientsModel]
    
    
    
    struct Input {
        let viewWillApearEvent: Observable<Void>
        let edmitButtonTapped: Observable<Void>
        let inputArr: Observable<[IngredientsModel]>
        let addButtonTapped: Observable<Void>
    }
    
    struct Output {
        var ingredientsArr = BehaviorSubject<[IngredientsModel]>(value: [])
        var imagePicker = BehaviorSubject<Int>(value: 0)
        

    }
    

    
    
    weak var coordinator: IngredientsCoordinator?
    private let ingredientsUseCase: IngredientsUseCase
    private let firebaseService: FirebaseService
    
    init( coordinator: IngredientsCoordinator, firebaseService: FirebaseService, Ingredients: [IngredientsModel], ingredientsUseCase: IngredientsUseCase) {
        self.coordinator =  coordinator
        self.firebaseService =  firebaseService
        self.Ingredients =  Ingredients
        self.ingredientsUseCase = ingredientsUseCase
        
    }
    
    
    
    func transform(input: Input, disposeBag: DisposeBag ) -> Output {
        
       

        let output = Output()
        let value = 0

        
        switch UserDefaults.standard.string(forKey: "meal") {
        case "아침식사":
            output.imagePicker.onNext(0)
        case "점심식사":
            output.imagePicker.onNext(1)
        case "저녁식사":
            output.imagePicker.onNext(2)
        case "간식":
            output.imagePicker.onNext(3)

            
        case .none:
            output.imagePicker.onNext(value)
        case .some(_):
            output.imagePicker.onNext(value)
        }
        
        

        output.ingredientsArr.onNext(self.Ingredients)

        input.edmitButtonTapped.subscribe(onNext: { [weak self] _ in
            
            guard let self = self else {return}
            input.inputArr.subscribe(onNext: { arr in
                
                self.ingredientsUseCase.updateUsersIngredients(models: arr).subscribe({ _ in
                    
                    self.coordinator?.backToDiaryVC()
                    
                }).disposed(by: disposeBag)
                
                
            }).disposed(by: DisposeBag())
            
          
            
        }).disposed(by: disposeBag )
        
        
        
        input.addButtonTapped.subscribe(onNext: { _ in
            input.inputArr.subscribe(onNext: { arr in
                self.coordinator?.navigationController.popViewController(animated: false)
                self.coordinator?.pushIngredientsSelecting(arr: arr)
                



                }).disposed(by: DisposeBag())
                
                
           
            
        }).disposed(by: disposeBag)
       
        
        return output
    }
    
   
    
    
    
    
}

//
//  EditIngredientsVM.swift
//  HealthySecret
//
//  Created by 양승완 on 2023/11/28.
//

import Foundation
import RxCocoa
import RxSwift


class EditIngredientsVM : ViewModel {
    
    
    var disposeBag = DisposeBag()
    
    var Ingredients : [Row]
    
    struct Input {
        let viewWillApearEvent : Observable<Void>
        let edmitButtonTapped : Observable<Void>
        let inputArr : Observable<[Row]>
        let addButtonTapped : Observable<Void>
    }
    
    struct Output {
        var ingredientsArr = BehaviorSubject<[Row]>(value: [])
        var imagePicker = BehaviorSubject<Int>(value: 0)
        

    }
    
    
    weak var coordinator : IngredientsCoordinator?
    
    private var firebaseService : FirebaseService
    
    init( coordinator : IngredientsCoordinator , firebaseService : FirebaseService , Ingredients : [Row]){
        self.coordinator =  coordinator
        self.firebaseService =  firebaseService
        self.Ingredients =  Ingredients
        
    }
    
    
    
    func transform(input: Input, disposeBag: DisposeBag ) -> Output {
        
       

        let output = Output()
        let value = 0

        
        switch UserDefaults.standard.string(forKey: "meal"){
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
                self.firebaseService.addIngredients(meal: UserDefaults.standard.string(forKey: "meal") ?? "", date:  UserDefaults.standard.string(forKey: "date") ?? "", key:  UserDefaults.standard.string(forKey: "uid") ?? "", mealArr: arr).subscribe({ event in
                    switch event{
                    case.completed:
                        print("completed")
                        self.coordinator?.backToDiaryVC()
                    case.error(_):
                        print("error")
                    }





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

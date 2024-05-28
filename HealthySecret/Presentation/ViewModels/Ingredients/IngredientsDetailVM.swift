//
//  IngredientsDetailVM.swift
//  HealthySecret
//
//  Created by 양승완 on 2023/11/28.
//

import Foundation
import RxCocoa
import RxSwift


class IngredientsDetailVM  : ViewModel {
    
    
    var disposeBag = DisposeBag()
    
    struct DetailOutput {
        let outputRows = BehaviorSubject<[Row]>(value : [])
    }
    
    
    
    struct Input {
        let viewWillApearEvent : Observable<Void>
        let addBtnTapped : Observable<Void>
        let selectTextField : Observable<String>
        let selectButton : Observable<Int>
       
    }
    
    struct Output {
        let nameLabel = BehaviorSubject<String>(value: "")
        let calorieLabel = BehaviorSubject<String>(value: "0" )
        let carbohydratesLabel = BehaviorSubject<String>(value: "0")
        let proteinLabel = BehaviorSubject<String>(value: "0")
        let provinceLabel = BehaviorSubject<String>(value: "0")
        let buttonEnable = BehaviorSubject<Bool>(value: false)
        let firstTextToField = BehaviorSubject<String>(value: "0" )
    
    }
    
    
    weak var coordinator : IngredientsCoordinator?
    
    private var firebaseService : FirebaseService
    
    private var model : IngredientsModel
    
    
    init( coordinator : IngredientsCoordinator , firebaseService : FirebaseService , model : IngredientsModel){
        self.coordinator =  coordinator
        self.firebaseService =  firebaseService
        self.model = model
        

    }
    
    
    
    func transform(input: Input, disposeBag: DisposeBag ) -> Output {
        
        let output = Output()
        
        let serveSize = model.addServingSize ?? model.servingSize



        
        input.viewWillApearEvent.subscribe(onNext: { _ in
            input.selectButton.subscribe(onNext: { tag in
           
            var tag = tag
            

            input.selectTextField.subscribe(onNext: { text in
                var selectText = Double(text)
               
                
                

                print("tag \(tag)")

                  
                    
                    if(tag == 2){
                        selectText = 0
                        output.firstTextToField.onNext("0")
                        tag = 0
                        
                    }else if(tag == 3){
                        selectText = serveSize
                        output.firstTextToField.onNext(String(selectText ?? 0))
                        tag = 1
                    }
                
                
                
                let newRow : IngredientsModel
                
                
                if(tag == 0){
                    if text.isEmpty {
                        print("empty")
                        
                        newRow = self.getServingOnce(selectText: 0 , model : self.model)

                    }else{
                        newRow = self.getServingOnce(selectText: selectText ?? 0, model : self.model)
                    }
                }else{
                    if text.isEmpty {
                        print("empty")
                        
                        newRow = self.getGram(selectText: 0 , model : self.model)

                    }else{
                        newRow = self.getGram(selectText: selectText ?? 0, model : self.model)
                    }
                    
                }
                
                
             
                
                output.calorieLabel.onNext(String(newRow.calorie)+"kcal")
                output.nameLabel.onNext(String(newRow.descKor))
                output.proteinLabel.onNext(String(newRow.protein)+"g")
                output.provinceLabel.onNext(String(newRow.province)+"g")
                output.carbohydratesLabel.onNext(String(newRow.carbohydrates)+"g")
                
                
                input.addBtnTapped.subscribe(onNext: { _ in
                   
                        
                    var filteredArr = self.coordinator?.filteredArr
                   
                     filteredArr?.append(newRow)

                    self.coordinator?.navigationController.popViewController(animated: false)
                    self.coordinator?.pushIngredientsEdmit(arr: filteredArr ?? [])
                        
                    
                    
                    
                    
                }).disposed(by: disposeBag)
                
            }).disposed(by: disposeBag)

                
                
            }).disposed(by: disposeBag)

        }).disposed(by: disposeBag)

        output.firstTextToField.onNext(String(Int(serveSize)))
        
        return output
    }
    
    func getGram(selectText : Double , model : IngredientsModel ) -> IngredientsModel {
        var newRow = model
        let size = model.addServingSize ?? model.servingSize
        
        newRow.calorie = Int(CustomMath().getDecimalSecond(data: (selectText * (   Double(model.calorie) / size))))
        
        newRow.carbohydrates = CustomMath().getDecimalSecond(data: (selectText * (  model.carbohydrates / size)))
        
        newRow.protein = CustomMath().getDecimalSecond(data: (selectText * (   model.protein / size)))
        
        newRow.province = CustomMath().getDecimalSecond(data: (selectText * (   model.province / size)))
        
        newRow.sugars = CustomMath().getDecimalSecond(data: (selectText * (   model.sugars / size)))
        
        newRow.sodium = CustomMath().getDecimalSecond(data: (selectText * (  model.sodium / size)))
        
        newRow.cholesterol = CustomMath().getDecimalSecond(data: (selectText * (   model.cholesterol / size)))
        
        newRow.fattyAcid = CustomMath().getDecimalSecond(data: (selectText * (  model.fattyAcid  / size)))
        
        newRow.transFat = CustomMath().getDecimalSecond(data: (selectText * (   model.transFat / size)))
     
        newRow.addServingSize = selectText
        
        return newRow
        
        
    }
    func getServingOnce(selectText : Double , model : IngredientsModel ) -> IngredientsModel {
        var newRow = model
        let addServingSize = model.addServingSize ?? model.servingSize
        let servingSize = model.servingSize
        
        
        
        newRow.calorie = Int(CustomMath().getDecimalSecond(data: (selectText * (   Double(model.calorie) / addServingSize * servingSize))))
        
        newRow.carbohydrates = CustomMath().getDecimalSecond(data: (selectText * (   model.carbohydrates / addServingSize * servingSize)))
        
        newRow.protein = CustomMath().getDecimalSecond(data: (selectText * (   model.protein / addServingSize * servingSize)))
        
        newRow.province = CustomMath().getDecimalSecond(data: (selectText * (   model.province / addServingSize * servingSize)))
        
        newRow.sugars = CustomMath().getDecimalSecond(data: (selectText * (   model.sugars / addServingSize * servingSize)))
        
        newRow.sodium = CustomMath().getDecimalSecond(data: (selectText * (  model.sodium / addServingSize * servingSize)))
        
        newRow.cholesterol = CustomMath().getDecimalSecond(data: (selectText * (    model.cholesterol / addServingSize * servingSize)))
        
        newRow.fattyAcid = CustomMath().getDecimalSecond(data: (selectText * (   model.fattyAcid / addServingSize * servingSize)))
        
        newRow.transFat = CustomMath().getDecimalSecond(data: (selectText * (   model.transFat / addServingSize * servingSize)))
        
        newRow.addServingSize =  selectText * servingSize

        
        
        return newRow
    }
    
    
    
    
}

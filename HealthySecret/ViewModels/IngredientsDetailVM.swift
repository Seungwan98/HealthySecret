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
        let firstTextToField = BehaviorSubject<String>(value: "0")
    
    }
    
    
    weak var coordinator : IngredientsCoordinator?
    
    private var firebaseService : FirebaseService
    
    private var row : Row
    
    
    init( coordinator : IngredientsCoordinator , firebaseService : FirebaseService , row : Row){
        self.coordinator =  coordinator
        self.firebaseService =  firebaseService
        self.row = row
        

    }
    
    
    
    func transform(input: Input, disposeBag: DisposeBag ) -> Output {
        
        let output = Output()
        
        let serveSize = row.addServingSize ?? row.servingSize



        
        input.viewWillApearEvent.subscribe(onNext: { _ in
            
              
                
                
            
       
            
            
        input.selectButton.subscribe(onNext: { tag in
           
            var tag = tag
            

            input.selectTextField.subscribe(onNext: { text in
                var selectText = ""
                selectText = text
                
                

                print("tag \(tag)")

                  
                    
                    if(tag == 2){
                        selectText = "0"
                        output.firstTextToField.onNext(selectText)
                        tag = 0
                        
                    }else if(tag == 3){
                        selectText = serveSize
                        output.firstTextToField.onNext(selectText)
                        tag = 1
                    }
                
                
                
                let newRow : Row
                
                
                if(tag == 0){
                    if text.isEmpty {
                        print("empty")
                        
                       newRow = self.getServingOnce(selectText: "0" , row : self.row)

                    }else{
                        newRow = self.getServingOnce(selectText: selectText, row : self.row)
                    }
                }else{
                    if text.isEmpty {
                        print("empty")
                        
                        newRow = self.getGram(selectText: "0" , row : self.row)

                    }else{
                        newRow = self.getGram(selectText: selectText, row : self.row)
                    }
                    
                }
                
                
             
               
                
                output.calorieLabel.onNext(newRow.kcal+"kcal")
                output.nameLabel.onNext(newRow.descKor)
                output.proteinLabel.onNext(newRow.protein+"g")
                output.provinceLabel.onNext(newRow.province+"g")
                output.carbohydratesLabel.onNext(newRow.carbohydrates+"g")
                
                
                input.addBtnTapped.subscribe(onNext: { _ in
                   
                        
                    var filteredArr = self.coordinator?.filteredArr
                    filteredArr?.append(newRow)

                    self.coordinator?.navigationController.popViewController(animated: false)
                    self.coordinator?.pushIngredientsEdmit(arr: filteredArr ?? [])
                        
                    
                    
                    
                    
                }).disposed(by: disposeBag)
                
            }).disposed(by: disposeBag)

                
                
            }).disposed(by: disposeBag)

        }).disposed(by: disposeBag)

        output.firstTextToField.onNext(serveSize)
        
        return output
    }
    
    func getGram(selectText : String , row : Row ) -> Row {
        var newRow = row
        let text = (Double(selectText) ?? 1)
        let size = (Double(row.addServingSize ?? row.servingSize )! )
        
        newRow.kcal = String(CustomMath().getDecimalSecond(data: (text * (   (Double(row.kcal) ?? 0)! / size))))
        
        newRow.carbohydrates = String(CustomMath().getDecimalSecond(data: (text * (   (Double(row.carbohydrates) ?? 0)! / size))))
        
        newRow.protein = String(CustomMath().getDecimalSecond(data: (text * (   (Double(row.protein) ?? 0)! / size))))
        
        newRow.province = String(CustomMath().getDecimalSecond(data: (text * (   (Double(row.province) ?? 0)! / size))))
        
        newRow.sugars = String(CustomMath().getDecimalSecond(data: (text * (   (Double(row.sugars) ?? 0)! / size))))
        
        newRow.sodium = String(CustomMath().getDecimalSecond(data: (text * (   (Double(row.sodium) ?? 0)! / size))))
        
        newRow.cholesterol = String(CustomMath().getDecimalSecond(data: (text * (   (Double(row.cholesterol) ?? 0)! / size))))
        
        newRow.fattyAcid = String(CustomMath().getDecimalSecond(data: (text * (   (Double(row.fattyAcid) ?? 0)! / size))))
        
        newRow.transFat = String(CustomMath().getDecimalSecond(data: (text * (   (Double(row.transFat) ?? 0)! / size))))
     
        newRow.addServingSize = selectText
        
        return newRow
        
        
    }
    func getServingOnce(selectText : String , row : Row ) -> Row {
        var newRow = row
        let text = (Double(selectText) ?? 1)
        let addServingSize = (Double(row.addServingSize ?? row.servingSize ))!
        let servingSize = Double(row.servingSize) ?? 1
        
        
        
        newRow.kcal = String(CustomMath().getDecimalSecond(data: (text * (   (Double(row.kcal) ?? 0)! / addServingSize * servingSize))))
        
        newRow.carbohydrates = String(CustomMath().getDecimalSecond(data: (text * (   (Double(row.carbohydrates) ?? 0)! / addServingSize * servingSize))))
        
        newRow.protein = String(CustomMath().getDecimalSecond(data: (text * (   (Double(row.protein) ?? 0)! / addServingSize * servingSize))))
        
        newRow.province = String(CustomMath().getDecimalSecond(data: (text * (   (Double(row.province) ?? 0)! / addServingSize * servingSize))))
        
        newRow.sugars = String(CustomMath().getDecimalSecond(data: (text * (   (Double(row.sugars) ?? 0)! / addServingSize * servingSize))))
        
        newRow.sodium = String(CustomMath().getDecimalSecond(data: (text * (   (Double(row.sodium) ?? 0)! / addServingSize * servingSize))))
        
        newRow.cholesterol = String(CustomMath().getDecimalSecond(data: (text * (   (Double(row.cholesterol) ?? 0)! / addServingSize * servingSize))))
        
        newRow.fattyAcid = String(CustomMath().getDecimalSecond(data: (text * (   (Double(row.fattyAcid) ?? 0)! / addServingSize * servingSize))))
        
        newRow.transFat = String(CustomMath().getDecimalSecond(data: (text * (   (Double(row.transFat) ?? 0)! / addServingSize * servingSize))))
        
        newRow.addServingSize = String(Double(selectText)! * Double(servingSize))

        
        
        return newRow
    }
    
    
    
    
}

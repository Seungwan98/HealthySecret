//
//  DetailPageVM.swift
//  HealthySecret
//
//  Created by 양승완 on 2023/11/28.
//

import Foundation
import RxCocoa
import RxSwift


class ExerciseDetailVM : ViewModel {
    
    var model : ExerciseDtoData?
    
    var exercises : [Exercise]?
    
    var disposeBag = DisposeBag()
    
    
    struct Input {
        let viewWillApearEvent : Observable<Void>
        let addBtnTapped : Observable<Void>
        let minuteTextField : Observable<String>
        let memoTextField : Observable<String>
    }
    
    struct Output {
        let nameLabel = BehaviorSubject<String>(value: "")
        let guessLabel = BehaviorSubject<String>(value: "" )
        let buttonEnable = BehaviorSubject<Bool>(value: false)
    }
    
    
    weak var coordinator : ExerciseCoordinator?
    
    private var firebaseService : FirebaseService
    
    init( coordinator : ExerciseCoordinator , firebaseService : FirebaseService ){
        self.coordinator =  coordinator
        self.firebaseService =  firebaseService
        
    }
    
    
    
    func transform(input: Input, disposeBag: DisposeBag ) -> Output {
        
        let weight = UserDefaults.standard.object(forKey: "weight")
        
        
        var time = ""
        var finalCalorie = ""
        var memo = ""
        let name = self.model?.name ?? ""
        let exerciseGram = self.model?.exerciseGram ?? ""

        let output = Output()
        
        input.viewWillApearEvent.subscribe(onNext: { [weak self] in
            
            output.nameLabel.onNext(self?.model?.name ?? "")
            
        }).disposed(by: disposeBag)
        

        
        input.minuteTextField.subscribe(onNext: { text in
            time = text
            finalCalorie = self.getCalorie(text: text , weight : weight as! Int) 
            output.guessLabel.onNext(finalCalorie)
            
            output.buttonEnable.onNext(text.isEmpty)
            
        }).disposed(by: disposeBag)
        
        input.memoTextField.subscribe(onNext: { text in
            memo = text
            
        }).disposed(by: disposeBag)
        
        
        
        input.addBtnTapped.subscribe(onNext: { _ in
            
            let exercise = Exercise(date: UserDefaults.standard.string(forKey: "date") ?? "", name: name , time: time  , finalCalorie : finalCalorie , memo : memo  , key: UUID().uuidString , exerciseGram: exerciseGram)

            var exercises = self.exercises ?? []
            exercises.append(exercise)
            
            self.coordinator?.navigationController.popViewController(animated: false)
            self.coordinator?.pushEditExerciseVC(exercises: exercises)
              
            
        }).disposed(by: disposeBag)
        
        
        
        
        return output
    }
    
    func getCalorie(text : String , weight : Int ) -> String {
        let weight = Double(weight)
        let min = Double(text) ?? 0
        let met = Double(model!.exerciseGram ) ?? 0
        let result =  lroundl(( ( met * (3.5 *  weight * min  )) / 1000 ) * 5 )
        return String(result)
        
        
    }
    
    
    
    
}

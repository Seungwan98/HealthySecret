//
//  ChangeSignUpVM.swift
//  HealthySecret
//
//  Created by 양승완 on 2023/11/28.
//

import Foundation
import RxCocoa
import RxSwift


class ChangeSignUpVM : ViewModel {
    
    
    var disposeBag = DisposeBag()
    
    private let profileUseCase : ProfileUseCase
    
    private let exerciseArr = ["활동적음" , "일반적" , "활동많음"]
        
    private let defaultSex = ["남성" ,  "여성"]
    
    private let defaultCalorie = [  [30 , 35 , 40] , [25 , 30 , 35]]
    
    struct Input {
        let sexInput : Observable<Int>
        let exerciseInput : Observable<Int>
        let ageInput : Observable<String>
        let tallInput : Observable<String>
        let startWeight : Observable<String>
        let goalWeight : Observable<String>

        let nextButtonTapped : Observable<Void>
        
         
        
      
    }
    
    struct Output {
        
        var sexOutput = BehaviorSubject<Int>(value: 3)
        var exerciseOutput = BehaviorSubject<Int>(value: 4)
        var ageOutput = BehaviorSubject<String>(value: "")
        var tallOutput = BehaviorSubject<String>(value: "")
        var startWeight = BehaviorSubject<String>(value: "")
        var goalWeight = BehaviorSubject<String>(value: "")
        
        var nextButtonEnable = BehaviorSubject<Bool>(value: false)

        
    }

    
    var signUpModel = SignUpModel(uuid: "" , name: "" , tall: "", age: "" , sex: "" , calorie: 0, nowWeight: 0, goalWeight: 0,  activity: 0)
    


    
    weak var coordinator : ProfileCoordinator?
    
    
    init( coordinator : ProfileCoordinator , profileUseCase : ProfileUseCase  ){
        self.coordinator =  coordinator
        self.profileUseCase = profileUseCase
        
    }
    
    
    func transform(input: Input, disposeBag: DisposeBag ) -> Output {
        
        
        let output = Output()

        output.ageOutput.onNext(signUpModel.age)
        output.exerciseOutput.onNext(signUpModel.activity)
        output.goalWeight.onNext(String(signUpModel.goalWeight))
        switch(signUpModel.sex){
        case "남성":
            output.sexOutput.onNext(0)
        case "여성":
            output.sexOutput.onNext(1)
            
        default:
            break
        }
        output.startWeight.onNext(String(signUpModel.nowWeight))
        output.tallOutput.onNext(signUpModel.tall)
        
        var isValid: Observable<Bool> {
               return Observable
                .combineLatest(input.ageInput, input.goalWeight , input.sexInput , input.startWeight , input.tallInput , input.exerciseInput)
                   .map { age, goal , sex , start , tall , exercise in
                       
                       return !age.isEmpty && !goal.isEmpty && (sex < 2) && !start.isEmpty && !tall.isEmpty && (exercise < 3 )
                   }
           }
        
        isValid.subscribe(onNext: { event in
            output.nextButtonEnable.onNext(event)
            
        }).disposed(by: disposeBag)
        
        
        input.nextButtonTapped.subscribe(onNext: { _ in

            
       print("tap")
            
        
            
            input.sexInput.subscribe(onNext: {
                sex in
                print("sex")
                self.signUpModel.sex = self.defaultSex[sex]
                input.exerciseInput.subscribe(onNext: {
                    exercise in
                    
                    input.goalWeight.subscribe(onNext: {
                        goal in
                        
                        
                        self.signUpModel.activity = Int(exercise)
                        self.signUpModel.goalWeight = Int(goal) ?? 0
                        self.signUpModel.calorie = Int(goal)! * self.defaultCalorie[sex][exercise]
                        
                        input.ageInput.subscribe(onNext: {
                            age in
                            print("age")
                            self.signUpModel.age = age
                            input.tallInput.subscribe(onNext: {
                                tall in print("\(tall) tall " )
                                self.signUpModel.tall = tall
                                input.startWeight.subscribe(onNext: {
                                    start in print("\(start) startWeight " )
                                    self.signUpModel.nowWeight = Int(start) ?? 0
                                    
                                    
                                    self.profileUseCase.updateSignUpData(signUpModel: self.signUpModel).subscribe({event in
                                        print(event)
                                        switch(event){
                                            
                                        case .error(_):
                                            print("error")
                                        case .completed:
                                            
                                            self.coordinator?.navigationController.popViewController(animated: false)
                                        }
                                        
                                    }
                                                                                                                  
                                                                                                                  
                                    ).disposed(by: disposeBag)
                                    
                                    
                                    
                                    
                                    
                                }).disposed(by: disposeBag)
                                
                            }).disposed(by: disposeBag)
                            
                        }).disposed(by: disposeBag)
                        
                        
                        
                     
                        
                    }).disposed(by: disposeBag)
                    
                    
                    
                }).disposed(by: disposeBag)
                
                
            }).disposed(by: disposeBag)
            
            
            
            
            
           
                    

                    
                    
          
                 
         
                    
           
                
                
                
                

            
        }).disposed(by: disposeBag)
       
        
        
     
        
        return output
    }
    
    
   
        
        
        
    }
    
    
    
    
    
    
    


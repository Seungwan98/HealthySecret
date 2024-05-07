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
    
   
    
    let exerciseArr = ["활동적음" , "일반적" , "활동많음"]
        
    let defaultSex = ["남성" ,  "여성"]
    
    let defaultCalorie = [  [30 , 35 , 40] , [25 , 30 , 35]]
    
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

    
    var userModel = UserModel(uuid: "", name: "" ,  tall: "", age: "", sex: "", calorie: 0, nowWeight: 0, goalWeight: 0, ingredients: [], exercise: [] , diarys: [] )

    
    weak var coordinator : ProfileCoordinator?
    
    private var firebaseService : FirebaseService
    
    init( coordinator : ProfileCoordinator , firebaseService : FirebaseService ){
        self.coordinator =  coordinator
        self.firebaseService =  firebaseService
        
    }
    
    
    func transform(input: Input, disposeBag: DisposeBag ) -> Output {
        //let name : String = UserDefaults.standard.value(forKey: "name") as! String
        
        
        let output = Output()
        print(userModel.tall)
        output.ageOutput.onNext(userModel.age)
        output.exerciseOutput.onNext(userModel.activity ?? 4)
        output.goalWeight.onNext(String(userModel.goalWeight))
        switch(userModel.sex){
        case "남성":
            output.sexOutput.onNext(0)
        case "여성":
            output.sexOutput.onNext(1)
            
        default:
            break
        }
        output.startWeight.onNext(String(userModel.nowWeight))
        output.tallOutput.onNext(userModel.tall)
        
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
                self.userModel.sex = self.defaultSex[sex]
                input.exerciseInput.subscribe(onNext: {
                    exercise in
                    
                    input.goalWeight.subscribe(onNext: {
                        goal in
                        
                        
                        self.userModel.activity = Int(exercise)
                        self.userModel.goalWeight = Int(goal) ?? 0
                        self.userModel.calorie = Int(goal)! * self.defaultCalorie[sex][exercise]
                        
                        input.ageInput.subscribe(onNext: {
                            age in
                            print("age")
                            self.userModel.age = age
                            input.tallInput.subscribe(onNext: {
                                tall in print("\(tall) tall " )
                                self.userModel.tall = tall
                                input.startWeight.subscribe(onNext: {
                                    start in print("\(start) startWeight " )
                                    self.userModel.nowWeight = Int(start) ?? 0
                                    
                                    guard let uuid = UserDefaults.standard.string(forKey: "uid") else {return}
                                    
                                    self.firebaseService.updateSignUpData(model: self.userModel, key: uuid).subscribe({event in
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
    
    
    
    
    
    
    


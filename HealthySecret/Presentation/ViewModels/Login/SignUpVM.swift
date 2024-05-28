//
//  HomeVM.swift
//  HealthySecret
//
//  Created by 양승완 on 2023/11/28.
//

import Foundation
import RxCocoa
import RxSwift


class SignUpVM : ViewModel {
    
    
    var disposeBag = DisposeBag()
    
    private let signUpUseCase : SignUpUseCase
   
    
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

        var nextButtonEnable = BehaviorSubject<Bool>(value: false)
        
    }
    
    
    weak var coordinator : LoginCoordinator?
    
    
    init( coordinator : LoginCoordinator , signUpUseCase : SignUpUseCase  ){
        self.coordinator =  coordinator
        self.signUpUseCase = signUpUseCase
        
    }
    
    
    func transform(input: Input, disposeBag: DisposeBag ) -> Output {
    

        let name = UserDefaults.standard.string(forKey: "name") ?? "사용자"
        
        var SignUpModel = SignUpModel(uuid: "", name: name, tall: "" , age: "" , sex: "" , calorie: 0 , nowWeight: 0 , goalWeight: 0 , loginMethod: "" , activity: 0)
        
        
        let output = Output()

        
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
        
        input.nextButtonTapped.subscribe(onNext: { [weak self] _ in
            guard let self = self else {return}
            
            LoadingIndicator.showLoading()
            
            
            
            
            input.sexInput.subscribe(onNext: {
                sex
                in
                SignUpModel.sex = self.defaultSex[sex]
                input.exerciseInput.subscribe(onNext: {
                    exercise in
                    SignUpModel.activity = exercise
                    input.goalWeight.subscribe(onNext: {
                        goal in
                        SignUpModel.goalWeight = Int(goal)!
                        SignUpModel.calorie = Int(goal)! * self.defaultCalorie[sex][exercise]
                        
                    }).disposed(by: disposeBag)
                    
                    
                    
                }).disposed(by: disposeBag)
                
                
            }).disposed(by: disposeBag)
            
            input.ageInput.subscribe(onNext: {
                age in
                SignUpModel.age = age
            }).disposed(by: disposeBag)
            
            input.tallInput.subscribe(onNext: {
                tall in print("\(tall) tall " )
                SignUpModel.tall = tall
            }).disposed(by: disposeBag)
            
            input.startWeight.subscribe(onNext: {
                start in print("\(start) startWeight " )
                SignUpModel.nowWeight = Int(start) ?? 0
            }).disposed(by: disposeBag)
            
            
            
            
            
            self.signUpUseCase.SignUp(signUpModel: SignUpModel).subscribe{ event in
                
                switch(event){
                    
                case.completed:
                    LoadingIndicator.hideLoading()
                    self.coordinator?.login()
                case .error(_):
                    self.coordinator?.pushSignUpVC()
                }
                
                
            }.disposed(by: disposeBag)
            
                

            
        }).disposed(by: disposeBag)
       
        
        
     
        
        return output
    }
    
    
   
        
        
        
    }
    
    
    
    
    
    
    


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

        
    }
    
    
    weak var coordinator : LoginCoordinator?
    
    private var firebaseService : FirebaseService
    
    init( coordinator : LoginCoordinator , firebaseService : FirebaseService ){
        self.coordinator =  coordinator
        self.firebaseService =  firebaseService
        
    }
    
    
    func transform(input: Input, disposeBag: DisposeBag ) -> Output {
        let id : String = UserDefaults.standard.value(forKey: "email") as! String
        let password : String = UserDefaults.standard.value(forKey: "password") as! String
        let name : String = UserDefaults.standard.value(forKey: "name") as! String
        
        var userModel = UserModel(id: id, name: name ,  tall: "", age: "", sex: "", calorie: 0, nowWeight: 0, goalWeight: 0, ingredients: [], exercise: [])
        
        
        input.nextButtonTapped.subscribe(onNext: {
            
        
            
            input.sexInput.subscribe(onNext: {
                sex
                in
                userModel.sex = self.defaultSex[sex]
                input.exerciseInput.subscribe(onNext: {
                    exercise in
                    
                    input.goalWeight.subscribe(onNext: {
                        goal in
                        userModel.goalWeight = Int(goal) ?? 0
                        userModel.calorie = Int(goal)! * self.defaultCalorie[sex][exercise]
                        
                    }).disposed(by: disposeBag)
                    
                    
                    
                }).disposed(by: disposeBag)
                
                
            }).disposed(by: disposeBag)
            
            input.ageInput.subscribe(onNext: {
                age in
                userModel.age = age
            }).disposed(by: disposeBag)
            
            input.tallInput.subscribe(onNext: {
                tall in print("\(tall) tall " )
                userModel.tall = tall
            }).disposed(by: disposeBag)
            
            input.startWeight.subscribe(onNext: {
                start in print("\(start) startWeight " )
                userModel.nowWeight = Int(start) ?? 0
            }).disposed(by: disposeBag)
            
            
            self.firebaseService.signUp(email: id  , pw: password ).subscribe({event in
                switch event{
                case .completed:
                    
                    
                    
                    
                    
                    self.firebaseService.signIn(email: id, pw: password).subscribe({
                        event in
                        switch event{
                        case .completed:
                            
                            self.firebaseService.createUsers(model: userModel).subscribe({
                                event in
                                switch event{
                                case .completed:
                                    print("cim")
                                case .error(_):
                                    print("error")
                                }
                                
                                
                            }).disposed(by: disposeBag)
                            
                            
                            //self.coordinator?.login()
                        case .error(_): break
                            
                        }
                        
                        
                    }).disposed(by: disposeBag)
                    
                case .error(_): break
                    
                }
                
                
                
            }).disposed(by: disposeBag)
                

            
        }).disposed(by: disposeBag)
       
        let output = Output()
        
        
     
        
        return output
    }
    
    
   
        
        
        
    }
    
    
    
    
    
    
    


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

        var nextButtonEnable = BehaviorSubject<Bool>(value: false)
        
    }
    
    
    weak var coordinator : LoginCoordinator?
    
    private var firebaseService : FirebaseService
    
    init( coordinator : LoginCoordinator , firebaseService : FirebaseService ){
        self.coordinator =  coordinator
        self.firebaseService =  firebaseService
        
    }
    
    
    func transform(input: Input, disposeBag: DisposeBag ) -> Output {
        let loginMethod = UserDefaults.standard.string(forKey: "loginMethod") ?? ""
        let id : String = UserDefaults.standard.string(forKey: "email") ?? ""
        let password : String = UserDefaults.standard.string(forKey: "password") ?? ""
        let name : String = UserDefaults.standard.string(forKey: "name") ?? ""
        let uuid = UserDefaults.standard.string(forKey: "uid") ?? ""

        
        print("signUp uuid exist? \(uuid)")
        
        var userModel = UserModel( uuid: uuid , name: name ,  tall: "", age: "", sex: "", calorie: 0, nowWeight: 0, goalWeight: 0, ingredients: [], exercise: [] , diarys: [] , loginMethod: loginMethod )
        
        
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
        
        input.nextButtonTapped.subscribe(onNext: { _ in
            LoadingIndicator.showLoading()
            print("tappe")
            
            
            
            input.sexInput.subscribe(onNext: {
                sex
                in
                userModel.sex = self.defaultSex[sex]
                input.exerciseInput.subscribe(onNext: {
                    exercise in
                    userModel.activity = exercise
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
            
            
            if loginMethod == "kakao" || loginMethod == "normal" {
                self.firebaseService.signUp(email: id  , pw: password ).subscribe({event in
                    switch event{
                    case .completed:
                        
                        self.firebaseService.signIn(email: id, pw: password).subscribe(
                            
                            
                            
                            onCompleted: {
                                let uuid = UserDefaults.standard.string(forKey: "uid") ?? ""
                                userModel.uuid = uuid

                                
                                
                                print("login")
                                self.firebaseService.createUsers(model: userModel).subscribe({
                                    event in
                                    switch event{
                                    case .completed:
                                        
                                        LoadingIndicator.hideLoading()
                                        self.coordinator?.login()


                                    case .error(_):
                                        LoadingIndicator.hideLoading()
                                        self.coordinator?.pushSignUpVC()

                                        print("error")
                                    }
                                    
                                    
                                }).disposed(by: disposeBag)
                                


                                
                            },
                            onError: { error in
                                print(error)
                                
                            }).disposed(by: disposeBag)
                        
                      
                        
                        
                    case .error(_): break
                        
                    }
                    
                    
                    
                }).disposed(by: disposeBag)
            }
            else if(loginMethod == "apple"){
                print("apple")
                self.firebaseService.createUsers(model: userModel).subscribe({
                    event in
                    switch event{
                    case .completed:
                     
                        self.coordinator?.login()
                        LoadingIndicator.hideLoading()

                            
                      
                        
                    case .error(_):
                        LoadingIndicator.hideLoading()

                        print("error")
                    }
                    
                    
                }).disposed(by: disposeBag)
                
                
            }
            
                

            
        }).disposed(by: disposeBag)
       
        
        
     
        
        return output
    }
    
    
   
        
        
        
    }
    
    
    
    
    
    
    


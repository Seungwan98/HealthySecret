//
//  AnalyzeVM.swift
//  HealthySecret
//
//  Created by 양승완 on 2023/12/11.
//

import Foundation
import RxSwift
import RxRelay
import RxCocoa

class DiaryVM : ViewModel {
    
    
    let coordinator : DiaryCoordinator?
    
    var disposeBag = DisposeBag()
    
    let filetedArr : [Row] = []
    
    var recentAdd : [String] = []
    
    let firebaseService : FirebaseService
    
    var user : UserModel?
    
    var dic : [String:Double] = [:]
    var finalDic = [String:Any]()
    
    init( coordinator : DiaryCoordinator , firebaseService : FirebaseService ){
        self.coordinator =  coordinator
        self.firebaseService = firebaseService
        
    }
    
    var getBreakfast = BehaviorSubject<[Row]>(value: [])
    var getLunch = BehaviorSubject<[Row]>(value: [])
    var getDinner = BehaviorSubject<[Row]>(value: [])
    var getSnack = BehaviorSubject<[Row]>(value: [])
    
    struct Input {
        let viewWillApearEvent : Observable<Void>
        let mealButtonsTapped : Observable<Void>
        
        
        let calendarLabelTapped : ControlEvent<UITapGestureRecognizer>
        let execiseButtonTapped : Observable<Void>
        
        let rightBarButtonTapped : Observable<Void>
        let leftBarButtonTapped : Observable<Void>
        let detailButtonTapped : Observable<Void>
        
    }
    
    struct Output {
        let searchedIngredients = PublishSubject<[Row]>()
        let totalIngredients = PublishSubject<[String : Double]>()
        let date = BehaviorRelay<NSAttributedString>(value: (NSAttributedString()))
        
        let checkBreakFast = BehaviorRelay<Bool>(value: false)
        let checkLunch = BehaviorRelay<Bool>(value: false)
        let checkDinner = BehaviorRelay<Bool>(value: false)
        let checkSnack = BehaviorRelay<Bool>(value: false)
        
        let minuteLabel = BehaviorRelay<String>(value: "0")
        let exCalorieLabel = BehaviorRelay<String>(value: "0")
        
        let goalLabel = BehaviorRelay<String>(value:  "0")
        let leftCalorieLabel = BehaviorRelay<String>(value: "0")
        
        let IngTotalCalorie = BehaviorRelay<String>(value: "0")
        
        
        
    }
    
    
    func pushIngredients(){
        //    }
    }
 
    func transform(input: Input, disposeBag: DisposeBag) -> Output {
        let getExercises = BehaviorSubject<[Exercise]>(value: [])
        
        let output = Output()
        
        input.execiseButtonTapped.subscribe(onNext: { [weak self] _ in
            getExercises.subscribe(onNext: { exercises in
                if exercises.isEmpty{
                    self?.coordinator?.pushExerciseVC()
                    
                }else{
                    
                    self?.coordinator?.pushEditExerciseVC(exercises: exercises)
                    
                }
                
            }).disposed(by: DisposeBag())
            
            
            
            
            
        }).disposed(by: disposeBag)
        
        
    
        
        input.mealButtonsTapped.subscribe(onNext: { [weak self] _ in
            let meal : String = UserDefaults.standard.value(forKey: "meal") as! String
            switch meal {
            case "아침식사":
                self?.getBreakfast.subscribe(onNext: { arr in
                    self?.coordinator?.pushEditIngredientsVC(arr: arr)
                   
                }).disposed(by: DisposeBag())

                
            case "점심식사":
                self?.getLunch.subscribe(onNext: { arr in
                    self?.coordinator?.pushEditIngredientsVC(arr: arr)
                   
                }).disposed(by: DisposeBag())

                
            case "저녁식사":
                self?.getDinner.subscribe(onNext: { arr in
                    self?.coordinator?.pushEditIngredientsVC(arr: arr)
                   
                }).disposed(by: DisposeBag())
                
            case "간식":
                self?.getSnack.subscribe(onNext: { arr in
                    self?.coordinator?.pushEditIngredientsVC(arr: arr)
                   
                }).disposed(by: DisposeBag()  )
                
                
            default:
                break
            }
        }).disposed(by: disposeBag)
        
        input.calendarLabelTapped.when(.recognized).subscribe(onNext: {
            [weak self] _ in
            self?.coordinator?.pushCalendarVC()
            
        }).disposed(by: disposeBag)
        
  
        
        
        
        input.detailButtonTapped.subscribe(onNext: { _ in
            self.coordinator?.presentDetailView(arr: self.finalDic)
            
            
        }).disposed(by: disposeBag)
        
        
        
        
        
        
        
        
        
        
        
        input.viewWillApearEvent.subscribe(onNext: { _ in
            
            
            
            var morning : [Row] = []
            var lunch : [Row] = []
            var dinner : [Row] = []
            var snack : [Row] = []
            var total : [Row] = []
            
            
            //날짜로 검색
            var pickedDate : String = ""
            var outputDate : String = ""
            
            let imageAttach = NSTextAttachment()
            let textAttach = NSMutableAttributedString(string: "")
            imageAttach.image = UIImage(systemName: "calendar")
            imageAttach.bounds = CGRect(x: 0, y: 0, width: 14, height: 14)
            textAttach.append(NSAttributedString(attachment: imageAttach))
            
            
            
            if let date = UserDefaults.standard.string(forKey: "date"){
                
                pickedDate = date
                outputDate = CustomFormatter().formatToOutput(date: date)
                
                
                
            } else {
                
                pickedDate = CustomFormatter().getToday()
                outputDate = CustomFormatter().formatToOutput(date: pickedDate)
                
                
            }
            
            textAttach.append(NSAttributedString(string: outputDate))
            output.date.accept(textAttach)
            
            
            
            
            
            UserDefaults.standard.set(pickedDate, forKey: "date")
            
            
            
            
            
            if let uid = UserDefaults.standard.string(forKey: "uid") {
                
                
                var exTotalCal : Int = 0
                var ingTotalCal : Int = 0
                
                morning = []
                lunch =  []
                dinner =  []
                snack =  []
                total = []
                
                self.firebaseService.getDocument(key: uid).subscribe( { event in
                    
                    
                    
                    self.dic  = [ "carbohydrates" : 0.0 , "protein" : 0.0 , "province" : 0.0 , "cholesterol" : 0.0 , "fattyAcid" : 0.0 , "sugars" : 0.0 , "transFat" : 0.0 ,
                                 "sodium" : 0.0 ]
                    
                    
                    switch event{
                    case .success(let user):
                        UserDefaults.standard.set(user.dictionary, forKey: "user")
                        UserDefaults.standard.set(user.goalWeight , forKey: "weight")
                        output.goalLabel.accept(String(user.calorie))
                        
                        
                        
                        
                        let exercises = user.exercise.filter({
                            
                            $0.date == pickedDate
                            
                        })
                        
                        getExercises.onNext(exercises)
                        
                        
                        //운동
                        let totalTime = exercises.map({ $0.time }).reduce(0) { Int($0) + (Int($1) ?? 0) }
                        exTotalCal = exercises.map({ $0.finalCalorie }).reduce(0) { Int($0) + (Int($1) ?? 0) }
                        var outputTime = ""
                        if totalTime/60 > 1 {
                            outputTime = "\(totalTime/60)시간 \(totalTime%60)"
                        }else{
                            outputTime = String(totalTime)
                        }
                        output.exCalorieLabel.accept( String(exTotalCal) )
                        output.minuteLabel.accept(String(outputTime))
                        
                        
                        let ingredients = user.ingredients.filter {(
                            $0.date == pickedDate
                            
                        )}
                        
                       
                        if let ingredient = ingredients.first{
                            morning =  ingredient.morning ?? []
                            lunch =  ingredient.lunch ?? []
                            dinner =  ingredient.dinner ?? []
                            snack =  ingredient.snack ?? []
                            total = morning + lunch + dinner + snack
                            
                            self.getLunch.onNext(lunch)
                            self.getBreakfast.onNext(morning)
                            self.getDinner.onNext(dinner)
                            self.getSnack.onNext(snack)
                            
                            
                            for ingredient in total {
                                
                                
                                ingTotalCal += Int(ingredient.kcal) ?? 0
                                self.dic["carbohydrates"]! += Double(ingredient.carbohydrates) ?? 0
                                self.dic["protein"]! += Double(ingredient.protein) ?? 0
                                self.dic["province"]! += Double(ingredient.province) ?? 0
                                self.dic["cholesterol"]! += Double(ingredient.cholesterol) ?? 0
                                self.dic["fattyAcid"]! += Double(ingredient.fattyAcid) ?? 0
                                self.dic["sugars"]! += Double(ingredient.sugars) ?? 0
                                self.dic["transFat"]! += Double(ingredient.transFat) ?? 0
                                self.dic["sodium"]! += Double(ingredient.sodium) ?? 0
                                
                                
                                
                            }
                            self.finalDic = self.dic
                            self.finalDic["kcal"] = ingTotalCal
                            
                            
                            
                        }
                        
                        
                        
                        
                        
                        
                        
                        
                        
                        
               
                    case.failure(_):
                        print("error")
                        
                    }
                    
                    
                    output.IngTotalCalorie.accept(String(ingTotalCal))
                    
                    output.totalIngredients.onNext(self.dic)
                    
                    
                    
                    
                    
                    
                    
                    output.checkBreakFast.accept(!(morning.isEmpty))
                    output.checkLunch.accept(!(lunch.isEmpty))
                    output.checkDinner.accept(!(dinner.isEmpty))
                    output.checkSnack.accept(!(snack.isEmpty))
                    
                    
                    
                    
                    
                    
                    
                }).disposed(by: disposeBag)
                
            }
            
            
            
        }).disposed(by: disposeBag)
        
        
        
        
     
        
        
        
        return output
    }
    
    
    
    
   
    
    
    
}

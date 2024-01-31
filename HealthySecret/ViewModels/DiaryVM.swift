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



    
    init( coordinator : DiaryCoordinator , firebaseService : FirebaseService ){
        self.coordinator =  coordinator
        self.firebaseService = firebaseService
        
    }
    
    
    struct Input {
        let viewWillApearEvent : Observable<Void>
        let mealButtonsTapped : Observable<Void>
        let leftBarButtonTapped : ControlEvent<UITapGestureRecognizer>
        let rightBarButtonTapped : Observable<Void>
                                                

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
        let calorieLabel = BehaviorRelay<String>(value: "0")
    }
    
    
    func pushIngredients(){
        self.coordinator?.user = self.user
        self.coordinator?.pushIngredientsVC()
    }
    
    func transform(input: Input, disposeBag: DisposeBag) -> Output {
        
        let output = Output()

        input.rightBarButtonTapped.subscribe(onNext: { [weak self] _ in
            
            self?.coordinator?.pushExerciseVC()
            
            
            
        }).disposed(by: disposeBag)
        
        input.mealButtonsTapped.subscribe(onNext: { [weak self] _ in
            let disposeBag2 = DisposeBag()
            let meal : String = UserDefaults.standard.value(forKey: "meal") as! String
            switch meal {
            case "아침식사":
                output.checkBreakFast.subscribe(onNext: { [weak self]
                    valid in
                    if valid{
                        print("gotoInform")
                    }
                    else{
                        print("push")
                        self?.pushIngredients()
                    }
                    
                }).disposed(by: disposeBag2)
                
            case "점심식사":
                output.checkLunch.subscribe(onNext: { [weak self]
                    valid in
                    if valid{
                        print("gotoInform")
                    }
                    else{
                        print("push")

                        self?.pushIngredients()
                    }
                    
                }).disposed(by: disposeBag2)
                
            case "저녁식사":
                output.checkDinner.subscribe(onNext: { [weak self]
                    valid in
                    if valid{
                        print("gotoInform")
                    }
                    else{
                        print("push")

                        self?.pushIngredients()
                    }
                
                                             
                                             
                }).disposed(by: disposeBag2)
            case "간식":
                output.checkSnack.subscribe(onNext: { [weak self]
                    valid in
                    if valid{
                        print("gotoInform")
                    }
                    else{
                        print("push")

                        self?.pushIngredients()
                    }
                
                                             
                                             
                }).disposed(by: disposeBag2)
                
                
            default:
                break
            }
        }).disposed(by: disposeBag)
        
        input.leftBarButtonTapped.when(.recognized).subscribe(onNext: {
            [weak self] _ in
            print("leftBarButton")
            self?.coordinator?.pushCalendarVC()
            
        }).disposed(by: disposeBag)
        
        
        
        
        
        

        
        
        
        
        if let userEmail = UserDefaults.standard.string(forKey: "email") {
            self.firebaseService.getDocument(key: userEmail).subscribe( { event in
                
                switch event{
                case .success(let user):
                    self.recentAdd = user.recentAdd ?? []
                    
                    
                case .failure(_):
                    print("fail")
                    
                }
                
                
            }).disposed(by: disposeBag)
            
        }

        
        
        
        input.viewWillApearEvent.subscribe(onNext: { _ in
            
            
            print("appear!")
            
            var morning : [String] = []
            var lunch : [String] = []
            var dinner : [String] = []
            var total : [String] = []
            
            
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
                outputDate = self.formatToOutput(date: date)



            } else {

                pickedDate = self.getToday()
                outputDate = self.formatToOutput(date: pickedDate)


            }
            textAttach.append(NSAttributedString(string: outputDate))
            output.date.accept(textAttach)



            

            UserDefaults.standard.set(pickedDate, forKey: "date")
           
            
            
            
            
            if let userEmail = UserDefaults.standard.string(forKey: "email") {
                print("\(userEmail)   userEmail")

                               
                

                self.firebaseService.getDocument(key: userEmail).subscribe( { event in
                    
                    print("업뎃")
                    
                    
                    var dic : [String : Double] = ["kcal" : 0.0 , "carbohydrates" : 0.0 , "protein" : 0.0 , "province" : 0.0 , "cholesterol" : 0.0 , "fattyAcid" : 0.0 , "sugars" : 0.0 , "transFat" : 0.0 ,
                                                   "sodium" : 0.0 ]
                    
                    
                    switch event{
                    case .success(let user):
                        
                        UserDefaults.standard.set(user.weight , forKey: "weight")
                        
                        print(user.exercise)
                        
                        let exercises = user.exercise.filter({

                            $0.date == pickedDate
                            
                        })
                        print(exercises)
            
                       let totalTime = exercises.map({ $0.time }).reduce(0) { Int($0) + (Int($1) ?? 0) }
                       let totalCal = exercises.map({ $0.finalCalorie }).reduce(0) { Double($0) + (Double($1) ?? 0.0) }
         
                        output.calorieLabel.accept(String(totalCal))
                        output.minuteLabel.accept(String(totalTime))
                     
                        
                        let ingredients = user.ingredients.filter {(
                            $0.date == pickedDate
                            
                        )}
                        

                        if let ingredients = ingredients.first{
                            morning  = ingredients.morning ?? []
                            lunch = ingredients.lunch ?? []
                            dinner = ingredients.dinner ?? []
                            
                            //
                           
                            
                            
                            total = morning + lunch + dinner
                            
                            print("\(morning)")
           
                 
                            

                            self.firebaseService.getUsersIngredients(key: total).subscribe({
                                
                                event in
                                
                                switch event {

                                case .success(let ingredients):
                                    

                                    for ingredient in ingredients {
                                        dic["kcal"]! += Double(ingredient.kcal) ?? 0
                                        dic["carbohydrates"]! += Double(ingredient.carbohydrates) ?? 0
                                        dic["protein"]! += Double(ingredient.protein) ?? 0
                                        dic["province"]! += Double(ingredient.province) ?? 0
                                        dic["cholesterol"]! += Double(ingredient.cholesterol) ?? 0
                                        dic["fattyAcid"]! += Double(ingredient.fattyAcid) ?? 0
                                        dic["sugars"]! += Double(ingredient.sugars) ?? 0
                                        dic["transFat"]! += Double(ingredient.transFat) ?? 0
                                        dic["sodium"]! += Double(ingredient.sodium) ?? 0
                                        
                                    }
                                    
                                    dic = dic.mapValues{ values in
                                        return self.setDigit(data: values)
                                    }
                                    
                                    
                                    output.totalIngredients.onNext(dic)

                                    print("if")

                                    
                                    
                                    
                                case .failure(_):
                                    print("fail to load")
                               

                                }
                                
                                
                                
                                

                            }).disposed(by: disposeBag)


                            
                        }else{
                            
                            
                            output.totalIngredients.onNext(dic)

                        }
                        output.checkBreakFast.accept(!(morning.isEmpty))
                        output.checkLunch.accept(!(lunch.isEmpty))
                        output.checkDinner.accept(!(dinner.isEmpty))
                        
                        


                    case .failure(_):
                        print("fail")
                        
                    }
                    



                }).disposed(by: disposeBag)
                
            }
            
            print(morning)
           
            
        }).disposed(by: disposeBag)
        
       
        
        


        
        
        return output
    }
    
    func setDigit(data : Double) -> Double{
        let digit: Double = pow(10, 3)
        return round(data * digit) / digit
    }
    
    
    func formatToOutput(date : String) -> String{
        let formatter = DateFormatter()
        let outputDate : String
        let splitedDate = date.split(separator: "-")
        formatter.dateFormat = "yyyy-MM-dd"
        let todayDate = formatter.string(from: Date())
        let splitedTodayDate = todayDate.split(separator: "-")
                  

        
        if ( date == todayDate ){
            outputDate = "오늘"
        }
        else if (   Int(splitedDate[2])!  == Int(splitedTodayDate[2])! - 1 ){
            outputDate = "어제"
        }
        else if (   Int(splitedDate[2])!  == Int(splitedTodayDate[2])! + 1 ){
            outputDate = "내일"
        }
        else{
            outputDate = splitedDate[1] + "월" + splitedDate[2] + "일"
        }
        return outputDate
    }
    
    
    func getToday() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yy-MM-dd"
        return formatter.string(from: Date())

      
        
    }
    
    
    
}

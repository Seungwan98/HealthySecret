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

class DiaryVM: ViewModel {
    
    
    let coordinator: DiaryCoordinator?
    
    var disposeBag = DisposeBag()
    
    let filetedArr: [Row] = []
    
    var recentAdd: [String] = []
        
    var user: UserModel?
    
    private let diaryUseCase: DiaryUseCase
    
    
    init( coordinator: DiaryCoordinator, diaryUseCase: DiaryUseCase) {
        self.coordinator =  coordinator
        self.diaryUseCase = diaryUseCase
        
    }
    
   
    
    struct Input {
        let viewWillApearEvent: Observable<Void>
        let mealButtonsTapped: Observable<Void>
        
        
        let calendarLabelTapped: ControlEvent<UITapGestureRecognizer>
        let execiseButtonTapped: Observable<Void>
        
        let rightBarButtonTapped: Observable<Void>
        let leftBarButtonTapped: Observable<Void>
        let detailButtonTapped: Observable<Void>
        
    }
    
    struct Output {
        let totalIngredients = PublishSubject<IngredientsModel>()
        let date = BehaviorRelay<NSAttributedString>(value: (NSAttributedString()))
        
        let checkBreakFast = BehaviorRelay<Bool>(value: false)
        let checkLunch = BehaviorRelay<Bool>(value: false)
        let checkDinner = BehaviorRelay<Bool>(value: false)
        let checkSnack = BehaviorRelay<Bool>(value: false)
        
        let minuteLabel = BehaviorRelay<String>(value: "0")
        let exCalorieLabel = BehaviorRelay<String>(value: "0")
        
        let goalLabel = BehaviorRelay<String>(value: "0")
        let leftCalorieLabel = BehaviorRelay<String>(value: "0")
        
        let ingTotalCalorie = BehaviorRelay<String>(value: "0")
        let alert = PublishSubject<String>()
        
        
        
    }
    
   
 
    func transform(input: Input, disposeBag: DisposeBag) -> Output {
        
        let output = Output()
        
        
        
        input.execiseButtonTapped.subscribe(onNext: { [weak self] _ in
            guard let self = self else {return}
            self.diaryUseCase.getExercises.subscribe(onNext: { exercises in
             
                    
                self.coordinator?.startExerciseCoordinator(exercises: exercises)
                    
                
                
            }).disposed(by: DisposeBag())
            
            
            
            
            
        }).disposed(by: disposeBag)
        
        self.diaryUseCase.getMorning.map { !$0.isEmpty }.bind(to: output.checkBreakFast).disposed(by: disposeBag)
        self.diaryUseCase.getLunch.map { !$0.isEmpty }.bind(to: output.checkLunch).disposed(by: disposeBag)
        self.diaryUseCase.getDinner.map { !$0.isEmpty }.bind(to: output.checkDinner).disposed(by: disposeBag)
        self.diaryUseCase.getSnack.map { !$0.isEmpty }.bind(to: output.checkSnack).disposed(by: disposeBag)
    
    
        
        input.mealButtonsTapped.subscribe(onNext: { [weak self] _ in
            guard let self = self else {return}
            let meal: String = UserDefaults.standard.value(forKey: "meal") as! String
            switch meal {
            case "아침식사":
                self.diaryUseCase.getMorning.subscribe(onNext: { arr in
                    self.coordinator?.pushEditIngredientsVC(arr: arr)
                   
                }).disposed(by: DisposeBag())

                
            case "점심식사":
                self.diaryUseCase.getLunch.subscribe(onNext: { arr in
                    self.coordinator?.pushEditIngredientsVC(arr: arr)
                   
                }).disposed(by: DisposeBag())

                
            case "저녁식사":
                self.diaryUseCase.getDinner.subscribe(onNext: { arr in
                    self.coordinator?.pushEditIngredientsVC(arr: arr)
                   
                }).disposed(by: DisposeBag())
                
            case "간식":
                self.diaryUseCase.getSnack.subscribe(onNext: { arr in
                    self.coordinator?.pushEditIngredientsVC(arr: arr)
                   
                }).disposed(by: DisposeBag()  )
                
                
            default:
                break
            }
        }).disposed(by: disposeBag)
        
        input.calendarLabelTapped.when(.recognized).subscribe(onNext: { [weak self] _ in
            guard let self = self else {return}
            
            self.coordinator?.pushCalendarVC()
            
        }).disposed(by: disposeBag)
        
  
        
        
        
        input.detailButtonTapped.subscribe(onNext: { [weak self] _ in
            guard let self = self else {return}
            self.coordinator?.presentDetailView(models: self.diaryUseCase.finalIngredientsModel! )
            
            
        }).disposed(by: disposeBag)
        
        
        
        
        
        
        
        
        
        
        
        input.viewWillApearEvent.subscribe(onNext: { _ in
            
            self.coordinator?.refreshChild()
     
            
            
            // 날짜로 검색
            var pickedDate: String = ""
            var outputDate: String = ""
            
            let imageAttach = NSTextAttachment()
            let textAttach = NSMutableAttributedString(string: "")
            imageAttach.image = UIImage(systemName: "calendar")
            imageAttach.bounds = CGRect(x: 0, y: 0, width: 14, height: 14)
            textAttach.append(NSAttributedString(attachment: imageAttach))
            
            
            
            if let date = UserDefaults.standard.string(forKey: "date") {
                
                pickedDate = date
                outputDate = CustomFormatter().formatToOutput(date: date)
                
                
                
            } else {
                
                pickedDate = CustomFormatter().getToday()
                outputDate = CustomFormatter().formatToOutput(date: pickedDate)
                
                
            }
            
            UserDefaults.standard.set(pickedDate, forKey: "date")
            textAttach.append(NSAttributedString(string: outputDate))
            output.date.accept(textAttach)
            
            
            self.diaryUseCase.getUser(pickedDate: pickedDate ).subscribe({  [weak self] event in guard let self = self else {return}
                switch event {
                case.success(let total):
                    
                    
                    
                    self.diaryUseCase.getUsersGoalCal.bind(to: output.goalLabel ).disposed(by: disposeBag)
                    self.diaryUseCase.getExTime.bind(to: output.minuteLabel ).disposed(by: disposeBag)
                    self.diaryUseCase.getExCalorie.bind(to: output.exCalorieLabel).disposed(by: disposeBag)
                 
                    
                    output.ingTotalCalorie.accept(String(total.calorie))
                    output.totalIngredients.onNext(total)
                    

                    
                    
                    
                case.failure(let err):
                    print(err)
                }
                
                
                
            }).disposed(by: disposeBag)
            
            
            
            
            
            
            
            
         
            
            
        }).disposed(by: disposeBag)
        
        
        
        
     
        
        
        
        return output
    }
    
    
    
    
   
    
    
    
}

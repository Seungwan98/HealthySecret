//
//  HomeVM.swift
//  HealthySecret
//
//  Created by 양승완 on 2023/11/28.
//

import Foundation
import RxCocoa
import RxSwift


class CalendarVM : ViewModel {
    
    
    var disposeBag = DisposeBag()
    var disposeBag1 = DisposeBag()
    
    var diarys : [Diary] = []
    
    var pickDate : String?
    
    var selectingDate = BehaviorSubject<String>(value: "")
    
    struct Input {
        let viewWillApearEvent : Observable<Void>
        let moveButtonTapped : Observable<Void>
        let writeButtonTapped : Observable<Void>
        let selectingDate : Observable<Date>
        
        
    }
    
    struct Output {
        var outputDate = BehaviorSubject<String>(value : "")
        var outputTodayDiary = BehaviorSubject<String>(value : "")
    }
    
    
    weak var coordinator : CalendarCoordinator?
    
    private var firebaseService : FirebaseService
    
    init( coordinator : CalendarCoordinator , firebaseService : FirebaseService ){
        self.coordinator =  coordinator
        self.firebaseService =  firebaseService
        
    }
    
    
    func transform(input: Input, disposeBag: DisposeBag ) -> Output {
        let output = Output()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let dayFormatter = DateFormatter()
        
        input.viewWillApearEvent.subscribe(onNext: { 
            self.firebaseService.getDocument(key: UserDefaults.standard.string(forKey: "uid") ?? "").subscribe( { event in
                switch event{
                case.success(let user):
                    self.diarys = user.diarys
                    
                    input.selectingDate.subscribe(onNext : {
                        date in
                        
                        dayFormatter.dateFormat = "M.dd EEEE "
                        dayFormatter.locale = Locale(identifier:"ko_KR")
                    
                        output.outputDate.onNext(dayFormatter.string(from: date))
                        print("check")
                        self.pickDate = (dateFormatter.string(from: date))
                        
                        let todayDiary = self.diarys.filter{
                            $0.date == self.pickDate
                        }
                        
                        output.outputTodayDiary.onNext( todayDiary.first?.diary ?? "" )

                    
                        
                    input.moveButtonTapped.subscribe(onNext: { [weak self] _ in
                        UserDefaults.standard.set( dateFormatter.string(from: date) , forKey: "date")
                        self?.coordinator?.BacktoDiaryVC()
                      
                        
                    }).disposed(by: disposeBag)
                    
                        
                         
                     }).disposed(by: disposeBag)
                    
                    
                case.failure(_):
                    print("error")
                }
                
                
                
            }).disposed(by: disposeBag)
            
        }).disposed(by: disposeBag)
      
        
   
     
        
        input.writeButtonTapped.subscribe(onNext: { _ in
     
            
         

            
            self.coordinator?.pushAddDiaryVC(pickDate: self.pickDate ?? "" , diarys: self.diarys)
            
            
//            let multiArray = numArray.map({ (number: Int) -> Int in
//                return number * 2
//            })

            
            
        }).disposed(by: disposeBag)
        
        return output
    }
    
    
    
    
    struct AddInput {
        let addButtonTapped : Observable<Void>
        let diaryText : Observable<String?>
    
        
    }
    
    struct AddOutput {
        var beforeDiary = BehaviorSubject<String>(value: "")
        
    }
    
    func addTransform(input: AddInput, disposeBag1: DisposeBag ) -> AddOutput {
        
        let output = AddOutput()
        
        
        
        input.addButtonTapped.subscribe(onNext: { _ in
            
            input.diaryText.subscribe(onNext: { text in
                let text = text ?? ""
                self.selectingDate.subscribe(onNext: { date in
                   
                    print(self.diarys)
                    let diary = Diary(date:  self.pickDate ?? "", diary: text )

                    for i in 0..<self.diarys.count {
                        if(self.diarys[i].date == self.pickDate){
                            self.diarys.remove(at: i)
                        }
                        
                        
                    }
                    self.diarys.append(diary)
                    
                    
                    
                    self.firebaseService.updateDiary(diary: self.diarys, key: UserDefaults.standard.string(forKey: "email") ?? "").subscribe{
                        
                        event in
                        switch(event){
                        case.completed: self.coordinator?.navigationController.popViewController(animated: false)

                           
                            
                            
                        case.error(_):
                            print("error")
                        }
                        
                    }.disposed(by: disposeBag1)
                    
                    
                }).disposed(by: disposeBag1)
                
  
                
            }).disposed(by: disposeBag1)
            
        
            
           
            
            
        }).disposed(by: disposeBag1)
        
        return output
        
    }
    
}

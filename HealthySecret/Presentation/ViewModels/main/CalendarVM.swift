//
//  HomeVM.swift
//  HealthySecret
//
//  Created by 양승완 on 2023/11/28.
//

import Foundation
import RxCocoa
import RxSwift


class CalendarVM: ViewModel {
    
    weak var coordinator: CalendarCoordinator?
    
    private let calendarUseCase: CalendarUseCase
    var disposeBag = DisposeBag()
    var disposeBag1 = DisposeBag()
    
    var diarys: [Diary] = []
    
    var pickDate: String?
    
    var selectingDate = BehaviorSubject<String>(value: "")
    
    
    init( coordinator: CalendarCoordinator, calendarUseCase: CalendarUseCase ) {
        self.coordinator =  coordinator
        self.calendarUseCase =  calendarUseCase
        
    }
    
    
    struct Input {
        let viewWillApearEvent: Observable<Void>
        let moveButtonTapped: Observable<Void>
        let writeButtonTapped: Observable<Void>
        let selectingDate: Observable<Date>
        
        
    }
    
    struct Output {
        var outputDate = BehaviorSubject<String>(value: "")
        var outputTodayDiary = BehaviorSubject<String>(value: "")
    }
    
    
    
    
    
    func transform(input: Input, disposeBag: DisposeBag ) -> Output {
        let output = Output()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let dayFormatter = DateFormatter()
        
        input.viewWillApearEvent.subscribe(onNext: { [weak self] _ in guard let self = self else {return}
            self.calendarUseCase.getDiarys().subscribe({ event in
                switch event {
                case.success(let diarys):
                    self.diarys = diarys
                    
                    input.selectingDate.subscribe(onNext: { date in
                        
                        dayFormatter.dateFormat = "M.dd EEEE "
                        dayFormatter.locale = Locale(identifier: "ko_KR")
                        self.pickDate = (dateFormatter.string(from: date))
                        
                        let todayDiary = diarys.filter {
                            
                            $0.date == self.pickDate!
                        }
                        
                        output.outputDate.onNext(dayFormatter.string(from: date))
                        output.outputTodayDiary.onNext( todayDiary.first?.diary ?? "" )
                        
                        
                        
                        
                        input.moveButtonTapped.subscribe(onNext: { [weak self] _ in
                            UserDefaults.standard.set( dateFormatter.string(from: date), forKey: "date")
                            self?.coordinator?.BacktoDiaryVC()
                            
                            
                        }).disposed(by: disposeBag)
                        
                        
                        
                        
                        
                        
                    }).disposed(by: disposeBag)
                    
                    
                case.failure(_):
                    print("error")
                }
                
                
                
            }).disposed(by: disposeBag)
            
        }).disposed(by: disposeBag)
        
        
        
        
        
        input.writeButtonTapped.subscribe(onNext: { [weak self]  _ in
            guard let self = self, let pickDate = self.pickDate else {return}
            
            self.coordinator?.pushAddDiaryVC(pickDate: pickDate, diarys: self.diarys)
            
            
        }).disposed(by: disposeBag)
        
        return output
    }
    
    
    
    
    struct AddInput {
        let addButtonTapped: Observable<Void>
        let diaryText: Observable<String?>
        
        
    }
    
    struct AddOutput {
        var beforeDiary = BehaviorSubject<String>(value: "")
        var writedText = BehaviorSubject<String>(value: "")
    }
    
    func addTransform(input: AddInput, disposeBag1: DisposeBag ) -> AddOutput {
        
        let output = AddOutput()
        
        self.selectingDate.subscribe(onNext: { _ in
            
            for i in 0..<self.diarys.count {
                if self.diarys[i].date == self.pickDate {
                    output.writedText.onNext(self.diarys[i].diary)
                }
                
                
            }
            
            input.addButtonTapped.subscribe(onNext: { [weak self] _ in guard let self = self else {return}
                
                input.diaryText.subscribe(onNext: { text in
                    guard let text = text else {return}
                    
                    
                    
                    let diary = Diary(date: self.pickDate ?? "", diary: text )
                    
                    for i in 0..<self.diarys.count {
                        if self.diarys[i].date == self.pickDate {
                            self.diarys.remove(at: i)
                        }
                        
                        
                    }
                    self.diarys.append(diary)
                    
                    
                    self.calendarUseCase.updateDiary(diarys: self.diarys).subscribe({ event in
                        switch event {
                        case.completed: self.coordinator?.navigationController.popViewController(animated: false)
                            
                            
                            
                        case.error(_):
                            print("error")
                        }
                        
                        
                        
                    }).disposed(by: disposeBag1)
                    
                }).disposed(by: disposeBag1)
                
                
                
            }).disposed(by: disposeBag1)
            
            
            
            
            
            
        }).disposed(by: disposeBag1)
        
        return output
        
    }
    
}

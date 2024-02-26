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
    
    
    var selectingDate = PublishSubject<Date>()
    
    struct Input {
        let moveButtonTapped : Observable<Void>
        let selectingDate : Observable<Date>
    }
    
    struct Output {
        var outputDate = BehaviorSubject<String>(value : "")
        var outputTodayMemo = BehaviorSubject<String>(value : "")
        
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
        input.selectingDate.subscribe(onNext : {
            date in
            
          
            dayFormatter.dateFormat = "M.dd EEEE "
            print("\(date)   date")
        
            output.outputDate.onNext(dayFormatter.string(from: date))
            print(dateFormatter.string(from: date))
        
        input.moveButtonTapped.subscribe(onNext: { [weak self] _ in
            UserDefaults.standard.set( dateFormatter.string(from: date) , forKey: "date")
            self?.coordinator?.BacktoDiaryVC()
          
            
        }).disposed(by: disposeBag)
        
            
             
         }).disposed(by: disposeBag)
     
        
        return output
    }
    
    
    
    
    
    
    
}

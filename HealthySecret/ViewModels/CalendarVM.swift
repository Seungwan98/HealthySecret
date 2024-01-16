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
    
    var user : UserModel?
    
    var selectingDate = PublishSubject<String>()
    
    struct Input {
        let rightBarButtonTapped : Observable<Void>
        let selectingDate : Observable<String>
    }
    
    struct Output {

        
    }
    
    
    weak var coordinator : CalendarCoordinator?
    
    private var firebaseService : FirebaseService
    
    init( coordinator : CalendarCoordinator , firebaseService : FirebaseService ){
        self.coordinator =  coordinator
        self.firebaseService =  firebaseService
        
    }
    
    
    func transform(input: Input, disposeBag: DisposeBag ) -> Output {
        let output = Output()
        
        input.selectingDate.bind(to: self.selectingDate).disposed(by: disposeBag)
        self.selectingDate.subscribe(onNext : {
     
            date in
        
        
        input.rightBarButtonTapped.subscribe(onNext: { [weak self] _ in
            print(date)
            UserDefaults.standard.set( date , forKey: "date")
            self?.coordinator?.BacktoDiaryVC()
            
        }).disposed(by: disposeBag)
        
            
             
         }).disposed(by: disposeBag)
     
        
        return output
    }
    
    
    
    
    
    
    
}

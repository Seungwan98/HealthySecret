//
//  HomeVM.swift
//  HealthySecret
//
//  Created by 양승완 on 2023/11/28.
//

import Foundation
import RxCocoa
import RxSwift


class HomeVM: ViewModel {
    // var coreMotionService = CoreMotionService.shared
    
    var disposeBag = DisposeBag()
    
    var user: UserModel?
    
    struct Input {
        let logoutButtonTapped: Observable<Void>
        let rightBarButtonTapped: Observable<Void>
        
    }
    
    struct Output {
        let testLabel = BehaviorSubject<String>(value: "")
        var outputImage = BehaviorSubject<Data?>(value: nil)
        
    }
    
    
    weak var coordinator: HomeCoordinator?
    
    private var firebaseService: FirebaseService
    
    init( coordinator: HomeCoordinator, firebaseService: FirebaseService ) {
        self.coordinator =  coordinator
        self.firebaseService =  firebaseService
        
    }
    
    
    
    func transform(input: Input, disposeBag: DisposeBag ) -> Output {
        
        
        
        
        
        let output = Output()
        
        
        
        input.logoutButtonTapped.subscribe(onNext: { [weak self] _ in
            self?.firebaseService.signOut().subscribe(onCompleted: {
                print("logoutButton")
                
                self?.coordinator?.logout()
            }).disposed(by: disposeBag)
            
        }).disposed(by: disposeBag)
        
        input.rightBarButtonTapped.subscribe(onNext: { [weak self] _ in
            CoreMotionService.getSteps.subscribe(onNext: { step in
                _ = CoreMotionService.shared
                
                output.testLabel.onNext(step ?? "0")
                
            }).disposed(by: self!.disposeBag)
            
            
            
        }).disposed(by: disposeBag)
        
        
        
        
        
        
        
        return output
    }
    
    
    
    
    
    
    
}

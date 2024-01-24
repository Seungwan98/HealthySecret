//
//  HomeVM.swift
//  HealthySecret
//
//  Created by 양승완 on 2023/11/28.
//

import Foundation
import RxCocoa
import RxSwift


class HomeVM : ViewModel {
    
    
    var disposeBag = DisposeBag()
    
    var user : UserModel?
    
    struct Input {
        let logoutButtonTapped : Observable<Void>
        let rightBarButtonTapped : Observable<Void>
        
    }
    
    struct Output {
        let testLabel = PublishSubject<[String]>()
        
    }
    
    
    weak var coordinator : HomeCoordinator?
    
    private var firebaseService : FirebaseService
    
    init( coordinator : HomeCoordinator , firebaseService : FirebaseService ){
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
            print("rightBarButton")
            self?.coordinator?.user = self?.user
            self?.coordinator?.pushIngredientsVC()
            
        }).disposed(by: disposeBag)
        
        
        if let userEmail = UserDefaults.standard.string(forKey: "email") {
            self.firebaseService.getDocument( key: userEmail ).subscribe({
                event in
                switch event {
                case.success(let user):
                    output.testLabel.onNext(user.recentSearch ?? [])
                    
                    
                case .failure(_):
                    print("fail")
                }
                
            }).disposed(by: disposeBag)
            
        }
        
        return output
    }
    
    
    
    
    
    
    
}

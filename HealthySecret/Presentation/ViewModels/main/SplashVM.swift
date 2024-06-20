//
//  SplashVM.swift
//  MeloMeter
//
//  Created by 양승완 on 2024/05/17.
//

import Foundation
import FirebaseAuth
import RxCocoa
import RxRelay
import RxSwift



final class SplashVM {

  
    weak var coordinator: AppCoordinator?
    private let disposeBag = DisposeBag()
    private let loginUseCase: LoginUseCase
    
    init(
        coordinator: AppCoordinator,
        loginUseCase: LoginUseCase
    ) {
        self.coordinator = coordinator
        self.loginUseCase = loginUseCase
    }
    
    var freeze = PublishSubject<Bool>()
   
    
    func selectStart() {
        
        freeze.bind(to: self.freeze).disposed(by: disposeBag)
        
        
        self.setStart().subscribe({ event in
            
            switch event {
            case.success(let select):
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2) {
                    
                    switch(select) {
                    case(.logIn):
                        self.coordinator?.showLoginViewController()
                    case(.signUp):
                        self.coordinator?.showSignUpVC()
                        
                    case(.main):
                        self.coordinator?.showMainViewController()
                        
                        
                        
                    default:
                        self.coordinator?.showLoginViewController()
                        
                    }
                    
                }
                
            case.failure(let err):
                break
            }
            
            
        }).disposed(by: disposeBag)
        
        
    }
    
    func setStart() -> Single<LoginStatus> {
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        
        UserDefaults.standard.set(formatter.string(from: Date()), forKey: "date")
        
        return self.loginUseCase.loginStatus()
            
        }
        
        
}

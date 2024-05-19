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

    private let disposeBag = DisposeBag()
    weak var coordinator: AppCoordinator?
    private var firebaseService: FirebaseService
    init(
        coordinator: AppCoordinator,
        firebaseService: FirebaseService
    ) {
        self.coordinator = coordinator
        self.firebaseService = firebaseService
    }
    
    var freeze = PublishSubject<Bool>()
   
    
    func selectStart(){
        
        
        self.setStart().subscribe({ event in
            
            switch(event){
            case.success(let select):
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2) {
                    
                    switch(select){
                    case("login"):
                        self.coordinator?.showLoginViewController()
                    case("signUp"):
                        self.coordinator?.showSignUpVC()
                        
                    case("main"):
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
    
    func setStart() -> Single<String>{
        
        return Single.create{ single in
            
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd"
            
            UserDefaults.standard.set(formatter.string(from: Date()), forKey: "date")
            
            
            
            self.firebaseService.getCurrentUser().subscribe { event in
                switch event {
                    
                case .success(let user):
                    print("success")
                    var email : String?
                    var uid : String?
                    
                    if user.uid.isEmpty {
                        
                        print("sign Out")
                        
                        self.firebaseService.signOut().subscribe({ event in
                            switch(event) {
                            case.completed:
                                
                                single(.success("login"))
                                
                                
                            case.error(let err):
                                print(err)
                            }
                            
                            
                        }).disposed(by: self.disposeBag)
                        

                    }else{
                        email = user.email
                        uid = user.uid
                        
                    }
                    
                 
                   
                    
                    self.firebaseService.getDocument(key: uid ?? "").subscribe{ event in
                        switch event{
         
                            
                        case .success(let firUser):
                        
                        
                            if( !CustomFormatter.shared.dateCompare(targetString: firUser.freezeDate ?? "")  ) {
                                self.freeze.onNext(true)
                                single(.success("login"))

                               

                            }else{
                                
                                print("getFure")
                                
                                UserDefaults.standard.set( email , forKey: "email")
                                UserDefaults.standard.set( uid , forKey: "uid")
                                
                                
                                UserDefaults.standard.set( firUser.name  , forKey: "name")
                                UserDefaults.standard.set( firUser.loginMethod , forKey: "loginMethod")
                                UserDefaults.standard.set( firUser.profileImage  , forKey: "profileImage")
                                
                                
                                single(.success("main"))
                            }
                           
                        case .failure(_):
                            print("fail lets sign Out")
                          
                            
                           

                            self.firebaseService.signOut().subscribe({ event in
                                switch(event){
                                case.completed:
                                    
                                        single(.success("signUp"))
                                    
                                case.error(_):
                                    print("err")
                                }
                                
                            }).disposed(by: self.disposeBag)
                           
                            
                        }
                        
                            
                    }.disposed(by: self.disposeBag)
                    
                    
                case .failure(let error):
                    print("fail lets Login \(error)")
                    self.coordinator?.showLoginViewController()

                
                }
            }.disposed(by: self.disposeBag)
            
            return Disposables.create()

        }
            
        }
        
        
}

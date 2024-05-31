//
//  UserRepository.swift
//  HealthySecret
//
//  Created by 양승완 on 5/27/24.
//

import Foundation
import RxSwift
import FirebaseAuth

class  DefaultLoginRepository : LoginRepository {
 
   
    
    private let firebaseService : FirebaseService
    private let appleService : AppleService
    private let kakaoService : KakaoService
    
    private let disposeBag = DisposeBag()
    
    init( firebaseService : FirebaseService , appleService : AppleService , kakaoServcie : KakaoService  ) {
        
        
        self.firebaseService = firebaseService
        self.appleService = appleService
        self.kakaoService = kakaoServcie
        
        
    }
    func login() -> Completable {
        
        return Completable.create{ completable in
            guard let loginMethod = UserDefaults.standard.string(forKey: "loginMethod") else { return Disposables.create() }

            
            if(loginMethod == "kakao"){
                self.kakaoService.kakaoLogin().subscribe({ event in
                    switch event{
                    case .success( let inform ):
                        
                        UserDefaults.standard.set(inform["email"], forKey: "email")
                        UserDefaults.standard.set(inform["name"], forKey: "name")
                        UserDefaults.standard.set(inform["pw"], forKey: "password")

                    
                        self.firebaseService.signIn(email:inform["email"] ?? "" ,
                                                     pw:inform["pw"] ?? "" ).subscribe({ event in
                           
                            
                            print("signIn \(event)")
                            completable(event)

                            
                        }).disposed(by: self.disposeBag)
                        
                        
                   
                    case .failure(let err):
                        completable(.error(err))
                    }
                    
                    
                }).disposed(by: self.disposeBag)
                
            }
            
            
           
            
            
            
            return Disposables.create()
        }
        
        
    }
    
    func login(credential : OAuthCredential) -> Completable {
            
        return Completable.create{ [weak self] completable in
         
            guard let loginMethod = UserDefaults.standard.string(forKey: "loginMethod") , let self = self else {return Disposables.create()  }
            
            if(loginMethod == "apple"){
                
                self.firebaseService.signInCredential(credential: credential).subscribe({ event in
                    
                    completable(event)
                    
                    
                    
                }).disposed(by: disposeBag)
            }
            
            return Disposables.create()
        }
    }
    
    
  
    func signUp(email : String , pw : String) -> Completable {
        
        return self.firebaseService.signUp(email: email, pw: pw)
    }
    
    func getCurrentUser() -> Single<User> {
        
        return self.firebaseService.getCurrentUser()
    }
    
    func signOut() -> Completable {
        
        return self.firebaseService.signOut()
    }
    
    func kakaoSignOut() -> Completable {
        
        return self.kakaoService.kakaoSignOut()
    }
    
    func kakaoGetToken() -> Single<String> {
  
        return self.kakaoService.kakaoGetToken()
    }
    

    func deleteAccount(credential: AuthCredential) -> Completable {
        return self.firebaseService.deleteAccount(credential: credential)
    }
    
    func kakaoSecession() -> Completable {
        return self.kakaoService.kakaoSessionOut()
    }
    
    func appleSecession(refreshToken : String , userId : String) -> Completable {
        return self.appleService.removeAccount(refreshToken: refreshToken , userId: userId )
    }
    
   
  
    
    
    
    
}

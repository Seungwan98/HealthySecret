//
//  SignUpUseCase.swift
//  HealthySecret
//
//  Created by 양승완 on 5/27/24.
//

import Foundation
import RxSwift

class ProfileUseCase  {
    
    
    
    
    private let disposeBag = DisposeBag()
    private let userRepository : UserRepository
    private let feedRepository : FeedRepository
    private let loginRepository : LoginRepository
    
    init( userRepository : UserRepository , feedRepository : FeedRepository , loginRepository : LoginRepository){
        self.userRepository = userRepository
        self.feedRepository = feedRepository
        self.loginRepository = loginRepository
    }
    
    
    func getUser() -> Single<UserModel>{

        return userRepository.getUser()
    }
    
    
    func getFeeds(uid : String) -> Single<[FeedModel]>{
        
        return Single.create{ [weak self] single in
            guard let self else {single(.failure(CustomError.isNil))  
                return Disposables.create()}
            
            feedRepository.getFeedsUid(uid: uid).subscribe({ event in
                switch(event){
                case .success(let feed):
                    
                    self.userRepository.getUser(uid: feed.uuid).subscribe({ event in
                        
                        switch(event){
                        case .success(let user):
                            single( .success(feed.toDomain(nickname: user.name  , profileImage: user.profileImage ?? "" )))
                        case .failure(let err):
                            single( .failure(err))
                        }
                        
                    }).disposed(by: self.disposeBag)
                    
                    
                case .failure(let err):
                    single( .failure(err))
                }
                
                
            }).disposed(by: disposeBag)
            return Disposables.create()
        }
        

    }
    
    func signOut() -> Completable{
            
            if( UserDefaults.standard.string(forKey: "loginMethod") == "kakao" ){
                
                self.loginRepository.kakaoSignOut().subscribe{ event in
                    switch(event){
                    case.completed:
                        print("completedkakao")
                        
                        
                    case.error(_):
                        print("kako err")

                        
                    }

                }.disposed(by: disposeBag)
                
                
            }
            
        
       
        
        return self.loginRepository.signOut()
        
    }
        
        
        
        
        
    
}

//
//  SignUpUseCase.swift
//  HealthySecret
//
//  Created by 양승완 on 5/27/24.
//

import Foundation
import RxSwift

public enum FollowType {
    case followings
    case followers
   
}

class FollowUseCase {
  
    
    
    
    private let disposeBag = DisposeBag()
    
    private let followsRepository: FollowsRepository
    private let userRepository: UserRepository
    
    init( userRepository: UserRepository, followsRepository: FollowsRepository ) {
        self.userRepository = userRepository
        self.followsRepository = followsRepository
        
        
    }
    
    
    func getFollows(uid: String) -> Single< [FollowType: [UserModel]]> {
        var followDic = [FollowType: [UserModel]]()
        return Single.create { [weak self] single in
            guard let self else {
                single(.failure(CustomError.isNil))
                return Disposables.create() }
            self.userRepository.getUser(uid: uid).subscribe({ event in
                switch event {
                    
                case .success(let user):
                   
                    
                    self.followsRepository.getFollowsLikes(uid: user.followers ?? []).subscribe({ event in
                        switch event {
                        case .success(let followers):
                            followDic[ .followers ] = followers
                            self.followsRepository.getFollowsLikes(uid: user.followings ?? []).subscribe({ event in
                                switch event {
                                case .success(let followings):
                                    followDic[ .followings ] = followings
                                    print("\(followDic)followDic")
                                    single( .success(followDic))
                                case .failure(let err):
                                    print("\(err)errr")
                                    single(.failure(err))

                                    
                                }
                            }).disposed(by: self.disposeBag)
                            
                        case.failure(let err):
                            print("\(err) errrr")
                            single(.failure(err))
                        }
                        
                        
                        
                    }).disposed(by: self.disposeBag)
                    
                    
                    
                case .failure(let err):
                    print("\(err) errrrrrr")

                    single(.failure(err))
                }
                
                
            }).disposed(by: disposeBag)
            
            return Disposables.create()
        }
    }
    
    
    func updateFollowers( opponentUid: String, follow: Bool) -> Completable {
        guard let uid = UserDefaults.standard.string(forKey: "uid") else {return Completable.error(CustomError.isNil)}
        return self.followsRepository.updateFollowers(ownUid: uid, opponentUid: opponentUid, follow: follow)
    }
    
        
    
        
        
        
        
        
    
}

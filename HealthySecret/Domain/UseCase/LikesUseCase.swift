//
//  SignUpUseCase.swift
//  HealthySecret
//
//  Created by 양승완 on 5/27/24.
//

import Foundation
import RxSwift

class LikesUseCase  {
  
    
    
    
    private let disposeBag = DisposeBag()
    
    private let followsRepository : FollowsRepository
    private let feedRepository : FeedRepository
    
    init( feedRepository : FeedRepository , followsRepository : FollowsRepository ){
        self.feedRepository = feedRepository
        self.followsRepository = followsRepository
        
        
    }
    
    
    
    
        
    func updateFollowers( opponentUid: String  , follow: Bool) -> Completable{
        guard let uid = UserDefaults.standard.string(forKey: "uid") else {return Completable.error(CustomError.isNil)}
        return self.followsRepository.updateFollowers(ownUid: uid, opponentUid: opponentUid, follow: follow)
    }
        
    
    
        
    func getLikes(feedUid : String) -> Single<[UserModel]> {
        return Single.create{ [weak self] single in
            guard let self else { single(.failure(CustomError.isNil) )
                return Disposables.create() }

            self.feedRepository.getFeedFeedUid(feedUid: feedUid).subscribe({ event in
                switch(event){
                case.success(let feed):
                    
                    self.followsRepository.getFollowsLikes(uid: feed.likes ).subscribe({ event in
                        switch(event){
                        case.success(let likes):
                            print(likes)
                            single( .success(likes))
                            
                        case.failure(let err):
                            single( .failure(err))

                            
                        }
                        
                        
                        
                    }).disposed(by: self.disposeBag)
                    
                    
                case.failure(let err):
                    single(.failure(err))
                    
                }
                
                
            }).disposed(by: disposeBag)
            return Disposables.create()
        }
        
    }
        
        
    
}

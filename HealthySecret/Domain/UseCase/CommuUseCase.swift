//
//  CommuUseCase.swift
//  HealthySecret
//
//  Created by 양승완 on 5/27/24.
//

import Foundation
import RxSwift
import FirebaseAuth



class CommuUseCase {
    
    

    private let disposeBag = DisposeBag()
    private let userRepository : UserRepository
    private let feedRepository : FeedRepository
    
  
    private var count = 0
    private var follow : [String] = []
    private var block : [String] = []
    
    
    init( feedRepository : FeedRepository , userRepository : UserRepository ){
        self.userRepository = userRepository
        self.feedRepository = feedRepository
    }
    

    
    func getUser() -> Completable{
        return Completable.create { [weak self]  completable in guard let self = self else { return Disposables.create() }
            self.userRepository.getUser().subscribe({ [weak self] event in guard let self = self else {return}
                
                switch(event){
                case.success(let user):
                    print(user)

                    self.follow = user.followings ?? []
                    self.block = user.blocking + user.blocked
                    
                    completable(.completed)
                    
                    
                    
                    
                case .failure(let err):
                    print("err \(err)")
                    completable(.error(err))

                }
                
                
                
            }).disposed(by: disposeBag)
            
            return Disposables.create()
        }
    
    }
    
    
    func getFeedPagination(feedModels : [FeedModel] , getFollow : Bool , count : Int , reset : Bool) -> Single<[FeedModel]>{
        return Single.create{ [weak self] single in guard let self = self else { return  Disposables.create()}
            
            
            self.feedRepository.getFeedPagination(feeds: feedModels.map{ $0.toData() }, pagesCount: self.count , follow: self.follow , getFollow : getFollow , followCount: 0 , block : self.block , reset : reset ).subscribe({ event in
                switch(event){
                    
                case.success(let feeds):
                    var set : Set<String> = []
                    var feedDtos : [FeedDTO] = feeds
                    var users : [UserModel] = []
                   
                    _ = feedDtos.map{ set.insert( $0.uuid) }
                    _ = set.compactMap{
                        
                       self.userRepository.getUser(uid: $0)
            
                        
                    }.map{ $0.subscribe({ single in
                       
                        switch(single){
                        case(.success(let user)):
                            users.append(user)
                            
                            
                        case .failure(_):
                            break
                        }
                        
                    }).disposed(by: self.disposeBag)  }
                    
                    
                    single(.success(feedDtos.map{
                        var a : UserModel?
                        for user in users{
                            if(user.uuid == $0.uuid){
                                a = user
                            }
                        }
                        
                        
                        return $0.toDomain(nickname: a?.name ?? "" , profileImage: a?.profileImage ?? "")  } ) )
                    
                    
                    
                case.failure(let err):
                    single(.failure(err))
                }
                
                
                
            }).disposed(by: disposeBag)
            
            
            
            return Disposables.create()
        }
    }
   

    func deleteFeed(feedUid:String) -> Completable{
        
        return feedRepository.deleteFeed(feedUid: feedUid)
    }
    
    
}

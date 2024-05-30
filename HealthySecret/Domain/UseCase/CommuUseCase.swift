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
    private let fireStorageRepository : FireStorageRepository
    
  
    private var follow : [String] = []
    private var block : [String] = []
    
    
    init( feedRepository : FeedRepository , userRepository : UserRepository , fireStorageRepository : FireStorageRepository){
        self.userRepository = userRepository
        self.feedRepository = feedRepository
        self.fireStorageRepository = fireStorageRepository
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
            
            self.feedRepository.getFeedPagination(feeds: feedModels.map{ $0.toData() }, pagesCount: count , follow: self.follow , getFollow : getFollow , followCount: 0 , block : self.block , reset : reset ).subscribe({ event in
                

                
                switch(event){
                    
                case.success(let feedDtos):
                  var idx = 0
                    var feedModels = feedDtos.map{ $0.toDomain(nickname: "", profileImage: "") }
                    
                    for i in 0..<feedDtos.count {
                        self.userRepository.getUser(uid: feedDtos[i].uuid ).subscribe(onSuccess: { user  in
                            
                            feedModels[i] = feedDtos[i].toDomain(nickname: user.name , profileImage: user.profileImage ?? "")
                            idx += 1
                            if(idx >= feedDtos.count){
                                single(.success(feedModels))
                            }
                            
                        }).disposed(by: self.disposeBag)
                        
                    }
                    
                    
                    
                    
                    
                case.failure(let err):
                    single(.failure(err))
                }
                
                
                
            }).disposed(by: disposeBag)
            
            
            
            return Disposables.create()
        }
    }
   

    func deleteFeed(feedUid:String) -> Completable{
        
        return self.feedRepository.deleteFeed(feedUid: feedUid)
    }
    
    func updateFeedLikes(feedUid: String  , uuid: String, like: Bool ) -> Completable {
        
        
        
        return self.feedRepository.updateFeedLikes(feedUid: feedUid  , uuid: uuid, like: like )
    }
    
    func report(url : String , uid : String , uuid : String , event : String) -> Completable {

        return self.feedRepository.report(url : url , uid : uid , uuid : uuid , event : event)
    }
    
    
  
    
    func addFeed(feed : FeedModel) -> Completable {
        
        return self.feedRepository.addFeed(feed : feed.toData())
    }
    
    func getFeedFeedUid(feedUid: String) -> Single<FeedModel>{
        
        return Single.create{ single in
            
            self.feedRepository.getFeedFeedUid(feedUid : feedUid).subscribe({ [weak self] event in
                guard let self else {return}
                
                switch(event){
                    
                case .success(let dto):
                    
                    self.userRepository.getUser(uid: dto.uuid).subscribe({ event in
                        switch(event){
                        case .success(let user): 
                            single(.success(dto.toDomain(nickname: user.name , profileImage: user.profileImage ?? "")))
                        case .failure(let err):
                            single( .failure(err))
                        }
                        
                    }).disposed(by: disposeBag)
                    
                    
                case .failure(let err):
                    single(.failure(err))
                }
                
                
            }).disposed(by: self.disposeBag)
            return Disposables.create()
        }
        
    }
    
   
    
    func updateFeed(feed : FeedModel) -> Completable{
        
        let feedDto = feed.toData()
        return self.feedRepository.updateFeed(feedDto : feedDto)
    }
    
}



extension CommuUseCase {
    
    func deleteImage(urlString: String) -> Completable{
        
        
        return self.fireStorageRepository.deleteImage(urlString : urlString)
    }
    
    func uploadImage(imageData: Data, pathRoot: String) -> Single<String> {
        return self.fireStorageRepository.uploadImage(imageData: imageData, pathRoot: pathRoot )
    }
}

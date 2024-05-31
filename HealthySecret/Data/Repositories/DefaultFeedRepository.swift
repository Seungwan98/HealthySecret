//
//  DefaultIngredientsRepository.swift
//  HealthySecret
//
//  Created by 양승완 on 5/28/24.
//

import Foundation
import RxSwift

class DefaultFeedRepository : FeedRepository {
    
    
    private let firebaseService : FirebaseService

    
    private let disposeBag = DisposeBag()
    
    init( firebaseService : FirebaseService   ) {
        self.firebaseService = firebaseService

    }
 
    

    func getFeedPagination(feeds: [FeedDTO], pagesCount: Int, follow: [String], getFollow: Bool, followCount: Int, block: [String] , reset : Bool) -> Single<[FeedDTO]> {
        if(reset){
            self.firebaseService.query = nil
        }
        
        print("\(pagesCount)  pagesCount")
        return self.firebaseService.getFeedPagination(feeds: feeds, pagesCount: pagesCount, follow: follow, getFollow: getFollow , followCount: 0, block: block)
    }
    
    
    func deleteFeed(feedUid: String) -> Completable {
        return self.firebaseService.deleteFeed(feedUid: feedUid)
    }
    
    
    func updateFeedLikes(feedUid: String, uuid: String, like: Bool) -> Completable {
        
        return self.firebaseService.updateFeedLikes(feedUid: feedUid, uuid: uuid, like: like)
    }
    
    
    func report(url : String , uid : String , uuid : String , event : String) -> Completable {
        
        return firebaseService.report(url: url, uid: uid, uuid: uuid, event: event)
    }
    
    func addFeed(feed: FeedDTO) -> Completable {
        
        return firebaseService.addFeed(feed: feed)
    }
    
    func getFeedFeedUid(feedUid : String) -> Single<FeedDTO> {
        
        return self.firebaseService.getFeedFeedUid(feedUid: feedUid )
    }
    

    
    func updateFeed(feedDto: FeedDTO) -> Completable {
        return self.firebaseService.updateFeed(feedDto: feedDto)
    }
    
    
    
    func getFeedsUid(uid: String) -> Single<[FeedDTO]> {
        
        return firebaseService.getFeedsUid(uid: uid)
    }
    
   
   
}

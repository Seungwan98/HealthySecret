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
       
        return firebaseService.getFeedPagination(feeds: [], pagesCount: 4, follow: [], getFollow: false , followCount: 0, block: block)
    }
    
    func deleteFeed(feedUid: String) -> Completable {
        return firebaseService.deleteFeed(feedUid: feedUid)
    }
    
    
    
    
    
}

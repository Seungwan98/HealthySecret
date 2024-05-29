//
//  UserRepository.swift
//  HealthySecret
//
//  Created by 양승완 on 5/27/24.
//

import Foundation
import RxSwift

protocol FeedRepository {
    
  
    func getFeedPagination(feeds : [FeedDTO] , pagesCount:Int , follow : [String] , getFollow : Bool , followCount : Int , block : [String], reset : Bool) -> Single<[FeedDTO]>
    func deleteFeed(feedUid : String) -> Completable
    
}

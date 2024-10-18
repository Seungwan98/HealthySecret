//
//  DefaultComentsRepository.swift
//  HealthySecret
//
//  Created by 양승완 on 5/30/24.
//

import Foundation
import RxSwift


class DefaultFollowsRepositoy: FollowsRepository {
   
   
    private let firebaseService: FirebaseService
    
    init( firebaseService: FirebaseService   ) {
        self.firebaseService = firebaseService
    }
    
    
  
    func updateFollowers(ownUid: String, opponentUid: String, follow: Bool) -> Completable {
        return firebaseService.updateFollowers(ownUid: ownUid, opponentUid: opponentUid, follow: follow)
    }
    
    func getFollowsLikes(uid: [String]) -> Single<[UserModel]> {
        return firebaseService.getFollowsLikes(uid: uid)
    }
    
    
    
    
}

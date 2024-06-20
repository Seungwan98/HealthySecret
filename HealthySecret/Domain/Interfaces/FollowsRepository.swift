//
//  FollowRepository.swift
//  HealthySecret
//
//  Created by 양승완 on 5/30/24.
//

import Foundation
import RxSwift

protocol FollowsRepository {
    
    func updateFollowers( ownUid: String, opponentUid: String, follow: Bool ) -> Completable
    func getFollowsLikes(uid:[String]) -> Single<[UserModel]>
}

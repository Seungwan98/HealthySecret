//
//  DefaultComentsRepository.swift
//  HealthySecret
//
//  Created by 양승완 on 5/30/24.
//

import Foundation
import RxSwift


class DefaultComentsRepository : ComentsRepository {
    
    
    private let firebaseService : FirebaseService
    init( firebaseService : FirebaseService   ) {
        self.firebaseService = firebaseService
    }
    
    func getComents(feedUid: String) -> Single<[ComentDTO]> {
        
        
        return self.firebaseService.getComents(feedUid: feedUid)
    }
    
    
    
    
    
}

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
    
    
    func reportComents( uid: String, uuid: String ) -> Completable {
        return self.firebaseService.report(url: "HealthySecretComentsReports", uid: uid, uuid: uuid, event: "coment")
    }
    
    
    func updateComents(feedUid: String, coment: ComentDTO) -> RxSwift.Single<[ComentDTO]> {
        return self.firebaseService.updateComents(feedUid: feedUid, coment: coment)
    }
    
    
    func deleteComents(coment: ComentDTO, feedUid: String) -> Single<[ComentDTO]> {
        return self.firebaseService.deleteComents(coment: coment , feedUid: feedUid)
    }
    
    
  
  
    
    
    
    
}

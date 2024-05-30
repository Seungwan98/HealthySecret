//
//  ComentsRepository.swift
//  HealthySecret
//
//  Created by 양승완 on 5/30/24.
//

import Foundation
import RxSwift

protocol ComentsRepository {
    
    func getComents(feedUid : String) -> Single<[ComentDTO]>
    func reportComents(  uid: String , uuid: String ) -> Completable
    func deleteComents( coment : ComentDTO , feedUid : String) -> Single<[ComentDTO]>
    func updateComents(feedUid: String , coment: ComentDTO ) -> Single<[ComentDTO]>
    
}

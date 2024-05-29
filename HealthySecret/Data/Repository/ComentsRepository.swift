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
    
}

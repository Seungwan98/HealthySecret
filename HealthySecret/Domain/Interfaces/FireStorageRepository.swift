//
//  FireStorageRepository.swift
//  HealthySecret
//
//  Created by 양승완 on 5/30/24.
//

import Foundation
import RxSwift

protocol FireStorageRepository {
    
    func uploadImage(imageData: Data, pathRoot: String) -> Single<String>
    func deleteImage(urlString: String) -> Completable
}

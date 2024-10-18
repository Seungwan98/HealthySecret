//
//  DefaultFireStorageRepository.swift
//  HealthySecret
//
//  Created by 양승완 on 5/30/24.
//

import Foundation
import RxSwift

class DefaultFireStorageRepository: FireStorageRepository {
  
    
   
    
    private let firebaseService: FirebaseService
    init( firebaseService: FirebaseService   ) {
        self.firebaseService = firebaseService
    }
    
    func uploadImage(imageData: Data, pathRoot: String) -> Single<String> {
        self.firebaseService.uploadImage(imageData: imageData, pathRoot: pathRoot)
    }
    
    func deleteImage(urlString: String) -> Completable {
        self.firebaseService.deleteImage(urlString: urlString)
    }
    
    
    
}

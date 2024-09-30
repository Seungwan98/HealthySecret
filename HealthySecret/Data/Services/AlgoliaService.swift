//
//  AlgoliaService.swift
//  HealthySecret
//
//  Created by 양승완 on 9/28/24.
//

import Foundation
import AlgoliaSearchClient
import RxSwift
class AlgoliaService {

    func searchTeams(searchText: String) -> Single<[UserModel]> {
        guard let algoliaAppId = Bundle.main.object(forInfoDictionaryKey: "AlgoliaAppId") as? String else {
            return Single.error(CustomError.isNil)}

        guard let algoliaApiKey = Bundle.main.object(forInfoDictionaryKey: "AlgoliaApikey") as? String else {return Single.error(CustomError.isNil)}
    
        
        let client = SearchClient(appID: ApplicationID(rawValue: algoliaAppId), apiKey: APIKey(rawValue: algoliaApiKey))

        print("\(algoliaAppId) id")
        print("\(algoliaApiKey) key")

        
        let index = client.index(withName: "HealthySecretUsers")
        var query = Query(searchText)


        return Single.create { single in
            
            index.search(query: query ) { result in
                
                
                switch result {
                case .failure(let error):
                    single(.failure(error))

                case .success(let response):
                    do {
                       
                        
                        let users: [UserModel] = try response.extractHits()
                        single(.success(users))
                    } catch let error {
                        single(.failure(error))

                    }
                }
            }
            return Disposables.create()
        }
    }
}

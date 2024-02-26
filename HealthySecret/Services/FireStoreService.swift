//
//  GetDataFromFirestore.swift
//  HealthySecret
//
//  Created by 양승완 on 2023/11/07.
//

import Foundation
import Firebase
import FirebaseFirestore
import RxSwift

class FireStoreService {
    let db =  Firestore.firestore()
    
    
    func getAllIngredients(completionHandler: @escaping([Row]) -> () ) {
        self.db.collection("HealthySecret").getDocuments() { (querySnapshot , err) in
            var parsed : [Row] = []

            if let err = err {
                print("error : \(err)")
                
            } else {
                for document in querySnapshot!.documents{
                    do{
                        let jsonData = try JSONSerialization.data(withJSONObject: document.data() , options: [])
                        
                        
                        
                        let responseFile  = try JSONDecoder().decode(IngredientsModel.self, from: jsonData)
                        
                        parsed = responseFile.row
                        
                    }
                    catch let err {
                        print("Error \(err)")
                        return
                    }
                    
                }
                
                
            }
            
            completionHandler(parsed)
        }
        
    }

    
}


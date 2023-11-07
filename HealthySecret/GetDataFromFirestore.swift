//
//  GetDataFromFirestore.swift
//  HealthySecret
//
//  Created by 양승완 on 2023/11/07.
//

import Foundation
import Firebase
import FirebaseFirestore
class getDataFromFireStore {
    static let share = getDataFromFireStore()
    let db =  Firestore.firestore()
    
    
    func getAll(completionHandler: @escaping([Row]) -> () ) {
        db.collection("HealthySecret").getDocuments() { (querySnapshot , err) in
            var parsed : [Row] = []

            if let err = err {
                print("error : \(err)")
                
            } else {
                for document in querySnapshot!.documents{
                    do{
                        let jsonData = try JSONSerialization.data(withJSONObject: document.data() , options: [])
                        
                        
                        
                        let responseFile  = try JSONDecoder().decode(ResponseFile.self, from: jsonData)
                        
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


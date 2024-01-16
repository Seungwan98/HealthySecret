//
//  UserModel.swift
//  HealthySecrets
//
//  Created by 양승완 on 2023/11/03.
//

import Foundation

    
    
struct UserModel : Codable {
    var id : String
    var password : String
    var recentAdd : [String]
    var recentSearch : [String]
    var tall : Int
    var ingredients : [ingredients]?
    }

struct ingredients : Codable {
    var date : String?
    var morning : [String]?
    var lunch : [String]?
    var dinner : [String]?
    
    enum Codingkeys : String , CodingKey {
        case date , morning , lunch , dinner
        
        
        
    }
    
    init(date: String?, morning: [String]? , lunch : [String]? , dinner : [String]?) {
        self.date = date
        self.morning = morning
        self.dinner = dinner
        self.lunch = lunch
       
    }
    
    
}
extension Encodable {
    func asDictionary() throws -> [String: Any] {
        let data = try JSONEncoder().encode(self)
        guard let dictionary = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any] else {
            throw NSError()
        }
        return dictionary
    }
    
    var dictionary: [String: Any]? {
        guard let data = try? JSONEncoder().encode(self) else { return nil }
        return (try? JSONSerialization.jsonObject(with: data, options: .allowFragments)).flatMap { $0 as? [String: Any] }
      }
    
}



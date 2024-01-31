//
//  UserModel.swift
//  HealthySecrets
//
//  Created by 양승완 on 2023/11/03.
//

import Foundation

    
    
struct UserModel : Codable {
    var id : String
    var recentAdd : [String]?
    var recentSearch : [String]?
    var tall : String
    var age : String
    var sex : String
    var calorie : Int
    var weight : Double
    var ingredients : [ingredients]
    var exercise : [Exercise]
    }

struct ingredients : Codable {
    var date : String?
    var morning : [String]?
    var lunch : [String]?
    var dinner : [String]?
    var snack : [String]?
    
    enum Codingkeys : String , CodingKey {
        case date , morning , lunch , dinner , snack
        
        
        
    }
    
    init(date: String?, morning: [String]? , lunch : [String]? , dinner : [String]? , snack : [String]?) {
        self.date = date
        self.morning = morning
        self.dinner = dinner
        self.lunch = lunch
        self.snack = snack
       
    }
    
    
}
struct Exercise : Codable {
    var date : String
    var name : String
    var time : String
    var finalCalorie : String
    var memo : String

    
    enum Codingkeys : String , CodingKey {
        case date , name , time , finalCalorie , memo
        
        
        
    }
    
    init(date : String , name : String , time : String , finalCalorie : String , memo : String){
        self.date = date
        self.name = name
        self.time = time
        self.finalCalorie = finalCalorie
        self.memo = memo
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



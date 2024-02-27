//
//  UserModel.swift
//  HealthySecrets
//
//  Created by 양승완 on 2023/11/03.
//

import Foundation

    
    
struct UserModel : Codable {
    var id : String
    var name : String
    var recentAdd : [String]?
    var recentSearch : [String]?
    var tall : String
    var age : String
    var sex : String
    var calorie : Int
    var nowWeight : Int
    var goalWeight : Int
    var ingredients : [ingredients]
    var exercise : [Exercise]
    }

struct ingredients : Codable {
    var date : String?
    var morning : [Row]?
    var lunch : [Row]?
    var dinner : [Row]?
    var snack : [Row]?
    


    enum Codingkeys : String , CodingKey {
        case date , morning , lunch , dinner , snack 
        
        
        
    }
    
    init(date: String?, morning: [Row]? , lunch : [Row]? , dinner : [Row]? , snack : [Row]? ) {
        self.date = date
        self.morning = morning
        self.dinner = dinner
        self.lunch = lunch
        self.snack = snack
       
    }
    
    
}



struct Exercise : Codable {
    var key : String
    var date : String
    var name : String
    var time : String
    var finalCalorie : String
    var memo : String
    var exerciseGram : String


    
    enum Codingkeys : String , CodingKey {
        case date , name , time , finalCalorie , memo , key , exerciseGram
        
        
        
    }
    
    init(date : String , name : String , time : String , finalCalorie : String , memo : String , key : String , exerciseGram : String){
        self.date = date
        self.name = name
        self.time = time
        self.finalCalorie = finalCalorie
        self.memo = memo
        self.key = key
        self.exerciseGram = exerciseGram
    }
    
}


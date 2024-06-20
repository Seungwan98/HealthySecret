//
//  UserModel.swift
//  HealthySecrets
//
//  Created by 양승완 on 2023/11/03.
//

import Foundation

struct UserModel: Codable {
    var uuid: String
    var name: String
    var recentAdd: [String]?
    var recentSearch: [String]?
    var tall: String
    var age: String
    var sex: String
    var calorie: Int
    var nowWeight: Int
    var goalWeight: Int
    var ingredients: [Ingredients]
    var exercise: [ExerciseModel]
    var diarys: [Diary]
    var introduce: String?
    var profileImage: String?
    var activity: Int?
    var feeds: [String]?
    var followings: [String]?
    var followers: [String]?
    var loginMethod: String
    var blocked: [String]
    var blocking: [String]
    var report: [String]

    var freezeDate: String?

    
    
    func toSignUpModel() -> SignUpModel {
        return SignUpModel(uuid: self.uuid, name: self.name, tall: self.tall, age: self.age, sex: self.sex, calorie: self.calorie, nowWeight: self.nowWeight, goalWeight: self.goalWeight, activity: self.activity ?? 2 )
    }
    
    }

struct Ingredients: Codable {
    var date: String?
    var morning: [IngredientsModel]?
    var lunch: [IngredientsModel]?
    var dinner: [IngredientsModel]?
    var snack: [IngredientsModel]?
    


    enum Codingkeys: String, CodingKey {
        case date, morning, lunch, dinner, snack 
        
        
        
    }
    
    init(date: String?, morning: [IngredientsModel]?, lunch: [IngredientsModel]?, dinner: [IngredientsModel]?, snack: [IngredientsModel]? ) {
        self.date = date
        self.morning = morning
        self.dinner = dinner
        self.lunch = lunch
        self.snack = snack
       
    }
    
    
}


struct Diary: Codable {
    var date: String
    var diary: String
    
    enum CodingKeys: String, CodingKey {
        case date, diary
    }
    
    init(date: String, diary: String) {
        self.date = date
        self.diary = diary
    }
    
}




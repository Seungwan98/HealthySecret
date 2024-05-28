//
//  UserModel.swift
//  HealthySecrets
//
//  Created by 양승완 on 2023/11/03.
//

import Foundation

struct SignUpModel {
    var uuid : String
    var name : String
    var tall : String
    var age : String
    var sex : String
    var calorie : Int
    var nowWeight : Int
    var goalWeight : Int
    var loginMethod : String
    var activity : Int
   

    func toData() -> UserModel {
        return UserModel(uuid: self.uuid, name: self.name, tall: self.tall, age: self.age, sex: self.sex ,
                         calorie: self.calorie , nowWeight: self.nowWeight , goalWeight: self.goalWeight , ingredients: [], exercise: [], diarys: [], activity: self.activity, loginMethod: self.loginMethod, blocked: [] , blocking: [] , report: [] )
        }


    }





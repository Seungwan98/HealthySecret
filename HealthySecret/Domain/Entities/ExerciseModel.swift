//
//  ExerciseModel.swift
//  HealthySecret
//
//  Created by 양승완 on 5/29/24.
//

import Foundation
struct ExerciseModel: Codable {
    var key: String
    var date: String
    var name: String
    var time: String
    var finalCalorie: String
    var memo: String
    var exerciseGram: String


    
    enum Codingkeys: String, CodingKey {
        case date, name, time, finalCalorie, memo, key, exerciseGram
        
        
        
    }
    
    init(date: String, name: String, time: String, finalCalorie: String, memo: String, key: String, exerciseGram: String) {
        self.date = date
        self.name = name
        self.time = time
        self.finalCalorie = finalCalorie
        self.memo = memo
        self.key = key
        self.exerciseGram = exerciseGram
    }
    
}

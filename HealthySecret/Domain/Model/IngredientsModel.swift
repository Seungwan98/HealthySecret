//
//  IngredientsModel.swift
//  HealthySecret
//
//  Created by 양승완 on 5/28/24.
//

import Foundation

struct IngredientsModel : Codable {
    var descKor: String
    var carbohydrates: Double
    var calorie: Double
    var protein: Double
    var province: Double
    var sugars: Double
    var sodium: Double
    var cholesterol: Double
    var fattyAcid: Double
    var transFat: Double
    let servingSize: Double
    var addServingSize : Double
    
    
    
}

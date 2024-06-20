// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let welcome = try? JSONDecoder().decode(Welcome.self, from: jsonData)

import Foundation

// MARK: - Welcome
struct ExerciseDTO: Codable {
    let data: [ExerciseDtoData]
    
    enum CodingKeys: String, CodingKey {
        case data = "data"
    }
}

// MARK: - Datum
struct ExerciseDtoData: Codable {
    let exerciseGram: String
    let name: String
    
    enum CodingKeys: String, CodingKey {
        case exerciseGram = "단위체중당에너지소비량"
        case name = "운동명"
    }
    
    func toDomain() -> ExerciseModel {
        
        return ExerciseModel(date: "", name: self.name, time: "0", finalCalorie: "0", memo: "", key: "", exerciseGram: self.exerciseGram )
        
    }
    
   
}

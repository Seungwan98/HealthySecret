// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let responseFile = try? JSONDecoder().decode(ResponseFile.self, from: jsonData)

import Foundation

// MARK: - ResponseFile
struct IngredientsDTO: Codable {
    let row: [Row]
    
    enum CodingKeys: String, CodingKey {
        case row
    }
}

// MARK: - Row
struct Row: Codable {
    
    
    
    
    var descKor: String
    var foodCd: String
    var groupName: String
    var makerName: MakerName
    var num: String
    
    var calorie: String
    var carbohydrates: String
    var protein: String
    var province: String
    var sugars: String
    var sodium: String
    var cholesterol: String
    var fattyAcid: String
    var transFat: String
    let researchYear: String
    let samplingMonthCd: SamplingMonthCd
    let samplingMonthName: SamplingMonthName
    let samplingRegionCd: String
    let samplingRegionName: String
    let servingSize: String
    let subRefName: SubRefName
    
    var addServingSize: String?
    
    
    
    
    
    func toDomain() -> IngredientsModel {
        return IngredientsModel( num: self.num, descKor: self.descKor, carbohydrates: Double(self.carbohydrates) ?? 0.0, calorie: Int(Double(calorie) ?? 0), protein: Double(self.protein) ?? 0.0, province: Double(self.province) ?? 0.0, sugars: Double(self.sugars) ?? 0.0, sodium: Double(self.sodium) ?? 0.0, cholesterol: Double(self.cholesterol) ?? 0.0, fattyAcid: Double(self.fattyAcid) ?? 0.0, transFat: Double(self.transFat) ?? 0.0, servingSize: Double(servingSize) ?? 0.0, serveStyle: "g"   )
    }
    
    
    
    
    
    
    enum CodingKeys: String, CodingKey {
        
        case addServingSize = "ADD_SERVING_SIZE"
        case descKor = "DESC_KOR"
        case foodCd = "FOOD_CD"
        case groupName = "GROUP_NAME"
        case makerName = "MAKER_NAME"
        case num = "NUM"
        case calorie = "NUTR_CONT1"
        case carbohydrates = "NUTR_CONT2" // 탄수화물
        case protein = "NUTR_CONT3" // 단백질
        case province = "NUTR_CONT4" // 지방
        case sugars = "NUTR_CONT5" // 당류
        case sodium = "NUTR_CONT6" // 나트륨
        case cholesterol = "NUTR_CONT7" // 콜레스테롤
        case fattyAcid = "NUTR_CONT8" // 포화지방산
        case transFat = "NUTR_CONT9" // 트랜스지방
        case researchYear = "RESEARCH_YEAR"
        case samplingMonthCd = "SAMPLING_MONTH_CD"
        case samplingMonthName = "SAMPLING_MONTH_NAME"
        case samplingRegionCd = "SAMPLING_REGION_CD"
        case samplingRegionName = "SAMPLING_REGION_NAME"
        case servingSize = "SERVING_SIZE"
        case subRefName = "SUB_REF_NAME"
    }
}

enum MakerName: String, Codable {
    case empty = ""
    case 도미노피자 = "도미노피자"
    case 미스터피자 = "미스터피자"
    case 뽕뜨락피자 = "뽕뜨락피자"
    case 피자알볼로 = "피자알볼로"
    case 피자에땅 = "피자에땅"
    case 피자헛 = "피자헛"
}

enum SamplingMonthCd: String, Codable {
    case avg = "AVG"
}

enum SamplingMonthName: String, Codable {
    case 평균
}

enum SubRefName: String, Codable {
    case 식약처12제1권 = "식약처('12) 제1권"
    case 식약처12제1권명절 = "식약처('12) 제1권/명절"
    case 식약처13제2권 = "식약처('13) 제2권"
    case 식약처13제2권명절 = "식약처('13) 제2권/명절"
    case 식약처14명절 = "식약처('14) 명절"
    case 식약처15제3권 = "식약처('15) 제3권"
    case 식약처16제4권 = "식약처('16) 제4권"
    case 식약처17제5권 = "식약처('17) 제5권"
    case 식약처19 = "식약처('19)"
}

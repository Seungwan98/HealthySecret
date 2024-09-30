//
//  RequestFile.swift
//  HealthySecrets
//
//  Created by 양승완 on 2023/10/09.
//

import Alamofire
import UIKit
import RxSwift

class RequestFile {
    
    func foodToDomain(foodDto: Food) -> IngredientsModel {
        
        let serve = foodDto.servingSize ?? ""
        var splitDouble = 0.0
        var splitStr = ""
        if let result = serve.splitNumberAndUnit() {
            splitStr = result.unit
            splitDouble = Double(result.number) ?? 0.0
        }
        
        
        return IngredientsModel(num: foodDto.num ?? "", descKor: foodDto.foodNmKr ?? "", carbohydrates: (Double(foodDto.carbohydrates ?? "0.0") ?? 0), calorie: Int(Double(foodDto.calorie ?? "0.0") ?? 0), protein: Double(foodDto.protein ?? "0.0") ?? 0.0, province: (Double(foodDto.province ?? "0.0") ?? 0.0), sugars: Double(foodDto.sugars ?? "0.0") ?? 0.0, sodium: (Double(foodDto.sodium ?? "0.0") ?? 0.0), cholesterol: (Double(foodDto.cholesterol ?? "0.0") ?? 0.0), fattyAcid: (Double(foodDto.fattyAcid ?? "0.0") ?? 0.0), transFat: (Double(foodDto.transFat ?? "0.0") ?? 0.0), servingSize: splitDouble, serveStyle: splitStr, food_CD: foodDto.foodCD!)
    }
    static let shared = RequestFile()
    
    func getRequestData(text: String) -> Single<[IngredientsModel]> {
        
        return Single.create { single in
            let parameters: [String: Any] = ["FOOD_NM_KR": "\(text)"]
            let url =  "https://apis.data.go.kr/1471000/FoodNtrCpntDbInfo01/getFoodNtrCpntDbInq01?serviceKey=kc0al0dugGaSv1DDTZgLAx7uCBbhBaHU2rm1srUocfltPHQEozGrfNSEoeytjDRF%2B%2BAPtzscGL2s3aMLQ70pFQ%3D%3D&pageNo=1&numOfRows=100&type=json"
            
            
            
            
            
            AF.request(url, parameters: parameters).responseData { response in
                switch response.result {
                case .success(let data):
                    do {
                        print(data)
                        let decoder = JSONDecoder()
                        let result = try decoder.decode(FoodDTO.self, from: data)
                        
                        let dtos = result.body.items.map { self.foodToDomain(foodDto: $0) }
                        
                        single(.success(dtos))
                    } catch {
                        
                        
                        print("Error decoding JSON: \(error)")
                        
                        
                        
                        
                    }
                case .failure(let error):
                    print("\(error) error")
                }
                
            }
            
            return Disposables.create()
            
        }
        
        
        
    }
    
    
    
    
}

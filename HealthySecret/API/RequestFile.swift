//'//
////  RequestFile.swift
////  HealthySecrets
////
////  Created by 양승완 on 2023/10/09.
////
//
//import Alamofire
//import UIKit
//
//class RequestFile{
//
//    func getRequestData(_ ingredientsViewController: IngredientsViewController){
//
//        var url = "https://openapi.foodsafetykorea.go.kr/api/0953eeacbbde4438b716/I2790/json/1/2"
//        AF.request(url,
//                   method: .post,
//                   parameters: nil,
//                   headers: nil)
//        .responseDecodable(of: ResponseFile.self) {response in
//
//            switch response.result{
//
//            case .success(let data):
//
//                print("DEBUG>> OpenWeather Response \(data)")
//                print("success")
//                ingredientsViewController.toAppendList(data.i2790.row)
//
//
//
//
//            case .failure(let error):
//
//
//                print("DEBUG>> OpenWeather Get Error : \(error.localizedDescription)")
//            }
//
//
//
//        }
//
////        url = "https://openapi.foodsafetykorea.go.kr/api/0953eeacbbde4438b716/I2790/json/1001/2000"
////        AF.request(url,
////                   method: .post,
////                   parameters: nil,
////                   headers: nil)
////        .responseDecodable(of: ResponseFile.self) {response in
////
////
////            switch response.result{
////
////            case .success(let data):
////
////                print("DEBUG>> OpenWeather Response \(data)")
////                print("success")
////                ingredientsViewController.toAppendList(data.i2790.row)
////
////
////
////
////            case .failure(let error):
////
////
////                print("DEBUG>> OpenWeather Get Error : \(error.localizedDescription)")
////            }
//
//
//
//        //}
//
//        //"http://openapi.foodsafetykorea.go.kr/api/0953eeacbbde4438b716/I2790/json/1/1000"
//
//
//
//
//
//
//    }
//
//
//
//
//}
//
//
//
//




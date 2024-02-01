//
//  Custom.swift
//  HealthySecret
//
//  Created by 양승완 on 2024/01/31.
//

import Foundation


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


struct CustomMath {
    
    func getDecimalSecond(data : Double) -> Double{
        let digit: Double = pow(10, 1)
        return round(data * digit) / digit
    }
    
}

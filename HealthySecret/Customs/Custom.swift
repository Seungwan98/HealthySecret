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
    
struct CustomFormatter {
    
    var formatter : DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
        
    }()
    func StringToDate(date : String) -> Date {
        
        let date = formatter.date(from: date)!
        
        return date
        
    }
    func DateToString(date : Date) -> String {
        
        let date = formatter.string(from: date)
        
        return date
        
    }
    
    func getToday() -> String {
        
        return formatter.string(from: Date())
        
        
        
    }
    
    
    func formatToOutput(date : String) -> String{
        let calendar = Calendar.current
        var result = date
        
        let date = StringToDate(date: date)
        
        if calendar.isDateInToday(date){
            result = "오늘"
        }else if(calendar.isDateInYesterday(date)){
            result = "어제"
        }else if(calendar.isDateInTomorrow(date)){
            result = "내일"
            
        }
        
        return result
        
    }
}

    


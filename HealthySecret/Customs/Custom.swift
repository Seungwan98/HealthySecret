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

extension String {
    func splitNumberAndUnit() -> (number: String, unit: String)? {
        // 정규 표현식을 사용하여 숫자와 단위를 분리합니다.
        let pattern = "([0-9]+)([a-zA-Z]+)"
        
        // 정규 표현식 객체 생성
        guard let regex = try? NSRegularExpression(pattern: pattern, options: []) else {
            return nil
        }
        
        // 첫 번째 일치하는 부분을 찾습니다.
        if let match = regex.firstMatch(in: self, options: [], range: NSRange(location: 0, length: self.count)) {
            // 첫 번째 캡처 그룹: 숫자
            if let numberRange = Range(match.range(at: 1), in: self) {
                let number = String(self[numberRange])
                
                // 두 번째 캡처 그룹: 단위
                if let unitRange = Range(match.range(at: 2), in: self) {
                    let unit = String(self[unitRange])
                    
                    return (number, unit)
                }
            }
        }
        
        return nil
    }
}

struct CustomMath {
    
    func getDecimalSecond(data: Double) -> Double {
        let digit: Double = pow(10, 1)
        return round(data * digit) / digit
    }
}

struct CustomFormatter {
    static let shared = CustomFormatter()
    
    
    
    var formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
        
    }()
    
    
    var formatterForFeed: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return formatter
        
    }()
    
    
    
    
    func StringToDate(date: String) -> Date {
        
        let date = formatter.date(from: date)!
        return date
        
    }
    func DateToString(date: Date) -> String {
        
        let date = formatter.string(from: date)
        
        return date
        
    }
    
    func StringToDateForFeed(date: String) -> Date {
        
        let date = formatterForFeed.date(from: date)!
        
        return date
        
    }
    func DateToStringForFeed(date: Date) -> String {
        
        let date = formatterForFeed.string(from: date)
        
        return date
        
    }
    
    
    
    func getToday() -> String {
        
        return formatter.string(from: Date())
        
        
        
    }
    
    
    func formatToOutput(date: String) -> String {
        let calendar = Calendar.current
        var result = date
        
        let date = StringToDate(date: date)
        
        
        
        if calendar.isDateInToday(date) {
            result = "오늘"
        } else if calendar.isDateInYesterday(date) {
            result = "어제"
        } else if calendar.isDateInTomorrow(date) {
            result = "내일"
        }
        
        return result
        
    }
    
    func dateCompare(targetString: String) -> Bool {
        
        print("targetSring \(targetString)")
        if targetString.isEmpty {
            return true
        } else {
            let targetDate: Date = formatter.date(from: targetString) ?? Date()
            
            
            
            
            
            
            switch targetDate.compare( Date.now ) {
                
            case.orderedDescending:
                print("des")
                return false
                
                
                
            case .orderedAscending:
                print("asc")
                return true
                
                
                
            case .orderedSame:
                print("same")
                return true
                
                
                
            }
        }
        
    }
    
    
    func getDifferDate(date: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy년 MM월 dd일"
        
        
        
        
        
        let stringToDate = self.StringToDateForFeed(date: date)
        
        var changedDate = String()
        
        let offsetComps = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute ], from: stringToDate, to: Date())
        
        if case let (y?, m?, d?, h?, min?) = (offsetComps.year, offsetComps.month, offsetComps.day, offsetComps.hour, offsetComps.minute ) {
            
            
            if y == 0 {
                formatter.dateFormat = "MM월 dd일"
                changedDate = formatter.string(from: stringToDate)
                if m == 0 {
                    changedDate = "\(d)일 전"
                    if d == 0 {
                        changedDate = "\(h)시간 전"
                        if h == 0 {
                            changedDate = "\(min)분 전"
                            if min == 0 {
                                changedDate = "방금"
                            }
                        }
                        
                        
                    }
                }
                
                
                
            } else {
                changedDate = formatter.string(from: stringToDate)
                
            }
            
        }
        return changedDate
    }
    
    
}

//
//  CoreMotionService.swift
//  HealthySecret
//
//  Created by 양승완 on 2024/03/06.
//

import Foundation
import CoreMotion
import RxCocoa
import RxSwift
final class CoreMotionService {
    
    static let shared = CoreMotionService()
    
    private var pedoMeter = CMPedometer()
    
    private init() {
        Timer.scheduledTimer(timeInterval: 3.0,
                             target: self,
                             selector: #selector(checkSteps),
                             userInfo: nil,
                             repeats: true)
    }
    
    static var getSteps = BehaviorSubject<String?>(value: nil)
    
    @objc private func checkSteps() {
        
        let nowDate = Date()
        guard let todayStartDate = Calendar.current.date(bySettingHour: 0, minute: 0, second: 0, of: nowDate) else {
            return
        }
        
        pedoMeter.queryPedometerData(from: todayStartDate, to: nowDate) { data, error in
            if let error {
                print("CoreMotionService.queryPedometerData Error: \(error)")
                return
            }
            
            if let steps = data?.numberOfSteps {
                DispatchQueue.main.async {
                    CoreMotionService.getSteps.onNext(String(describing: steps))
                }
            }
        }

    }
    
}

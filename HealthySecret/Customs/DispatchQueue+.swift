//
//  DispatchQueue.swift
//  HealthySecret
//
//  Created by 양승완 on 4/9/24.
//

import Foundation
extension DispatchQueue {
    static func mainSyncSafe(execute work: () -> Void) {
        if Thread.isMainThread {
            work()
        } else {
            DispatchQueue.main.sync(execute: work)
        }
    }
}

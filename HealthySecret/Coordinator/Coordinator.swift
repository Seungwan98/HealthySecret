//
//  Coordinator.swift
//  HealthySecrets
//
//  Created by 양승완 on 2023/10/25.
//

import UIKit
import Firebase
import FirebaseAuth
import Foundation

//AnyObject로 등록 시 특정 클래스만 사용 가능
protocol Coordinator: AnyObject {
    
    /// 부모 코디네이터가 자식이 finish 됐을 때 알 수 있도록 돕는 delegate 프로토콜
    var finishDelegate: CoordinatorFinishDelegate? { get set }
    /// 각각의 코디네이터는 하나의 네비게이션 컨트롤러를 가지고 있습니다.
    var navigationController: UINavigationController { get set }
    /// 모든 하위 코디네이터를 가지고 추적하는 배열, 대부분의 경우 이 배열에는 하위 코디네이터가 하나만 포함됩니다.
    var childCoordinator: [Coordinator] { get set }
    /// 코디네이터 타입
    var type: CoordinatorType { get }
        
    init(_ navigationController: UINavigationController)
    
    func start()
    func finish()
}

extension Coordinator {
    
    func finish() {
        
        childCoordinator.removeAll()
        finishDelegate?.coordinatorDidFinish(childCoordinator: self)
    }
}


protocol CoordinatorFinishDelegate: AnyObject {
    func coordinatorDidFinish(childCoordinator: Coordinator)
    
    func coordinatorDidFinishNotRoot(childCoordinator: Coordinator)
    
}

// MARK: - CoordinatorType
enum CoordinatorType {
    case home , tab , detailPage , diaryPage , ingredients , calendar , exercise , myprofile , run ,communicate , follow
}






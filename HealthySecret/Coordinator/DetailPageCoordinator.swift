//
//  DetailPageCoordinator.swift
//  HealthySecret
//
//  Created by 양승완 on 2023/11/20.
//

import UIKit
import Foundation



class DetailPageCoordinator: Coordinator {
    var detailPageViewController : DetailPageViewController
    
    var childCoordinator: [Coordinator] = []
        
    var navigationController: UINavigationController
    
    var finishDelegate: CoordinatorFinishDelegate?
    
    var type: CoordinatorType = .detailPage
    
    required init(_ navigationController: UINavigationController ) {
        self.navigationController = navigationController
        self.detailPageViewController = DetailPageViewController()
      //  self.coordinatorDidFinish(childCoordinator: self)
    }
    
    func start() {
        self.detailPageViewController.view.backgroundColor = .white
        self.navigationController.pushViewController(detailPageViewController, animated: true)
    }
    

}

extension DetailPageCoordinator : CoordinatorFinishDelegate {
    func coordinatorDidFinish(childCoordinator: Coordinator) {
        // 자식 뷰를 삭제하는 델리게이트 (자식 -> 부모 접근 -> 부모에서 자식 삭제)
        print("DetailPageDidFinish")
        self.childCoordinator = self.childCoordinator
            .filter({ $0.type != childCoordinator.type })
        childCoordinator.navigationController.popToRootViewController(animated: true)
    }
    
    
}

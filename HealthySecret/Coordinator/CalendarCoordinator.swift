//
//  DetailPageCoordinator.swift
//  HealthySecret
//
//  Created by 양승완 on 2023/11/20.
//

import UIKit
import Foundation



class CalendarCoordinator: Coordinator {
    
    var parentCoordinator : DiaryCoordinator?
    
    var childCoordinator: [Coordinator] = []
        
    var navigationController: UINavigationController
    
    var finishDelegate: CoordinatorFinishDelegate?
    
    var type: CoordinatorType = .calendar
    
    required init(_ navigationController: UINavigationController ) {
        self.navigationController = navigationController
    }
    
    func start() {
        let firebaseService = FirebaseService()
        let viewModel = CalendarVM(coordinator: self, firebaseService: firebaseService)
        let calendarViewController = CalendarViewController(viewModel: viewModel)
        calendarViewController.view.backgroundColor =  .white
        calendarViewController.hidesBottomBarWhenPushed = true

        
        self.navigationController.navigationBar.topItem?.title = ""
        self.navigationController.navigationBar.tintColor = .black
        
        
        
        
        
        self.navigationController.pushViewController(calendarViewController, animated: true)
        
    }
    
    func BacktoDiaryVC(){
        finishDelegate?.coordinatorDidFinish(childCoordinator: self)

       // parentCoordinator?.pushDiaryVC()
        
    }
    
    
}

extension CalendarCoordinator : CoordinatorFinishDelegate {
    func coordinatorDidFinish(childCoordinator: Coordinator) {
        print("CalendarDidFinished")
        self.childCoordinator = self.childCoordinator
            .filter({ $0.type != childCoordinator.type })
        childCoordinator.navigationController.popToRootViewController(animated: true)
    }
    
    
}

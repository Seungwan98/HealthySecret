//
//  ExerciseCoordinator.swift
//  HealthySecret
//
//  Created by 양승완 on 2023/11/20.
//

import UIKit
import Foundation



class ExerciseCoordinator: Coordinator {
    
    
    var childCoordinator: [Coordinator] = []
        
    var navigationController: UINavigationController
    
    var parentCoordinator : Coordinator?
    
    var finishDelegate: CoordinatorFinishDelegate?
    
    var type: CoordinatorType = .exercise
    
    required init(_ navigationController: UINavigationController ) {
        self.navigationController = navigationController
        self.navigationController.navigationBar.tintColor = .white
        self.navigationController.navigationBar.topItem?.title = ""
        
    }
    
    func start() {
        let firebaseService = FirebaseService()
        let viewModel = ExerciseVM(coordinator: self, firebaseService: firebaseService)
        let ExerciseViewController = ExerciseViewController(viewModel: viewModel)

        ExerciseViewController.hidesBottomBarWhenPushed = true
        ExerciseViewController.view.backgroundColor = .white
        
        self.navigationController.pushViewController(ExerciseViewController, animated: false)
        
        
        
        
    }
    
    func pushDetailVC(model : ExerciseDtoData){
        
        let firebaseService = FirebaseService()
        let viewModel = ExerciseDetailVM(coordinator: self, firebaseService: firebaseService)
        viewModel.model = model
        let viewController = ExerciseDetailVC(viewModel: viewModel)
        
        viewController.hidesBottomBarWhenPushed = true

        self.navigationController.pushViewController(viewController, animated: false)
        
    }
    
    func back() {
        
        finishDelegate?.coordinatorDidFinish(childCoordinator: self)
        
        
        
    }
    
   
    
    
}

extension ExerciseCoordinator : CoordinatorFinishDelegate {
    func coordinatorDidFinish(childCoordinator: Coordinator) {
        print("CalendarDidFinished")
        self.childCoordinator = self.childCoordinator
            .filter({ $0.type != childCoordinator.type })
        childCoordinator.navigationController.popToRootViewController(animated: true)
    }
    
    
}

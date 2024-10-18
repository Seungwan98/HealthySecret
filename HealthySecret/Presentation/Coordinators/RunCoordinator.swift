//
//  tabBarCoordinator.swift
//  HealthySecrets
//
//  Created by 양승완 on 2023/10/26.
//

import UIKit
import RxSwift
import Firebase




class RunCoordinator: Coordinator {
    
    
    // MARK: - Properties
    var navigationController: UINavigationController
    var childCoordinator: [Coordinator] = []
    var finishDelegate: CoordinatorFinishDelegate?
    var type: CoordinatorType
    var firebaseService: FirebaseService
    var disposeBag = DisposeBag()
    
    // MARK: - Initializers
    required init(_ navigationController: UINavigationController ) {
        self.navigationController = navigationController
        self.type = CoordinatorType.run
        self.firebaseService = FirebaseService()

       
    }
    
  
    
    func start() {
        
        
        
        
    }
    


    
   
  
    
 
    
    
    
    
    
    
   
    
    
}

extension RunCoordinator: CoordinatorFinishDelegate {
    func coordinatorDidFinishNotRoot(childCoordinator: any Coordinator) {
        //
    }
    
    func coordinatorDidFinish(childCoordinator: Coordinator) {
        // print("RunCoordinatorDidfinish")
        self.childCoordinator = self.childCoordinator
            .filter({ $0.type != childCoordinator.type })
        childCoordinator.navigationController.popToRootViewController(animated: true)
    }
}

//
//  ProfileFeedCoordinator.swift
//  HealthySecrets
//
//  Created by 양승완 on 2023/10/26.
//

import UIKit
import RxSwift
import Firebase




class ProfileFeedCoordinator : Coordinator  {
    func start() {
        //
    }
    
   
    
    
    // MARK: - Properties
    var navigationController: UINavigationController
    var childCoordinator: [Coordinator] = []
    var finishDelegate: CoordinatorFinishDelegate?
    var type: CoordinatorType
    var firebaseService: FirebaseService
    var disposeBag = DisposeBag()
    var CommuCoordinator : CommuCoordinator?
    
    
    // MARK: - Initializers
    required init(_ navigationController : UINavigationController ){
        self.navigationController = navigationController
        self.type = CoordinatorType.follow
        self.firebaseService = FirebaseService()
       
    }
    
    

  
    
    
    
  
    
    func finish() {
        print("finish")
        self.finishDelegate?.coordinatorDidFinishNotRoot(childCoordinator: self)
    }

   

    
   
  
    
 
    
    
    
    
    
    
   
    
    
}

extension ProfileFeedCoordinator: CoordinatorFinishDelegate {
    func coordinatorDidFinishNotRoot(childCoordinator: any Coordinator) {
        //
    }
    
    func coordinatorDidFinish(childCoordinator: Coordinator) {
        print("ProfileFeedCoordinator childs Pop")
        self.childCoordinator = self.childCoordinator
            .filter({ $0.type != childCoordinator.type })
        childCoordinator.navigationController.popToRootViewController(animated: true)
    }
}




//
//  FollowCoordinator.swift
//  HealthySecrets
//
//  Created by 양승완 on 2023/10/26.
//

import UIKit
import RxSwift
import Firebase




class FollowsCoordinator : Coordinator  {
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
    
    var follow : Bool?
    var feedUid : String?
    
    // MARK: - Initializers
    required init(_ navigationController : UINavigationController ){
        self.navigationController = navigationController
        self.type = CoordinatorType.follow
        self.firebaseService = FirebaseService()

       
    }
    
  
    
    func startPush( follow : Bool , uid : String ) {
        
        let viewModel = FollowsVM(coordinator: self , firebaseService: self.firebaseService)
        
        viewModel.follow = follow
        viewModel.feedUid = feedUid
        
        let viewController = FollowsVC(viewModel: viewModel)
        
        self.navigationController.pushViewController(viewController, animated: false)
        
        
    }
    


    
   
  
    
 
    
    
    
    
    
    
   
    
    
}

extension FollowsCoordinator: CoordinatorFinishDelegate {
    func coordinatorDidFinish(childCoordinator: Coordinator) {
        print("RunCoordinatorDidfinish")
        self.childCoordinator = self.childCoordinator
            .filter({ $0.type != childCoordinator.type })
        childCoordinator.navigationController.popToRootViewController(animated: true)
    }
}




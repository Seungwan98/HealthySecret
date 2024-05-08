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
    
    
    // MARK: - Initializers
    required init(_ navigationController : UINavigationController ){
        self.navigationController = navigationController
        self.type = CoordinatorType.follow
        self.firebaseService = FirebaseService()

       
    }
    
  
    
    func startPush( follow : Bool , uid : String , name : String) {
        
        let viewModel = FollowsVM(coordinator: self , firebaseService: self.firebaseService)
        
        viewModel.follow = follow
        viewModel.uid = uid
        
        let viewController = FollowsVC(viewModel: viewModel)
        
        self.navigationController.navigationBar.topItem?.title = ""
        self.navigationController.navigationBar.tintColor = .black
        
        viewController.navigationItem.title = "\(name)"
        
        viewController.hidesBottomBarWhenPushed = true
        
        self.navigationController.pushViewController(viewController , animated: false)
        
        
    }
    
    
    func finish() {
        print("finish")
        self.finishDelegate?.coordinatorDidFinishNotRoot(childCoordinator: self)
    }

   

    
   
  
    
 
    
    
    
    
    
    
   
    
    
}

extension FollowsCoordinator: CoordinatorFinishDelegate {
    func coordinatorDidFinishNotRoot(childCoordinator: any Coordinator) {
        //
    }
    
    func coordinatorDidFinish(childCoordinator: Coordinator) {
        print("RunCoordinatorDidfinish")
        self.childCoordinator = self.childCoordinator
            .filter({ $0.type != childCoordinator.type })
        childCoordinator.navigationController.popToRootViewController(animated: true)
    }
}




//
//  Coordinator.swift
//  HealthySecrets
//
//  Created by 양승완 on 2023/10/25.
//

import UIKit

//AnyObject로 등록 시 특정 클래스만 사용 가능
protocol Coordinator : AnyObject {
    var childCoordinator : [Coordinator] {
        get set
    }
    func start()
    
    init(_ navigationController : UINavigationController )
    
}





class AppCoordinator : Coordinator , LoginCoordinatorDelegate {
   
    
    var childCoordinator: [Coordinator] = []
    private var navigationController : UINavigationController!
    
    required init(_ navigationController : UINavigationController ){
        self.navigationController = navigationController
       
    }
    
    
    
    func didLoggedIn(_ coordinator: LoginCoordinator) {
        self.childCoordinator = self.childCoordinator.filter { $0 !== coordinator }
        self.showMainViewController()
    }
    
    func start() {
        let loginCoordinator = LoginCoordinator(self.navigationController)
        loginCoordinator.delegate = self
        loginCoordinator.start()
        
        self.childCoordinator.append(loginCoordinator)
    }
    
    
    
    
    func showMainViewController(){
        
        let coordinator = DefaultTabBarCoordinator(self.navigationController)
        
        coordinator.start()
        
    }
    
 
    
    
    
    
    
    
   
    
    
}



protocol LoginCoordinatorDelegate {
    func didLoggedIn(_ coordinator: LoginCoordinator)
}


class LoginCoordinator : Coordinator , LoginViewControllerDelegate {
    
    
    
    var childCoordinator: [Coordinator] = []
    
    var delegate : LoginCoordinatorDelegate?
    
    private var navigationController : UINavigationController!
    
        
    

    
    
    required init(_ navigationController  : UINavigationController ){
        self.navigationController = navigationController
        
        
    }
    
    
    
    func start() {
        let loginViewController = LoginViewController()
        loginViewController.view.backgroundColor = .white
        loginViewController.delegate = self
        
       
        self.navigationController?.viewControllers = [loginViewController]
    }
    
    func login() {
        self.delegate?.didLoggedIn(self)
    }
    
    
    
}



//
//  tabBarCoordinator.swift
//  HealthySecrets
//
//  Created by 양승완 on 2023/10/26.
//

import UIKit
import RxSwift
import Firebase


protocol LoginCoordinatorDelegate {
    func didLoggedIn(_ coordinator: Coordinator)
    
}

protocol LogoutCoordinatorDelegate{
    func didLoggedOut(_ coordinator : Coordinator )
}


class AppCoordinator : Coordinator , LoginCoordinatorDelegate , LogoutCoordinatorDelegate {
    
    
    // MARK: - Properties
    var navigationController: UINavigationController
    var childCoordinator: [Coordinator] = []
    var finishDelegate: CoordinatorFinishDelegate?
    var type: CoordinatorType
    var firebaseService: FirebaseService
    var kakaoService : KakaoService
    var disposeBag = DisposeBag()
    
    // MARK: - Initializers
    required init(_ navigationController : UINavigationController ){
        self.navigationController = navigationController
        self.type = CoordinatorType.tab
        self.firebaseService = FirebaseService()
        self.kakaoService = KakaoService()
       
    }
    
    
    
    func didLoggedIn(_ coordinator: Coordinator ) {
        self.childCoordinator = self.childCoordinator.filter { $0 !== coordinator }
        self.showMainViewController()
    }
  
    func didLoggedOut(_ coordinator: Coordinator) {
        self.childCoordinator = self.childCoordinator.filter { $0 !== coordinator }
        self.showLoginViewController()
        
    }
    
    
    func start() {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        
        UserDefaults.standard.set(formatter.string(from: Date()), forKey: "date")
        
        
        
        self.firebaseService.getCurrentUser().subscribe { event in
            switch event {
                
            case .success(let user):
                let uid = user.uid
                guard let email = user.email else {return}

                UserDefaults.standard.set("\(uid)", forKey: "uid")
                UserDefaults.standard.set("\(email)", forKey: "email")
                print("loginSuccess")
                self.showMainViewController()
                
                
            case .failure(_):
            
                self.showLoginViewController()
            }
        }.disposed(by: disposeBag)
    }
    
    func showMainViewController(){
        print("mainView")
        let coordinator = TabBarCoordinator(self.navigationController)
        coordinator.logoutDelegate = self
        coordinator.finishDelegate = self
        coordinator.start()
        self.childCoordinator.append(coordinator)
    }
    
    
    
    
    func showLoginViewController() {
        print("들옴")
        
        let coordinator = LoginCoordinator(self.navigationController)
        coordinator.delegate = self
        
        coordinator.start()
        
        self.childCoordinator.append(coordinator)
        
    }
    
    
   
  
    
 
    
    
    
    
    
    
   
    
    
}

extension AppCoordinator: CoordinatorFinishDelegate {
    func coordinatorDidFinish(childCoordinator: Coordinator) {
        
        print("AppCoordinatorDidFinish")

        
        self.childCoordinator = self.childCoordinator.filter({ $0.type != childCoordinator.type })
        self.navigationController.view.backgroundColor = .systemBackground
        self.navigationController.viewControllers.removeAll()
        
        switch childCoordinator.type {
        case .tab:
            self.showMainViewController()
        case .home:
            self.showLoginViewController()
        default:
            break
        }
    }
}





class LoginCoordinator : Coordinator  {
    var parentCoordinator: AppCoordinator?
    
    var navigationController: UINavigationController
    
    var finishDelegate: CoordinatorFinishDelegate?
        
    var type: CoordinatorType
    
    private var firebaseService : FirebaseService!
    private var kakaoService : KakaoService!
    
    var childCoordinator: [Coordinator] = []
    
    var delegate : LoginCoordinatorDelegate?
    
    
        
    

    
    
    required init(_ navigationController  : UINavigationController ){
        self.navigationController = navigationController
        self.type = CoordinatorType.tab
        self.firebaseService = FirebaseService()
        self.kakaoService = KakaoService()
        
    }
    
    
    
    func start() {
        let loginVm = LoginVM(firebaseService: self.firebaseService, loginCoordinator: self , kakaoService: self.kakaoService)
        let loginViewController = LoginViewController(viewModel: loginVm)
        loginViewController.view.backgroundColor = .white
        
       
        self.navigationController.viewControllers = [loginViewController]
   
    }
    
    
    func pushSignUpVC() {
        let viewModel = SignUpVM(coordinator: self, firebaseService: self.firebaseService)
        let viewController = SignUpViewController(viewModel: viewModel)
        self.navigationController.viewControllers = [viewController]
    }
    
    func login() {
        print("login")
        self.delegate?.didLoggedIn(self)
        
            
        
        
    }
    
    
    
}
extension LoginCoordinator : CoordinatorFinishDelegate {
    func coordinatorDidFinish(childCoordinator: Coordinator) {
        // 자식 뷰를 삭제하는 델리게이트 (자식 -> 부모 접근 -> 부모에서 자식 삭제)
        print("LoginCoordinatorDidfinsh")
        self.childCoordinator = self.childCoordinator
            .filter({ $0.type != childCoordinator.type })
        childCoordinator.navigationController.popToRootViewController(animated: true)
    }
    
}

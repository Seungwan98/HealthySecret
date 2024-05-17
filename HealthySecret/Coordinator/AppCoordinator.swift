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
        print("\(self.childCoordinator)  childCoordinator")
        self.showMainViewController()
    }
  
    func didLoggedOut(_ coordinator: Coordinator) {
        self.finishDelegate?.coordinatorDidFinish(childCoordinator: coordinator)
        self.showLoginViewController()
        
    }
    
    
   
    
    func start() {
        
       
        let viewController = SplashVC(viewModel: SplashVM(coordinator: self, firebaseService: self.firebaseService))
        self.navigationController.setViewControllers([viewController], animated: false)
       
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
        
        let coordinator = LoginCoordinator(self.navigationController)
        
        coordinator.delegate = self
        
        coordinator.start()
        
        self.childCoordinator.append(coordinator)
        
    } 
    func showSignUpVC() {
        
        let coordinator = LoginCoordinator(self.navigationController)
        
        coordinator.delegate = self
        
        coordinator.pushSignUpVC()
        
        self.childCoordinator.append(coordinator)
        
    }
    
   
  
    
 
    
    
    
    
    
    
   
    
    
}

extension AppCoordinator: CoordinatorFinishDelegate {
    func coordinatorDidFinishNotRoot(childCoordinator: any Coordinator) {
        //
    }
    
    func coordinatorDidFinish(childCoordinator: Coordinator) {
        
        print("AppCoordinatorDidFinish \(childCoordinator.type) \(self.childCoordinator)")

        
        self.childCoordinator = self.childCoordinator.filter({ $0.type != childCoordinator.type })
        self.navigationController.view.backgroundColor = .systemBackground
        self.navigationController.viewControllers.removeAll()
        
        print("AppCoordinatorDidFinish \(childCoordinator.type) \(self.childCoordinator)")

        
        switch childCoordinator.type {
        case .tab:
            self.showMainViewController()
        case .login:
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
        self.type = .login
        self.firebaseService = FirebaseService()
        self.kakaoService = KakaoService()
        
    }
    
    func presentModal(){
        let viewController = AssignModalVC()
            
        viewController.view.backgroundColor = .white
        if let sheet = viewController.sheetPresentationController {
                    
                    //지원할 크기 지정
            sheet.detents = [.medium()]
            
                   
                    //시트 상단에 그래버 표시 (기본 값은 false)
                    sheet.prefersGrabberVisible = true
                    
             
                }
        viewController.coordinator = self
        self.navigationController.present(viewController, animated: true)
        
        
        
        
    }
    
   
    
    func start() {
        print("startLoginVC")
        let viewModel = LoginVM(firebaseService: self.firebaseService, loginCoordinator: self , kakaoService: self.kakaoService)
        let loginViewController = LoginViewController(viewModel: viewModel)
        loginViewController.view.backgroundColor = .white
        
       
        self.navigationController.viewControllers = [loginViewController]
   
    }
    
    
    func pushSignUpVC() {
        let viewModel = SignUpVM(coordinator: self, firebaseService: self.firebaseService)
        let viewController = SignUpVC(viewModel: viewModel)
        self.navigationController.viewControllers = [viewController]
    }
    
    func login() {
        print("login")
        self.delegate?.didLoggedIn(self)
        
            
        
        
    }
    
    
    
}
extension LoginCoordinator : CoordinatorFinishDelegate {
    func coordinatorDidFinishNotRoot(childCoordinator: any Coordinator) {
        //
    }
    
    func coordinatorDidFinish(childCoordinator: Coordinator) {
        // 자식 뷰를 삭제하는 델리게이트 (자식 -> 부모 접근 -> 부모에서 자식 삭제)
        print("LoginCoordinatorDidfinsh")
        self.childCoordinator = self.childCoordinator
            .filter({ $0.type != childCoordinator.type })
        childCoordinator.navigationController.popToRootViewController(animated: true)
    }
    
}

//
//  tabBarCoordinator.swift
//  HealthySecrets
//
//  Created by 양승완 on 2023/10/26.
//

import UIKit
import Foundation




//탭바 코디네이터
class TabBarCoordinator : Coordinator {
  
    let firebaseService = FirebaseService()
    
    var navigationController: UINavigationController
    
    var finishDelegate: CoordinatorFinishDelegate?
    
    var logoutDelegate : LogoutCoordinatorDelegate?
    
    var type: CoordinatorType
        
    var tabBarController: UITabBarController
    var childCoordinator: [Coordinator] = []
    var tabBarItems : [UITabBarItem] = []
    
    var tabBars : [UITabBar] = []
    
    
    private var tabNavigationControllers : [UINavigationController] = []

    
    
    required init(_ navigationController  : UINavigationController ) {
        self.type = CoordinatorType.tab
        self.navigationController = navigationController
        self.tabBarController = UITabBarController()
        
        
    }
    
    func start(){
        tabBarItems = getTabBarItems()
        let controllers : [UINavigationController] = tabBarItems.map {
            getControllers($0 , UINavigationController())
        }
        
        let _ = controllers.map{ self.startCoordinator( _ : $0) }
        
        startTabBarController(controllers)
        navigationController.setNavigationBarHidden(true, animated: false)
        
        //self.navigationController.setNavigationBarHidden(true, animated: false)
        
        navigationController.viewControllers = [tabBarController]
        
        

    }
    
    
    func startTabBarController( _ controllers : [UINavigationController] ){
        // home의 index로 TabBar Index 세팅
        // TabBar 스타일 지정
        self.tabBarController.setViewControllers( controllers , animated: true)
        self.tabBarController.view.backgroundColor = .systemBackground
        self.tabBarController.tabBar.backgroundColor = .systemBackground
        self.tabBarController.tabBar.tintColor = UIColor.black
        
    }
    
    
    func getTabBarItems() -> [UITabBarItem] {
        let firstItem = UITabBarItem(title: "홈" , image: UIImage.init(systemName: "house") , tag:0)
        let secondItem = UITabBarItem(title: "다이어리" , image: UIImage.init(systemName: "fork.knife") , tag:1)
        
        return [firstItem , secondItem]
    }
    
    func startCoordinator(_ navigationTabController : UINavigationController ) {
        let navigationTabController = navigationTabController
        let tabBarItemTag : Int = navigationTabController.tabBarItem.tag
        
        switch tabBarItemTag{
        case 0:
            let homeCoordinator =  HomeCoordinator( navigationTabController )
            homeCoordinator.parentCoordinator = self
            childCoordinator.append(homeCoordinator)
            homeCoordinator.finishDelegate = self
            homeCoordinator.startPush()

        case 1:
            let diaryCoordinator =  DiaryCoordinator( navigationTabController )
            diaryCoordinator.parentCoordinator = self
            childCoordinator.append(diaryCoordinator)
            diaryCoordinator.finishDelegate = self
            diaryCoordinator.pushDiaryVC()

            
    
        default:
            break
        }
        
        
        
    }
    
    
    
    
    func getControllers(_ tabBarItem : UITabBarItem , _ nav : UINavigationController ) -> UINavigationController {
        let navigationController = nav

        navigationController.tabBarItem = tabBarItem
        return navigationController
        
    }
    
    
    func logout(){
        self.coordinatorDidFinish(childCoordinator: self)
        self.logoutDelegate?.didLoggedOut(self)
        
    }
    
    
    
    
}


extension TabBarCoordinator : CoordinatorFinishDelegate {
    func coordinatorDidFinish(childCoordinator: Coordinator) {
        print("TabBarCoordinatorDidFinish")
        self.childCoordinator.removeAll()
        self.navigationController.viewControllers.removeAll()
        self.finishDelegate?.coordinatorDidFinish(childCoordinator: self)
        
    }
}




//탭바 첫번째 인자 컨트롤러
class HomeCoordinator : Coordinator  {
    
    var parentCoordinator: TabBarCoordinator?
        
    var finishDelegate: CoordinatorFinishDelegate?
            
    let firebaseService = FirebaseService()
        
    var type: CoordinatorType = .home
            
    var navigationController : UINavigationController
        
    var childCoordinator: [Coordinator] = []
    
    var user : UserModel?
    
    required init(_ navigationController: UINavigationController ) {
        self.navigationController = navigationController
        
        
    }
    
    func start() {}
   
    
    
 
    
    func pushIngredientsVC() {
        let IngredientsCoordinator =  IngredientsCoordinator( self.navigationController )
        IngredientsCoordinator.finishDelegate = self
        childCoordinator.append(IngredientsCoordinator)
        IngredientsCoordinator.start()
        
    }
    
   
   

        
    
    
    
    
    func startPush() {
        
        let firebaseService = self.firebaseService
        let viewController = HomeViewController(viewModel : HomeVM ( coordinator : self , firebaseService: firebaseService ))
        
        self.navigationController.pushViewController( viewController , animated: true )
    
    }
    
    func logout() {
        self.coordinatorDidFinish(childCoordinator: self)
        self.parentCoordinator?.logout()
        
    }
    
    
    
    
    
}

extension HomeCoordinator: CoordinatorFinishDelegate {
    func coordinatorDidFinish(childCoordinator: Coordinator) {
        print("HomeCoordinatorDidFinish")
        // 자식 뷰를 삭제하는 델리게이트 (자식 -> 부모 접근 -> 부모에서 자식 삭제)
        self.childCoordinator = self.childCoordinator
            .filter({ $0.type != childCoordinator.type })
        childCoordinator.navigationController.popToRootViewController(animated: true)
    }
}




//탭바 첫번째 인자 컨트롤러
class DiaryCoordinator : Coordinator  {
    var navigationController: UINavigationController
    

    
    var parentCoordinator: TabBarCoordinator?
        
    var finishDelegate: CoordinatorFinishDelegate?
            
    let firebaseService = FirebaseService()
        
    var type: CoordinatorType = .diaryPage
            
        
    var childCoordinator: [Coordinator] = []
    
    var user : UserModel?
    
    required init(_ navigationController: UINavigationController ) {
        self.navigationController = navigationController
        
        
    }
    
    func start() {}
   
  

        
    
    func pushIngredientsVC() {
        let ingredientsCoordinator =  IngredientsCoordinator( self.navigationController )
        ingredientsCoordinator.finishDelegate = self
        childCoordinator.append(ingredientsCoordinator)
        ingredientsCoordinator.start()
        
    }
     
    func pushCalendarVC() {
        let calendarCoordinator =  CalendarCoordinator( self.navigationController )
        calendarCoordinator.finishDelegate = self
        calendarCoordinator.parentCoordinator = self
        childCoordinator.append(calendarCoordinator)
        calendarCoordinator.start()
        
    }
    
    
    
    
    func pushDiaryVC() {
        
        let firebaseService = self.firebaseService
        let viewController = DiaryViewController(viewModel : DiaryVM ( coordinator : self , firebaseService: firebaseService ))
        self.navigationController.pushViewController( viewController , animated: true )
    
    }
    
    
    
    
    
    
    
}

extension DiaryCoordinator: CoordinatorFinishDelegate {
    func coordinatorDidFinish(childCoordinator: Coordinator) {
        
        print("HomeCoordinatorDidFinish")
        // 자식 뷰를 삭제하는 델리게이트 (자식 -> 부모 접근 -> 부모에서 자식 삭제)
        self.childCoordinator = self.childCoordinator
            .filter({ $0.type != childCoordinator.type })
        childCoordinator.navigationController.popToRootViewController(animated: true)
    }
    
   
}





    


    


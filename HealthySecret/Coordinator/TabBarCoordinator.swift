//
//  tabBarCoordinator.swift
//  HealthySecrets
//
//  Created by 양승완 on 2023/10/26.
//

import UIKit

protocol TabBarCoordinator: Coordinator {
    var tabBarController : UITabBarController { get set }
}




//탭바 코디네이터
class DefaultTabBarCoordinator : TabBarCoordinator {
    var tabBarController: UITabBarController
    var childCoordinator: [Coordinator] = []
    var tabBarItems : [UITabBarItem] = []
    var tabBars : [UITabBar] = []
    
    private var navigationController : UINavigationController!
    private var tabNavigationControllers : [UINavigationController] = []

    
    
    required init(_ navigationController  : UINavigationController ){
        self.navigationController = navigationController
        self.tabBarController = UITabBarController()
        
    }
    
    func start(){
        
        tabBarItems = getTabBarItems()
        let controllers : [UINavigationController] = tabBarItems.map {
            getControllers($0)
        }
        
        let _ = controllers.map{ self.startCoordinator( _ : $0) }
        
        startTabBarController(controllers)
        
        self.navigationController.viewControllers = [tabBarController]
        
        
        
        
        
        
       
   

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
        let secondItem = UITabBarItem(title: "검색" , image: UIImage.init(systemName: "magnifyingglass") , tag:1)
        
        return [firstItem , secondItem]
    }
    
    func startCoordinator(_ navigationTabController : UINavigationController ) {
        var navigationTabController = navigationTabController
        let tabBarItemTag : Int = navigationTabController.tabBarItem.tag
        
        switch tabBarItemTag{
        case 0:
            let homeCoordinator =  DefaultHomeCoordinator( navigationTabController )
            childCoordinator.append(homeCoordinator)
            navigationTabController = homeCoordinator.startPush()

        case 1:
            let homeCoordinator =  DefaultIngredientsCoordinator( navigationTabController )
            childCoordinator.append(homeCoordinator)
            navigationTabController = homeCoordinator.startPush()
        
        
            
            
            
        default:
            break
        }
        
        
        
    }
    
    
    
    
    func getControllers(_ tabBarItem : UITabBarItem ) -> UINavigationController {
        let navigationController = UINavigationController()
        navigationController.tabBarItem = tabBarItem
        return navigationController
        
    }
    
    
}


protocol HomeCoordinator : Coordinator{
    var homeViewController : HomeViewController { get set }
    
    
}


//탭바 첫번째 인자 컨트롤러
class DefaultHomeCoordinator: HomeCoordinator  {
    var homeViewController : HomeViewController
    var navigationController : UINavigationController
    required init(_ navigationController: UINavigationController ) {
        self.navigationController = navigationController
        self.homeViewController =  HomeViewController()
    }
    
   
    var childCoordinator: [Coordinator] = []
    
 
    

    
    func start() {
        
    }
    
    func startPush() -> UINavigationController {
        

        
        
        self.navigationController.setViewControllers([self.homeViewController], animated: false)
        return self.navigationController
       
    }
    
    
}

protocol IngredientsCoordinator : Coordinator {
    var ingredientsViewController : IngredientsViewController { get set }
}

//탭바 두번째 인자 컨트롤러
class DefaultIngredientsCoordinator : IngredientsCoordinator {
    
    var ingredientsViewController: IngredientsViewController

    var childCoordinator : [Coordinator] = []
    var navigationController : UINavigationController
    
    required init(_ navigationController : UINavigationController){
        self.navigationController = navigationController
        self.ingredientsViewController = IngredientsViewController()
    }
    
    func start() {
        //do
    }
    
    func startPush() -> UINavigationController{
        navigationController.setViewControllers([self.ingredientsViewController], animated: false)
        return navigationController
    }
    
    
}

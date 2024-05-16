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
        
       
        //네비게이션 겹침 상황을 없애기 위해 추가.
        navigationController.setNavigationBarHidden(true, animated: false)
        
      
        
        

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
        
        let firstItem = UITabBarItem(title: "홈" , image: UIImage.init(systemName: "house")  , tag:0)
        let secondItem = UITabBarItem(title: "소통" , image: UIImage.init(systemName: "message") , tag:1)
        let thirdItem = UITabBarItem(title: "마이" , image: UIImage.init(systemName: "person") , tag:2)
      
     

        
        
        return [firstItem , secondItem , thirdItem]
    }
   
    
    
    func startCoordinator(_ navigationTabController : UINavigationController ) {
        let navigationTabController = navigationTabController

        let tabBarItemTag : Int = navigationTabController.tabBarItem.tag
        
        
      
      

        switch tabBarItemTag{
        case 0:
            let diaryCoordinator =  DiaryCoordinator( navigationTabController )
            diaryCoordinator.parentCoordinator = self
            childCoordinator.append(diaryCoordinator)
            diaryCoordinator.finishDelegate = self
            diaryCoordinator.pushDiaryVC()
        case 1:
            let commuCoordinator =  CommuCoordinator( navigationTabController )
            commuCoordinator.parentCoordinator = self
            childCoordinator.append(commuCoordinator)
            commuCoordinator.finishDelegate = self
            commuCoordinator.startPush()
        case 2:
            let profileCoordinator =  ProfileCoordinator( navigationTabController )
            profileCoordinator.parentCoordinator = self
            childCoordinator.append(profileCoordinator)
            profileCoordinator.finishDelegate = self
            profileCoordinator.PushMyProfileVC()





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
        self.finishDelegate?.coordinatorDidFinish(childCoordinator: self)
        
        
        
        
        self.logoutDelegate?.didLoggedOut(self)
        
    }
 

    
    
}


extension TabBarCoordinator : CoordinatorFinishDelegate {
    func coordinatorDidFinishNotRoot(childCoordinator: any Coordinator) {
        //
    }
    
    func coordinatorDidFinish(childCoordinator: Coordinator) {
        print("TabBarCoordinatorDidFinish")
        self.childCoordinator.removeAll()
        self.navigationController.viewControllers.removeAll()
        self.finishDelegate?.coordinatorDidFinish(childCoordinator: self)
        
    }
}




//탭바 첫번째 인자 컨트롤러
class CommuCoordinator : Coordinator  {
    
    var parentCoordinator: TabBarCoordinator?
        
    var finishDelegate: CoordinatorFinishDelegate?
            
    let firebaseService = FirebaseService()
        
    var type: CoordinatorType = .communicate
            
    var navigationController : UINavigationController
        
    var childCoordinator: [Coordinator] = []
    
    var user : UserModel?
    
    required init(_ navigationController: UINavigationController ) {
        self.navigationController = navigationController
        
        
    }
    
    func start() {}
    
    
    func pushProfileVC(uuid:String){
        
        let profileCoordinator =  ProfileCoordinator( self.navigationController )
        childCoordinator.append(profileCoordinator)
        profileCoordinator.finishDelegate = self
        profileCoordinator.PushOtherProfileVC(uuid: uuid)
        
        
    }
    
    func pushUpdateFeed(feed:FeedModel){
        let viewModel = UpdateFeedVM(coordinator: self, firebaseService: self.firebaseService)
        viewModel.feed = feed
        print(feed)
        let viewController = UpdateFeedVC(viewModel:viewModel)
        
        self.navigationController.navigationBar.topItem?.title = ""
        self.navigationController.navigationBar.tintColor = .black
        
        viewController.hidesBottomBarWhenPushed = true

        self.navigationController.pushViewController(viewController , animated: false)
        
        
    }
   
    
    
 
    
  
    
   
    func pushComents(coments : [Coment] , feedUid : String , feedUuid : String){
        let firebaseService = FirebaseService()
        let viewModel = ComentsVM(coordinator: self, firebaseService: firebaseService)
        viewModel.coments = coments
        viewModel.feedUid = feedUid
        viewModel.feedUuid = feedUuid
        
        let viewController = ComentsVC(viewModel:viewModel)
        
        self.navigationController.navigationBar.topItem?.title = ""
        self.navigationController.navigationBar.tintColor = .black
        
        viewController.hidesBottomBarWhenPushed = true

        self.navigationController.pushViewController(viewController , animated: false)
        
        
    } 
    
    func pushLikes( uid : String , feedUid : String){
        
        
        let firebaseService = FirebaseService()
        let viewModel = LikesVM(coordinator: self, firebaseService: firebaseService)
      
        viewModel.uid = uid
        viewModel.feedUid = feedUid
        
        
        let viewController = LikesVC(viewModel:viewModel)
        
        self.navigationController.navigationBar.topItem?.title = ""
        self.navigationController.navigationBar.tintColor = .black
        
        viewController.hidesBottomBarWhenPushed = true

        self.navigationController.pushViewController(viewController , animated: false)
        
        
        
        
        
        
    }
    
    

        
    
    
    
    
    func startPush() {
        
        let viewController = CommuVC(viewModel : CommuVM(coordinator: self , firebaseService: self.firebaseService ))
        
        self.navigationController.pushViewController( viewController , animated: false )
    
    }
    
    func pushAddFeedVC(){
        let viewController = AddFeedVC(viewModel: AddFeedVM(coordinator: self, firebaseService: self.firebaseService))
        
        self.navigationController.navigationBar.topItem?.title = ""
        self.navigationController.navigationBar.tintColor = .black
        
        viewController.hidesBottomBarWhenPushed = true

        self.navigationController.pushViewController(viewController , animated: false)
    }
    
    func pushProfileFeed(feedUid:String){
        let viewModel =  ProfileFeedVM(coordinator: self , firebaseService: self.firebaseService )
        viewModel.feedUid = feedUid
        let viewController = ProfileFeedVC(viewModel: viewModel )
        
        
        
        
        self.navigationController.navigationBar.topItem?.title = ""
        self.navigationController.navigationBar.tintColor = .black
        
        self.navigationController.pushViewController(viewController , animated: false)
    }
    
   

  
    func refreshChild() {
        
        self.childCoordinator = []

    }
    
    
    
}


extension CommuCoordinator: CoordinatorFinishDelegate {
    func coordinatorDidFinish(childCoordinator: Coordinator) {
        print("CommuCoordinator DidFinish")
        // 자식 뷰를 삭제하는 델리게이트 (자식 -> 부모 접근 -> 부모에서 자식 삭제)
        self.childCoordinator = self.childCoordinator
            .filter({ $0.type != childCoordinator.type })
        
        childCoordinator.navigationController.popToRootViewController(animated: true)
    }
    
    func coordinatorDidFinishNotRoot(childCoordinator: Coordinator) {
        print("CommuCoordinator DidFinish")
        // 자식 뷰를 삭제하는 델리게이트 (자식 -> 부모 접근 -> 부모에서 자식 삭제)
        self.childCoordinator = self.childCoordinator
            .filter({ $0.type != childCoordinator.type })
        
        childCoordinator.navigationController.popViewController(animated: false)
        
    }
    
}









    



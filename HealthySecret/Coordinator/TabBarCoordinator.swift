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
            let myprofileCoordinator =  MyProfileCoordinator( navigationTabController )
            myprofileCoordinator.parentCoordinator = self
            childCoordinator.append(myprofileCoordinator)
            myprofileCoordinator.finishDelegate = self
            myprofileCoordinator.startPush()





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
        let viewModel = OtherProfileVM(coordinator: self , firebaseService: self.firebaseService , uuid : uuid)
        let viewController = OtherProfileVC(viewModel:viewModel)
        self.navigationController.navigationBar.topItem?.title = ""
        self.navigationController.navigationBar.tintColor = .black
        
        viewController.hidesBottomBarWhenPushed = true

        self.navigationController.pushViewController(viewController , animated: false)
        
        
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

    
    func pushFollowsVC( follow : Bool , uid : String ) {
        
        let coordinator = FollowsCoordinator(self.navigationController)
        
        childCoordinator.append(coordinator)
        coordinator.finishDelegate = self
        coordinator.startPush(follow: follow , uid : uid  )
        
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
       //let viewController = HomeViewController(viewModel : MyPro ( coordinator : self , firebaseService: firebaseService ))
        
      //  self.navigationController.pushViewController( viewController , animated: true )
    
    }
    
    func logout() {
        self.coordinatorDidFinish(childCoordinator: self)
        self.parentCoordinator?.logout()
        
    }
    
    
    
    
    
}


extension HomeCoordinator: CoordinatorFinishDelegate {
    func coordinatorDidFinishNotRoot(childCoordinator: any Coordinator) {
        
    }
    
    func coordinatorDidFinish(childCoordinator: Coordinator) {
        print("HomeCoordinatorDidFinish")
        // 자식 뷰를 삭제하는 델리게이트 (자식 -> 부모 접근 -> 부모에서 자식 삭제)
        self.childCoordinator = self.childCoordinator
            .filter({ $0.type != childCoordinator.type })
        childCoordinator.navigationController.popToRootViewController(animated: true)
    }
}

class MyProfileCoordinator : Coordinator {
    
    let kakaoService = KakaoService()

    
    var parentCoordinator: TabBarCoordinator?
        
    var finishDelegate: CoordinatorFinishDelegate?
            
    let firebaseService = FirebaseService()
        
    var type: CoordinatorType = .myprofile
            
    var navigationController : UINavigationController
        
    var childCoordinator: [Coordinator] = []
    
    
    required init(_ navigationController: UINavigationController ) {
        self.navigationController = navigationController
        
        
    }
    
    func start() {}
 
   
    func pushAddFeedVC(){
        let viewController = AddFeedVC(viewModel: AddFeedVM( coordinator: self, firebaseService: self.firebaseService))
        
        self.navigationController.navigationBar.topItem?.title = ""
        self.navigationController.navigationBar.tintColor = .black
        
        viewController.hidesBottomBarWhenPushed = true

        self.navigationController.pushViewController(viewController , animated: false)
    }
        
    
    
    
    
    func startPush() {
     
        
        let firebaseService = self.firebaseService
        let kakaoService = self.kakaoService
        let viewController =  MyProfileVC(viewModel : MyProfileVM ( coordinator : self , firebaseService: firebaseService, kakaoService: kakaoService ))
        

        
       
        self.navigationController.pushViewController( viewController , animated: true )
    
    }
    
    func pushChangeProfileVC(name : String , introduce : String , profileImage : Data? , beforeImageUrl : String){
        let firebaseService = self.firebaseService
        let kakaoService = self.kakaoService
        let viewModel = ChangeIntroduceVM(coordinator: self, firebaseService: firebaseService , kakaoService: kakaoService)
        viewModel.introduce = introduce
        viewModel.name = name
        viewModel.beforeImage = beforeImageUrl
        viewModel.profileImage = profileImage
        let viewController = ChangeIntroduceVC(viewModel: viewModel )
        viewController.hidesBottomBarWhenPushed = true
        
        
        
        self.navigationController.navigationBar.topItem?.title = ""
        self.navigationController.navigationBar.tintColor = .black

        self.navigationController.pushViewController(viewController, animated: false)
        
    }
    
    func pushSettingVC(){
        print("setting")
        let firebaseService = self.firebaseService
        let kakaoService = self.kakaoService

        let viewModel = MyProfileVM(coordinator: self , firebaseService : firebaseService , kakaoService: kakaoService)
        let viewController = SettingVC(viewModel: viewModel)
        
        self.navigationController.navigationBar.topItem?.title = ""
        self.navigationController.navigationBar.tintColor = .black

        self.navigationController.pushViewController(viewController, animated: false)
        
    }
 
    
    func logout() {
        
        
        
        self.coordinatorDidFinish(childCoordinator: self)
        self.parentCoordinator?.logout()
        
    }
    

    
    func pushChangeSignUpVC(user : UserModel){
        let firebaseService = self.firebaseService
        let viewModel = ChangeSignUpVM(coordinator: self, firebaseService: firebaseService)
        viewModel.userModel = user
        let viewController = ChangeSignUpVC(viewModel: viewModel)
        viewController.hidesBottomBarWhenPushed = true
        
        self.navigationController.navigationBar.topItem?.title = ""
        self.navigationController.navigationBar.tintColor = .black
        self.navigationController.navigationBar.backgroundColor = .clear
        
        
        self.navigationController.pushViewController(viewController, animated: false)

        
    }
    
    
        
        
        
        
    
    
    
    
    
    
}
extension MyProfileCoordinator : CoordinatorFinishDelegate {
    func coordinatorDidFinishNotRoot(childCoordinator: any Coordinator) {
        //
    }
    
    func coordinatorDidFinish(childCoordinator: Coordinator) {
        
        // 자식 뷰를 삭제하는 델리게이트 (자식 -> 부모 접근 -> 부모에서 자식 삭제)
        self.childCoordinator = self.childCoordinator
            .filter({ $0.type != childCoordinator.type })
        childCoordinator.navigationController.popToRootViewController(animated: true)
    }
    
}



//탭바 첫번째 인자 컨트롤러
class DiaryCoordinator : Coordinator  {
    func start() {
    }
    

    
    var navigationController: UINavigationController
    

    
    var parentCoordinator: TabBarCoordinator?
        
    var finishDelegate: CoordinatorFinishDelegate?
            
    let firebaseService = FirebaseService()
        
    var type: CoordinatorType = .diaryPage
            
        
    var childCoordinator: [Coordinator] = []
    
    
    required init(_ navigationController: UINavigationController ) {
        self.navigationController = navigationController
        
        
    }
    
   
  

//
//    
//    func pushIngredientsVC() {
//        let ingredientsCoordinator =  IngredientsCoordinator( self.navigationController )
//        ingredientsCoordinator.finishDelegate = self
//        childCoordinator.append(ingredientsCoordinator)
//        ingredientsCoordinator.start()
//
//    }
    
    
    
    
    func pushEditIngredientsVC(arr : [Row]) {
        let ingredientsCoordinator =  IngredientsCoordinator( self.navigationController )
        ingredientsCoordinator.finishDelegate = self
        childCoordinator.append(ingredientsCoordinator)
        ingredientsCoordinator.pushIngredientsVC(arr : arr)
        
    }
     
    func pushCalendarVC() {
        let calendarCoordinator =  CalendarCoordinator( self.navigationController )
        calendarCoordinator.finishDelegate = self
        calendarCoordinator.parentCoordinator = self
        childCoordinator.append(calendarCoordinator)
        calendarCoordinator.start()
        
    }
    
    func pushExerciseVC() {
        let exerciseCoordinator =  ExerciseCoordinator( self.navigationController )
        exerciseCoordinator.finishDelegate = self
        exerciseCoordinator.parentCoordinator = self
        childCoordinator.append(exerciseCoordinator)
        exerciseCoordinator.start()
    }
  
    
    
    func pushDiaryVC() {
        
        let firebaseService = self.firebaseService
        let viewController = DiaryViewController(viewModel : DiaryVM ( coordinator : self , firebaseService: firebaseService ))
        
        self.navigationController.hidesBottomBarWhenPushed = false
        self.navigationController.pushViewController( viewController , animated: true )
    
    }
    
    func pushEditExerciseVC(exercises : [Exercise]) {
        print("pushEdit")
        let firebaseService = self.firebaseService
        let viewController = EditExerciseVC(viewModel: EditExerciseVM(coordinator: self, firebaseService: firebaseService , exercises : exercises))
        
        viewController.hidesBottomBarWhenPushed = true
        
//        self.navigationController.navigationBar.backIndicatorImage = UIImage(systemName: "xmark")
//        self.navigationController.navigationBar.backIndicatorTransitionMaskImage = UIImage(systemName: "xmark")
        self.navigationController.navigationBar.topItem?.title = ""
        self.navigationController.navigationBar.tintColor = .white

        self.navigationController.pushViewController( viewController , animated: false )

        
    }
    
    func presentDetailView(arr : [String:Any] ){
        print("pushDetailView")
        let viewController = DetailModalVC(dic:arr)
            
        viewController.view.backgroundColor = .white
        self.navigationController.present(viewController, animated: true)
        
        
        
        
    }
    
    func finishChild(){
        print("popnavigation")
        self.navigationController.popViewController(animated: false)
        
    }
    
    
    
    
    
    
    
}

extension DiaryCoordinator: CoordinatorFinishDelegate {
    func coordinatorDidFinishNotRoot(childCoordinator: any Coordinator) {
        //
    }
    
    func coordinatorDidFinish(childCoordinator: Coordinator) {
        
        print("DiaryCoordinatorFinish")
        // 자식 뷰를 삭제하는 델리게이트 (자식 -> 부모 접근 -> 부모에서 자식 삭제)
        self.childCoordinator = self.childCoordinator
            .filter({ $0.type != childCoordinator.type })
        childCoordinator.navigationController.popToRootViewController(animated: true)
    }
    
   
}


    



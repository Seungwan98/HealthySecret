//
//  ProfileCoordinator.swift
//  HealthySecret
//
//  Created by 양승완 on 5/7/24.
//

import Foundation
import UIKit

class ProfileCoordinator : Coordinator {
    
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
        let viewController = AddFeedVC(viewModel: AddFeedVM( coordinator: self, commuUseCase: CommuUseCase(feedRepository: DefaultFeedRepository(firebaseService: self.firebaseService), userRepository: DefaultUserRepository(firebaseService: self.firebaseService ), fireStorageRepository: DefaultFireStorageRepository(firebaseService: self.firebaseService)) ))
        
        self.navigationController.navigationBar.topItem?.title = ""
        self.navigationController.navigationBar.tintColor = .black
        
        viewController.hidesBottomBarWhenPushed = true

        self.navigationController.pushViewController(viewController , animated: false)
    }
        
    
    
    
    
    func PushMyProfileVC() {
     

        
        let firebaseService = self.firebaseService
        let kakaoService = self.kakaoService
        let viewController =  MyProfileVC(viewModel : MyProfileVM ( coordinator : self , firebaseService: firebaseService, kakaoService: kakaoService ))
        


       
        self.navigationController.pushViewController( viewController , animated: true )
    
    }
    
    func PushOtherProfileVC( uuid: String) {
     
        
        let viewModel = OtherProfileVM(coordinator: self , firebaseService: self.firebaseService , uuid : uuid)
        
        let viewController = OtherProfileVC(viewModel:viewModel)
        self.navigationController.navigationBar.topItem?.title = ""
        self.navigationController.navigationBar.tintColor = .black
        
        viewController.hidesBottomBarWhenPushed = true

        self.navigationController.pushViewController(viewController , animated: false)
    
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
    
    
    func pushBlockList(){
       

        let viewController = BlockListVC(viewModel: BlockListVM(coordinator: self, firebaseService: self.firebaseService))
        
   

        self.navigationController.pushViewController(viewController, animated: false)
        
    }
 
 
    
    func logout() {
        
        
        
        self.finishDelegate?.coordinatorDidFinish(childCoordinator: self)
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
    
    
    func pushProfileFeed(feedUid:String){
        let commuCoordinator = CommuCoordinator(self.navigationController)
        
        childCoordinator.append(commuCoordinator)
        commuCoordinator.finishDelegate = self
        commuCoordinator.pushProfileFeed(feedUid: feedUid)
        
    }

    
    
    func pushFollowsVC( follow : Bool , uid : String , name : String ) {
        
        let coordinator = FollowsCoordinator(self.navigationController)
        
        childCoordinator.append(coordinator)
        coordinator.finishDelegate = self
        coordinator.startPush(follow: follow , uid : uid, name: name  )
        
    }
    
    func refreshChild() {
        
        self.childCoordinator = []

    }
    
    
    
    
    
    
    
}
extension ProfileCoordinator : CoordinatorFinishDelegate {
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

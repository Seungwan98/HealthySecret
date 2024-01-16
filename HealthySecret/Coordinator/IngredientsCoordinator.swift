//
//  IngredientsCoordinator.swift
//  HealthySecret
//
//  Created by 양승완 on 2023/11/14.
//

import Foundation
import UIKit

//탭바 두번째 인자 컨트롤러
class IngredientsCoordinator : Coordinator {

    var navigationController: UINavigationController
    
    var finishDelegate: CoordinatorFinishDelegate?
        
    var childCoordinator : [Coordinator] = []
    
    var type : CoordinatorType = .ingredients
    
    var filteredArr : [Row] = []
    
    required init(_ navigationController : UINavigationController){
        self.navigationController = navigationController
    }
    
    func start() {
        let firebaseService = FirebaseService()
        let ingredientsVM =  IngredientsVM(coordinator: self, firebaseService: firebaseService)
        let viewController = IngredientsViewController(viewModel : ingredientsVM )

        viewController.view.backgroundColor = UIColor(red: 0.949, green: 0.918, blue: 0.886, alpha: 1) 
        viewController.hidesBottomBarWhenPushed = true
        
     


        self.navigationController.navigationBar.topItem?.title = ""
        self.navigationController.navigationBar.tintColor = .white
        self.navigationController.pushViewController(viewController, animated: true)
     

        
        
    }
    
    func backToDiaryVC(){
        
        finishDelegate?.coordinatorDidFinish(childCoordinator: self)
        
    }
    
    
    func startDetailView(_ detailContent : Row ) {
       
        
    }
    
    func startAnalyzeView(_ filteredArr : [Row] ){
        
//        print("startAn")
//
//        self.filteredArr = filteredArr
//        let viewController = DiaryViewController(viewModel: DiaryVM(coordinator: <#DiaryCoordinator#>, firebaseService: <#FirebaseService#>))
//        self.navigationController.pushViewController(viewController, animated: true)
    }
    
    
    
    
 
    
}

extension IngredientsCoordinator : CoordinatorFinishDelegate {
    func coordinatorDidFinish(childCoordinator: Coordinator) {
        // 자식 뷰를 삭제하는 델리게이트 (자식 -> 부모 접근 -> 부모에서 자식 삭제)
        self.childCoordinator = self.childCoordinator
            .filter({ $0.type != childCoordinator.type })
        childCoordinator.navigationController.popToRootViewController(animated: true)
    }
    
    
}

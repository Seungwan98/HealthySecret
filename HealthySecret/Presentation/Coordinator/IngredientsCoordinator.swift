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
    func start() {
        
    }
    func finish() {
        navigationController.popViewController(animated: false)
    }
    
    
    var navigationController: UINavigationController
    
    var finishDelegate: CoordinatorFinishDelegate?
    
    var childCoordinator : [Coordinator] = []
    
    var type : CoordinatorType = .ingredients
    
    var filteredArr : [Row] = []
    
    required init(_ navigationController : UINavigationController){
        self.navigationController = navigationController
        self.navigationController.navigationBar.tintColor = .white
        self.navigationController.navigationBar.topItem?.title = ""
    }
    
    func pushIngredientsSelecting(arr:[Row]){
        self.filteredArr = arr
        let firebaseService = FirebaseService()
        let ingredientsVM =  IngredientsVM(coordinator: self, firebaseService: firebaseService)
        
        ingredientsVM.lastArr = arr
        let viewController = IngredientsViewController(viewModel : ingredientsVM )
        
        viewController.view.backgroundColor = UIColor(red: 0.949, green: 0.918, blue: 0.886, alpha: 1)
        viewController.hidesBottomBarWhenPushed = true
        
        
        
        
        //self.navigationController.popViewController(animated: false)
    
        self.navigationController.pushViewController(viewController, animated: false)
    }
    
    
    func pushIngredientsEdmit(arr:[Row]){
        let firebaseService = FirebaseService()
        let EditIngredientsVM =  EditIngredientsVM(coordinator: self, firebaseService: firebaseService, Ingredients: arr)
        let viewController = EditIngredientsVC(viewModel: EditIngredientsVM )
        viewController.hidesBottomBarWhenPushed = true

     
        
        self.navigationController.pushViewController(viewController, animated: false)
        
    }
    
    
    func pushIngredientsVC(arr : [Row]) {
        
        if(arr.isEmpty){

            pushIngredientsSelecting(arr: arr)
        }
        else{
            pushIngredientsEdmit(arr: arr)
        }
        
        
        
        
        
        
        
        
        
        
        
        
    }
    func pushIngredientsDetail(row : Row){
        
        let firebaseService = FirebaseService()
        let ingredientsDetailVM =  IngredientsDetailVM(coordinator: self, firebaseService: firebaseService, row: row)
        let viewController = IngredientsDetailVC(viewModel: ingredientsDetailVM )
        viewController.hidesBottomBarWhenPushed = true


        self.navigationController.navigationBar.backgroundColor = UIColor(red: 0.09, green: 0.18, blue: 0.03, alpha: 1)
        self.navigationController.pushViewController(viewController, animated: false)
        
    }
    
    func backToDiaryVC(){
        self.navigationController.hidesBottomBarWhenPushed = false
        self.finishDelegate?.coordinatorDidFinish(childCoordinator: self)
        
    }
    
    
    
    
    
    
}

extension IngredientsCoordinator : CoordinatorFinishDelegate {
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

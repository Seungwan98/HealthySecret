//
//  DetailPageCoordinator.swift
//  HealthySecret
//
//  Created by 양승완 on 2023/11/20.
//

import UIKit
import Foundation



class CalendarCoordinator: Coordinator {
    
    var parentCoordinator: DiaryCoordinator?
    
    var childCoordinator: [Coordinator] = []
        
    var navigationController: UINavigationController
    
    var finishDelegate: CoordinatorFinishDelegate?
    
    var type: CoordinatorType = .calendar
    
    required init(_ navigationController: UINavigationController ) {
        self.navigationController = navigationController
    }
    
    func start() {
        let firebaseService = FirebaseService()
        let viewModel = CalendarVM(coordinator: self, calendarUseCase: CalendarUseCase(exerciseRepository: DefaultExerciseRepository(firebaseService: firebaseService), userRepository: DefaultUserRepository(firebaseService: firebaseService)))
        let calendarViewController = CalendarViewController(viewModel: viewModel)
        calendarViewController.view.backgroundColor =  .white
        calendarViewController.hidesBottomBarWhenPushed = true

        
        self.navigationController.navigationBar.topItem?.title = ""
        self.navigationController.navigationBar.tintColor = .black
        
        
        
        
        
        self.navigationController.pushViewController(calendarViewController, animated: true)
        
    }
    
    func pushAddDiaryVC(pickDate: String, diarys: [Diary]) {
        let firebaseService = FirebaseService()
        let viewModel = CalendarVM(coordinator: self, calendarUseCase: CalendarUseCase(exerciseRepository: DefaultExerciseRepository(firebaseService: firebaseService), userRepository: DefaultUserRepository(firebaseService: firebaseService)))
        viewModel.pickDate = pickDate
        viewModel.diarys = diarys
        
        let viewController = AddDiaryVC(viewModel: viewModel)
        viewController.view.backgroundColor =  .white
        
     
        self.navigationController.pushViewController(viewController, animated: true)

    }
    
    func BacktoDiaryVC() {
        finishDelegate?.coordinatorDidFinish(childCoordinator: self)

      
        
    }
    
    
}

extension CalendarCoordinator: CoordinatorFinishDelegate {
    func coordinatorDidFinishNotRoot(childCoordinator: any Coordinator) {
        //
    }
    
    func coordinatorDidFinish(childCoordinator: Coordinator) {
        print("CalendarDidFinished")
        self.childCoordinator = self.childCoordinator
            .filter({ $0.type != childCoordinator.type })
        childCoordinator.navigationController.popToRootViewController(animated: true)
    }
    
    
}

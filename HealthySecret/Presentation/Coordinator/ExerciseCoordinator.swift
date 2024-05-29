//
//  ExerciseCoordinator.swift
//  HealthySecret
//
//  Created by 양승완 on 2023/11/20.
//

import UIKit
import Foundation



class ExerciseCoordinator: Coordinator {
    func start() {
        
    }
    
    
    
    var childCoordinator: [Coordinator] = []
        
    var navigationController: UINavigationController
    
    var parentCoordinator : Coordinator?
    
    var finishDelegate: CoordinatorFinishDelegate?
    
    var type: CoordinatorType = .exercise
    
    let firebaseService : FirebaseService
    
    required init(_ navigationController: UINavigationController  ) {
        self.navigationController = navigationController
        self.firebaseService = FirebaseService()

        self.navigationController.navigationBar.tintColor = .white
        self.navigationController.navigationBar.topItem?.title = ""
        
    }
    
    func pushExerciseVC(exercises : [ExerciseModel]) {
        let viewModel = ExerciseVM(coordinator: self, exerciseUseCase: ExerciseUseCase(exerciseRepository: DefaultExerciseRepository(firebaseService: self.firebaseService), userRepository: DefaultUserRepository(firebaseService: self.firebaseService)) )
        viewModel.exercises =  exercises
        let ExerciseViewController = ExerciseViewController(viewModel: viewModel)

        ExerciseViewController.hidesBottomBarWhenPushed = true
        ExerciseViewController.view.backgroundColor = .white
        
        self.navigationController.pushViewController(ExerciseViewController, animated: false)
        
        
        
    }
    
    func pushExerciseDetailVC(model : ExerciseModel , exercises : [ExerciseModel]){
        
        let firebaseService = FirebaseService()
        let viewModel = ExerciseDetailVM(coordinator: self, firebaseService: firebaseService)
        viewModel.model = model
        viewModel.exercises = exercises
        let viewController = ExerciseDetailVC(viewModel: viewModel)
        
        viewController.hidesBottomBarWhenPushed = true

        self.navigationController.pushViewController(viewController, animated: false)
        
    }
    
    func pushEditExerciseVC(exercises:[ExerciseModel]){
        print("pushEdit")
        let firebaseService = self.firebaseService
        let viewController = EditExerciseVC(viewModel: EditExerciseVM(coordinator: self, exercises : exercises, exerciseUseCase: ExerciseUseCase(exerciseRepository: DefaultExerciseRepository(firebaseService: self.firebaseService ), userRepository: DefaultUserRepository(firebaseService: self.firebaseService))))

        viewController.hidesBottomBarWhenPushed = true

        self.navigationController.navigationBar.topItem?.title = ""
        self.navigationController.navigationBar.tintColor = .white

        self.navigationController.pushViewController( viewController , animated: false )
    }
    
    
    
    
    func finish() {
        
        finishDelegate?.coordinatorDidFinish(childCoordinator: self)
        
        
        
    }
    
    
    
   
    
    
}

extension ExerciseCoordinator : CoordinatorFinishDelegate {
  
    
    func coordinatorDidFinish(childCoordinator: Coordinator) {
        print("CalendarDidFinished")
        self.childCoordinator = self.childCoordinator
            .filter({ $0.type != childCoordinator.type })
        childCoordinator.navigationController.popToRootViewController(animated: true)
    }
    
    
    func coordinatorDidFinishNotRoot(childCoordinator: any Coordinator) {
        
        
        print("coordinatorDidFinishNotRoot")
        
        
    }
    
}

import UIKit
import Foundation


// 탭바 첫번째 인자 컨트롤러
class DiaryCoordinator: Coordinator {
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
    
   
 
    
    
    func pushEditIngredientsVC( arr: [IngredientsModel] ) {
        let ingredientsCoordinator =  IngredientsCoordinator( self.navigationController )
        ingredientsCoordinator.finishDelegate = self
        childCoordinator.append(ingredientsCoordinator)
        ingredientsCoordinator.pushIngredientsVC( arr: arr )
        
    }
     
    func pushCalendarVC() {
        let calendarCoordinator =  CalendarCoordinator( self.navigationController )
        calendarCoordinator.finishDelegate = self
        calendarCoordinator.parentCoordinator = self
        childCoordinator.append(calendarCoordinator)
        calendarCoordinator.start()
        
    }
    
 
  
    
    
    func pushDiaryVC() {
        
        let viewController = DiaryViewController(viewModel: DiaryVM( coordinator: self, diaryUseCase: DiaryUseCase(userRepository: DefaultUserRepository(firebaseService: self.firebaseService ))))
        
        self.navigationController.hidesBottomBarWhenPushed = false
        self.navigationController.pushViewController( viewController, animated: false )
    
    }
    
    func startExerciseCoordinator(exercises: [ExerciseModel]) {
        let exerciseCoordinator =  ExerciseCoordinator( self.navigationController )
        exerciseCoordinator.finishDelegate = self
        exerciseCoordinator.parentCoordinator = self
        childCoordinator.append(exerciseCoordinator)
        
        if exercises.isEmpty {
            
            
            exerciseCoordinator.pushExerciseVC(exercises: exercises)
            
        } else {
            exerciseCoordinator.pushEditExerciseVC(exercises: exercises)
        }
        


        
    }
    
    func presentDetailView(models: IngredientsModel ) {
        // print("pushDetailView")
        let viewController = DetailModalVC(models: models)
            
        viewController.view.backgroundColor = .white
        self.navigationController.present(viewController, animated: true)
        
        
        
        
    }
    
    func pop() {
        print("popnavigation")
        self.navigationController.popViewController(animated: false)
        
    }
    
    func refreshChild() {
        self.childCoordinator = []
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

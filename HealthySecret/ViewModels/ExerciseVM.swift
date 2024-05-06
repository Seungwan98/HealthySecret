//
//  ExerciseVM.swift
//  HealthySecret
//
//  Created by 양승완 on 2023/11/28.
//

import Foundation
import RxCocoa
import RxSwift


class ExerciseVM : ViewModel {
    
    
    var disposeBag = DisposeBag()
    
    
    struct Input {
        let viewWillApearEvent : Observable<Void>
        let cellTapped : Observable<ExerciseDtoData>
        let searchText : Observable<String>
        
    }
    
    struct Output {
        let exerciseArr = BehaviorSubject<[ExerciseDtoData]>(value: [] )
        let checkController = BehaviorSubject<Bool>(value: false)
        let titleLabelText = BehaviorSubject<String>(value: "")

    }
    
    
    weak var coordinator : ExerciseCoordinator?
    
    private var firebaseService : FirebaseService
    
    init( coordinator : ExerciseCoordinator , firebaseService : FirebaseService ){
        self.coordinator =  coordinator
        self.firebaseService =  firebaseService
        
    }
    
    
    var exerciseArr : ExerciseDTO?
    
    func transform(input: Input, disposeBag: DisposeBag ) -> Output {
        
        let output = Output()

        input.viewWillApearEvent.subscribe(onNext: {
            
            self.firebaseService.getExercise().subscribe({
                        single in
                        
                        switch single{
                        case.success(let exercise):

                            
                            
                            input.searchText.map({ [weak self] text in
                                var arr = exercise.data

                                print("\(text) text")
                                var check : Bool = false
                                if text.isEmpty{
                                    check = false
                                    output.exerciseArr.onNext(arr)

                                }else{
                                    arr = arr.filter{ $0.name.localizedCaseInsensitiveContains(text) }
                                    print(arr)
                                    output.exerciseArr.onNext(arr)
                                    check = true
                                    
                                }
                                
                                
                                
                                return check
                            }).bind(to: output.checkController).disposed(by: disposeBag)
                            
                            
                        case.failure(_):
                            print("exercise fail")
                        }
                        
                
                
                        
                    }).disposed(by: disposeBag)
            
            
            
            
        }).disposed(by: disposeBag)
        
        input.cellTapped.subscribe(onNext:{
            model in
            
            self.coordinator?.pushDetailVC(model : model)
            
            
            
        }).disposed(by: disposeBag)
     
        
        output.titleLabelText.onNext(UserDefaults.standard.string(forKey: "date") ?? "")

    
     
        
        
        return output
    }
    
    
    
    
    
    
    
}

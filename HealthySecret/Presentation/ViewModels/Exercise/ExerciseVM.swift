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
    
    var exercises : [ExerciseModel]?
    
    struct Input {
        let viewWillApearEvent : Observable<Void>
        let cellTapped : Observable<ExerciseModel>
        let searchText : Observable<String>
        
    }
    
    struct Output {
        let exerciseArr = BehaviorSubject<[ExerciseModel]>(value: [] )
        let checkController = BehaviorSubject<Bool>(value: false)
        let titleLabelText = BehaviorSubject<String>(value: "")
        
    }
    
    
    weak var coordinator : ExerciseCoordinator?
    private let exerciseUseCase : ExerciseUseCase
    
    init( coordinator : ExerciseCoordinator , exerciseUseCase : ExerciseUseCase ){
        self.coordinator =  coordinator
        self.exerciseUseCase = exerciseUseCase
    }
    
    
    var exerciseArr : ExerciseDTO?
    
    func transform(input: Input, disposeBag: DisposeBag ) -> Output {
        
        let output = Output()
        
        input.viewWillApearEvent.subscribe(onNext: {
            
            self.exerciseUseCase.getExerciseList().subscribe({ event in
                switch(event){
                case.success(let models):
                    input.searchText.subscribe(onNext:{ [weak self] text in
                        guard let self = self else {return}
                        var arr = models
                        
                        print("\(text) text")
                        if text.isEmpty{
                            output.exerciseArr.onNext(arr)
                            
                        }else{
                            arr = arr.filter{ $0.name.localizedCaseInsensitiveContains(text) }
                            print(arr)
                            output.exerciseArr.onNext(arr)
                            
                        }
                        
                    }).disposed(by: disposeBag)
                    
                    
                case .failure(let err):
                    print(err)
                }
                
                
            }).disposed(by: disposeBag)
            
            
            
        }).disposed(by: disposeBag)
        
        input.cellTapped.subscribe(onNext:{
            model in
            
            print("model \(model)")
            self.coordinator?.pushExerciseDetailVC(model : model , exercises : self.exercises ?? [])
            
            
            
        }).disposed(by: disposeBag)
        
        
        output.titleLabelText.onNext(UserDefaults.standard.string(forKey: "date") ?? "")
        
        
        
        
        
        return output
    }
    
    
    
    
    
    
    
}

//
//  AnalyzeVM.swift
//  HealthySecret
//
//  Created by 양승완 on 2023/12/11.
//

import Foundation
import RxSwift
import RxRelay
import RxCocoa

class SearchVM: ViewModel {
    
    var disposeBag = DisposeBag()
 
    
    
    
    
    weak var coordinator: CommuCoordinator?

    private let likesUseCase: LikesUseCase
    
    init( coordinator: CommuCoordinator, likesUseCase: LikesUseCase ) {
        self.coordinator =  coordinator
        self.likesUseCase =  likesUseCase
        
    }
    
    
    struct Input {
        let viewWillApearEvent: Observable<Void>
        let pressedFollows: Observable<[String: Bool]>
        let pressedProfile: Observable<String>
        let searchText: Observable<String>
        
    }
    
    struct Output {
        
        var userModels = BehaviorSubject<[UserModel]>(value: [])
        var backgroundViewHidden = PublishSubject<Bool>()
        
        
    }
    
   
 
    func transform(input: Input, disposeBag: DisposeBag) -> Output {
        
        let output = Output()
        
        
        let algoliaSearch = AlgoliaService()
        
        
        input.pressedProfile.subscribe(onNext: { [weak self] idx in
            
            guard let self else {return}
            
            self.coordinator?.pushProfileVC(uuid: idx)
            
            
            
            
        }).disposed(by: disposeBag)
        
        
        input.searchText.subscribe(onNext: { [weak self] text in
            if !text.isEmpty {
                
                algoliaSearch.searchTeams(searchText: text).subscribe({ single in
                    switch single {
                    case .success(let users):
                        output.userModels.onNext(users)
                    case .failure(let err):
                        print(err)
                    }
                    
                    
                    
                    
                }).disposed(by: disposeBag)
            }
            
        }).disposed(by: disposeBag)
      
        
        
        
        input.pressedFollows.subscribe(onNext: { [weak self] data in
            
            guard let self = self else {return}
            
            if data.count > 1 {
                return
            } else {
                
                
                guard let follow = data.first?.value, let uid = data.first?.key else {return}
                
                self.likesUseCase.updateFollowers( opponentUid: uid, follow: follow ).subscribe({ event in
                    
                    switch event {
                        
                    case.completed:
                        print("팔로워 완")
                    case.error(let err):
                        print(err)
                        
                    }
                    
                    
                    
                }).disposed(by: disposeBag)
                
            }
            
            
            
            
        }).disposed(by: disposeBag)
        
        return output
        
    }
    
    
    
    
   
    
    
    
}

//
//  LikesVM.swift
//  HealthySecret
//
//  Created by 양승완 on 2023/11/28.
//

import Foundation
import RxCocoa
import RxSwift


class LikesVM: ViewModel {
    
    var uid: String?
    var feedUid: String?
    
    
    var disposeBag = DisposeBag()
    
    
    
    struct Input {
        let viewWillApearEvent: Observable<Void>
        let pressedFollows: Observable<[String: Bool]>
        let pressedProfile: Observable<String>
        
    }
    
    struct Output {
        
        var userModels = BehaviorSubject<[UserModel]>(value: [])
        var backgroundViewHidden = PublishSubject<Bool>()
        
        
    }
    
    
    weak var coordinator: CommuCoordinator?
    
    
    
    
    private let likesUseCase: LikesUseCase
    
    init( coordinator: CommuCoordinator, likesUseCase: LikesUseCase ) {
        self.coordinator =  coordinator
        self.likesUseCase =  likesUseCase
        
    }
    
    
    
    func transform(input: Input, disposeBag: DisposeBag ) -> Output {
        
        let output = Output()
        
        
        guard UserDefaults.standard.string(forKey: "uid") != nil else {
            print("ownUid nil")
            return output }
        
        
        
        
        
        input.pressedProfile.subscribe(onNext: { [weak self] idx in
            
            guard let self = self else {return}
            
            self.coordinator?.pushProfileVC(uuid: idx)
            
            
            
            
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
        
        
        
        input.viewWillApearEvent.subscribe({ [weak self] _ in
            guard let self = self, let feedUid = self.feedUid else { return }
            
            
            
            self.likesUseCase.getLikes(feedUid: feedUid).subscribe({ event in
                
                
                
                
                switch event {
                case.success(let likes):
                    output.userModels.onNext( likes)
                    output.backgroundViewHidden.onNext(!likes.isEmpty)
                    
                    
                    
                case.failure(let err):
                    break
                    
                }
                
                
                
                
            }).disposed(by: disposeBag )
            
            
            
            
        }).disposed(by: disposeBag)
        
        
        
        
        
        
        
        
        
        
        
        return output
    }
    
    
    
    
    
    
    
}

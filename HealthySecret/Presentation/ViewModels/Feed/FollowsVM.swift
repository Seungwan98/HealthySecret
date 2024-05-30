//
//  FollowsVM.swift
//  HealthySecret
//
//  Created by 양승완 on 2023/11/28.
//

import Foundation
import RxCocoa
import RxSwift


class FollowsVM : ViewModel {
    
    var follow : Bool?
    var uid : String?
    private var followings : [UserModel] = []
    private var followers : [UserModel] = []
    
    var disposeBag = DisposeBag()
    
    

    
    struct Input {
        let viewWillApearEvent : Observable<Void>
        let backButtonTapped : Observable<Void>
        let segmentChanged : Observable<Bool>
        let pressedFollows : Observable<[String:Bool]>
        let pressedProfile : Observable<String>

    }
    
    struct Output {
        
        var userModels = BehaviorSubject<[UserModel]>(value: [])
        var follow = BehaviorSubject<Bool?>(value: nil)
        var backgroundViewHidden = PublishSubject<Bool>()

        
    }
    
    
    weak var coordinator : FollowsCoordinator?
    
    private let followUseCase : FollowUseCase


    
    init( coordinator : FollowsCoordinator , followUseCase : FollowUseCase ){
        self.coordinator =  coordinator
        self.followUseCase =  followUseCase
        
    }
    
    
    
    func transform(input: Input, disposeBag: DisposeBag ) -> Output {
        
        let output = Output()

        
        
        guard let uid = self.uid  else { return output }
        
        
        
        
        
        
        input.segmentChanged.subscribe(onNext:{ [weak self] event in
            
            guard let self else {return}
            
        
            if(event){
                output.userModels.onNext(self.followers)
                output.backgroundViewHidden.onNext(!self.followers.isEmpty)
                
            }else{
                output.userModels.onNext(self.followings)
                output.backgroundViewHidden.onNext(!self.followings.isEmpty)

            }
            
        }).disposed(by: disposeBag)
        
        
        
        input.backButtonTapped.subscribe({ [weak self] _  in
            print("tapp")
            self?.coordinator?.finish()
            
            
        }).disposed(by: disposeBag)
        
        input.pressedFollows.subscribe(onNext: { [weak self] data in
            
            guard let self else {return}
            
            if(data.count > 1 ){
                return
            }else{
                

                guard let like = data.first?.value , let uid = data.first?.key  else {return}
                
                self.followUseCase.updateFollowers(opponentUid: uid  , follow: like).subscribe({ event in
                    
                    switch(event){
                        
                    case.completed:
                        print("팔로워 완")
                    case.error(let err):
                        print(err)
                        
                    }
                    
                    
                    
                }).disposed(by: disposeBag)
                
            }
            
            
            
            
        }).disposed(by: disposeBag)
        
        input.pressedProfile.subscribe(onNext: { [weak self] idx in
            
            guard let self = self else {return}
            
            self.coordinator?.pushProfileVC(uuid: idx)
           
            
            
            
        }).disposed(by: disposeBag)
        
        
        
        input.viewWillApearEvent.subscribe({ [weak self] _ in
            
            
                guard let self = self else { return }
            
            if let follow = self.follow {
                
                
                output.follow.onNext(follow)
                
                
                
                
                
                
                self.followUseCase.getFollows(uid: uid).subscribe({ [weak self]  event in
                    guard let self else { return }

                    switch(event){
                    case.success(let dic):
                        self.followers = dic[ .followers ] ?? []
                        self.followings = dic[ .followings ] ?? []
                            
                            if(follow){
                                
                                output.userModels.onNext(self.followers)
                                output.backgroundViewHidden.onNext(!self.followers.isEmpty)
                            }else{
                                output.userModels.onNext(self.followings)
                                output.backgroundViewHidden.onNext(!self.followings.isEmpty)
                            }
                            
                        
                        
                        
                    case.failure(let err):
                        print(err)
                        break
                        
                    }
                    
                    
                    
                    
                }).disposed(by: disposeBag )
                
            }
            
            
        }).disposed(by: disposeBag)
        
        
        
        
        
        

        
       
        
        
        return output
    }
    
    
    
    
    
    
    
}

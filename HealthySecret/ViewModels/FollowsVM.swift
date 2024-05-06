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
    var followings : [UserModel] = []
    var followers : [UserModel] = []
   // var coreMotionService = CoreMotionService.shared
    
    var disposeBag = DisposeBag()
    

    
    struct Input {
        let viewWillApearEvent : Observable<Void>
        let backButtonTapped : Observable<Void>
        let segmentChanged : Observable<Bool>
        let pressedFollows : Observable<[String:Bool]>

    }
    
    struct Output {
        
        var userModels = BehaviorSubject<[UserModel]>(value: [])
        var follow = BehaviorSubject<Bool?>(value: nil)

        
    }
    
    
    weak var coordinator : FollowsCoordinator?
    
    
    
    
    private var firebaseService : FirebaseService
    
    init( coordinator : FollowsCoordinator , firebaseService : FirebaseService ){
        self.coordinator =  coordinator
        self.firebaseService =  firebaseService
        
    }
    
    
    
    func transform(input: Input, disposeBag: DisposeBag ) -> Output {
        
        let output = Output()

        
        guard let ownUid = UserDefaults.standard.string(forKey: "uid") else {
            print("ownUid nil")
            return output }
        
        guard let uid = self.uid else { print("uid nil")
                                return output }
        
        
        
        
        
        
        input.segmentChanged.subscribe(onNext:{ [weak self] event in
            
            guard let self = self else {return}
            
        
            if(event){
                print("changed \(self.followers) " )
                output.userModels.onNext(self.followers)
            }else{
                    print("changed \(self.followings) " )
                output.userModels.onNext(self.followings)
            }
            
        }).disposed(by: disposeBag)
        
        
        
        input.backButtonTapped.subscribe({ [weak self] _  in
            print("tapp")
            self?.coordinator?.finish()
            
            
        }).disposed(by: disposeBag)
        
        input.pressedFollows.subscribe(onNext: { [weak self] data in
            
            guard let self = self else {return}
            
            if(data.count > 1 ){
                return
            }else{
                

                guard let like = data.first?.value , let uid = data.first?.key  else {return}
                
                self.firebaseService.updateFollowers(ownUid: ownUid , opponentUid: uid  , follow: like).subscribe({ event in
                    
                    switch(event){
                        
                    case.completed:
                        print("팔로워 완")
                    case.error(let err):
                        print(err)
                        
                    }
                    
                    
                    
                }).disposed(by: disposeBag)
                
            }
            
            
            
            
        }).disposed(by: disposeBag)
        
        
        
        input.viewWillApearEvent.subscribe({ [weak self] _ in
            
                guard let self = self else { return }
                
                self.firebaseService.getDocument(key: uid).subscribe({  event in
                    
                  
                    
                    
                    
                    switch(event){
                    case.success(let user):
                 
                        self.firebaseService.getFollows(uid: user.followers ?? [] ).subscribe({ event in
                            switch(event){
                            case.success(let followers):
                                self.followers = followers
                                
                                self.firebaseService.getFollows(uid: user.followings ?? [] ).subscribe({ event in
                                    
                                    switch(event){
                                    case.success(let followings):
                                        
                                        self.followings = followings
                                        
                                       
                                        if let follow = self.follow {
                                            
                                            if(follow){
                                                output.userModels.onNext(self.followers)
                                                output.follow.onNext(true)
                                            }else{
                                                output.userModels.onNext(self.followings)
                                                output.follow.onNext(false)
                                            }
                                            
                                            
                                            
                                        }
                                        
                                        
                                    case.failure(let err):
                                        print(err)
                                    }
                                    
                                    
                                    
                                }).disposed(by: disposeBag)
                                
                                
                                
                                
                            case.failure(let err):
                                print(err)
                            }
                            
                            
                            
                        }).disposed(by: disposeBag)
                        
                        
                    case.failure(let err):
                        print(err)
                        break
                        
                    }
                    
                    
                    
                    
                }).disposed(by: disposeBag )
                
                
            
            
        }).disposed(by: disposeBag)
        
        
        
        
        
        

        
       
        
        
        return output
    }
    
    
    
    
    
    
    
}

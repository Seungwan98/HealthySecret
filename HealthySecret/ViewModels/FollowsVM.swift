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
        let pressedProfile : Observable<String>

    }
    
    struct Output {
        
        var userModels = BehaviorSubject<[UserModel]>(value: [])
        var follow = BehaviorSubject<Bool?>(value: nil)
        var backgroundViewHidden = PublishSubject<Bool>()

        
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
                output.backgroundViewHidden.onNext(!self.followers.isEmpty)
                
            }else{
                    print("changed \(self.followings) " )
                output.userModels.onNext(self.followings)
                output.backgroundViewHidden.onNext(!self.followings.isEmpty)

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
        
        input.pressedProfile.subscribe(onNext: { [weak self] idx in
            
            guard let self = self else {return}
            
            self.coordinator?.pushProfileVC(uuid: idx)
           
            
            
            
        }).disposed(by: disposeBag)
        
        
        
        input.viewWillApearEvent.subscribe({ [weak self] _ in
            
            
                guard let self = self else { return }
            
            if let follow = self.follow {
                
                
                output.follow.onNext(follow)
                
                
                
                
                
                
                self.firebaseService.getDocument(key: uid).subscribe({  event in
                    
                    
                    
                    
                    
                    switch(event){
                    case.success(let user):
                        
                        self.firebaseService.getFollowsLikes(uid: user.followers ?? [] ).subscribe({ event in
                            switch(event){
                            case.success(let followers):
                                self.followers = followers
                                
                                self.firebaseService.getFollowsLikes(uid: user.followings ?? [] ).subscribe({ event in
                                    
                                    switch(event){
                                    case.success(let followings):
                                        
                                        self.followings = followings
                                        
                                        
                                     
                                            
                                            if(follow){
                                                
                                                output.userModels.onNext(self.followers)
                                                output.backgroundViewHidden.onNext(!self.followers.isEmpty)
                                            }else{
                                                output.userModels.onNext(self.followings)
                                                output.backgroundViewHidden.onNext(!self.followings.isEmpty)
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
                
            }
            
            
        }).disposed(by: disposeBag)
        
        
        
        
        
        

        
       
        
        
        return output
    }
    
    
    
    
    
    
    
}

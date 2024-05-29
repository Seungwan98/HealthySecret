//
//  OtherProfileVM.swift
//  HealthySecret
//
//  Created by 양승완 on 2023/11/28.
//

import Foundation
import RxCocoa
import RxSwift


class OtherProfileVM : ViewModel {
    
    
    var disposeBag = DisposeBag()
    
    var feeds:[FeedModel]?
    
    var uuid:String

    var profileImage:Data?
    
    var name:String?
 
    struct Input {
        
        let viewWillApearEvent : Observable<Void>
        let outputProfileImage : Observable<Data?>
        let imageTapped : Observable<String>
        let addButtonTapped : Observable<Bool>
        let blockAndReport : Observable<String>

    }
    
    struct Output {
        
        var feedImage = BehaviorSubject<[[String]]?>(value: nil)
        var feedUid = BehaviorSubject<[String]?>(value: nil)
        var alert = PublishSubject<Bool>()

    }
    
    struct HeaderInput {
        
        let viewWillApearEvent : Observable<Bool>
        let outputProfileImage : Observable<Data?>
        let outputFollows : Observable<UITapGestureRecognizer>
        
    }
    
    struct HeaderOutput {
        
        var calorie = BehaviorSubject(value: "")
        var goalWeight = BehaviorSubject(value: "")
        var nowWeight = BehaviorSubject(value: "")
        var name = BehaviorSubject(value: "")
        var introduce = BehaviorSubject(value: "")
        var profileImage = BehaviorSubject<String?>(value: nil)
        var popView = BehaviorSubject<Bool>(value: false)
        var followersSelected = BehaviorSubject<Bool?>(value: nil)
        var followersCount = BehaviorSubject<Int>(value: 0)
        var followingsCount = BehaviorSubject<Int>(value: 0)
        var followersEnable = BehaviorSubject<Bool>(value: true)
        
    }
    
    
    weak var coordinator : ProfileCoordinator?
    
    private var firebaseService : FirebaseService
    
    var nowUser : UserModel?

    
    init( coordinator : ProfileCoordinator , firebaseService : FirebaseService , uuid : String ){
        
        self.coordinator =  coordinator
        self.firebaseService =  firebaseService
        self.uuid = uuid
        
    }
    
    func HeaderTransform(input : HeaderInput , disposeBag: DisposeBag) -> HeaderOutput {
        
        let output = HeaderOutput()

        
        guard let ownUid = UserDefaults.standard.string(forKey: "uid") else { return output  }
        
        let uid = self.uuid
        
        
        input.outputProfileImage.subscribe(onNext:{ image in

            self.profileImage = image

        }).disposed(by: disposeBag)
        
        input.outputFollows.subscribe(onNext: { event in
          
            guard let view = event.view else {return}
            let name = self.name ?? ""
            
            if(view.tag == 1 ){
                self.coordinator?.pushFollowsVC(follow: true , uid : uid , name: name)
                
            }else{
                
                self.coordinator?.pushFollowsVC(follow: false , uid : uid , name: name)
            }
            
            
        }).disposed(by: disposeBag)
        
       
        
        input.viewWillApearEvent.subscribe(onNext: { event in
            
            self.firebaseService.getDocument(key: uid ).subscribe{ [weak self]
                event in
                guard let self = self else {return}
                switch(event){
                case.success(let user):
                    
                    
                    self.nowUser = user
                    self.name = user.name
                    
                    output.introduce.onNext(user.introduce ?? "아직 소개글이 없어요")
                    output.goalWeight.onNext(String(user.goalWeight))
                    output.nowWeight.onNext(String(user.nowWeight))
                    output.calorie.onNext(String(user.calorie))
                    output.name.onNext(user.name)
                    output.profileImage.onNext(user.profileImage ?? nil)
                    output.followingsCount.onNext((user.followings ?? []).count)
                    
                    
                    
                    
                    
                    
                    var selected = false
                    
                    if let followers = user.followers {
                        
                        
                        
                        print("\(followers) followers")
                        
                        if(followers.contains(ownUid)){

                            selected = true
                        }
                        output.followersCount.onNext(followers.count)

                    }
                    
                    
                    let event = (uid == ownUid)
                    
                    output.followersEnable.onNext(event)
                    output.followersSelected.onNext(selected)

                    
                    
                    
                    
                case .failure(_):
                    print("fail to get Doc")
                }
                
    
                
            }.disposed(by: disposeBag)
            
            
        }).disposed(by: disposeBag)
        
        return output
        
    }
    
    
    func transform(input: Input, disposeBag: DisposeBag ) -> Output {
        
        
        let uid = self.uuid
        
        
        let output = Output()
        
        guard let ownUid = UserDefaults.standard.string(forKey: "uid") else { return output  }
        
        input.blockAndReport.subscribe(onNext: { event in
            
            if(event == "block"){
                
                self.firebaseService.blockUser(ownUid: ownUid, opponentUid: uid, block: true).subscribe({ event in
                    switch(event){
                    case.completed:
                        self.coordinator?.finish()
                        
                    case.error(let err):
                        
                        print(err)
                        
                        
                    }
                    
                    
                }).disposed(by: disposeBag)
            }else{
                
                self.firebaseService.report(url: "HealthySecretUsers", uid: uid , uuid: uid , event: "user").subscribe({ event in
                    
                    switch(event){
                        
                    case.completed:
                        output.alert.onNext(true)
                    case.error(let err):
                        print("식패")
                    }
                    
                    
                }).disposed(by: disposeBag)
                
                
            }
            
        }).disposed(by: disposeBag)
        
        input.addButtonTapped.throttle(.seconds(1),  scheduler: MainScheduler.instance).subscribe(onNext:{ selected in
            
            self.firebaseService.updateFollowers(ownUid: ownUid , opponentUid: uid, follow: selected).subscribe({ completable in
                switch(completable){
                    
                case.completed: print("complete update Followers")
                    
                case.error(let err):
                    print(err)
                    
                }
                
                
            }).disposed(by: disposeBag)
            
            
        }).disposed(by: disposeBag)
      
        input.imageTapped.subscribe(onNext:{ feedUid in
          
            self.feeds?.forEach({
                if(feedUid == $0.feedUid){
                    self.coordinator?.pushProfileFeed(feedUid: feedUid)
                }
                
                
            })
            
        }).disposed(by: disposeBag)
        
        input.viewWillApearEvent.subscribe(onNext: { event in
            
                //리팩
        
//                    self.firebaseService.getFeedsUid(uid: uid).subscribe({ event in
//                    switch(event){
//                    case.success(let feedArr):
//                        self.feeds = feedArr
//                        
//                        
//                        let imageArr = feedArr.map({
//                            $0.mainImgUrl
//                        })
//                        
//                        let uidArr =  feedArr.map({
//                            $0.feedUid
//                        })
//                        
//                        
//                        output.feedImage.onNext(imageArr)
//                        output.feedUid.onNext(uidArr)
//                        
//                        
//                        
//                    case.failure(let err):
//                        print(err)
//                    }
//                    
//                    
//                }).disposed(by: disposeBag)
            
            
        }).disposed(by: disposeBag)
        
        
     
        
        
        return output
    }
    
    
    
    
    
    
   
}

//
//  MyprofileVM.swift
//  HealthySecret
//
//  Created by 양승완 on 2023/11/28.
//

import Foundation
import RxCocoa
import RxSwift
import FirebaseStorage
import FirebaseAuth


class MyProfileVM : ViewModel {
    
    
    var disposeBag = DisposeBag()
    
    var name : String?
    
    var feeds:[FeedModel]?
    
    var profileImage:Data?
    
    struct Input {
        let viewWillApearEvent : Observable<Void>
        let leftBarButton : Observable<UITapGestureRecognizer>
        let settingTapped : Observable<UITapGestureRecognizer>
        let addButtonTapped : Observable<Void>
        let outputProfileImage : Observable<Data?>
        let imageTapped : Observable<String>
        
    }
    
    struct Output {
        
        var feedImage = BehaviorSubject<[[String]]?>(value: nil)
        var feedUid = BehaviorSubject<[String]?>(value: nil)
        
        
        
    }
    
    struct HeaderInput {
        let viewWillApearEvent : Observable<Bool>
        
        let goalLabelTapped : Observable<UITapGestureRecognizer>
        let changeProfile : Observable<UITapGestureRecognizer>
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
    
    private let profileUseCase : ProfileUseCase
    
    var nowUser : UserModel?
    
    
    init( coordinator : ProfileCoordinator , profileUseCase : ProfileUseCase ){
        
        self.coordinator =  coordinator
        self.profileUseCase = profileUseCase
    }
    
    func HeaderTransform(input : HeaderInput , disposeBag: DisposeBag) -> HeaderOutput {
        let ownUid = UserDefaults.standard.string(forKey: "uid") ?? ""
        
        
        let output = HeaderOutput()
        
        
        input.outputProfileImage.subscribe(onNext:{ image in
            
            self.profileImage = image
            
        }).disposed(by: disposeBag)
        
        input.outputFollows.subscribe(onNext: { event in
            
            guard let view = event.view else {return}
            let name = self.name ?? ""
            if(view.tag == 1 ){
                self.coordinator?.pushFollowsVC(follow: true , uid : ownUid, name: name)
                
            }else{
                
                self.coordinator?.pushFollowsVC(follow: false , uid : ownUid, name: name)
            }
            
            
        }).disposed(by: disposeBag)
        
        input.changeProfile.when(.recognized).subscribe(onNext: { [weak self] _ in
            //print(nowUser)
            
            self?.coordinator?.pushChangeProfileVC(name: self?.nowUser?.name ?? "" , introduce: self?.nowUser?.introduce ?? "" , profileImage: self?.profileImage ?? nil , beforeImageUrl : self?.nowUser?.profileImage ?? "" )
            
        }).disposed(by: disposeBag)
        
        
        input.outputProfileImage.subscribe(onNext:{ image in
            
            
            
            self.profileImage = image
            
            
            
            
        }).disposed(by: disposeBag)
        
        input.goalLabelTapped.subscribe(onNext: { _ in
            
            self.coordinator?.pushChangeSignUpVC(user: self.nowUser!)
            
            
        }).disposed(by: disposeBag)
        
        
        
        input.viewWillApearEvent.subscribe(onNext: { event in
            
            
            
            
            self.profileUseCase.getUser().subscribe{ [weak self]
                event in
                guard let self = self else {return}
                switch(event){
                case.success(let user):
                    
                    UserDefaults.standard.set(user.profileImage, forKey: "profileImage")
                    
                    
                    self.nowUser = user
                    self.name = user.name
                    output.introduce.onNext(user.introduce ?? "아직 소개글이 없어요")
                    output.goalWeight.onNext(String(user.goalWeight))
                    output.nowWeight.onNext(String(user.nowWeight))
                    output.calorie.onNext(String(user.calorie))
                    output.name.onNext(user.name)
                    output.profileImage.onNext(user.profileImage ?? nil)
                    output.followingsCount.onNext(user.followings?.count ?? 0)
                    output.followersCount.onNext(user.followers?.count ?? 0)
                    
                    
                    
                    
                    
                    
                    
                    
                    
                    
                    
                    
                    
                    
                    
                    
                    
                    
                case .failure(_):
                    print("fail to get Doc")
                }
                
                
                
            }.disposed(by: disposeBag)
            
            
        }).disposed(by: disposeBag)
        
        return output
        
    }
    
    
    func transform(input: Input, disposeBag: DisposeBag ) -> Output {
        
        
        
        let output = Output()
        
        input.imageTapped.subscribe(onNext:{ feedUid in
            
            print(feedUid)
            self.feeds?.forEach({
                if(feedUid == $0.feedUid){
                    self.coordinator?.pushProfileFeed(feedUid: feedUid)
                }
                
                
            })
            
        }).disposed(by: disposeBag)
        
        input.leftBarButton.subscribe(onNext:{ _ in
            print("tapped")
            
            self.coordinator?.pushChangeProfileVC(name: self.nowUser?.name ?? "" , introduce: self.nowUser?.introduce ?? "" , profileImage: self.profileImage ?? nil , beforeImageUrl : self.nowUser?.profileImage ?? "" )
            
            
            
            
        }).disposed(by: disposeBag)
        
        input.addButtonTapped.subscribe(onNext: { _ in
            
            self.coordinator?.pushAddFeedVC()
            
            
        }).disposed(by: disposeBag)
        
        input.viewWillApearEvent.subscribe(onNext: { event in
            
            self.coordinator?.refreshChild()
            
            
            if let uid = UserDefaults.standard.string(forKey: "uid"){
                self.profileUseCase.getFeeds(uid: uid).subscribe({ event in
                    switch(event){
                    case.success(let feedArr):
                        self.feeds = feedArr
                        let imageArr = feedArr.map({
                            $0.mainImgUrl
                        })
                        
                        let uidArr =  feedArr.map({
                            $0.feedUid
                        })
                        
                        output.feedImage.onNext(imageArr)
                        output.feedUid.onNext(uidArr)
                        
                        
                        
                    case.failure(let err):
                        print(err)
                    }
                    
                    
                }).disposed(by: disposeBag)
            }
            
        }).disposed(by: disposeBag)
        
        
        
        
        
        
        
        
        
        
        
        
        input.settingTapped.subscribe(onNext: { [weak self] _ in
            
            self?.coordinator?.pushSettingVC()
            
        }).disposed(by: disposeBag)
        
        
        
        
        
        return output
    }
    
    
    
    
    struct SettingInput {
        let viewWillApearEvent : Observable<Void>
        let logoutTapped : Observable<UITapGestureRecognizer>
        let secessionTapped : Observable<Bool>
        let values : Observable<(String, String)>
        let OAuthCredential : Observable<OAuthCredential>
        let blockListTapped : Observable<UITapGestureRecognizer>
        
    }
    
    struct SettingOutput {
        var appleSecession = PublishSubject<Bool>()
        
        
    }
    
    func settingTransform(input: SettingInput, disposeBag: DisposeBag ) -> SettingOutput {
        
        let output = SettingOutput()
        
        input.logoutTapped.subscribe(onNext: { [weak self]  _ in
            guard let self else {return}
            self.profileUseCase.signOut().subscribe({ [weak self] event in
                guard let self else { return }
                switch(event){
                case .completed:
                    self.coordinator?.logout()
                case .error(let err):
                    print(err)
                }
                
                
                
            }).disposed(by: disposeBag)
            
            
        }).disposed(by: disposeBag)
        
        input.secessionTapped.subscribe(onNext: { [weak self] _ in
            guard let self else {return}
            LoadingIndicator.showLoading()
            
            if(UserDefaults.standard.string(forKey: "loginMethod") == "kakao"  ){
                
                self.profileUseCase.kakaoSecessionOut().subscribe({ event in
                    
                    switch(event){
                    case .completed:
                        LoadingIndicator.hideLoading()
                        self.coordinator?.logout()
                        
                    case .error(let err):
                        print("err")
                    }
                    
                    
                }).disposed(by: disposeBag)
                
                
            }else{
                output.appleSecession.onNext(true)
            }
            
        }).disposed(by: disposeBag)
        
        
        input.values.subscribe(onNext: { [weak self] codeString , userId in
            guard let self else {return}
            
            input.OAuthCredential.subscribe(onNext: { credential in
                
                self.profileUseCase.appleSecession(codeString: codeString, userId: userId , credential : credential).subscribe({ event in
                    switch(event){
                        
                    case .completed:
                        LoadingIndicator.hideLoading()
                        self.coordinator?.logout()
                    case .error(let err):
                        print(err)
                    }
                    
                    
                }).disposed(by: disposeBag)
                
            }).disposed(by: disposeBag)
            
        }).disposed(by: disposeBag)
        
        
        
        input.blockListTapped.subscribe(onNext:{ _ in
            
            self.coordinator?.pushBlockList()
            
            
            
        }).disposed(by: disposeBag)
        
        
        
        
        return output
        
        
    }
}
                                           

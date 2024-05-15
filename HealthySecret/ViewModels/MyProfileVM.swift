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
    
    private var kakaoService : KakaoService
    
    private var firebaseService : FirebaseService
    
    var nowUser : UserModel?

    
    init( coordinator : ProfileCoordinator , firebaseService : FirebaseService , kakaoService : KakaoService){
        
        self.coordinator =  coordinator
        self.firebaseService =  firebaseService
        self.kakaoService =  kakaoService
        
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
            
           
            
            
            print("viewWillAppeear")
            self.firebaseService.getDocument(key: ownUid ).subscribe{ [weak self]
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
                    self.firebaseService.getFeedsUid(uid: uid).subscribe({ event in
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
    
    
    
    
    
    
    //
    //    struct ChangeInput {
    //        let viewWillApearEvent : Observable<Void>
    //        let addButtonTapped : Observable<Void>
    //        let nameTextField : Observable<String>
    //        let introduceTextField : Observable<String>
    //        let profileImageTapped : Observable<UITapGestureRecognizer>
    //        let profileImageValue : Observable<UIImage?>
    //
    //    }
    //
    //    struct ChageOutput {
    //        var name = BehaviorSubject<String>(value: "")
    //        var introduce = BehaviorSubject<String>(value: "")
    //        var profileImage = BehaviorSubject<Data?>(value: nil)
    //
    //
    //    }
    //
    //
    //
    //    func ChangeTransform(input: ChangeInput, disposeBag: DisposeBag ) -> ChageOutput {
    //
    //        let output = ChageOutput()
    //
    //        input.viewWillApearEvent.subscribe(onNext: {
    //
    //            output.name.onNext(self.name!)
    //            output.introduce.onNext(self.introduce ?? "")
    //            output.profileImage.onNext(self.profileImage ?? nil)
    //
    //
    //
    //        }).disposed(by: disposeBag)
    //
    //
    //
    //
    //        input.addButtonTapped.subscribe(onNext: { _ in
    //            input.nameTextField.subscribe(onNext: { name in
    //                input.introduceTextField.subscribe(onNext: { introduce in
    //
    //
    //
    //                    input.profileImageValue.subscribe(onNext: { image in
    //                        self.firebaseService.updateValues(name: name , introduce: introduce  , key: UserDefaults.standard.string(forKey: "email") ?? "" , image : image , beforeImage: self.beforeImage ?? "" ).subscribe{ event in
    //                            switch(event){
    //                            case.completed:
    //                                print("업데이트완료")
    //
    //                            case.error(_):
    //                                print("error")
    //                            }
    //
    //
    //                            let imageData = image?.jpegData(compressionQuality: 0.1)
    //                            UserDefaults.standard.set(imageData, forKey: "profileImage")
    //
    //                          //  self.coordinator?.navigationController.popViewController(animated: false)
    //
    //
    //
    //
    //                        }.disposed(by: disposeBag)
    //
    //
    //                    }).disposed(by: disposeBag)
    //
    //                }).disposed(by: disposeBag)
    //
    //
    //
    //
    //            }).disposed(by: disposeBag)
    //
    //
    //
    //
    //        }).disposed(by: disposeBag)
    //
    //
    //        return output
    //    }
    //
    
    
    struct SettingInput {
        let viewWillApearEvent : Observable<Void>
        let logoutTapped : Observable<UITapGestureRecognizer>
        let secessionTapped : Observable<Bool>
        let values : Observable<(String, String)>
        let OAuthCredential : Observable<OAuthCredential>
        
    }
    
    struct SettingOutput {
        var appleSecession = PublishSubject<Bool>()
        
        
    }
    
    func settingTransform(input: SettingInput, disposeBag: DisposeBag ) -> SettingOutput {
        
        let output = SettingOutput()
        
        input.logoutTapped.subscribe(onNext: { [weak self]  _ in
            guard let self = self else {return}
            if( UserDefaults.standard.string(forKey: "loginMethod") == "kakao" ){
                
                self.kakaoService.kakaoLogout().subscribe{ event in
                switch(event){
                case.completed:   
                    print("completedkakao")
                    

                case.error(_): 
                    print("kako err")
                    
                    
                    
                    
                    
                }
                    
                    self.firebaseService.signOut().subscribe({ [weak self] event in
                        switch(event){
                        case.completed:
                            self?.coordinator?.logout()
                        case.error(_):
                            print("signOut err")

                        }
                    
                        
                        
                    }).disposed(by: disposeBag)
                
                
            }.disposed(by: disposeBag)
            
            
            }else if(UserDefaults.standard.string(forKey: "loginMethod") == "apple"){
                
                firebaseService.signOut().subscribe({ event in
                    
                    switch(event){
                    case.completed:
                        self.coordinator?.logout()
                    case.error(_):
                        print("logoutErr")

                    }
                    
                    
                    

                    
                }).disposed(by: disposeBag)
            
                
                
            }
            
            
            
        }).disposed(by: disposeBag)
        
        input.secessionTapped.subscribe(onNext: { _ in
            if(UserDefaults.standard.string(forKey: "loginMethod") == "kakao"  ){
                
                guard let email =   UserDefaults.standard.string(forKey: "email") else {return}
               

                
                
                
               self.kakaoService.kakaoGetToken().subscribe({ single in
                    switch(single){
                    case.success(let password):
                        
                        let credential = EmailAuthProvider.credential(withEmail: email, password: password)
                        print("\(credential)  credential")
                        self.firebaseService.deleteAccount(auth: credential ).subscribe{ completable in
                            switch(completable){
                            case.completed:
                                print("successsssDeleteAcount")
                                self.kakaoService.kakaoSessionOut().subscribe{ event in
                                    switch(event){
                                    case.completed:
                                        print("successsssDeleteSessionOut")
                                        self.coordinator?.logout()
                                    case.error(let error):
                                        print(error)
                                        return
                                    }
                                    
                                    
                                }.disposed(by: disposeBag)
                                
                                
                            case.error(let err):
                                print(err)
                                
                                
                            }
                        }.disposed(by: disposeBag)
                    case.failure(let err):
                        print(err)
                    }
                    
                }).disposed(by: disposeBag)
                
                
                print("stark")
                
                
               
            }else{
                output.appleSecession.onNext(true)
            }
            
        }).disposed(by: disposeBag)
        
        
        input.values.subscribe(onNext: { codeString , userId in
            
            LoadingIndicator.showLoading()
            
            input.OAuthCredential.subscribe(onNext: { auth in
                
                
           
            let url = URL(string: "https://us-central1-healthysecrets-f1b20.cloudfunctions.net/getRefreshToken?code=\(codeString)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "https://apple.com")!
            let task = URLSession.shared.dataTask(with: url) {(data, response, error) in
                if let data = data {
                    let refreshToken = String(data: data, encoding: .utf8) ?? ""
                    
                    self.firebaseService.deleteAccount(auth: auth).subscribe({ event in
                        switch(event){
                        case.completed:
                            self.coordinator?.logout()
                            LoadingIndicator.hideLoading()


                            
                        case.error(_):
                            print("error")
                            
                        }
                        
                        
                        
                    }).disposed(by: disposeBag)
                    
                    
                    AppleService().removeAccount(refreshToken : refreshToken, userId: userId).subscribe({ event in
                        switch(event){
                        case.completed: break
                           
                            
                        case.error(let err):
                            print(err)
                        }
                        
                        
                        
                    }).disposed(by: disposeBag)
                    
                    
                }else{
                    print("\(String(describing: error)) error")
                }
            }
            
            
            task.resume()
            
            }).disposed(by: disposeBag)
        }).disposed(by: disposeBag)
        
        
        return output
    }
    
    
    
}
                                           

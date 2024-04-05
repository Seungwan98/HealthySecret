//
//  MyprofileVM.swift
//  HealthySecret
//
//  Created by 양승완 on 2023/11/28.
//

import Foundation
import RxCocoa
import RxSwift


class MyProfileVM : ViewModel {
    
    
    var disposeBag = DisposeBag()
    
    
    var feeds:[FeedModel]?

    var profileImage:Data?
 
    struct Input {
        let viewWillApearEvent : Observable<Void>
        let leftBarButton : Observable<UITapGestureRecognizer>
        let settingTapped : Observable<UITapGestureRecognizer>
        let addButtonTapped : Observable<Void>
        let outputProfileImage : Observable<Data?>

    }
    
    struct Output {
        
        var feedImage = BehaviorSubject<[[String]]?>(value: nil)
        
        
    }
    
    struct HeaderInput {
        let viewWillApearEvent : Observable<Bool>
        
        let goalLabelTapped : Observable<UITapGestureRecognizer>
        let changeProfile : Observable<UITapGestureRecognizer>
        let outputProfileImage : Observable<Data?>
        
        
        
        
    }
    
    struct HeaderOutput {
        var calorie = BehaviorSubject(value: "")
        var goalWeight = BehaviorSubject(value: "")
        var nowWeight = BehaviorSubject(value: "")
        var name = BehaviorSubject(value: "")
        var introduce = BehaviorSubject(value: "")
        var profileImage = BehaviorSubject<String?>(value: nil)
        var popView = BehaviorSubject<Bool>(value: false)
    }
    
    
    
    
    weak var coordinator : MyProfileCoordinator?
    
    private var kakaoService : KakaoService
    
    private var firebaseService : FirebaseService
    
    var nowUser : UserModel?

    
    init( coordinator : MyProfileCoordinator , firebaseService : FirebaseService , kakaoService : KakaoService){
        
        self.coordinator =  coordinator
        self.firebaseService =  firebaseService
        self.kakaoService =  kakaoService
        
    }
    
    func HeaderTransform(input : HeaderInput , disposeBag: DisposeBag) -> HeaderOutput {
        let id = UserDefaults.standard.string(forKey: "email") ?? ""
        
        
        let output = HeaderOutput()
        
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
            self.firebaseService.getDocument(key: id ).subscribe{ [weak self]
                event in
                switch(event){
                case.success(let user):
                    
                    UserDefaults.standard.set(user.profileImage, forKey: "profileImage")
                    
                    
                    self?.nowUser = user
                    output.introduce.onNext(user.introduce ?? "아직 소개글이 없어요")
                    output.goalWeight.onNext(String(user.goalWeight))
                    output.nowWeight.onNext(String(user.nowWeight))
                    output.calorie.onNext(String(user.calorie))
                    output.name.onNext(user.name)
                    output.profileImage.onNext(user.profileImage ?? nil)
                    
                    
                    
                    
                    
                
                    
                    
//                    if let data = UserDefaults.standard.data(forKey: "profileImage"){
//                        output.profileImage.onNext(data)
//                        self?.profileImage = data
//                    }else{
//                        print("없음")
//                        output.profileImage.onNext(nil)
//                        self?.profileImage = nil
//                    }
                    
                    
                case .failure(_):
                    print("fail to get Doc")
                }
                
    
                
            }.disposed(by: disposeBag)
            
            
        }).disposed(by: disposeBag)
        
        return output
        
    }
    
    
    func transform(input: Input, disposeBag: DisposeBag ) -> Output {
        
        
        
        let output = Output()
        
        input.leftBarButton.subscribe(onNext:{ _ in
            print("tapped")
            
            self.coordinator?.pushChangeProfileVC(name: self.nowUser?.name ?? "" , introduce: self.nowUser?.introduce ?? "" , profileImage: self.profileImage ?? nil , beforeImageUrl : self.nowUser?.profileImage ?? "" )
            
            
            
            
        }).disposed(by: disposeBag)
        
        input.addButtonTapped.subscribe(onNext: { _ in
            
            self.coordinator?.pushAddFeedVC()

            
        }).disposed(by: disposeBag)
        
        input.viewWillApearEvent.subscribe(onNext: { event in
            
//            
//            let ob = self.firebaseService.downloadAll(urlString: "test")
//            ob.subscribe(onNext:{ dic in
//                guard let dic = dic else { return }
//                
//                let sortedDictionary = dic.sorted { $0.0 > $1.0 }
//                
//                var arr : [UIImage] = []
//                
//                for data in sortedDictionary {
//                    
//                    arr.append(UIImage(data: data.value ) ?? UIImage())
//                    
//                }
//                print("\(dic)      dictionary")
//                output.feedImage.onNext(arr)
//                
//            }).disposed(by: disposeBag)
            
                if let uid = UserDefaults.standard.string(forKey: "uid"){
                print(uid)
                    self.firebaseService.getFeedsUid(uid: uid).subscribe({ event in
                    switch(event){
                    case.success(let feedArr):
                        self.feeds = feedArr
                        let imageArr = feedArr.map({
                            $0.mainImgUrl
                        })
                        output.feedImage.onNext(imageArr)
                        
                        
                        
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
        let secessionTapped : Observable<UITapGestureRecognizer>
        
    }
    
    struct SettingOutput {
        
        
        
    }
    
    func settingTransform(input: SettingInput, disposeBag: DisposeBag ) -> SettingOutput {
        
        let output = SettingOutput()
        
        input.logoutTapped.subscribe(onNext: { _ in
            self.kakaoService.kakaoLogout().subscribe{ event in
                switch(event){
                case.completed:
                    self.coordinator?.logout()
                case.error(let err):
                    print(err)
                    
                    
                }
                
                
            }.disposed(by: disposeBag)
            
            
            
            
            
            
        }).disposed(by: disposeBag)
        
        input.secessionTapped.subscribe(onNext: { _ in
            
            self.firebaseService.deleteAccount().subscribe{ completable in
                switch(completable){
                case.completed:
                    
                    self.kakaoService.kakaoSessionOut().subscribe{ event in
                        switch(event){
                        case.completed:
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
            
        }).disposed(by: disposeBag)
        
        
        return output
    }
    
    
    
}

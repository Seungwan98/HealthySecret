//
//  HomeVM.swift
//  HealthySecret
//
//  Created by 양승완 on 2023/11/28.
//

import Foundation
import RxCocoa
import RxSwift


class MyProfileVM : ViewModel {
    
    
    var disposeBag = DisposeBag()
    
    
    
    var name:String?
    var introduce:String?
    var profileImage:Data?
    var beforeImage:String?
    
    struct Input {
        let viewWillApearEvent : Observable<Void>
        let rightBarButton : Observable<Void>
        let changeProfile : Observable<UITapGestureRecognizer>
        
        let goalLabelTapped : Observable<UITapGestureRecognizer>
        let settingTapped : Observable<UITapGestureRecognizer>
        
    }
    
    struct Output {
        var calorie = BehaviorSubject(value: "")
        var goalWeight = BehaviorSubject(value: "")
        var nowWeight = BehaviorSubject(value: "")
        var name = BehaviorSubject(value: "")
        var introduce = BehaviorSubject(value: "")
        var profileImage = BehaviorSubject<Data?>(value: Data())
        
        
    }
    
    
    let backgroundSerialQueue = SerialDispatchQueueScheduler(qos: .background)

    
    weak var coordinator : MyProfileCoordinator?
    
    private var kakaoService : KakaoService
    
    private var firebaseService : FirebaseService
    
    init( coordinator : MyProfileCoordinator , firebaseService : FirebaseService , kakaoService : KakaoService){
        self.coordinator =  coordinator
        self.firebaseService =  firebaseService
        self.kakaoService =  kakaoService
        
    }
    
    
    func transform(input: Input, disposeBag: DisposeBag ) -> Output {
        
        let id = UserDefaults.standard.string(forKey: "email") ?? ""
        
        let output = Output()
        
        
        
        
        input.rightBarButton.subscribe(onNext: { _ in
            
            print("설정버튼")
            
            
        }).disposed(by: disposeBag)
        
        var nowUser : UserModel?
        
        
        input.viewWillApearEvent.subscribe(onNext: { [weak self] _ in
            self?.firebaseService.getDocument(key: id ).subscribe{ [weak self]
                event in
                switch(event){
                case.success(let user):
                    nowUser = user
                    output.introduce.onNext(user.introduce ?? "아직 소개글이 없어요")
                    output.goalWeight.onNext(String(user.goalWeight))
                    output.nowWeight.onNext(String(user.nowWeight))
                    output.calorie.onNext(String(user.calorie))
                    output.name.onNext(user.name)
                    
                    
                    
                    
                    
                    
//                    self?.firebaseService.downloadImage(urlString: user.profileImage ?? "" ).subscribe{ data in
                    if let data =  UserDefaults.standard.data(forKey: "profileImage"){
                            output.profileImage.onNext(data)
                            self?.profileImage = data
                        }else{
                            print("없음")
                            output.profileImage.onNext(nil)
                            self?.profileImage = nil
                        }
                        
//                    }.disposed(by: disposeBag)
                    
                    
                    
                    
                case .failure(_):
                    print("fail to get Doc")
                }
                
                
                
                
            }.disposed(by: disposeBag)
            
            
            
            
            
            
        }).disposed(by: disposeBag)
        
        
        input.changeProfile.when(.recognized).subscribe(onNext: { [weak self] _ in
            
            self?.coordinator?.pushChangeProfileVC(name: nowUser?.name ?? "" , introduce: nowUser?.introduce ?? "" , profileImage: self?.profileImage ?? nil , beforeImageUrl : nowUser?.profileImage ?? "" )
           
            
        }).disposed(by: disposeBag)
        
        input.settingTapped.subscribe(onNext: { [weak self] _ in
            
            self?.coordinator?.pushSettingVC()
            
        }).disposed(by: disposeBag)
        
        
        input.goalLabelTapped.subscribe(onNext: { _ in
            self.coordinator?.pushChangeSignUpVC(user: nowUser!)
            
            
        }).disposed(by: disposeBag)
        
        
        return output
    }
    
    
    
    
    
    
    
    struct ChangeInput {
        let viewWillApearEvent : Observable<Void>
        let addButtonTapped : Observable<Void>
        let nameTextField : Observable<String>
        let introduceTextField : Observable<String>
        let profileImageTapped : Observable<UITapGestureRecognizer>
        let profileImageValue : Observable<UIImage?>
        
    }
    
    struct ChageOutput {
        var name = BehaviorSubject<String>(value: "")
        var introduce = BehaviorSubject<String>(value: "")
        var profileImage = BehaviorSubject<Data?>(value: nil)
        
        
    }
    
    
    
    func ChangeTransform(input: ChangeInput, disposeBag: DisposeBag ) -> ChageOutput {
        
        let output = ChageOutput()
        
        input.viewWillApearEvent.subscribe(onNext: {
            
            output.name.onNext(self.name!)
            output.introduce.onNext(self.introduce ?? "")
            output.profileImage.onNext(self.profileImage ?? nil)
            
            
            
        }).disposed(by: disposeBag)
        
        
        
        
        input.addButtonTapped.subscribe(onNext: { _ in
            input.nameTextField.subscribe(onNext: { name in
                input.introduceTextField.subscribe(onNext: { introduce in
                    
                    input.profileImageValue.subscribe(onNext: { image in
                        self.firebaseService.updateValues(name: name , introduce: introduce  , key: UserDefaults.standard.string(forKey: "email") ?? "" , image : image , beforeImage: self.beforeImage ?? "" ).subscribe(on: self.backgroundSerialQueue).subscribe{ event in
                            switch(event){
                            case.completed:
                                print("업데이트완료")
                                
                            case.error(_):
                                print("error")
                            }
                            
                            
                            let imageData = image?.jpegData(compressionQuality: 0.1)
                            UserDefaults.standard.set(imageData, forKey: "profileImage")
                            
                            self.coordinator?.navigationController.popViewController(animated: false)

                            
                            
                            
                        }.disposed(by: disposeBag)
                        
                        
                    }).disposed(by: disposeBag)
                    
                }).disposed(by: disposeBag)
                
                
                
                
            }).disposed(by: disposeBag)
            
            
            
            
        }).disposed(by: disposeBag)
        
        
        return output
    }
    
    
    
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

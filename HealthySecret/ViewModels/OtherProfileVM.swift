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
    
    var feed:FeedModel?

    var profileImage:Data?
 
    struct Input {
        let viewWillApearEvent : Observable<Void>
        let outputProfileImage : Observable<Data?>

    }
    
    struct Output {
        
        var feedImage = BehaviorSubject<[[String]]?>(value: nil)
        
        
    }
    
    struct HeaderInput {
        let viewWillApearEvent : Observable<Bool>
        
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
    
    
    
    
    weak var coordinator : CommuCoordinator?
    
    
    private var firebaseService : FirebaseService
    
    var nowUser : UserModel?

    
    init( coordinator : CommuCoordinator , firebaseService : FirebaseService ){
        
        self.coordinator =  coordinator
        self.firebaseService =  firebaseService
        
    }
    
    func HeaderTransform(input : HeaderInput , disposeBag: DisposeBag) -> HeaderOutput {
        let uid = self.feed?.uuid ?? ""
        
        
        let output = HeaderOutput()
        
      
        
        
        input.outputProfileImage.subscribe(onNext:{ image in

        
            
            self.profileImage = image
            
            
            
            
        }).disposed(by: disposeBag)
        
       
        
        input.viewWillApearEvent.subscribe(onNext: { event in
            
            self.firebaseService.getDocument(key: uid ).subscribe{ [weak self]
                event in
                switch(event){
                case.success(let user):
                    
                    
                    
                    self?.nowUser = user
                    output.introduce.onNext(user.introduce ?? "아직 소개글이 없어요")
                    output.goalWeight.onNext(String(user.goalWeight))
                    output.nowWeight.onNext(String(user.nowWeight))
                    output.calorie.onNext(String(user.calorie))
                    output.name.onNext(user.name)
                    output.profileImage.onNext(user.profileImage ?? nil)
                    
                    
                    
                    
                    
                
                    

                    
                    
                case .failure(_):
                    print("fail to get Doc")
                }
                
    
                
            }.disposed(by: disposeBag)
            
            
        }).disposed(by: disposeBag)
        
        return output
        
    }
    
    
    func transform(input: Input, disposeBag: DisposeBag ) -> Output {
        
        
        
        let output = Output()
        
      
       
        
        input.viewWillApearEvent.subscribe(onNext: { event in
            

            
            if let uid = self.feed?.uuid{
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
    
   
    
}

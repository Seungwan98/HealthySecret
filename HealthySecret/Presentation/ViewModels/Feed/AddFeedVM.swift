//
//  AddFeedVM.swift
//  HealthySecret
//
//  Created by 양승완 on 2023/11/28.
//

import Foundation
import RxCocoa
import RxSwift


class AddFeedVM : ViewModel {
   
    
   
    
    
    
    var disposeBag = DisposeBag()
  
    
    weak var coordinator : Coordinator?
    
    
    private var firebaseService : FirebaseService
    
    init( coordinator : Coordinator , firebaseService : FirebaseService ){
        self.coordinator =  coordinator
        self.firebaseService =  firebaseService
        
    }
    
    
    
    struct Input {
        let addButtonTapped : Observable<Void>
        let feedText : Observable<String>
        let imagesDatas : Observable<[UIImage]>
        
        
    }
    
    struct Output {
        var beforeDiary = BehaviorSubject<String>(value: "")
        
    }
    
    func transform(input: Input, disposeBag: DisposeBag ) -> Output {
        
        let output = Output()
        
        
        let customFormatter = CustomFormatter()
        let date = customFormatter.DateToStringForFeed(date: Date())
        let uuid = UserDefaults.standard.string(forKey: "uid") ?? ""
        let name = UserDefaults.standard.string(forKey: "name") ?? ""
        
        
        input.addButtonTapped.subscribe(onNext: { _ in
            
            input.imagesDatas.subscribe(onNext: { arr in
                
                input.feedText.subscribe(onNext: { text in
                        var urlArr : [String] = []
                    
                    LoadingIndicator.showLoading()
                        for image in arr {
                            
                            self.firebaseService.uploadImage( image: image, pathRoot: uuid ).subscribe({ event in
                                switch(event){
                                case.success(let url): urlArr.append(url)
                                case.failure(let err):
                                    print(err)
                                    break
                                }
                                
                                if(urlArr.count == arr.count){
                                
                                    var feed = FeedModel(uuid: uuid , feedUid: UUID().uuidString+CustomFormatter.shared.getToday(), date: date, profileImage : "", nickname: name , contents: text, mainImgUrl: urlArr , likes: [], report: [], coments: []  )
                                  
//                                    
//                                    self.firebaseService.addFeed(feed: feed).subscribe({ event in
//                                        switch(event){
//                                        case.completed:
//                                            DispatchQueue.main.async {
//                                                       LoadingIndicator.hideLoading()
//                                                   }
//                                            self.coordinator?.finish()
//                                            
//                                        case .error(_):
//                                            break
//                                        }
//                                        
//                                    }).disposed(by: disposeBag)
                                }
                                
                                
                            }).disposed(by: disposeBag)
                            
                        }
                    
                        
                        
                        
                        
                    

                }).disposed(by: disposeBag)
                
                
                
            }).disposed(by: disposeBag)
            
            
            
            
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

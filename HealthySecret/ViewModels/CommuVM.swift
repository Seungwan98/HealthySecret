//
//  CommuVM.swift
//  HealthySecret
//
//  Created by 양승완 on 2023/11/28.
//

import Foundation
import RxCocoa
import RxSwift


class CommuVM : ViewModel {
    
    
    var disposeBag = DisposeBag()
    
    
    
    
    struct Input {
        let viewWillApearEvent : Observable<Void>
        let likesButtonTapped : Observable<[String : Bool]>
        let addButtonTapped : Observable<Void>
        
        
    }
    
    struct Output {
        
        var feedModel = BehaviorSubject<[FeedModel]>(value: [])
        var likesCount = BehaviorSubject<[ String : [ String ] ]>(value: [:] )
        
        
    }
    
    
    
    
    
    
    
    
    weak var coordinator : CommuCoordinator?
    
    
    private var firebaseService : FirebaseService
    
    init( coordinator : CommuCoordinator , firebaseService : FirebaseService ){
        self.coordinator =  coordinator
        self.firebaseService =  firebaseService
        
    }
    
    func transform(input : Input , disposeBag: DisposeBag) -> Output {
        let id = UserDefaults.standard.string(forKey: "email") ?? ""
        let authUid = UserDefaults.standard.string(forKey: "uid") ?? ""
        
        
        let output = Output()
        
        input.likesButtonTapped.throttle(.seconds(2),  scheduler: MainScheduler.instance).subscribe(onNext: { dic in
            guard let feedUid = dic.keys.first else {return}
            guard let like = dic.values.first else {return}
            self.firebaseService.updateFeedLikes(feedUid: feedUid  , uuid: authUid, like: like ).subscribe({ event in
                switch(event){
                case(.completed):
                    print("좋아요 수정완료")
                case(.error(let err)):
                    print("likesUpdate err \(err)")
                    
                }
                
                
                
            }).disposed(by: disposeBag)
            
            
        }).disposed(by:disposeBag )
        
        input.addButtonTapped.subscribe(onNext: { _ in
            
            self.coordinator?.pushAddFeedVC()
            
        }).disposed(by: disposeBag)
        
        
        input.viewWillApearEvent.subscribe(onNext: { event in
            
            
            print("viewWillAppeear")
            
            
            self.firebaseService.getAllFeeds().subscribe({ event in
                switch(event){
                case.success(let feeds):
                    var likesCount : [ String : [ String ] ] = [:]
                    
                    for i in 0..<feeds.count {
                        likesCount[feeds[i].feedUid ] = feeds[i].likes
                    }
                    output.feedModel.onNext(feeds)
                    output.likesCount.onNext(likesCount)
                    
                case.failure(let err):
                    print(err)
                    break
                }
                
                
                
            }).disposed(by: disposeBag)
            
            
            
            
            
            
            
            
            
            
            //    output.FeedModel.onNext(testFeeds)
            
            
            
            
            
        }).disposed(by: disposeBag)
        
        return output
        
    }
    
    struct AddInput {
        let addButtonTapped : Observable<Void>
        let feedText : Observable<String>
        let imagesDatas : Observable<[UIImage]>
        
        
    }
    
    struct AddOutput {
        var beforeDiary = BehaviorSubject<String>(value: "")
        
    }
    
    func addTransform(input: AddInput, disposeBag1: DisposeBag ) -> AddOutput {
        
        let output = AddOutput()
        
        
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
                            
                            self.firebaseService.uploadImageTest(filePath: "test" , image: image ).subscribe({ event in
                                switch(event){
                                case.success(let url): urlArr.append(url)
                                case.failure(let err):
                                    print(err)
                                    break
                                }
                                
                                if(urlArr.count == arr.count){
                                    let feed = FeedModel(uuid: uuid , feedUid: UUID().uuidString, date: date, nickname: name , contents: text, mainImgUrl: urlArr , likes: [] )
                                    self.firebaseService.addFeed(feed: feed).subscribe({ event in
                                        switch(event){
                                        case.completed:
                                            DispatchQueue.main.async {
                                                       LoadingIndicator.hideLoading()
                                                   }
                                            self.coordinator?.navigationController.popViewController(animated: false)
                                            
                                        case .error(_):
                                            break
                                        }
                                        
                                    }).disposed(by: disposeBag1)
                                }
                                
                                
                            }).disposed(by: disposeBag1)
                            
                        }
                    
                        
                        
                        
                        
                    

                }).disposed(by: disposeBag1)
                
                
                
            }).disposed(by: disposeBag1)
            
            
            
            
        }).disposed(by: disposeBag1)
        
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

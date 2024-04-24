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
    
    
    var reload = PublishSubject<Bool>()
    
    struct Input {
        let viewWillApearEvent : Observable<Void>
        let likesButtonTapped : Observable<[String : Bool]>
        let comentsTapped : Observable<String>
        let addButtonTapped : Observable<Void>
        let deleteFeed : Observable<String>
        let reportFeed : Observable<String>
        let updateFeed : Observable<String>
        let paging : Observable<Bool>
        let profileTapped : Observable<String>
        let refreshControl : Observable<Void>
        
        
    }
    
    struct Output {
        
        var feedModel = BehaviorSubject<[FeedModel]>(value: [])
        var likesCount = BehaviorSubject<[ String : [ String ] ]>(value: [:] )
        var isLastPage = BehaviorSubject<Bool>(value:false)
        var isPaging = BehaviorSubject<Bool>(value: false)
        var endRefreshing = BehaviorSubject<Bool>(value: false)
        
        
    }
    
    
    
    var feedModels = [FeedModel]()
    
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
        
        input.refreshControl.subscribe(onNext: { _ in
            self.feedModels = []
            self.firebaseService.query = nil
            
            DispatchQueue.main.asyncAfter(wallDeadline: .now() + 1) { [weak self] in
                self?.reload.onNext(true)
                
                
                    }
            
            
        }).disposed(by: disposeBag)
        
        input.profileTapped.subscribe(onNext : { feedUid in
            
            var feed : FeedModel?
            _ = self.feedModels.map({  if($0.feedUid == feedUid){ feed = $0}  })
            if let uuid = feed?.uuid {
                self.coordinator?.pushProfileVC(uuid: uuid )
            }

            
        }).disposed(by: disposeBag)
        
        input.updateFeed.subscribe(onNext :{ feedUid in
            
            var feed : FeedModel?
            _ = self.feedModels.map({  if($0.feedUid == feedUid){ feed = $0}  })
            
            
            self.coordinator?.pushUpdateFeed(feed: feed!)
            
        }).disposed(by: disposeBag)
        
        input.deleteFeed.subscribe(onNext: { feedUid in
            self.firebaseService.deleteFeed(feedUid: feedUid).subscribe({ event in
                switch(event){
                case.completed:
                    self.reload.onNext(true)
                    
                case.error(let err):
                    print(err)
                    
                    
                }
                
                
                
            }).disposed(by: disposeBag)
            
            
        }).disposed(by: disposeBag)
        
        input.comentsTapped.subscribe(onNext: { feedUid in

            var feed : FeedModel?
            _ = self.feedModels.map({  if($0.feedUid == feedUid){ feed = $0}  })
            
            guard let feed = feed else { return }
            
            self.coordinator?.pushComents(coments: feed.coments ?? [] , feedUid : feedUid , feedUuid: feed.uuid )
            
            
        }).disposed(by: disposeBag)
        
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
            self.reload.onNext(true)
           
            
            
        }).disposed(by: disposeBag)
        
        
        self.reload.subscribe(onNext: { _ in
            
            print("reload")
            self.firebaseService.getFeedPagination(feeds: self.feedModels).subscribe({ event in
                switch(event){
                    
                    
                case(.success(let feeds)):
                    var likesCount : [ String : [ String ] ] = [:]
                    

                    for i in 0..<feeds.count {
                        
                        if likesCount[ feeds[i].feedUid ] == nil{
                            likesCount[ feeds[i].feedUid ] = feeds[i].likes
                        }
                    }
                    self.feedModels = feeds
                    
                    if(feeds.count < 2){
                        
                        output.isLastPage.onNext(true)
                        
                    }else{
                        
                        output.isLastPage.onNext(false)

                    }
                    
                    output.feedModel.onNext(self.feedModels)
                    output.likesCount.onNext(likesCount)
                    output.isPaging.onNext(false)
                    output.endRefreshing.onNext(true)
                    
                        
                case .failure(_):
                    break
                }
                
                
                
            }).disposed(by: disposeBag)
            
            
            
        }).disposed(by: disposeBag)
        
        input.paging.subscribe(onNext:{ event in
            
            if(event){
                print("paging subscribe")

                self.reload.onNext(true)
            }
            
            
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
                        
                        self.firebaseService.uploadImage(image: image, pathRoot: uuid).subscribe({ event in
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

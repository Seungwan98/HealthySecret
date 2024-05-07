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
    
    
    var reload = PublishSubject<Int>()
    
    struct Input {
        let viewWillAppearEvent : Observable<Void>
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
    
    private let paginationCount = 4
    
    var likesCount : [ String : [ String ] ] = [:]
    
    var feedModels = [FeedModel]()
    
    weak var coordinator : CommuCoordinator?
    
    private var firebaseService : FirebaseService
    
    init( coordinator : CommuCoordinator , firebaseService : FirebaseService ){
        self.coordinator =  coordinator
        self.firebaseService =  firebaseService
        
    }
    
    
    
    
    
    func transform(input : Input , disposeBag: DisposeBag) -> Output {
        let authUid = UserDefaults.standard.string(forKey: "uid") ?? ""
        
        
        
        let output = Output()
        
        input.refreshControl.subscribe(onNext: { [weak self] _  in
            
            self?.resetFirebaseValue()
            
          
            DispatchQueue.main.asyncAfter(wallDeadline: .now() + 0.6) {}
                
                self?.reload.onNext(4)
                
                
                    
            
            
        }).disposed(by: self.disposeBag)
        
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
        
        input.deleteFeed.subscribe(onNext: { [weak self] feedUid in
            self?.firebaseService.deleteFeed(feedUid: feedUid).subscribe({ event in
                switch(event){
                case.completed:
                    var count : Int = 4
                    if let feedModels = self?.feedModels{
                        
                        
                        
                        
                        
                        for i in 0..<feedModels.count{
                            if(feedModels[i].feedUid == feedUid){
                                self?.feedModels.remove(at: i)
                                count = feedModels.count
                                
                            }
                        }
                        
                    }
                    
                    self?.resetFirebaseValue()
                    
                    self?.reload.onNext(count)
                    
                    
                    
                    
                case.error(let err):
                    print(err)
                    
                    
                }
                
                
                
            }).disposed(by: disposeBag)
            
            
        }).disposed(by: disposeBag)
        
        input.comentsTapped.subscribe(onNext: { [weak self] feedUid in

            var feed : FeedModel?
            
            _ = self?.feedModels.map({  if($0.feedUid == feedUid){ feed = $0}  })
            
            guard let feed = feed else { return }
            
            self?.coordinator?.pushComents(coments: feed.coments ?? [] , feedUid : feedUid , feedUuid: feed.uuid )
            
            
        }).disposed(by: disposeBag)
        
        input.likesButtonTapped.throttle(.seconds(1),  scheduler: MainScheduler.instance).subscribe(onNext: { dic in
            guard let feedUid = dic.keys.first else {return}
            guard let like = dic.values.first else {return}
            self.firebaseService.updateFeedLikes(feedUid: feedUid  , uuid: authUid, like: like ).subscribe({ event in
                switch(event){
                case(.completed):
                    if(like){
                        
                        if(self.likesCount[feedUid] == nil){
                            self.likesCount[feedUid] = [authUid]
                        }else{
                            self.likesCount[feedUid]?.append(authUid)
                        }
                        
                        
                    }else{
                        guard let index = self.likesCount[feedUid]?.firstIndex(of: authUid) else {return}
                        self.likesCount[feedUid]?.remove(at: index )
                    }
                case(.error(let err)):
                    print("likesUpdate err \(err)")
                    
                }
                
                
                
            }).disposed(by: disposeBag)
            
            
        }).disposed(by:disposeBag )
        
        input.addButtonTapped.subscribe(onNext: { [weak self] _ in
            
            
            self?.coordinator?.pushAddFeedVC()
           
            
        }).disposed(by: disposeBag)
        
        
        input.viewWillAppearEvent.subscribe(onNext: { [weak self] _ in
            var count = 4
        
            if let cnt = self?.feedModels.count {
                if(cnt != 0 ){
                    count = cnt
                }
            }
            
            self?.resetFirebaseValue()
            
            self?.reload.onNext(count)
            
            
            
        }).disposed(by: disposeBag)
        
        
        self.reload.subscribe(onNext: { [self] count in
            
           // guard let block : [String] = UserDefaults.standard.stringArray(forKey: "block") else { return }
            
            self.firebaseService.getFeedPagination(feeds: self.feedModels, pagesCount: count , block: [] ).subscribe({ event in
                switch(event){
                    
                    
                case(.success(let feeds)):
                    
                    
                    self.feedModels = feeds
                    
                    for i in feeds{
                        print("nickname \(i.nickname)")
                    }
                    


                    for i in 0..<feeds.count {
                        
                        self.likesCount[feeds[i].feedUid ] = feeds[i].likes
                    }
                    
                    if(feeds.count < 2){
                        
                        output.isLastPage.onNext(true)
                        
                    }else{
                        
                        output.isLastPage.onNext(false)

                    }
                    
                    
                    
                    output.feedModel.onNext(self.feedModels)
                    output.likesCount.onNext(self.likesCount)
                    output.isPaging.onNext(false)
                    output.endRefreshing.onNext(true)
                    
                        
                case .failure(_):
                    break
                }
                
                
                
            }).disposed(by: disposeBag)
            
            
            
        }).disposed(by: disposeBag)
        
        input.paging.subscribe(onNext:{ [weak self] event in
            
            if(event){

                self?.reload.onNext(4)
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
    
    
    
    
    
    
    
    func resetFirebaseValue(){
        self.feedModels = []
        self.firebaseService.query = nil
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
}

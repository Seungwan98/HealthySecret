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
    
    var reset : Bool = false
    
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
        let likesTapped : Observable<String>
        let refreshControl : Observable<Void>
        let segmentChanged : Observable<Bool>
        
        
    }
    
    struct Output {
        
        var feedModel = PublishSubject<[FeedModel]>()
        var likesCount = BehaviorSubject<[ String : [ String ] ]>(value: [:] )
        var isLastPage = BehaviorSubject<Bool>(value:false)
        var isPaging = BehaviorSubject<Bool>(value: false)
        var endRefreshing = BehaviorSubject<Bool>(value: false)
        var alert = PublishSubject<Bool>()
        
        
    }
    
    var getFollow : Bool = false
    
    var likesCount : [ String : [ String ] ] = [:]
    
    var feedModels = [FeedModel]()

    
    weak var coordinator : CommuCoordinator?
    private let commuUseCase : CommuUseCase
    
    
    init( coordinator : CommuCoordinator , commuUseCase : CommuUseCase ){
        self.coordinator = coordinator
        self.commuUseCase = commuUseCase
    }
    
    
    
    
    
    func transform(input : Input , disposeBag: DisposeBag) -> Output {
        let authUid = UserDefaults.standard.string(forKey: "uid") ?? ""
        
        
        
        let output = Output()
        
        input.segmentChanged.subscribe(onNext: { [weak self]  event in
        
            guard let self = self else {return}
            var count = self.feedModels.count

            self.resetValue()
            
            self.getFollow = !event


            self.reload.onNext( count == 0 ? 4 : count )

            
            
        }).disposed(by: disposeBag)
        
        input.refreshControl.subscribe(onNext: { [weak self] _  in
            
            self?.resetValue()
            
            
          
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
            guard let self = self else {return}
            self.commuUseCase.deleteFeed(feedUid: feedUid).subscribe({ event in
                switch(event){
                case.completed:
         
      
                        
                    var count = 4

                    for i in 0..<self.feedModels.count{

                        if(self.feedModels[i].feedUid == feedUid){
                            self.feedModels.remove(at: 0)
                            break
                            }
                        }
                    count = self.feedModels.count
                    
                    self.resetValue()

                    self.reload.onNext(count == 0 ? 4 : count )


                    
                    
                    
                    
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
        
        
        input.likesTapped.subscribe(onNext: { [weak self] feedUid in

            var feed : FeedModel?
            
            _ = self?.feedModels.map({  if($0.feedUid == feedUid){ feed = $0}  })
            
            guard let feed = feed else { return }
            
            self?.coordinator?.pushLikes(uid: feed.uuid , feedUid : feed.feedUid )
            
            
        }).disposed(by: disposeBag)
        
        input.likesButtonTapped.throttle(.seconds(1),  scheduler: MainScheduler.instance).subscribe(onNext: { dic in
            guard let feedUid = dic.keys.first else {return}
            guard let like = dic.values.first else {return}
            self.commuUseCase.updateFeedLikes(feedUid: feedUid  , uuid: authUid, like: like ).subscribe({ [weak self] event in
                guard let self = self else {return}
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
            guard let self = self else {return}
            self.coordinator?.refreshChild()
            
            self.commuUseCase.getUser().subscribe({ event in
                switch(event){
                case.completed:
                    
                    var count = self.feedModels.count
                    
                    self.resetValue()

                    self.reload.onNext(count == 0 ? 4 : count )
                    
                    
                    
                case.error(let err):
                    print(err)
                }
                
                
            }).disposed(by: disposeBag)
            
            
         
            
            
           
            
            
            
        }).disposed(by: disposeBag)
        
        
        self.reload.subscribe(onNext: { [weak self] count in
            
            print("\(count) count")
            guard let self = self else {return}
            
            self.commuUseCase.getFeedPagination(feedModels: self.feedModels , getFollow: self.getFollow , count: count, reset: self.reset ).subscribe({ event in
                    
                    switch(event){
                        
                    case.success(let feeds):
                        
                        self.reset = false
                        
                        self.feedModels = feeds
                        
                        for i in 0..<feeds.count {
                            
                            self.likesCount[feeds[i].feedUid ] = feeds[i].likes
                            
                        }
                        
              
                            
                            output.isLastPage.onNext(false)
                 
                        
                        
                        
                        
                        output.feedModel.onNext(self.feedModels)
                        output.likesCount.onNext(self.likesCount)
                        output.isPaging.onNext(false)
                        output.endRefreshing.onNext(true)
                        
                        
                    case .failure(let err):
                        print("fail")
                        output.isPaging.onNext(false)
                        output.isLastPage.onNext(true)
                        output.feedModel.onNext(self.feedModels)
                        output.likesCount.onNext(self.likesCount)
                        output.endRefreshing.onNext(true)


                    }
                    
                    
                    
                }).disposed(by: disposeBag)

            
        }).disposed(by: disposeBag)
        
        input.paging.subscribe(onNext:{ [weak self] event in
            
            
            if(event){

                self?.reload.onNext(4)
            }
            
            
        }).disposed(by: disposeBag)
        
        input.reportFeed.subscribe(onNext : { [weak self] feedUid in
            guard let self = self else {return}
            
            
            self.commuUseCase.report(url: "HealthySecretFeed", uid: feedUid , uuid: authUid, event: "feed" ).subscribe({ event in
                
                switch(event){
                case.completed:
                    output.alert.onNext(true)
                case.error(let err):
                    print(err)
                    
                }
                
                
                
            }).disposed(by: disposeBag)
            
            
            
            
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
        
    
        
        input.addButtonTapped.subscribe(onNext: { [weak self] _ in
            
            input.imagesDatas.subscribe(onNext: { arr in
                
                input.feedText.subscribe(onNext: { text in
                    var urlArr : [String] = []
                    
                    LoadingIndicator.showLoading()
                    
                    for image in arr {
                        guard let imageData = image.jpegData(compressionQuality: 0.1) else { return  }

                        self?.commuUseCase.uploadImage(imageData: imageData, pathRoot: uuid).subscribe({ event in
                            switch(event){
                            case.success(let url): urlArr.append(url)
                            case.failure(let err):
                                print(err)
                                break
                            }
                            
                            if(urlArr.count == arr.count){
                                let feed = FeedModel(uuid: uuid , feedUid: UUID().uuidString, date: date, profileImage: "", nickname: name , contents: text, mainImgUrl: urlArr , likes: [], report: [], coments: []  )
                                
                                self?.commuUseCase.addFeed(feed: feed).subscribe({ event in
                                    switch(event){
                                    case .completed:
                                        
                                        DispatchQueue.main.async {
                                            LoadingIndicator.hideLoading()
                                        }
                                        
                                        self?.coordinator?.navigationController.popViewController(animated: false)
                                        
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
    
    
    
    
    
    
    
    func resetValue(){
        
        self.feedModels = []
        self.reset = true
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
}

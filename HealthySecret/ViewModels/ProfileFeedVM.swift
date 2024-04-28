//
//  CommuVM.swift
//  HealthySecret
//
//  Created by 양승완 on 2023/11/28.
//

import Foundation
import RxCocoa
import RxSwift


class ProfileFeedVM : ViewModel {
    
    
    var disposeBag = DisposeBag()
    
    var feedUid : String?
    
    var reload = PublishSubject<Bool>()
    
    struct Input {
        let viewWillApearEvent : Observable<Void>
        let likesButtonTapped : Observable<Bool>
        let comentsTapped : Observable<UITapGestureRecognizer>
        let deleteFeed : Observable<String>
        let reportFeed : Observable<String>
        let updateFeed : Observable<String>
        let profileTapped : Observable<UITapGestureRecognizer>
        let refreshControl : Observable<Void>
        
        
    }
    
    struct Output {
        
        var feedModel = BehaviorSubject<FeedModel?>(value: nil)
        var endRefreshing = BehaviorSubject<Bool>(value: false)
        
        
        
    }
    
    
    
    var feedModel : FeedModel?
    
    weak var coordinator : CommuCoordinator?
    
    private var firebaseService : FirebaseService
    
    init( coordinator : CommuCoordinator , firebaseService : FirebaseService ){
        self.coordinator =  coordinator
        self.firebaseService =  firebaseService
        
    }
    
    
    
    
    
    func transform(input : Input , disposeBag: DisposeBag) -> Output {
        let authUid = UserDefaults.standard.string(forKey: "uid") ?? ""
        
        
        
        let output = Output()
        
        input.refreshControl.subscribe(onNext: { _ in
            
            
            DispatchQueue.main.asyncAfter(wallDeadline: .now() + 1) { [weak self] in
                self?.reload.onNext(true)
                
                
                    }
            
            
        }).disposed(by: disposeBag)
        
        input.profileTapped.subscribe(onNext : { _ in
            guard let uuid = self.feedModel?.uuid else {return}
            self.coordinator?.pushProfileVC(uuid: uuid )
            
            
        }).disposed(by: disposeBag)
        
        input.updateFeed.subscribe(onNext :{ feedUid in
            
            guard let feedModel = self.feedModel else {return}
            
            self.coordinator?.pushUpdateFeed(feed: feedModel)
            
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
        
        input.comentsTapped.subscribe(onNext: { _ in

            guard let feed = self.feedModel else {return}
            
            self.coordinator?.pushComents(coments: feed.coments ?? [] , feedUid : feed.feedUid , feedUuid: feed.uuid )
            
            
        }).disposed(by: disposeBag)
        
        input.likesButtonTapped.throttle(.seconds(1) , latest: true  ,  scheduler: MainScheduler.instance).subscribe(onNext: { like in
          
            guard let feedUid = self.feedUid else {return}
            
            
            
            print("\(feedUid)  \(authUid)  \(like)")
            
            self.firebaseService.updateFeedLikes(feedUid: feedUid  , uuid: authUid, like: like ).subscribe({ event in
                switch(event){
                case(.completed):
                    print("좋아요 수정완료")
                case(.error(let err)):
                    print("likesUpdate err \(err)")
                    
                }
                
                
                
            }).disposed(by: disposeBag)
            
            
        }).disposed(by:disposeBag )
        

        
        
        input.viewWillApearEvent.subscribe(onNext: { event in
            
           
            print("viewWillAppeear")
            self.reload.onNext(true)
           
            
            
        }).disposed(by: disposeBag)
        
        
        self.reload.subscribe(onNext: { _ in
            
            print("reload")
            
            if let feedUid = self.feedUid {
                
                self.firebaseService.getFeedFeedUid(feedUid: feedUid).subscribe({ event in
                    switch(event){
                    case.success(let feed):
                        
                        
                        
                        
                            
                        
                        self.feedModel = feed
                        
                        output.feedModel.onNext(feed)
                        
                        
                        
                    case.failure(let err):
                        print(err)
                        break
                    }
                    
                    
                    
                }).disposed(by: disposeBag)
                
            }
            
            
            
        }).disposed(by: disposeBag)
        
      
        
        
        
        
        return output
        
    }

    
    
    
}
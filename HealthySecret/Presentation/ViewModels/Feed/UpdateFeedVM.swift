//
//  UpdateFeedVM.swift
//  HealthySecret
//
//  Created by 양승완 on 2023/11/28.
//

import Foundation
import RxCocoa
import RxSwift


class UpdateFeedVM: ViewModel {
    
    
    
    
    var feed: FeedModel?
    
    var disposeBag = DisposeBag()
    
    var beforeArr = [Int?]()
    
    
    
    weak var coordinator: Coordinator?
    
    private let commuUseCase: CommuUseCase
    
    init( coordinator: Coordinator, commuUseCase: CommuUseCase ) {
        self.coordinator =  coordinator
        self.commuUseCase = commuUseCase
    }
    
    
    
    struct Input {
        
        let addButtonTapped: Observable<Void>
        let feedText: Observable<String>
        let imagesDatas: Observable<([Int?], [UIImage])>
        
        
    }
    
    struct Output {
        var feedText = BehaviorSubject<String>(value: "")
        var imagesDatas = BehaviorSubject<[String]>(value: [])
        var BeforeImagesDatas = BehaviorSubject<[Int?]>(value: [])
        
    }
    
    func transform(input: Input, disposeBag: DisposeBag ) -> Output {
        
        let output = Output()
        
        
        let mainImgUrl = feed?.mainImgUrl ?? []
        
        let mainImgUrlRm = feed?.mainImgUrl ?? []
        
        for i in 0..<(mainImgUrl.count) {
            beforeArr.append(i)
        }
        
        
        
        output.feedText.onNext(feed?.contents ?? "")
        print(mainImgUrl)
        output.imagesDatas.onNext(mainImgUrl)
        output.BeforeImagesDatas.onNext(beforeArr)
        
        
        
        
        input.addButtonTapped.subscribe(onNext: { _ in
            
            input.imagesDatas.subscribe(onNext: { before, after  in
                
                input.feedText.subscribe(onNext: { text in
                    var urlArr = [String]()
                    print("\(before) before, \(after ) after ")
                    LoadingIndicator.showLoading()
                    
                    
                    
                    let singleArr = [Observable<String>]()
                    
                    //                    for i in (0..<before.count).reversed() {
                    //                        if let index = before[i]{
                    //                            print(index)
                    //                            print(mainImgUrlRm)
                    //                            urlArr.append(mainImgUrl[index])
                    //                            mainImgUrlRm.remove(at: index)
                    //                        } else {
                    //                            singleArr.insert( ( self.firebaseService.uploadImage(imageData: after[i], pathRoot: "test").asObservable() ), at: 0 )
                    //                        }
                    //
                    //
                    //                    }
                    
                    
                    
                    
                    
                    
                    Observable.concat(singleArr).subscribe( onNext: { url in
                        urlArr.append(url)
                        
                    }, onCompleted: {
                        
                        
                        var feed = self.feed!
                        feed.mainImgUrl = urlArr
                        feed.contents = text
                        if let profileImage = UserDefaults.standard.string(forKey: "profileImage") {
                            
                            feed.profileImage = profileImage
                        }
                        
                        self.commuUseCase.updateFeed(feed: feed).subscribe({ event in
                            switch event { 
                            case.completed:
                                DispatchQueue.main.async {
                                    LoadingIndicator.hideLoading()
                                }
                                
                                for url in mainImgUrlRm {
                                    
                                    self.commuUseCase.deleteImage(urlString: url).subscribe { event in
                                        switch event { 
                                        case.completed:
                                            print("전 사진 삭제")
                                        case.error(_):
                                            print("사진 삭제 에러")
                                        }
                                        
                                    }.disposed(by: disposeBag)
                                }
                                
                                self.coordinator?.finish()
                                
                            case .error(_):
                                break
                            }
                            
                        }).disposed(by: disposeBag)
                        
                        
                    }, onDisposed: {
                        
                        print("disposed")
                        
                        
                    }
                                                            
                                                            
                    ).disposed(by: disposeBag)
                    
                    
                    
                    
                }).disposed(by: disposeBag)
                
                
                
            }).disposed(by: disposeBag)
            
            
            
            
        }).disposed(by: disposeBag)
        
        return output
        
    }
    
    
    
    
    
    
    
    
}

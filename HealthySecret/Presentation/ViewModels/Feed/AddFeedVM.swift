//
//  AddFeedVM.swift
//  HealthySecret
//
//  Created by 양승완 on 2023/11/28.
//

import Foundation
import RxCocoa
import RxSwift


class AddFeedVM: ViewModel {
    
    
    
    
    
    
    var disposeBag = DisposeBag()
    
    
    weak var coordinator: Coordinator?
    private let commuUseCase: CommuUseCase
    
    init( coordinator: Coordinator, commuUseCase: CommuUseCase ) {
        self.coordinator =  coordinator
        self.commuUseCase = commuUseCase
    }
    
    
    
    struct Input {
        let addButtonTapped: Observable<Void>
        let feedText: Observable<String>
        let imagesDatas: Observable<[UIImage]>
        
        
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
                    var urlArr: [String] = []
                    
                    LoadingIndicator.showLoading()
                    for image in arr {
                        guard let imageData = image.jpegData(compressionQuality: 0.1) else { return  }
                        
                        self.commuUseCase.uploadImage( imageData: imageData, pathRoot: uuid ).subscribe({ event in
                            switch event {
                            case.success(let url): urlArr.append(url)
                            case.failure(let err):
                                print(err)
                            }
                            
                            if urlArr.count == arr.count {
                                
                                let feed = FeedModel(uuid: uuid, feedUid: UUID().uuidString+CustomFormatter.shared.getToday(), date: date, profileImage: "", nickname: name, contents: text, mainImgUrl: urlArr, likes: [], report: [], coments: []  )
                                
                                
                                self.commuUseCase.addFeed(feed: feed).subscribe({ event in
                                    switch event {
                                    case.completed:
                                        DispatchQueue.main.async {
                                            LoadingIndicator.hideLoading()
                                        }
                                        self.coordinator?.finish()
                                        
                                    case .error(_):
                                        break
                                    }
                                    
                                }).disposed(by: disposeBag)
                            }
                            
                            
                        }).disposed(by: disposeBag)
                        
                    }
                    
                    
                    
                    
                    
                    
                    
                }).disposed(by: disposeBag)
                
                
                
            }).disposed(by: disposeBag)
            
            
            
            
        }).disposed(by: disposeBag)
        
        return output
        
    }
    

}

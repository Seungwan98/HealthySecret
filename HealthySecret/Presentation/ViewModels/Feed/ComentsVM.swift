//
//  ComentsVM.swift
//  HealthySecret
//
//  Created by 양승완 on 2023/11/28.
//

import Foundation
import RxCocoa
import RxSwift


class ComentsVM: ViewModel {
    
    
    var disposeBag = DisposeBag()
    
    var coments: [ComentModel]?
    var feedUid: String?
    var feedUuid: String?
    
    struct Input {
        let addButtonTapped: Observable<Void>
        let coments: Observable<String>
        let comentsDelete: Observable<ComentModel>
        let profileTapped: Observable<String>
        let reportTapped: Observable<ComentModel>
        
        
    }
    
    struct Output {
        
        var coments = BehaviorSubject<[ComentModel]>(value: [])
        var feedUuid = BehaviorSubject<String>(value: "")
        var backgroundHidden = PublishSubject<Bool>()
        var alert = PublishSubject<Bool>()
        
        
        
    }
    
    
    weak var coordinator: CommuCoordinator?
    
    private let comentsUseCase: ComentsUseCase
    
    init( coordinator: CommuCoordinator, comentsUseCase: ComentsUseCase ) {
        self.coordinator =  coordinator
        self.comentsUseCase =  comentsUseCase
        
    }
    
    
    
    func transform(input: Input, disposeBag: DisposeBag ) -> Output {
        let output = Output()
        var coment: String = ""
        guard let nickname = UserDefaults.standard.string(forKey: "name"), let uid = UserDefaults.standard.string(forKey: "uid"), let feedUid = self.feedUid  else {return Output()}
        
        
        self.comentsUseCase.getComents(feedUid: feedUid ).subscribe({ [weak self] event in
            guard self != nil else {return}
            
            switch event {
                
            case.success(let coments):
                output.coments.onNext(coments)
                print("comentsCOunt \(coments.count)")
                
                output.backgroundHidden.onNext( !coments.isEmpty )
            case.failure(_):
                break
            }
            
            
            
            
        }).disposed(by: disposeBag)
        
        
        
        
        
        input.reportTapped.subscribe(onNext: { [weak self] coment  in
            guard let self = self else {return}
            self.comentsUseCase.reportComents( uid: coment.comentUid, uuid: uid, coment: coment, feedUid: feedUid ).subscribe({ event in
                switch event {
                case .success(let coments):
                    output.coments.onNext(coments)
                    output.backgroundHidden.onNext( !coments.isEmpty )
                    output.alert.onNext(true)
                    
                    
                case .failure(let err):
                    print(err)
                }
                
            }).disposed(by: disposeBag)
            
        }).disposed(by: disposeBag)
        
        
        if let feedUuid = self.feedUuid {
            
            output.feedUuid.onNext(feedUuid)
            
        }
        
        input.profileTapped.subscribe(onNext: { uuid in
            
            self.coordinator?.pushProfileVC(uuid: uuid)
            
        }).disposed(by: disposeBag)
        
        input.comentsDelete.subscribe(onNext: { coment in
            LoadingIndicator.showLoading()
            
            
            guard let feedUid = self.feedUid else {return}
            
            
            self.comentsUseCase.deleteComents( coment: coment, feedUid: feedUid ).subscribe({ event in
                switch event {
                case.success(let coments):
                    output.coments.onNext(coments)
                    output.backgroundHidden.onNext( !coments.isEmpty )
                    
                    
                    
                    LoadingIndicator.hideLoading()
                    
                    
                case.failure(let err):
                    print(err)
                }
                
            }).disposed(by: disposeBag)
            
            
        }).disposed(by: disposeBag)
        
        
        input.coments.subscribe(onNext: { value in
            
            coment = value
            
            
        }).disposed(by: disposeBag)
        
        
        
        
        input.addButtonTapped.subscribe(onNext: { _ in
            
            LoadingIndicator.showLoading()
            
            print("tapped")
            
            let profileImage = UserDefaults.standard.string(forKey: "profileImage") ?? ""
            
            let date = CustomFormatter.shared.DateToStringForFeed(date: Date())
            
            let coment = ComentModel(coment: coment, date: date, nickname: nickname, profileImage: profileImage, uid: uid, comentUid: UUID().uuidString+date, feedUid: feedUid )
            
            
            
            
            self.comentsUseCase.updateComents(feedUid: feedUid, coment: coment).subscribe({ event in
                switch event {
                case.success(let coments):
                    output.coments.onNext(coments)
                    output.backgroundHidden.onNext( !coments.isEmpty )
                    
                    
                    LoadingIndicator.hideLoading()
                    
                case.failure(let err):
                    print(err)
                }
                
                
            }).disposed(by: disposeBag)
            
            
            
            
        }).disposed(by: disposeBag)
        
        
        
        
        
        
        
        
        
        
        
        return output
    }
    
    
    
    
    
    
    
}

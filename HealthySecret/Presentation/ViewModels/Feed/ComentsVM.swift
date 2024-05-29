//
//  ComentsVM.swift
//  HealthySecret
//
//  Created by 양승완 on 2023/11/28.
//

import Foundation
import RxCocoa
import RxSwift


class ComentsVM : ViewModel {
    
   // var coreMotionService = CoreMotionService.shared
    
    var disposeBag = DisposeBag()
    
    var coments : [ComentModel]?
    var feedUid : String?
    var feedUuid : String?
    
    struct Input {
        let addButtonTapped : Observable<Void>
        let coments : Observable<String>
        let comentsDelete : Observable<ComentModel>
        let profileTapped : Observable<String>
        let reportTapped : Observable<ComentModel>
   
        
    }
    
    struct Output {
        
        var coments = BehaviorSubject<[ComentModel]>(value: [])
        var feedUuid = BehaviorSubject<String>(value: "")
        var backgroundHidden = PublishSubject<Bool>()
        var alert = PublishSubject<Bool>()
        

        
    }
    
    
    weak var coordinator : CommuCoordinator?
    
    private var firebaseService : FirebaseService
    
    init( coordinator : CommuCoordinator , firebaseService : FirebaseService ){
        self.coordinator =  coordinator
        self.firebaseService =  firebaseService
        
    }
    
    
    
    func transform(input: Input, disposeBag: DisposeBag ) -> Output {
        let output = Output()
        var coment : String = ""
        guard let nickname = UserDefaults.standard.string(forKey: "name") , let uid = UserDefaults.standard.string(forKey: "uid") , let feedUid = self.feedUid  else {return Output()}
 

//리팩
//            firebaseService.getComents(feedUid: feedUid ).subscribe({ [weak self] event in
//                guard self != nil else {return}
//                
//                switch(event){
//                    
//                case.success(let coments):
//                    output.coments.onNext(coments)
//                    
//                    output.backgroundHidden.onNext( !coments.isEmpty )
//                case.failure(let err):
//                    print(err)
//                    break
//                }
//                    
//                
//                
//                
//            }).disposed(by: disposeBag)
                
        
        
        
        
        input.reportTapped.subscribe(onNext: { [weak self] coment  in
            guard let self = self else {return}
            self.firebaseService.report(url: "HealthySecretComentsReports", uid: coment.comentUid , uuid: uid, event: "coment").subscribe({ event in
                switch(event){
                case.completed:
                    break
                    //리팩
//                    self.firebaseService.getComents(feedUid: feedUid ).subscribe({ [weak self] event in
//                        guard self != nil else {return}
//                        
//                        switch(event){
//                            
//                        case.success(let coments):
//                            output.coments.onNext(coments)
//                            
//                            output.backgroundHidden.onNext( !coments.isEmpty )
//                            output.alert.onNext(true)
//
//                        case.failure(let err):
//                         
//                            break
//                        }
//                            
//                        
//                        
//                        
//                    }).disposed(by: disposeBag)
                    
                case.error(let err): if(err as! CustomError == CustomError.delete){
                    
                    
                    //리팩
//                    self.firebaseService.deleteComents(coment: coment, feedUid: feedUid).subscribe({ event in
//                        switch(event){
//                        case.success(let coments):
//                            print("coments \(coments)")
//                            output.coments.onNext(coments)
//                            
//                            output.backgroundHidden.onNext( !coments.isEmpty )
//                            output.alert.onNext(true)
//
//                        case .failure(_):
//                            break
//                        }
//                        
//                        
//                        
//                    }).disposed(by: disposeBag)
                    
                }
                    
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
            
            //리팩
//            self.firebaseService.deleteComents( coment: coment , feedUid: feedUid ).subscribe({ event in
//                switch(event){
//                case.success(let coments):
//                    output.coments.onNext(coments)
//                    output.backgroundHidden.onNext( !coments.isEmpty )
//
//                    self.firebaseService.listener?.remove()
//
//                    
//                    LoadingIndicator.hideLoading()
//
//                
//                case.failure(let err):
//                    print(err)
//                }
//                
//            }).disposed(by: disposeBag)
            
            
        }).disposed(by: disposeBag)
            
        
        input.coments.subscribe(onNext: { value in
            
            coment = value

            
            
        }).disposed(by: disposeBag)
        
        
      

        input.addButtonTapped.subscribe(onNext: { _ in

            LoadingIndicator.showLoading()

            print("tapped")
            
            let profileImage = UserDefaults.standard.string(forKey: "profileImage") ?? ""
          
            let date = CustomFormatter.shared.DateToStringForFeed(date: Date())
            
            let coment = ComentModel(coment: coment, date: date, nickname: nickname, profileImage: profileImage , uid: uid, comentUid:  UUID().uuidString+date, feedUid: feedUid )
                

            
            
//            self.firebaseService.updateComents(feedUid: feedUid , coment: coment).subscribe({ event in
//                switch(event){
//                case.success(let coments):
//                    output.coments.onNext(coments)
//                    output.backgroundHidden.onNext( !coments.isEmpty )
//
//                    self.firebaseService.listener?.remove()
//
//
//                    
//                    LoadingIndicator.hideLoading()
//                    
//                case.failure(let err):
//                    print(err)
//                }
//                
//                
//            }).disposed(by: disposeBag)

            
            
            
        }).disposed(by: disposeBag)
        
        
        
  
        
        
   
        
       
        
        
        return output
    }
    
    
    
    
    
    
    
}

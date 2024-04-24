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
    
    var coments : [Coment]?
    var feedUid : String?
    var feedUuid : String?
    
    struct Input {
        let addButtonTapped : Observable<Void>
        let coments : Observable<String>
        let comentsDelete : Observable<Coment>
        let profileTapped : Observable<String>
   
        
    }
    
    struct Output {
        
        var coments = BehaviorSubject<[Coment]>(value: [])
        var feedUuid = BehaviorSubject<String>(value: "")

        
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

        
        if let coments = self.coments {
            
            
            
            output.coments.onNext(coments)
        }
        
        if let feedUuid = self.feedUuid {
            output.feedUuid.onNext(feedUuid)
            
        }
        
        input.profileTapped.subscribe(onNext: { uuid in
            self.coordinator?.pushProfileVC(uuid: uuid)
            
            
            
            
        }).disposed(by: disposeBag)
        
        input.comentsDelete.subscribe(onNext: { coment in
            LoadingIndicator.showLoading()

            guard let feedUid = self.feedUid else {return}
            self.firebaseService.deleteComents( coment: coment , feedUid: feedUid ).subscribe({ event in
                switch(event){
                case.success(let coments):
                    output.coments.onNext(coments)
                    output.coments.onNext(coments)
                    self.firebaseService.listener?.remove()

                    
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
            

            print("add")
            let profileImage = UserDefaults.standard.string(forKey: "profileImage") ?? ""
            guard let nickname = UserDefaults.standard.string(forKey: "name") else {return}
            guard let uid = UserDefaults.standard.string(forKey: "uid") else {return}
            guard let feedUid = self.feedUid else {return}
            let date = CustomFormatter.shared.DateToStringForFeed(date: Date())
            
            let coment = Coment(coment: coment, date: date, nickname: nickname, profileImage: profileImage , uid: uid, comentUid:  UUID().uuidString+date, feedUid: feedUid)
                

            
            
            self.firebaseService.updateComents(feedUid: feedUid , coment: coment).subscribe({ event in
                switch(event){
                case.success(let coments):
                    output.coments.onNext(coments)
                    self.firebaseService.listener?.remove()


                    
                    LoadingIndicator.hideLoading()
                    
                case.failure(let err):
                    print(err)
                }
                
                
            }).disposed(by: disposeBag)

            
            
            
        }).disposed(by: disposeBag)
        
        
        
  
        
        
   
        
       
        
        
        return output
    }
    
    
    
    
    
    
    
}

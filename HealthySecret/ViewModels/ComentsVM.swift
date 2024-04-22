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
    
    struct Input {
        let addButtonTapped : Observable<Void>
        let coments : Observable<String>
        let comentsDelete : Observable<Coment>
   
        
    }
    
    struct Output {
        
        var coments = BehaviorSubject<[Coment]>(value: [])

        
    }
    
    
    weak var coordinator : Coordinator?
    
    private var firebaseService : FirebaseService
    
    init( coordinator : Coordinator , firebaseService : FirebaseService ){
        self.coordinator =  coordinator
        self.firebaseService =  firebaseService
        
    }
    
    
    
    func transform(input: Input, disposeBag: DisposeBag ) -> Output {
        var output = Output()

        
        if let coments = self.coments {
            
            
            
            output.coments.onNext(coments)
        }
        
        input.comentsDelete.subscribe(onNext: { coment in
            guard let feedUid = self.feedUid else {return}
            self.firebaseService.deleteComents( coment: coment , feedUid: feedUid ).subscribe({ event in
                switch(event){
                case.completed:
                    print("complete")
                
                case.error(let err):
                    print(err)
                }
                
            }).disposed(by: disposeBag)
            
            
        }).disposed(by: disposeBag)
            
            input.addButtonTapped.subscribe(onNext: { _ in
                input.coments.subscribe(onNext: { coment in

                print("add")
                let profileImage = UserDefaults.standard.string(forKey: "profileImage") ?? ""
                guard let nickname = UserDefaults.standard.string(forKey: "name") else {return}
                guard let uid = UserDefaults.standard.string(forKey: "uid") else {return}
                guard let feedUid = self.feedUid else {return}
                let date = CustomFormatter.shared.DateToStringForFeed(date: Date())
                
                    var coments = Coment(coment: coment, date: date, nickname: nickname, profileImage: profileImage , uid: uid, comentUid:  UUID().uuidString+date, feedUid: feedUid)
                
                self.firebaseService.updateComents(feedUid: feedUid , coment: coments).subscribe({ event in
                    switch(event){
                    case.completed:
                        print("reload")
                    case.error(let err):
                        print(err)
                    }
                    
                    
                }).disposed(by: disposeBag)

                
                
                
            }).disposed(by: disposeBag)
            
        }).disposed(by: disposeBag)
      

        
        
        
  
        
        
   
        
       
        
        
        return output
    }
    
    
    
    
    
    
    
}

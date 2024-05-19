//
//  LikesVM.swift
//  HealthySecret
//
//  Created by 양승완 on 2023/11/28.
//

import Foundation
import RxCocoa
import RxSwift


class BlockListVM : ViewModel {
 
   
    
    var disposeBag = DisposeBag()
    

    
    struct Input {
        let viewWillApearEvent : Observable<Void>
        let pressedBlock : Observable<[String:Bool]>

    }
    
    struct Output {
        
        var userModels = BehaviorSubject<[UserModel]>(value: [])
        var backgroundViewHidden = PublishSubject<Bool>()
        var alert = PublishSubject<Bool>()

        
    }
    
    
    weak var coordinator : ProfileCoordinator?
    
    
    
    
    private var firebaseService : FirebaseService
    
    init( coordinator : ProfileCoordinator , firebaseService : FirebaseService ){
        self.coordinator =  coordinator
        self.firebaseService =  firebaseService
        
    }
    
    
    
    func transform(input: Input, disposeBag: DisposeBag ) -> Output {
        let reload = PublishSubject<Bool>()

        let output = Output()

        
        guard let ownUid = UserDefaults.standard.string(forKey: "uid") else {
            print("ownUid nil")
            return output }
        
       
        
        
        
        input.pressedBlock.subscribe(onNext: { [weak self] data in
            
            guard let self = self else {return}
            
            if(data.count > 1 ){
                return
            }else{
                

                
                guard let block = data.first?.value , let uid = data.first?.key  else {return}
                
                self.firebaseService.blockUser(ownUid: ownUid , opponentUid: uid , block: block).subscribe({ event in
                    
                    switch(event){
                        
                    case.completed:
                        
                        output.alert.onNext(true)
                        reload.onNext(true)

                        
                    case.error(let err):
                        print(err)
                        
                    }
                    
                    
                    
                }).disposed(by: disposeBag)
                
            }
            
            
            
            
        }).disposed(by: disposeBag)
        
        
        
  
        
        
        
        
        input.viewWillApearEvent.subscribe({ _ in
            
            reload.onNext(true)

           
            
                
                
                
            
            
            
        }).disposed(by: disposeBag)
        
        
        reload.subscribe(onNext: {[weak self]  _ in
            guard let self = self else {return}
            self.firebaseService.getDocument(key: ownUid).subscribe({ [weak self] event in
                switch(event){
                case.success(let user):
                    
                    self?.firebaseService.getFollowsLikes(uid: user.blocking).subscribe({ event in
                        switch(event){
                        case.success(let users):
                            if(users.isEmpty){
                                output.backgroundViewHidden.onNext(false)
                            }
                            output.userModels.onNext(users)
                            
                            
                        case.failure(let err):
                            print(err)
                        }
                        
                        
                        
                    }).disposed(by: disposeBag)
                    
                    
                case.failure(let err):
                    print(err)
                }
                
                
            }).disposed(by: disposeBag)
            
            
        }).disposed(by: disposeBag)
        
        
        
        

        
       
        
        
        return output
    }
    
    
    
    
    
    
    
}

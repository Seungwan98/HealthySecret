//
//  SignUpUseCase.swift
//  HealthySecret
//
//  Created by 양승완 on 5/27/24.
//

import Foundation
import RxSwift

class ComentsUseCase  {
    
    
    
    
    private let disposeBag = DisposeBag()
    private let comentsRepository : ComentsRepository
    private let userRepository : UserRepository
    
    init( userRepository : UserRepository , comentsRepository : ComentsRepository){
        self.comentsRepository = comentsRepository
        self.userRepository = userRepository
        
    }
    
    func getModels(comentsDtos : [ComentDTO] ) -> Single<[ComentModel]>{
        
        var index = 0
        var comentsModels = comentsDtos.map{ $0.toDomain(nickname: "", profileImage: "" ) }
        return Single.create { [weak self] single in
            guard let self else {  single( .failure(CustomError.isNil))
                return Disposables.create()}
            guard comentsDtos.isEmpty != true else {  single(.success([]))
                return Disposables.create() }
            for i in 0..<comentsDtos.count {
                self.userRepository.getUser(uid: comentsDtos[i].uid ).subscribe({ event in
                    
                    switch(event){
                    case.success(let user):
                        
                        
                        comentsModels[i] = comentsDtos[i].toDomain(nickname: user.name , profileImage: user.profileImage ?? "")
                        
                        if(index + 1 >= comentsDtos.count){
                            single(.success(comentsModels))
                        }else{
                            index += 1
                        }
                        
                        
                        
                        
                    case .failure(_):
                        single(.failure(CustomError.isNil))
                    }
                    
                    
                    
                }).disposed(by: self.disposeBag)
                
            }
            return Disposables.create()
        }
        
        
    }
    
    
    func getComents(feedUid: String ) -> Single<[ComentModel]>{
        
        return Single.create{ [weak self] single in 
            guard let self else { single(.failure(CustomError.isNil))
            return Disposables.create() }
            
            comentsRepository.getComents(feedUid: feedUid ).subscribe({ [weak self] event in
                guard let self = self else {return}
                switch(event){
                case .success(let dtos):
                    
<<<<<<< HEAD
                   
                
                    
                    
=======
                    self.getModels(comentsDtos: dtos).subscribe({ event in

                        single(event)
                        
                    }).disposed(by: disposeBag)
>>>>>>> staged_Issue
                    
      
                    
                    
                case .failure(let err):
                    single( .failure(err) )
                }
                
                
            }).disposed(by: disposeBag)
            
            
            return Disposables.create()
        }
       
        
        
        
        
        
    }
   
    
  
    
    func reportComents( uid: String , uuid : String , coment : ComentModel , feedUid : String) -> Single<[ComentModel]> {
        
        return Single.create{ [weak self] single in
            guard let self else {return single(.failure(CustomError.isNil)) as! Disposable}
            self.comentsRepository.reportComents(uid: uid, uuid: uuid).subscribe({ event in
                switch(event){
                 
                case .error(let err):
                    if(err as! CustomError == CustomError.delete){
                        
                        
                        self.deleteComents(coment: coment, feedUid: feedUid).subscribe({ event in
                            switch(event){
                            case.success(let coments):
                                single(.success(coments))

                            case .failure(let err):
                                single( .failure(err))
                            }
                            
                            
                            
                        }).disposed(by: self.disposeBag)
                        
                    }
                case .completed:
                    self.getComents(feedUid: feedUid ).subscribe({ event in
                        
                        switch(event){
                            
                        case.success(let coments):
                            single(.success(coments))

                        case.failure(let err):
                         
                            break
                        }
                            
                        
                        
                        
                    }).disposed(by: self.disposeBag)
                }
                
               
                
            }).disposed(by: disposeBag)
            
            return Disposables.create()
        }
       
        
    }
    
    func deleteComents( coment : ComentModel , feedUid : String) -> Single<[ComentModel]> {
        return Single.create{ [weak self] single in guard let self else {return single(.failure(CustomError.isNil)) as! Disposable}
            self.comentsRepository.deleteComents(coment: coment.toData() , feedUid: feedUid).subscribe(onSuccess:{ comentsDtos in

                self.getModels(comentsDtos: comentsDtos).subscribe({ event in
                    
                    single(event)
                    
                }).disposed(by: self.disposeBag)
                
                
            }).disposed(by: disposeBag)

            return Disposables.create()
        }
            
            
            
        
    }
    
    func updateComents(feedUid: String , coment: ComentModel) -> Single<[ComentModel]>{
        return Single.create{ [weak self] single in guard let self else {  single( .failure(CustomError.isNil) )
            return Disposables.create() }
            self.comentsRepository.updateComents(feedUid: feedUid , coment: coment.toData()).subscribe(onSuccess: { dtos in
                
                self.getModels(comentsDtos: dtos).subscribe({ event in
                    single(event)
                    
                    
                }).disposed(by: self.disposeBag )
                    
                    
            }).disposed(by: disposeBag)
                
                
                
            
            return Disposables.create()
        }
        
    }
    
    
        
        
        
        
        
        
    
}

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
    
    func getComents(feedUid: String ) -> Single<[ComentModel]>{
        
        return Single.create{ [weak self] single in guard let self else {
            single(.failure(CustomError.isNil))
            return Disposables.create() }
            
            comentsRepository.getComents(feedUid: feedUid ).subscribe({ [weak self] event in
                guard let self = self else {return}
                switch(event){
                case .success(let dtos):
                    
                    var comentDtos = dtos
                    let comentModels = comentDtos.compactMap{ dto in
                        
                        self.userRepository.getUser(uid: dto.uid).subscribe({ event in
                            switch(event){
                            case .success(let user):
                                print(user)
                                
                            case .failure(let err):
                                single( .failure(err))
                            }
                            
                            
                        }).disposed(by: self.disposeBag)
                        
                    }.map{ print($0) }
                
                    
                    
                    
                    
                    
                case .failure(let err):
                    single( .failure(err) )
                }
                
                
            }).disposed(by: disposeBag)
            
            
            return Disposables.create()
        }
       
        
        
        
        
        
    }
    
        
        
        
        
        
        
    
}

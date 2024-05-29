//
//  LoginUseCase.swift
//  HealthySecret
//
//  Created by 양승완 on 5/27/24.
//

import Foundation
import RxSwift
import FirebaseAuth



class CalendarUseCase {

    private let disposeBag = DisposeBag()
    private let userRepository : UserRepository
    
    init( exerciseRepository : ExerciseRepository , userRepository : UserRepository ){
        self.userRepository = userRepository
        
    }
    
    
    func getDiarys() -> Single<[Diary]> {
     
        return userRepository.getUser().map{
            
            $0.diarys
        }
        
        
    }
    
    func updateDiary(diarys : [Diary] ) -> Completable {
        
        return self.userRepository.updateUsersDiays(diarys: diarys)
     
    }
    
   

    
    
    
}

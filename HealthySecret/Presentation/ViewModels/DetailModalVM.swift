//
//  DetailModalVM.swift
//  HealthySecret
//
//  Created by 양승완 on 2024/02/16.
//

import Foundation
import RxSwift

class DetailModalVM: ViewModel {
   
    var disposeBag = DisposeBag()
    
    let arr: [String: Any]
        
    
    init( coordinator: DiaryCoordinator, arr: [String: Any] ) {
        self.coordinator =  coordinator
        self.arr = arr
        
    }
    
    struct Input {
     
        
    }
    
    struct Output {
        
        
    }
    func transform(input: Input, disposeBag: DisposeBag) -> Output {
        let output = Output()

        
        return output
    
    }
    
    
    
    
    weak var coordinator: DiaryCoordinator?
    
}

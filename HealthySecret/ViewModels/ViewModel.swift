//
//  ViewModel.swift
//  HealthySecret
//
//  Created by 양승완 on 2023/11/30.
//
import RxSwift
protocol ViewModel {
    
    func transform(input : Input , disposeBag : DisposeBag ) -> Output
    
    associatedtype Input
    associatedtype Output

    var disposeBag: DisposeBag { get set }
        
    
}

//
//  HomeVM.swift
//  HealthySecret
//
//  Created by 양승완 on 2023/11/28.
//

import Foundation
import RxCocoa
import RxSwift


class ChangeIntroduceVM: ViewModel {
    
    
    
    var disposeBag = DisposeBag()
    
    
    
    var name: String?
    var introduce: String?
    var profileImage: Data?
    var beforeImage: String?
    
    
    
    
    
    
    weak var coordinator: ProfileCoordinator?
    
    private let profileUseCase: ProfileUseCase
    
    
    init( coordinator: ProfileCoordinator, profileUseCase: ProfileUseCase ) {
        self.coordinator =  coordinator
        self.profileUseCase = profileUseCase
    }
    
    
    
    
    
    
    struct Input {
        let viewWillApearEvent: Observable<Void>
        let addButtonTapped: Observable<Bool>
        let nameTextField: Observable<String>
        let introduceTextField: Observable<String>
        let profileImageTapped: Observable<UITapGestureRecognizer>
        let profileImageValue: Observable<UIImage?>
        let profileChange: Observable<Bool>
        
    }
    
    struct Output {
        var name = BehaviorSubject<String>(value: "")
        var introduce = BehaviorSubject<String>(value: "")
        var profileImage = BehaviorSubject<String?>(value: nil)
        
        
    }
    
    
    
    func transform(input: Input, disposeBag: DisposeBag ) -> Output {
        
        let output = Output()
        _ = ConcurrentDispatchQueueScheduler(queue: DispatchQueue.global())
        
        
        print("appear")
        
        output.name.onNext(self.name!)
        output.introduce.onNext(self.introduce ?? "")
        output.profileImage.onNext(self.beforeImage)
        
        
        
        
        
        input.addButtonTapped.subscribe(onNext: { event in
            
            
            
            input.nameTextField.subscribe(onNext: { name in
                input.introduceTextField.subscribe(onNext: { introduce in
                    var introduce = introduce
                    if event {
                        introduce = ""
                        
                        
                    }
                    
                    input.profileImageValue.subscribe(onNext: { image in
                        
                        input.profileChange.subscribe(onNext: { change in
                            
                            print("\(change)")
                            guard let uuid = UserDefaults.standard.string(forKey: "uid") else {return}
                            
                            LoadingIndicator.showLoading()
                            
                            
                            self.profileUseCase.updateValues(name: name, introduce: introduce, uuid: uuid, image: image, beforeImage: self.beforeImage ?? "", profileChage: change ).subscribe { event in
                                switch event {
                                case.completed:
                                    
                                    DispatchQueue.main.async {
                                        LoadingIndicator.hideLoading()
                                    }
                                    
                                    self.coordinator?.navigationController.popViewController(animated: false)
                                    
                                    print("업데이트완료")
                                    
                                    
                                case.error(_):
                                    print("error")
                                }
                                
                                print("UserDefaultsStandart")
                                
                                
                                
                                
                                
                                
                                
                                
                            }.disposed(by: disposeBag)
                            
                            
                            
                        }).disposed(by: disposeBag)
                        
                        
                        
                    }).disposed(by: disposeBag)
                    
                }).disposed(by: disposeBag)
                
                
                
                
            }).disposed(by: disposeBag)
            
            
            
            
        }).disposed(by: disposeBag)
        
        
        return output
    }
    
    
    
    
    
}

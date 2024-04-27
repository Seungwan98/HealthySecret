//
//  HomeVM.swift
//  HealthySecret
//
//  Created by 양승완 on 2023/11/28.
//

import Foundation
import RxCocoa
import RxSwift


class ChangeIntroduceVM : ViewModel {

    
    
    var disposeBag = DisposeBag()
    
    
    
    var name:String?
    var introduce:String?
    var profileImage:Data?
    var beforeImage:String?
    
  
    
    

    
    weak var coordinator : MyProfileCoordinator?
    
    private var kakaoService : KakaoService
    
    private var firebaseService : FirebaseService
    
    init( coordinator : MyProfileCoordinator , firebaseService : FirebaseService , kakaoService : KakaoService){
        self.coordinator =  coordinator
        self.firebaseService =  firebaseService
        self.kakaoService =  kakaoService
        
    }
    
    
  
    
    
    
    struct Input {
        let viewWillApearEvent : Observable<Void>
        let addButtonTapped : Observable<Void>
        let nameTextField : Observable<String>
        let introduceTextField : Observable<String>
        let profileImageTapped : Observable<UITapGestureRecognizer>
        let profileImageValue : Observable<UIImage?>
        let profileChange : Observable<Bool>
        
    }
    
    struct Output {
        var name = BehaviorSubject<String>(value: "")
        var introduce = BehaviorSubject<String>(value: "")
        var profileImage = BehaviorSubject<String?>(value: nil)
        
        
    }
    
    
    
    func transform(input: Input , disposeBag: DisposeBag ) -> Output {
        
        let output = Output()
        let backgroundScheduler = ConcurrentDispatchQueueScheduler(queue: DispatchQueue.global())

        input.viewWillApearEvent.subscribe(onNext: {
            
            output.name.onNext(self.name!)
            output.introduce.onNext(self.introduce ?? "")
            output.profileImage.onNext(self.beforeImage)
            
           
            
            
        }).disposed(by: disposeBag)
        
        
        
        input.addButtonTapped.subscribe(onNext: { _ in

   
            input.nameTextField.subscribe(onNext: { name in
                input.introduceTextField.subscribe(onNext: { introduce in
                    

                   
                    
                    input.profileImageValue.subscribe(onNext: { image in
                        
                        input.profileChange.subscribe(onNext: { change in
                            
                            print("\(change)")
                            guard let uuid = UserDefaults.standard.string(forKey: "uid") else {return}
                            
                            LoadingIndicator.showLoading()

                            
                            self.firebaseService.updateValues(name: name , introduce: introduce  , key: uuid , image : image , beforeImage: self.beforeImage ?? "" , profileChage: change ).subscribe(on: backgroundScheduler ).subscribe{ event in
                                switch(event){
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

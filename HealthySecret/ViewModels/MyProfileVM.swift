//
//  HomeVM.swift
//  HealthySecret
//
//  Created by 양승완 on 2023/11/28.
//

import Foundation
import RxCocoa
import RxSwift


class MyProfileVM : ViewModel {
    
    
    var disposeBag = DisposeBag()
    
    var name:String?
    var introduce:String?
    
    struct Input {
        let viewWillApearEvent : Observable<Void>
        let rightBarButton : Observable<Void>
        let changeProfile : Observable<UITapGestureRecognizer>
        
        let goalLabelTapped : Observable<UITapGestureRecognizer>

    }
    
    struct Output {
        var calorie = BehaviorSubject(value: "")
        var goalWeight = BehaviorSubject(value: "")
        var nowWeight = BehaviorSubject(value: "")
        var name = BehaviorSubject(value: "")
        var introduce = BehaviorSubject(value: "")
        
        
    }
  
 
    
    
    weak var coordinator : MyProfileCoordinator?
    
    private var firebaseService : FirebaseService
    
    init( coordinator : MyProfileCoordinator , firebaseService : FirebaseService ){
        self.coordinator =  coordinator
        self.firebaseService =  firebaseService
        
    }
    
    
    func transform(input: Input, disposeBag: DisposeBag ) -> Output {
        
        let id = UserDefaults.standard.string(forKey: "email") ?? ""
        
        let output = Output()
        
        
        
        input.goalLabelTapped.subscribe(onNext: { _ in
            print("goalLabelTapped")
            
            
        }).disposed(by: disposeBag)
        
        input.rightBarButton.subscribe(onNext: { _ in
            
            print("설정버튼")
            
            
        }).disposed(by: disposeBag)
        
        var nowUser : UserModel?

        
        input.viewWillApearEvent.subscribe(onNext: { [weak self] _ in
            self?.firebaseService.getDocument(key: id ).subscribe{ [weak self]
                event in
                switch(event){
                case.success(let user):
                    nowUser = user
                    output.introduce.onNext(user.introduce ?? "아직 소개글이 없어요")
                    output.goalWeight.onNext(String(user.goalWeight))
                    output.nowWeight.onNext(String(user.nowWeight))
                    output.calorie.onNext(String(user.calorie))
                    output.name.onNext(user.name)
                    
                 print("aa")
                    
                case .failure(_):
                    print("fail to get Doc")
                }
                
             
                
                
            }.disposed(by: disposeBag)
            
         
            
            
           
            
        }).disposed(by: disposeBag)
        
        
        input.changeProfile.when(.recognized).subscribe(onNext: { [weak self] _ in
            
            self?.coordinator?.pushChangeProfileVC(name: nowUser?.name ?? "" , introduce: nowUser?.introduce ?? "")
        }).disposed(by: disposeBag)
        
        return output
    }
    
    
    
    
    
    
    
    struct ChangeInput {
        let viewWillApearEvent : Observable<Void>
        let addButtonTapped : Observable<Void>
        let nameTextField : Observable<String>
        let introduceTextField : Observable<String>

    }
    
    struct ChageOutput {
        var name = BehaviorSubject<String>(value: "")
        var introduce = BehaviorSubject<String>(value: "")
        
        
    }
    
    
    
    func ChangeTransform(input: ChangeInput, disposeBag: DisposeBag ) -> ChageOutput {
        
        let output = ChageOutput()
        
        input.viewWillApearEvent.subscribe(onNext: {
            
            output.name.onNext(self.name!)
            output.introduce.onNext(self.introduce ?? "")
            
            
            
        }).disposed(by: disposeBag)
        
        
        input.addButtonTapped.subscribe(onNext: { _ in
            input.nameTextField.subscribe(onNext: { name in
                input.introduceTextField.subscribe(onNext: { introduce in
                    
                    self.firebaseService.updateValues(name: name , introduce: introduce  , key: UserDefaults.standard.string(forKey: "email") ?? "").subscribe{ event in
                        switch(event){
                        case.completed:
                            self.coordinator?.navigationController.popViewController(animated: false)
                        case.error(_):
                            print("error")
                        }
                        
                        
                        
                        
                    }.disposed(by: disposeBag)
                }).disposed(by: disposeBag)
                
                
                
                
            }).disposed(by: disposeBag)
        
            
            
            
        }).disposed(by: disposeBag)
        
        
        return output
    }

    
    
    
}

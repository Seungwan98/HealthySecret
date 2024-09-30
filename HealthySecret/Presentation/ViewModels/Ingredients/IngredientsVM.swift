//
//  IngredientsVM.swift
//  HealthySecret
//
//  Created by 양승완 on 2023/12/04.
//

import Foundation
import RxSwift
import RxCocoa

class IngredientsVM: ViewModel {
    
    weak var coordinator: IngredientsCoordinator?
    
    var disposeBag = DisposeBag()
    
    var firebaseService: FirebaseService
        
    var searchArr: [IngredientsModel] = []
    
    var filteredArr: [IngredientsModel] = []
    
//    var likes: [String: Int] = [:]
    
    var recentSearchArr: [String] = []
    
    var filteredNumbersArr: [String] = []
    
    var filteredIngredientsArr: [IngredientsModel] = []
    
    var realIndex: String?
    
    var lastArr: [IngredientsModel] = []
     
    
    
    private let ingredientsUseCase: IngredientsUseCase
    
    private let searchText = BehaviorRelay<Bool>(value: false)
    private let touchedArr = BehaviorRelay<[String: Int]>(value: [:])
    
    
    init( coordinator: IngredientsCoordinator, firebaseService: FirebaseService, ingredientsUseCase: IngredientsUseCase ) {
        self.coordinator =  coordinator
        self.firebaseService =  firebaseService
        self.ingredientsUseCase = ingredientsUseCase
    }
    
    let outputPushedCheck = PublishSubject<Bool>()
    
    private var test = PublishSubject<Bool>()
    func transform(input: Input, disposeBag: DisposeBag ) -> Output {
        
        let output = Output()
        
        
        
        input.likesInputArr.subscribe(onNext: { [weak self] likes in
            guard let self else {return}
            self.filteredArr = []

            _ = likes.map({ (key, value) in
                print("\(likes)")


                if let idx = self.searchArr.firstIndex(where: { $0.food_CD == key }) {
                    print("\(idx)idx")
                    if value == 1 {
                        
                        self.filteredNumbersArr.append(key)
                        
                        
                        self.filteredArr.append(self.searchArr[idx])
                        
                        
                    }
                }
            })
            
        }).disposed(by: disposeBag)
        

        
        
        input.cellTouchToDetail.subscribe(onNext: { model in
            
            self.coordinator?.pushIngredientsDetail(model: model)
            
            
        }).disposed(by: disposeBag)
        
        
        
        input.searchText.map({ [self] text in
            print("\(text)  text")
            var check: Bool = false
            if text.isEmpty {
                check = false
            } else {
                RequestFile.shared.getRequestData(text: text).subscribe({ single in
                    switch single {
                    case .success(let models):
                        self.searchArr = models
                        output.ingredientsArr.onNext(self.searchArr)
                        check = true
                    case .failure(let err):
                        print(err)
                    }
                    
                    
                }).disposed(by: disposeBag)
               
                
            }
            
            return check
        }).bind(to: output.checkController).disposed(by: disposeBag)
        
        self.rightButtonEvent.bind(to: output.rightButtonEnable).disposed(by: disposeBag)
        
        
        output.titleLabelTexts.onNext([UserDefaults.standard.string(forKey: "meal") ?? "", UserDefaults.standard.string(forKey: "date") ?? ""])
        
        
        
        
        
        
        input.rightButtonTapped.subscribe(onNext: {
            
            
            
//            
//            _ = self.likes.map({ (key, value) in
//                if value == 1 {
//                    self.filteredNumbersArr.append(key)
//                    
//                    if let idx = self.ingredientsArr.firstIndex(where: { $0.num == key }) {
//                        print("\(self.ingredientsArr[idx]) idx")
//                        self.filteredArr.append(self.ingredientsArr[idx])
//                    }
//                    
//                }
//            })
            
            self.filteredArr += self.lastArr
            
            
            
            
            self.coordinator?.finish()
            self.coordinator?.pushIngredientsVC(arr: self.filteredArr)
            
            
            
            
            
            
            
        }).disposed(by: disposeBag)
        
        
        
        
        
        return output
    }
    
    struct Input {
        let viewWillAppear: Observable<Void>
        let rightButtonTapped: Observable<Void>
        let searchText: Observable<String>
        let likesInputArr: Observable<[String: Int]>
        let cellTouchToDetail: Observable<IngredientsModel>
        
        
        
        
    }
    
    
    struct Output {
        var recentsearchArr = PublishSubject<[String]>()
        var ingredientsArr = PublishSubject<[IngredientsModel]>()
        var rightButtonEnable = PublishSubject<Bool>()
        var checkController =  PublishSubject<Bool>()
        var likesOutput = PublishSubject<[String: Int]>()
        var testOutput = PublishSubject<[String: Int]>()
        var reloadOutput = PublishSubject<Bool>()
        var titleLabelTexts = BehaviorSubject<[String]>(value: ["", ""])
        
        
        
        
        
    }
    
    
    
    private var index = BehaviorRelay<String>(value: "")
    private let rightButtonEvent = BehaviorRelay<Bool>(value: false)
    
    
    
  
    
    
}

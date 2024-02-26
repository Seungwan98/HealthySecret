//
//  IngredientsVM.swift
//  HealthySecret
//
//  Created by 양승완 on 2023/12/04.
//

import Foundation
import RxSwift
import RxCocoa

class IngredientsVM : ViewModel {
    
    weak var coordinator : IngredientsCoordinator?
    
    var disposeBag = DisposeBag()
    
    var firebaseService : FirebaseService
    
    var ingredientsArr : [Row] = []
    
    var searchArr : [Row] = []
    
    var filteredArr : [Row] = []
    
    var likes: [String:Int] = [:]
    
    var recentSearchArr : [String] = []
    
    var filteredNumbersArr : [String] = []
    
    var filteredIngredientsArr : [Row] = []
    
    var realIndex : String?
    
    var lastArr : [Row] = []
    
    
    
    
    private let searchText = BehaviorRelay<Bool>(value: false)
    private let touchedArr = BehaviorRelay<[String:Int]>(value: [:])
    
    
    init( coordinator : IngredientsCoordinator , firebaseService : FirebaseService ){
        self.coordinator =  coordinator
        self.firebaseService =  firebaseService
        
    }
    
    let outputPushedCheck = PublishSubject<Bool>()

    private var test = PublishSubject<Bool>()
    func transform(input: Input, disposeBag: DisposeBag ) -> Output {
        
        let output = Output()
        
        
        
       
        
        input.viewWillAppear.subscribe(onNext: { [self] in
                //  print("appear")
            
            self.firebaseService.getAllFromStore { [self]
                parsed in self.ingredientsArr = parsed
                
               
                
            }
            
            
            
            
            
     

            
            
            
//
//            if let userEmail = UserDefaults.standard.string(forKey: "email") {
//                self.firebaseService.getDocument(key: userEmail).subscribe( { event in
//
//                    switch event{
//                    case .success(let user):
//                        self.recentSearchArr = user.recentSearch ?? []
//                        output.recentsearchArr.onNext(self.recentSearchArr)
//
//
//
//
//
//
//                    case .failure(_):
//                        print("fail")
//
//                    }
//
//
//                }).disposed(by: disposeBag)
//
//            }
            
        }).disposed(by: disposeBag)
        
        
        
        input.cellTouchToDetail.subscribe(onNext : { row in
            self.coordinator?.pushIngredientsDetail(row: row)
            
            
        }).disposed(by: disposeBag)
        
        
        
        input.searchText.map({ [self] text in
          //  print("\(text) text")
            var check : Bool = false
            if text.isEmpty{
                check = false
            }else{
                self.searchArr = self.ingredientsArr.filter{ $0.descKor.localizedCaseInsensitiveContains(text) }
                output.ingredientsArr.onNext(self.searchArr)
                check = true

            }

            return check
        }).bind(to: output.checkController).disposed(by: disposeBag)
        
        self.rightButtonEvent.bind(to: output.rightButtonEnable).disposed(by: disposeBag)
        
   
        output.titleLabelTexts.onNext([UserDefaults.standard.string(forKey: "meal") ?? "" , UserDefaults.standard.string(forKey: "date") ?? ""])

      
        
        
        
        
        input.rightButtonTapped.subscribe(onNext: {
            
         
            let meal = UserDefaults.standard.string(forKey: "meal")
            let date = UserDefaults.standard.string(forKey: "date")
            let key = UserDefaults.standard.string(forKey: "email")


                    
            _ = self.likes.map({ (key , value) in
                    if value == 1 {
                        self.filteredNumbersArr.append(key)

                        if let idx = self.ingredientsArr.firstIndex(where: { $0.num == key }){
                            self.filteredArr.append(self.ingredientsArr[idx])
                        }

                    }
                })

            self.filteredArr += self.lastArr




            self.coordinator?.finish()
            self.coordinator?.pushIngredientsVC(arr: self.filteredArr)

//
//
//            self.firebaseService.addIngredients(meal: meal ?? "" , date: date ?? "" , key: key ?? "" , mealArr : self.filteredArr ).subscribe({
//                event in
//                switch event{
//                case.completed:
//                    self.coordinator?.backToDiaryVC()
//
//                case .error(_):
//                    print("error")
//                }
//
//
//
//            }).disposed(by: disposeBag)

                
            
        
            
        }).disposed(by: disposeBag)
        
        
     
        
        
        return output
    }
    
    struct Input {
        let viewWillAppear : Observable<Void>
        let rightButtonTapped : Observable<Void>
        let searchText : Observable<String>
        let likesInputArr : Observable<[String:Int]>
        let cellTouchToDetail : Observable<Row>
        
        
        
        
        
    }
    
    
    struct Output {
        var recentsearchArr = PublishSubject<[String]>()
        var ingredientsArr = PublishSubject<[Row]>()
        var rightButtonEnable = PublishSubject<Bool>()
        var checkController =  PublishSubject<Bool>()
        var likesOutput = PublishSubject<[String:Int]>()
        var testOutput = PublishSubject<[String:Int]>()
        var reloadOutput = PublishSubject<Bool>()
        var titleLabelTexts = BehaviorSubject<[String]>(value: ["",""])
        
        
        
        
        
    }
    
    
    
    private var index = BehaviorRelay<String>(value: "")
    private let rightButtonEvent = BehaviorRelay<Bool>(value: false)
    
    
    
    func cellTransform(input: CellInput , disposeBag : DisposeBag) -> CellOutput {
        let output = CellOutput()
        
    
        input.checkBoxTapped.subscribe(onNext: {
            input.idx.subscribe(onNext: {

                idx in

                
                print("touch \(idx)")

            if( self.likes[idx] == 1 ){
                self.likes[idx] = nil

                } else {

                    self.likes[idx] = 1

                }
                print(self.likes)






            }).disposed(by: disposeBag)


//
//            self.outputPushedCheck.onNext(true)
            
            
//            if( self.likes.isEmpty == false ){
//                
//                self.rightButtonEvent.accept(true)
//                
//            }
//            else{
//                self.rightButtonEvent.accept(false)
//            }
//            
//            
//            print(self.likes)
            
            
        }).disposed(by: disposeBag)
        
        
        return output
    }
    
    
    
    struct CellInput {
        let checkBoxTapped : Observable<Void>
        let idx : Observable<String>
    }
    struct CellOutput {
        let outputPushedCheck = BehaviorRelay<Bool>(value: false)
        
    }
    
    
    
}
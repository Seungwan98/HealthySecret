//
//  File.swift
//  HealthySecret
//
//  Created by 양승완 on 2023/11/11.
//

import Foundation
import Firebase
import FirebaseAuth
import FirebaseFirestore
import FirebaseStorage
import RxSwift
import RxCocoa

public enum FireStoreError: Error, LocalizedError {
    case unknown
    case decodeError
}



final class FirebaseService {
    
    
    let disposeBag = DisposeBag()
    
    let db =  Firestore.firestore()
    
    
    
    
    public func signOut() -> Completable {
        return Completable.create{ completable in
            if let res = try? Auth.auth().signOut() {
                completable(.completed)
            }
            else{
                completable(.error("error" as! Error))
            }
            
            
            return Disposables.create()
        }
        
        
        
        
    }
    
    public func signUp(email : String , pw : String) -> Completable {
        return Completable.create { completable in
            Auth.auth().createUser(withEmail : email, password: pw){  [weak self] res, error in
                guard self != nil else { return }
                
                if let error = error{
                    completable(.error(error))
                    return
                }else{
                    completable(.completed)
                    
                }
                
                
            }
            return Disposables.create()
            
        }
        
    }
    
    public func getCurrentUser() -> Single<User> {
        return Single.create { single in
            guard let currentUser = Auth.auth().currentUser else{
                single(.failure(FireStoreError.unknown))
                return Disposables.create()
            }
            single(.success(currentUser))
            return Disposables.create()
        }
    }
    
    public func signIn(email : String , pw : String) -> Completable {
        return Completable.create { completable in
            Auth.auth()
                .signIn(withEmail: email, password: pw){ [weak self] res, error in
                    guard self != nil else { return }
                    if let error = error {
                        // 에러가 났다면 여기서 처리
                        completable(.error(error))
                        return
                    } else {
                        // 로그인에 성공했다면 여기서 처리
                        completable(.completed)
                    }
                }
            
            
            return Disposables.create()
            
        }
        
        
    }
    
    func getDocument( key : String ) -> Single<UserModel> {
        return Single.create { [weak self] single in
            guard let self = self else { return Disposables.create() }
            
            
            self.db.collection("HealthySecretUsers").whereField( "id" , isEqualTo: key  ).getDocuments{ snapshot , error in
                if let error = error { single(.failure(error))}
                
                guard let snapshot = snapshot else {
                    single(.failure(error!))
                    return
                }
                let datas = snapshot.documents.compactMap { doc -> UserModel? in
                    do {
                        
                        let jsonData = try JSONSerialization.data(withJSONObject: doc.data(), options: [])
                        let creditCard = try JSONDecoder().decode(UserModel.self, from: jsonData)
                        return creditCard
                    } catch let error {
                        print("Error json parsing \(error)")
                        return nil
                    }
                }
                if let data = datas.first{
                    print("\(data)  exee") 
                    single(.success(data))
                    
                }
                
                
            }
            
            
            
            
            return Disposables.create()
        }
        
        
        
    }
    
    
    
    
    func createUsers(model : UserModel) -> Completable {
        return Completable.create{ completable in
            
            self.db.collection("HealthySecretUsers").document( model.id ).setData(model.dictionary!) {  err in
                if let err = err {
                    print(err)
                } else {
                    print("Success")
                    
                }
            }
            return Disposables.create()
            
        }
        
        
        
    }
    
    func updateIngredients(ingredients : [ingredients] , key : String) -> Completable{
        return Completable.create{ completable in
            
            let arr = ingredients.map({
                return $0.dictionary
            })
            
            self.db.collection("HealthySecretUsers").whereField("id", isEqualTo: key)
                .getDocuments() { (querySnapshot, err) in
                    if let err = err {
                        
                        print("error1")
                        
                        completable(.error(err))
                        // Some error occured
                    } else if querySnapshot!.documents.count != 1 {
                        print("error2")
                        
                        completable(.error(err!))
                        // Perhaps this is an error for you?
                    } else {
                        let document = querySnapshot?.documents.first!
                        document?.reference.updateData([
                            "ingredients" : arr
                        ])
                        
                        
                        completable(.completed)
                    }
                }
            
            
            
            return Disposables.create()
            
            
        }
        
        
    }
    
    
    
    func addIngredients( meal : String , date : String , key : String  , mealArr : [String] ) -> Completable {
        return Completable.create { completable in
            self.getDocument(key: key).subscribe( { event in
                
                switch event{
                    
                    
                    
                case .success(let user):
                    
                    var userIngredients  = user.ingredients
                    var userIngredient : ingredients?
                    
                    
                    var count = 0
                    userIngredients.forEach({
                        if($0.date == date){
                            userIngredient = $0
                            userIngredients.remove(at: count)
                            
                            
                        }
                        count += 1
                        
                        
                        
                    })
                    
                    if let _ = userIngredient {
                        switch meal{
                        case "아침식사":
                            
                            userIngredient?.morning! += mealArr
                        case "점심식사":
                            userIngredient?.lunch! += mealArr
                            
                        case "저녁식사":
                            userIngredient?.dinner! += mealArr
                        case "간식":
                            userIngredient?.snack! += mealArr
                            
                        default:
                            return
                        }
                        userIngredients.append(userIngredient!)
                        self.updateIngredients(ingredients: userIngredients ?? [], key: key).subscribe(
                            onCompleted: {
                                print("업데이트성공")
                                completable(.completed)
                            }
                        ).disposed(by: self.disposeBag)
                        
                        
                    }
                    else {
                        
                        var ingredient =  ingredients(date: date, morning: [], lunch: [], dinner: [] , snack: [])
                        
                        
                        
                        switch meal{
                        case "아침식사":
                            ingredient.morning! += mealArr
                            
                        case "점심식사":
                            ingredient.lunch! += mealArr
                        case "저녁식사":
                            ingredient.dinner! += mealArr
                        case "간식식사":
                            ingredient.dinner! += mealArr
                            
                        default:
                            return
                        }
                        userIngredients.append(ingredient)
                        print(userIngredients)
                        self.updateIngredients(ingredients: userIngredients ?? [], key: key).subscribe(
                            onCompleted: {
                                print("생성성공")
                                completable(.completed)
                            }
                        ).disposed(by: self.disposeBag)
                        
                        
                    }
    
                case .failure(_):
                    print("fail")
                    
                }
                
                
            }).disposed(by: self.disposeBag)
            
            
            return Disposables.create()
            
            
            
            
        }
        
        
        
        
        
    }
    
//    func setExercise( key : String , exercise : Exercise ) -> Completable {
//        return Completable.create{ completable in
//
//
//
//
//
//
//        }
//    }
//
//
//
    
    
    
    
    
    func getUsersIngredients( key : [String] ) -> Single<[Row]> {
        return Single.create { [weak self] single in
            guard let self = self else { return Disposables.create() }
            
            self.db.collection("HealthySecret").getDocuments{ snapshot , error in
                
                if let error = error { single(.failure(error))}
                
                guard let snapshot = snapshot else {
                    single(.failure(error!))
                    return
                }
                
                let datas = snapshot.documents.compactMap { doc -> IngredientsModel? in
                    do {
                        let jsonData = try JSONSerialization.data(withJSONObject: doc.data(), options: [])
                        let creditCard = try JSONDecoder().decode(IngredientsModel.self, from: jsonData)
                        return creditCard
                    } catch let error {
                        print("Error json parsing \(error)")
                        return nil
                    }
                    
                }
                
                var resultData : [Row] = []
                
                if let data : [Row] = datas.first?.row {
                    for value in data{
                        for k in key {
                            if k == value.num{
                                resultData.append(value)
                            }
                        }
                        
                        
                        
                        
                    }
                }
                
                single(.success(resultData))
                
                
                
                
            }
            
            
            
            
            return Disposables.create()
        }
    }
}









extension FirebaseService {
    
    
    
    
    func getAllFromStore(completionHandler: @escaping([Row]) -> () ) {
        db.collection("HealthySecret").getDocuments() { (querySnapshot , err) in
            var parsed : [Row] = []
            
            if let err = err {
                print("error : \(err)")
                
            } else {
                for document in querySnapshot!.documents{
                    do{
                        let jsonData = try JSONSerialization.data(withJSONObject: document.data() , options: [])
                        
                        
                        
                        let responseFile  = try JSONDecoder().decode(IngredientsModel.self, from: jsonData)
                        
                        parsed = responseFile.row
                        
                    }
                    catch let err {
                        print("Error \(err)")
                        return
                    }
                    
                }
                
                
            }
            
            completionHandler(parsed)
        }
        
    }
}


extension FirebaseService {
    
    
    
    func updateExercise(exercise : [Exercise] , key : String) -> Completable {
        return Completable.create{ completable in
            
            let exercise = exercise.map({
                $0.dictionary
                
            })
      
            
            self.db.collection("HealthySecretUsers").whereField("id", isEqualTo: key)
                .getDocuments() { (querySnapshot, err) in
                    if let err = err {

                        print("error1")

                        completable(.error(err))
                        // Some error occured
                    } else if querySnapshot!.documents.count != 1 {
                        print("error2")

                        completable(.error(err!))
                        // Perhaps this is an error for you?
                    } else {
                        let document = querySnapshot?.documents.first!
                        document?.reference.updateData([
                            "exercise" : exercise
                        ])


                        completable(.completed)
                    }
                }
            
            
            
            return Disposables.create()
            
            
        }
        
        
    }
    
    func getExercise() -> Single<ExerciseModel>{
        return Single.create { [weak self] single in
            guard let self = self else { return Disposables.create() }
            
            self.db.collection("HealthySecretExercises").getDocuments{ snapshot , error in
                
                if let error = error { single(.failure(error))}
                
                guard let snapshot = snapshot else {
                    single(.failure(error!))
                    return
                }
                
                let datas = snapshot.documents.compactMap { doc -> ExerciseModel? in
                    do {
                        let jsonData = try JSONSerialization.data(withJSONObject: doc.data(), options: [])
                        let creditCard = try JSONDecoder().decode(ExerciseModel.self, from: jsonData)
                        print("\(creditCard)  crediet")
                        single(.success(creditCard))
                        
                        return creditCard
                    } catch let error {
                        print("Error json parsing \(error)")
                        return nil
                    }
                    
                }
                
                
                
                
                
                
                
            }
            
            
            
            
            return Disposables.create()
        }
        
    }
    
}

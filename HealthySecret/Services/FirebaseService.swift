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
    
    
    func deleteAccount() -> Completable {
        return Completable.create{ completable in
            
            if  let user = Auth.auth().currentUser {
                
                self.signOut().subscribe{ event in
                    switch(event){
                    case.completed:
                        
                        user.delete { [weak self] error in
                            if let error = error {
                                print("Firebase Error : ",error)
                               
                            } else {
                                
                                self?.db.collection("HealthySecrets").document(String(describing: user.email)).delete() { err in
                                  if let err = err {
                                    print("Error removing document: \(err)")
                                      completable(.error(err))
                                  } else {
                                    print("Document successfully removed!")
                                      completable(.completed)
                                  }
                                }
                                
                                
                            }
                        }
                        
                        
                    case.error(let err):completable(.error(err))
                    }
                    
                    
                    
                }.disposed(by: self.disposeBag)
               
            } else {
                print("로그인 정보가 존재하지 않습니다")
            }
            
            return Disposables.create()
            
        }
            
        }
    
    
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
            print(currentUser.email)
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
                        print("로그인 성공")
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
                    completable(.error(err))
                    
                } else {
                    completable(.completed)
                    
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
                        document?.get("Ingredients")
                        document?.reference.updateData([
                            "ingredients" : arr
                        ])
                        
                        
                        completable(.completed)
                    }
                }
            
            
            
            return Disposables.create()
            
            
        }
        
        
    }
    
    
    
    
    
    func addIngredients( meal : String , date : String , key : String  , mealArr : [Row] ) -> Completable {
        return Completable.create { completable in
            self.getDocument(key: key).subscribe( { event in
                
                switch event{
                    
                    
                    
                case .success(let user):
                    
                    var userIngredients  = user.ingredients
                    var userIngredient = ingredients(date: date, morning: [], lunch: [], dinner: [] , snack: [])
                    
                    var count = 0
                    userIngredients.forEach({
                        if($0.date == date){
                            
                            
                            userIngredient = $0
                            userIngredients.remove(at: count)
                            
                        }
                        count += 1
                        
                        
                        
                    })
                    
                    
                    
                    switch meal{
                    case "아침식사":
                        
                        userIngredient.morning! = mealArr
                    case "점심식사":
                        userIngredient.lunch! = mealArr
                        
                    case "저녁식사":
                        userIngredient.dinner! = mealArr
                    case "간식":
                        userIngredient.snack! = mealArr
                        
                    default:
                        return
                    }
                    userIngredients.append(userIngredient)
                    
                    print("userIngredients")
                    self.updateIngredients(ingredients: userIngredients , key: key).subscribe(
                        onCompleted: {
                            completable(.completed)
                        }
                    ).disposed(by: self.disposeBag)
                    
                    
                    
                    
                    
                case .failure(_):
                    print("fail")
                    
                }
                
                
            }).disposed(by: self.disposeBag)
            
            
            return Disposables.create()
            
            
            
            
        }
        
        
        
        
        
    }
    
    
    
    
    
    
    func getUsersIngredients( key : [String] ) -> Single<[Row]> {
        return Single.create { [weak self] single in
            // guard let self = self else { return Disposables.create() }
            
            self?.db.collection("HealthySecret").getDocuments{ snapshot , error in
                
                if let error = error { single(.failure(error))}
                
                guard let snapshot = snapshot else {
                    single(.failure(error!))
                    return
                }
                
                let datas = snapshot.documents.compactMap { doc -> IngredientsDTO? in
                    do {
                        let jsonData = try JSONSerialization.data(withJSONObject: doc.data(), options: [])
                        let creditCard = try JSONDecoder().decode(IngredientsDTO.self, from: jsonData)
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
                _ = resultData.map({ String(lroundl(Double($0.kcal) ?? 0.0))})
                
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
                        
                        
                        
                        let responseFile  = try JSONDecoder().decode(IngredientsDTO.self, from: jsonData)
                        
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
    
    func addExercise(exercise : Exercise , key : String) -> Completable {
        return Completable.create{ completable in
            
            completable(.completed)
            let path = self.db.collection("HealthySecretUsers").document(String(key))
            
            path.updateData(["exercise" :FieldValue.arrayUnion([exercise.dictionary!])])
            return Disposables.create()
        }
        
    }
    
    func addDiary(diary : Diary , key : String) -> Completable {
        return Completable.create{ completable in
            
            completable(.completed)
            let path = self.db.collection("HealthySecretUsers").document(String(key))
            
            path.updateData(["diarys" :FieldValue.arrayUnion([diary.dictionary!])])
            return Disposables.create()
        }
        
    }
    
    func updateDiary(diary : [Diary] , key : String) -> Completable {
        return Completable.create{ completable in
            
            let diary = diary.map({
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
                            "diarys" : diary
                        ])
                        
                        
                        completable(.completed)
                    }
                }
            
            
            
            return Disposables.create()
            
            
        }
        
        
    }
    
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
    
    func getExercise() -> Single<ExerciseDTO>{
        return Single.create { [weak self] single in
            guard let self = self else { return Disposables.create() }
            
            self.db.collection("HealthySecretExercises").getDocuments{ snapshot , error in
                
                if let error = error { single(.failure(error))}
                
                guard let snapshot = snapshot else {
                    single(.failure(error!))
                    return
                }
                
                let datas = snapshot.documents.compactMap { doc -> ExerciseDTO? in
                    do {
                        let jsonData = try JSONSerialization.data(withJSONObject: doc.data(), options: [])
                        let creditCard = try JSONDecoder().decode(ExerciseDTO.self, from: jsonData)
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
extension FirebaseService {
    
    func updateSignUpData( model : UserModel , key : String ) -> Completable {
        return Completable.create{ completable in
            
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
                            "age" : model.age ,
                            "tall" : model.tall ,
                            "sex" : model.sex,
                            "goalWeight" : model.goalWeight,
                            "nowWeight" : model.nowWeight,
                            "calorie" : model.calorie,
                            "activity" : model.activity
                            
                        ])
                        completable(.completed)
                        
                    }
                    
                    
                    
                }
            
            
            
            return Disposables.create()
            
        }
        
        
    }
    
    func updateValues( name : String , introduce : String , key : String , image : UIImage? , beforeImage : String?) -> Completable {
        return Completable.create{ completable in
            
            
      
            
            
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
                        
                        var profileImage = ""
//                        switch event{
//                        case.success(let url):
//                            document?.reference.updateData([
//                                "name" : name ,
//                                "introduce" : introduce ,
//                                "profileImage" : url
//                            ])
//                        case .failure(): break
//                        }
                        self.uploadImage(image: image, pathRoot: UserDefaults.standard.string(forKey: "uid") ?? "" ).subscribe({ event in
                            switch event{
                                
                                
                            case .success(let url):
                                document?.reference.updateData([
                                                                "name" : name ,
                                                                "introduce" : introduce ,
                                                                "profileImage" : url
                                                            ])
                                completable(.completed)
                            case .failure(let err):
                                completable(.error(err))
                            }

                            
                        }).disposed(by: self.disposeBag)

                    }
                    

                    
                }
            
            self.deleteImage(urlString: beforeImage ?? "").subscribe{ [weak self] event in
                switch(event){
                    
                case .error(let err):
                    completable(.error(err))
                case .completed:
                    print("success")
                }
                
            }.disposed(by: self.disposeBag)

            return Disposables.create()

        }
        
    }
    
}


extension FirebaseService {
    func uploadImage(image: UIImage?, pathRoot: String ) -> Single<String> {
        return Single.create { single in
            guard let image = image else {
                single(.success(""))
                return Disposables.create()  }
            guard let imageData = image.jpegData(compressionQuality: 0.4) else {
                single(.success(""))
                return Disposables.create()}
            let metaData = StorageMetadata()
            metaData.contentType = "image/jpeg"
            
            let imageName = UUID().uuidString + String(Date().timeIntervalSince1970)
            
            let firebaseReference = Storage.storage().reference().child("\(imageName)")
            firebaseReference.putData(imageData, metadata: metaData) { metaData, error in
                firebaseReference.downloadURL { url, _ in
                    single(.success(url?.absoluteString ?? ""))
                }
            }
            return Disposables.create()
        }
    }
    
    
    
    
    func downloadImage(urlString: String) -> Single<Data?> {
        return Single.create { single in
            if urlString.isEmpty {
                single(.success(nil))
                return Disposables.create()
                
            }
            let storageReference = Storage.storage().reference(forURL: urlString)
            
            let megaByte = Int64(1 * 1024 * 1024)
            
            storageReference.getData(maxSize: megaByte) { data, error in
                guard let imageData = data else {
                    single(.success(nil))
                    
                    return
                }
                
                single(.success(imageData))
                
            }
            
            return Disposables.create()
            
        }
    }
    
    func deleteImage(urlString: String) -> Completable {
        return Completable.create { completable in
            if urlString.isEmpty {
                return Disposables.create()
                
            }
            let storageReference = Storage.storage().reference(forURL: urlString)
            
       
            storageReference.delete{ error in
                if let error = error{
                    
                    completable(.error(error))

                }else{
                    completable(.completed)

                }
                
            }
            
            
            return Disposables.create()
            
        }
    }
    
    
    
    
    
}

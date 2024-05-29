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

enum CustomError: Error {
    case isNil
    case freeze
    case delete
}

public enum FireStoreError: Error, LocalizedError {
    case unknown
    case decodeError
}



final class FirebaseService {
    
    var requestQuery: Query?
    var query: Query? = nil
    var listener : ListenerRegistration?
    
    
    
    let disposeBag = DisposeBag()
    
    let db =  Firestore.firestore()
    
    
    func getMessage(uid : String) -> Single<String>{
        return Single.create(){ single in
            print(uid)
            self.db.collection("HealthySecretStartMessages").document(uid).getDocument(completion: { doc,err in
                
                if let err = err {
                    
                    single(.failure(err))
                    
                }else{
                    
                    if let data = doc?.data(){
                        let outputData : String = data["report"] as! String
                        doc?.reference.delete()
                        single(.success(outputData))
                        
                        
                        
                    }else{
                        single(.failure(CustomError.isNil))
                        
                    }
                    
                    
                }
                
                
            })
            
            return Disposables.create()
        }
        
    }
    func deleteDatas(user : User) -> Completable {
        
        
        Completable.create(){ completable in
            
            let collection = self.db.collection("HealthySecretUsers")
            let uid = user.uid
            collection.document(uid).delete{ err in
                
                if let err = err {
                    completable(.error(err))
                }
            }
            collection.getDocuments{ snapshot , err  in
                if let err = err {
                    print("Error removing document: \(err)")
                    completable(.error(err))
                }
                guard let snapshot = snapshot else {return}
                
                for doc in snapshot.documents{
                    
                    doc.reference.updateData([
                        
                        "followings" : FieldValue.arrayRemove([uid]),
                        "followers" : FieldValue.arrayRemove([uid]),
                        "blocking" : FieldValue.arrayRemove([uid]),
                        "blocked" : FieldValue.arrayRemove([uid]),
                        
                        
                    ])
                    
                }
                
                
                
                
                
                self.db.collection("HealthySecretFeed").getDocuments{ snapshot , error in
                    if error != nil { return }
                    
                    guard let snapshot = snapshot else {
                        
                        return
                    }
                    
                    for doc in snapshot.documents{
                        var comentArr : [ComentDTO] = []
                        
                        
                        do {
                            
                            let jsonData = try JSONSerialization.data(withJSONObject: doc.data(), options: [])
                            let creditCard = try JSONDecoder().decode(FeedDTO.self, from: jsonData)
                            
                            print("deleteFeed \(creditCard.uuid) user  \(uid)")
                            
                            
                            if creditCard.uuid.elementsEqual( uid ) {
                                doc.reference.delete()
                            }
                            else{
                               
                                    for coment in creditCard.coments {
                                        if(coment.uid == uid){
                                            comentArr.append(coment)
                                        }
                                        
                                    }
                                    
                                
                                
                                doc.reference.updateData([
                                    
                                    "likes" : FieldValue.arrayRemove([uid]),
                                    "coments" : FieldValue.arrayRemove(comentArr)
                                    
                                ])
                                
                            }
                            
                            
                        } catch let error {
                            print("Error json parsing \(error)")
                        }
                        
                        
                    }
                    let storageReference = Storage.storage().reference().child("\(user.uid)")
                    
                    let lock = NSLock()
                    lock.lock()
                    print("lock \(uid)  \(user.uid)")
                    storageReference.listAll()  { refs ,err in
                        guard let refs = refs else {return}
                        for item in refs.items{
                            print("\(item.name) refsItems")
                            let ref = Storage.storage().reference().child("\(uid)/\(item.name)")
                            ref.delete{ _ in
                                
                            }
                            
                        }
                        
                        
                    }
                    print("completed")
                    completable(.completed)
                    
                    lock.unlock()
                    
                }
                
                
                completable(.completed)
                
            }
            return Disposables.create()
        }
    }
    
    func deleteAccount( auth : AuthCredential ) -> Completable {
        return Completable.create{ completable in
            if  let user = Auth.auth().currentUser {
                
                user.reauthenticate(with: auth){ result ,err in
                    self.signOut().subscribe{ event in
                        switch(event){
                        case.completed:
                            result?.user.delete { [weak self] error in
                                if let error = error {
                                    print("Firebase Error : ",error)
                                    
                                    
                                } else {
                                    print("user \(user)")
                                    self?.deleteDatas(user: user).subscribe({ event in
                                        switch(event){
                                        case.completed:
                                            
                                            
                                            completable(.completed)
                                        case .error(_):
                                            break
                                        }
                                        
                                    }).disposed(by: self!.disposeBag)
                                    
                                }
                            }
                            
                            
                        case.error(let err):
                            print(err)
                            completable(.error(err))
                        }
                        
                        
                        
                    }.disposed(by: self.disposeBag)
                    
                }
                
                
                
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
            single(.success(currentUser))
            return Disposables.create()
            
        }
    }
    
    public func signIn(email : String , pw : String) -> Completable {
        return Completable.create { completable in
            Auth.auth()
                .signIn(withEmail: email, password: pw){ [weak self] res, error in
                    guard let self = self else { return }
                    if let error = error {
                        // 에러가 났다면 여기서 처리
                        completable(.error(error))
                        return
                    } else {
                        guard let uid = res?.user.uid else {return completable(.error(CustomError.isNil))}
                        print("로그인 성공")
                        UserDefaults.standard.setValue(uid , forKey: "uid")
                        
                        self.getDocument(key: uid).subscribe({ event in
                            switch(event){
                            case(.success(let user)):
                                if( CustomFormatter.shared.dateCompare(targetString: user.freezeDate ?? "")  ) {
                                    completable(.completed)
                                    
                                    
                                }else{
                                    completable(.error(CustomError.freeze))
                                }
                            case(.failure(let err)):
                                completable(.error(err))
                                
                                
                                
                                
                            }
                            
                            
                        }).disposed(by: self.disposeBag)
                        
                        
                        
                        completable(.completed)
                    }
                }
            
            
            return Disposables.create()
            
        }
        
        
    }
    
    func signInCredential(credential :AuthCredential) -> Completable{
        
        return Completable.create { completable in
            
            
            
            Auth.auth().signIn(with: credential) { authResult, error in
                if let error = error {
                    print("Error Apple sign in: \(error.localizedDescription)")
                    
                    return
                }
                
                
                guard let authUser = authResult?.user else { return }
                
                UserDefaults.standard.set(authUser.email, forKey: "email")
                UserDefaults.standard.set( authUser.uid  , forKey: "uid")
                
                
                
                
                self.getDocument(key: authUser.uid ).subscribe({ event in
                    switch(event){
                    case(.success(let user)):
                        if( CustomFormatter.shared.dateCompare(targetString: user.freezeDate ?? "")  ) {
                            completable(.completed)
                            
                            
                        }else{
                            completable(.error(CustomError.freeze))
                        }
                    case(.failure(let err)):
                        completable(.error(err))
                        
                        
                        
                        
                    }
                    
                    
                }).disposed(by: self.disposeBag)
            }
            return Disposables.create()
        }
    }
    
    func getDocument( key : String ) -> Single<UserModel> {
        return Single.create { [weak self] single in
            
            
            
            self?.db.collection("HealthySecretUsers").document(key).getDocument{ doc , err in
                if let err = err { single(.failure(err))}
                
                
                
                
                
                if let data = doc?.data() {
                    do {
                        
                        let jsonData = try JSONSerialization.data(withJSONObject: data, options: [])
                        let creditCard = try JSONDecoder().decode(UserModel.self, from: jsonData)
                        
                        single(.success(creditCard))
                        
                    } catch let error {
                        print("Error json parsing \(error)")
                        single(.failure(CustomError.isNil))
                        
                    }
                }else{
                    single(.failure(CustomError.isNil))
                }
                
                
            }
            
            
            
            
            return Disposables.create()
        }
        
        
        
    }
    
    
    
    
    func createUsers(model : UserModel) -> Completable {
        return Completable.create{ completable in
            
            self.db.collection("HealthySecretUsers").document( model.uuid ).setData(model.dictionary!) {  err in
                if let err = err {
                    completable(.error(err))
                    
                } else {
                    completable(.completed)
                    
                }
            }
            return Disposables.create()
            
        }
        
        
        
    }
    
    
    
    
    
    
    
    
}






extension FirebaseService {
    
    
    
    
    func getIngredientsList() -> Single<[Row]> {
        Single.create{ [weak self] single in guard let self = self else {return Disposables.create()}
            self.db.collection("HealthySecret").getDocuments() { (querySnapshot , err) in
                var list : [Row] = []
                
                if let err = err {
                    single(.failure(err))
                    
                    
                } else {
                    for document in querySnapshot!.documents{
                        do{
                            let jsonData = try JSONSerialization.data(withJSONObject: document.data() , options: [])
                            
                            
                            
                            let responseFile  = try JSONDecoder().decode(IngredientsDTO.self, from: jsonData)
                            
                            list = responseFile.row
                            single(.success(list))
                            
                        }
                        catch let err {
                            print("Error \(err)")
                            single(.failure(err))
                            
                            return
                        }
                        
                    }
                    
                    
                }
                
            }
            
            return Disposables.create()
        }
        
    }
    
    
    
    func getExercisesList() -> Single<ExerciseDTO>{
        return Single.create { [weak self] single in
            guard let self = self else { return Disposables.create() }
            
            self.db.collection("HealthySecretExercises").getDocuments{ snapshot , error in
                
                if let error = error { single(.failure(error))}
                
                guard let snapshot = snapshot else {
                    single(.failure(error!))
                    return
                }
                
                _ = snapshot.documents.compactMap { doc -> ExerciseDTO? in
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
    
    
    
    func addDiary(diary : Diary , key : String) -> Completable {
        return Completable.create{ completable in
            
            completable(.completed)
            let path = self.db.collection("HealthySecretUsers").document(key)
            
            path.updateData(["diarys" :FieldValue.arrayUnion([diary.dictionary!])])
            return Disposables.create()
        }
        
    }
    
    
    func updateIngredients(ingredients : [Ingredients] , key : String) -> Completable{
        return Completable.create{ completable in
            
            let arr = ingredients.map({
                return $0.dictionary
            })
            
            self.db.collection("HealthySecretUsers").document(key).getDocument{ doc, err in
                
                if let err = err{
                    completable(.error(err))
                }
                else{
                    doc?.reference.updateData([
                        "ingredients" : arr
                    ])
                    completable(.completed)
                    
                }
            }
            
            
            
            return Disposables.create()
            
            
        }
        
        
    }
    
    
    func updateExercises(exercise : [ExerciseModel] , key : String) -> Completable {
        return Completable.create{ completable in
            
            let exercise = exercise.map({
                $0.dictionary
                
            })
            
            
            self.db.collection("HealthySecretUsers").document(key).getDocument { (doc, err) in
                if let err = err {
                    
                    print("error1")
                    
                    completable(.error(err))
                    // Some error occured
                }  else {
                    
                    doc?.reference.updateData([
                        "exercise" : exercise
                    ])
                    
                    
                    completable(.completed)
                }
            }
            
            
            
            return Disposables.create()
            
            
        }
        
        
    }
    
    
    
    func updateDiary(diary : [Diary] , key : String) -> Completable {
        return Completable.create{ completable in
            
            let diary = diary.map({
                $0.dictionary
                
            })
            
            
            self.db.collection("HealthySecretUsers").document(key).getDocument { (doc, err) in
                if let err = err {
                    
                    print("error1")
                    
                    completable(.error(err))
                    // Some error occured
                    
                }
                else {
                    guard let doc = doc else { return }
                    doc.reference.updateData([
                        "diarys" : diary
                    ])
                    
                    
                    completable(.completed)
                }
            }
            
            
            
            return Disposables.create()
            
            
        }
        
        
    }
    
}

extension FirebaseService {
    
    func updateSignUpData( model : UserModel , key : String ) -> Completable {
        return Completable.create{ completable in
            
            self.db.collection("HealthySecretUsers").document(key).getDocument() { (doc, err) in
                
                if let err = err {
                    
                    print("error1")
                    
                    completable(.error(err))
                    // Some error occured
                }
                else {
                    
                    doc?.reference.updateData([
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
    
    
    func updateValues( name : String , introduce : String , key : String , image : UIImage? , beforeImage : String? , profileChage : Bool) -> Completable {
        
        
        
        
        
        return Completable.create{ completable in
            
            print("update Values")
            
            
            
            self.db.collection("HealthySecretUsers").document(key).getDocument() { (doc, err) in
                
                if let err = err {
                    
                    print("error1")
                    
                    completable(.error(err))
                    // Some error occured
                } else {
                    
                    
                    
                    doc?.reference.updateData([
                        "name" : name ,
                        "introduce" : introduce ,
                        
                        
                    ])
                    
                    
                    
                    if(profileChage){
                        
                        self.uploadImage(image: image, pathRoot: UserDefaults.standard.string(forKey: "uid") ?? ""+"profile").subscribe({ event in
                            switch event{
                                
                                
                            case .success(let url):
                                
                                
                                doc?.reference.updateData([
                                    
                                    "profileImage" : url
                                    
                                ])
                                completable(.completed)
                                
                                
                                
                            case .failure(let err):
                                completable(.error(err))
                            }
                            
                            
                        }).disposed(by: self.disposeBag)
                        
                        if !((beforeImage ?? "").isEmpty){ self.deleteImage(urlString: beforeImage ?? "").subscribe{ [weak self] event in
                            guard let self = self else {return}
                            switch(event){
                                
                            case .error(_):
                                print("이미지없음")
                            case .completed:
                                print("success")
                            }
                            
                        }.disposed(by: self.disposeBag)
                            
                            
                            
                            print("fireStore upload")
                            
                        }
                        
                    }else{
                        completable(.completed)
                        
                    }
                    
                    
                    
                }
                
                
                
                
                
                
                
                
            }
            return Disposables.create()
            
        }
    }
    
    
    func updateFollowers(  ownUid : String , opponentUid : String  , follow : Bool) -> Completable {
        return Completable.create{ completable in
            
            print("\(ownUid) , \(opponentUid) , \(follow)")
            self.db.collection("HealthySecretUsers").document(ownUid).getDocument{ doc , err in
                if let err = err {
                    completable(.error(err))
                }else{
                    
                    if(follow){
                        doc?.reference.updateData([
                            
                            "followings" : FieldValue.arrayUnion([opponentUid])
                            
                        ])}
                    else{
                        
                        doc?.reference.updateData([
                            
                            "followings" : FieldValue.arrayRemove([opponentUid])
                            
                        ])
                    }
                    
                    
                }
                
                self.db.collection("HealthySecretUsers").document(opponentUid).getDocument{ doc , err in
                    if let err = err {
                        completable(.error(err))
                    }else{
                        
                        if(follow){
                            doc?.reference.updateData([
                                
                                "followers" : FieldValue.arrayUnion([ownUid])
                                
                            ])}
                        else{
                            
                            doc?.reference.updateData([
                                
                                "followers" : FieldValue.arrayRemove([ownUid])
                                
                            ])
                            
                            
                        }
                        
                        completable(.completed)
                    }
                    
                    
                    
                    
                }
                
                
                
                
            }
            
            
            
            return Disposables.create()
        }
        
    }
    
    func report(url : String , uid : String  , uuid : String , event : String) -> Completable{
        return Completable.create{ completable in
            
            self.db.collection(url).document(uid).getDocument{ doc , err in
                if let err = err {
                    completable(.error(err))
                }else{
                    
                    if(event == "feed"){
                        doc?.reference.updateData([
                            
                            "report" : FieldValue.arrayUnion([uuid])
                            
                        ])
                        
                        let report = doc?.get("report") as! [String]
                        if(report.count >= 5){
                            
                            
                            self.db.collection("HealthySecretStartMessages").document(uuid).setData(["report":"신고 누적으로 피드가 삭제 되었습니다"])
                            
                            
                            
                        }
                        
                        
                        completable(.completed)
                        
                    }
                    else if(event == "coment"){
                        if(doc?.data() != nil){
                            doc?.reference.updateData([
                                
                                "report" : FieldValue.arrayUnion([uuid])
                                
                            ])
                            
                            let report = doc?.get("report") as! [String]
                            if(report.count >= 5){
                                
                                doc?.reference.delete()
                                
                                self.db.collection("HealthySecretStartMessages").document(uuid).setData(["report":"신고 누적으로 댓글이 삭제 되었습니다"])
                                
                                
                                completable(.error(CustomError.delete))
                                
                                
                                
                            }
                        }else{
                            doc?.reference.setData(["report":[uuid]])
                        }
                        
                        
                        completable(.completed)
                        
                        
                        
                    }else if(event == "user"){
                        
                        doc?.reference.updateData([
                            
                            "report" : FieldValue.arrayUnion([uuid])
                            
                        ])
                        
                        
                        
                        if let report = doc?.get("report") as? [String] {
                            if(report.count >= 5){
                                
                                
                                
                                doc?.reference.updateData([
                                    
                                    
                                    "freezeDate" :  CustomFormatter.shared.DateToString(date: Calendar.current.date(byAdding: .month, value: +1, to: Date() )!)
                                    
                                    
                                ])
                            }
                            
                            completable(.completed)
                            
                            
                        }
                    }
                    else{
                        completable(.error(CustomError.isNil))
                        
                    }
                }
                
            }
            
            
            
            
            return Disposables.create()
            
            
        }
        
        
        
        
        
    }
    
    func blockUser(ownUid : String , opponentUid : String  , block : Bool) -> Completable {
        return Completable.create{ completable in
            
            self.db.collection("HealthySecretUsers").document(ownUid).getDocument{ doc , err in
                if let err = err {
                    completable(.error(err))
                }else{
                    
                    if(block){
                        doc?.reference.updateData([
                            
                            "blocking" : FieldValue.arrayUnion([opponentUid]),
                            "followings" : FieldValue.arrayRemove([opponentUid]),
                            "followers" : FieldValue.arrayRemove([opponentUid]),
                            
                        ])
                        
                        
                        self.db.collection("HealthySecretUsers").document(opponentUid).getDocument{ doc , err in
                            if let err = err {
                                completable(.error(err))
                            }else{
                                
                                
                                doc?.reference.updateData([
                                    
                                    "blocked" : FieldValue.arrayUnion([ownUid]),
                                    "followings" : FieldValue.arrayRemove([ownUid]),
                                    "followers" : FieldValue.arrayRemove([ownUid]),
                                ])
                                
                                
                                
                                
                                completable(.completed)
                            }
                            
                            
                            
                            
                        }
                    }else{
                        
                        doc?.reference.updateData([
                            
                            "blocking" : FieldValue.arrayRemove([opponentUid]),
                            
                            
                        ])
                        
                        
                        self.db.collection("HealthySecretUsers").document(opponentUid).getDocument{ doc , err in
                            if let err = err {
                                completable(.error(err))
                            }else{
                                
                                
                                doc?.reference.updateData([
                                    
                                    "blocked" : FieldValue.arrayRemove([ownUid]),
                                    
                                ])
                                
                                
                                
                                
                                completable(.completed)
                            }
                            
                            
                            
                            
                        }
                        
                    }
                    
                    
                }
                
                
                
                
                
                
            }
            
            
            
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
            guard let imageData = image.jpegData(compressionQuality: 0.1) else {
                single(.success(""))
                return Disposables.create()}
            let metaData = StorageMetadata()
            metaData.contentType = "image/jpeg"
            let imageName = UUID().uuidString + String(Date().timeIntervalSince1970)
            
            let firebaseReference = Storage.storage().reference().child("\(pathRoot)/\(imageName)")
            
            
            firebaseReference.putData(imageData, metadata: metaData) { metaData, error in
                firebaseReference.downloadURL { url, _ in
                    single(.success(url?.absoluteString ?? ""))
                }
            }
            
            return Disposables.create()
        }
    }
    
    
    
    func deleteImage( urlString: String) -> Completable {
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
    
    
    
    
    func downloadAll(urlString: String) -> BehaviorSubject<[String:Data]?> {
        
        
        //            if urlString.isEmpty {
        //                single(.success(nil))
        //
        //            }
        
        
        let megaByte = Int64(1 * 1024 * 1024)
        let storageReference = Storage.storage().reference()
        let ob = BehaviorSubject<[String:Data]?>(value: nil)
        
        
        storageReference.child("\(urlString)/").listAll{ ( result, error ) in
            
            var index = 0
            
            var items : [StorageReference] = []
            
            if let error = error{
                print("error \(error)")
                
            }else{
                
                print("아이템 들어간당")
                
                items  = result!.items
                var resultArr:[String:Data] = [:]
                
                
                
                for i in 0..<items.count {
                    
                    items[i].getData(maxSize: megaByte) { data, error in
                        
                        guard data != nil else {
                            
                            return
                        }
                        resultArr.updateValue(data!, forKey: items[i].name)
                        
                        
                        
                        
                        
                        
                        
                        if(result!.items.count-1 == index){
                            print("onNext")
                            ob.onNext(resultArr)
                            
                            
                        }
                        index += 1
                        
                        
                    }
                }
            }
            
            print("언제?")
            
            
        }
        print("first")
        
        
        
        
        
        
        return ob
        
        
    }
    
    
    
    func updateFeed( feed : FeedModel) -> Completable {
        return Completable.create{ completable in
            self.db.collection("HealthySecretFeed").document(feed.feedUid).getDocument{ doc , err in
                if let err = err {
                    completable(.error(err))
                }else{
                    
                    doc?.reference.updateData([
                        "contents" : feed.contents ,
                        "mainImgUrl" :  feed.mainImgUrl
                        
                    ])}
                
                completable(.completed)
                
                
                
                
                
            }
            
            
            
            return Disposables.create()
        }
        
    }
    
    func addFeed(feed : FeedDTO) -> Completable {
        return Completable.create{ completable in
            
            self.db.collection("HealthySecretFeed").document( feed.feedUid ).setData(feed.dictionary!) {  err in
                if let err = err {
                    completable(.error(err))
                    
                } else {
                    completable(.completed)
                    
                }
            }
            return Disposables.create()
            
        }
        
        
        
    }
    
    
    func updateFeedLikes( feedUid : String , uuid : String  , like : Bool) -> Completable {
        return Completable.create{ completable in
            self.db.collection("HealthySecretFeed").document(feedUid).getDocument{ doc , err in
                if let err = err {
                    completable(.error(err))
                }else{
                    
                    if(like){
                        doc?.reference.updateData([
                            
                            "likes" : FieldValue.arrayUnion([uuid])
                            
                        ])}
                    else{
                        
                        doc?.reference.updateData([
                            
                            "likes" : FieldValue.arrayRemove([uuid])
                            
                        ])
                    }
                    completable(.completed)
                    
                    
                }
                
                
            }
            
            
            
            return Disposables.create()
        }
        
    }
    
    
    
    func getAllFeeds() -> Single<[FeedDTO]>{
        return Single.create{ single in
            
            
            var feedModels : [FeedDTO] = []
            
            self.db.collection("HealthySecretFeed").order(by: "date" , descending: true ).getDocuments() { (querySnapshot, err) in
                if let err = err {
                    
                    print("Error getting documents: \(err)")
                    single(.failure(err))
                    
                } else {
                    
                    for doc in querySnapshot!.documents {
                        
                        
                        do {
                            
                            let jsonData = try JSONSerialization.data(withJSONObject: doc.data(), options: [])
                            let feed = try JSONDecoder().decode(FeedDTO.self, from: jsonData)
                            
                            feedModels.append(feed)
                            
                            
                        } catch let error {
                            print("Error json parsing \(error)")
                            
                        }
                    }
                    
                    single(.success(feedModels))
                    
                }
                
            }
            
            return Disposables.create()
            
        }
        
    }
    
    
    
    
    
    
    
    
    func getFeedPagination(feeds:[FeedDTO] , pagesCount : Int , follow : [String] , getFollow : Bool , followCount : Int , block : [String]) -> Single<[FeedDTO]> {
        return Single<[FeedDTO]>.create { [weak self] single in
            guard let self = self else {return Disposables.create()}
            var newFeeds : [FeedDTO] = []
            let lastFeeds : [FeedDTO] = feeds
            var followCount = followCount
            
            print("getFeedPagination")
            if let query = self.query {
                //There is last query
                self.requestQuery = query
                print("last Q")
            } else {
                //It's First query request
                self.requestQuery = self.db.collection("HealthySecretFeed")
                    .order(by: "date" , descending: true )
                    .limit(to: pagesCount)
            }
            
            self.requestQuery?.getDocuments{ [weak self] (snapshot, error) in
                
                guard let self = self else { return }
                print("nniill")
                guard let snapshot = snapshot,
                      let lastDocument = snapshot.documents.last else {
                    single(.failure(CustomError.isNil))
                    
                    return
                }
                
                let next = self.db.collection("HealthySecretFeed")
                    .order(by: "date" , descending: true)
                    .limit(to: pagesCount)
                    .start(afterDocument: lastDocument)
                
                //Set next query
                self.query = next
                
                
                
                
                _ = snapshot.documents.map({ document in
                    
                    do {
                        let feedModel = try document.data(as: FeedDTO.self)
                        
                        if(getFollow){
                            
                            if(follow.contains(feedModel.uuid) && !block.contains(feedModel.uuid)) {
                                newFeeds.append(feedModel)
                                followCount += 1
                            }
                        }else if(!block.contains(feedModel.uuid)){
                            
                            newFeeds.append(feedModel)
                            followCount += 1
                        }
                        
                        
                    } catch {
                        
                        single(.failure(CustomError.isNil))
                    }
                })
                
                var idx = 0
                var totalFeeds = lastFeeds + newFeeds
                
                
                if(followCount < 4 || getFollow ) {
                    getFeedPagination(feeds: totalFeeds , pagesCount: 4, follow: follow , getFollow: getFollow , followCount: followCount, block: block ).subscribe({ event in
                        switch(event){
                            
                        case.success(let feeds):
                            
                            print("success")
                            
                            single(.success(feeds))
                        case.failure(let err):
                            if(err as! CustomError == CustomError.isNil){
                                
                                if(totalFeeds.count == 0 ){
                                    single(.failure(CustomError.isNil))
                                }
                                
                                single(.success(totalFeeds))
                                
                            }
                        }
                        
                        
                    }).disposed(by: disposeBag)
                    
                }else{
                    
                    print("else")
                    
                    
                    
                    
                    single(.success(totalFeeds))
                    
                    
                    
                    
                    
                }
                
                
                
                
                
                
                
                
            }
            print("why")
            
            return Disposables.create()
        }
        
    }
    
    
    
    
    
    func getFeedFeedUid(feedUid : String) -> Single<FeedModel>{
        return Single.create { single in
            
            self.db.collection("HealthySecretFeed").document(feedUid).getDocument{ [weak self] doc,err in
                if let err = err{
                    single(.failure(err))
                }else{
                    if let data = doc?.data() {
                        do{
                            let jsonData = try JSONSerialization.data(withJSONObject: data, options: [])
                            var feed = try JSONDecoder().decode(FeedDTO.self, from: jsonData)
                            //리팩
                            //                            self?.getDocument(key: feed.uuid).subscribe({ event in
                            //                                print("getDoc")
                            //                                switch(event){
                            //                                case.success(let user):
                            //                                    feed.profileImage = user.profileImage
                            //                                    feed.nickname = user.name
                            //
                            //
                            //                                    single(.success(feed))
                            //
                            //
                            //
                            //                                case .failure(let err):
                            //                                    print(err)
                            //                                }
                            //
                            //
                            //                            }).disposed(by: self!.disposeBag )
                            
                        }catch{
                            
                            single(.failure(CustomError.isNil))
                        }
                        
                    }
                }
                
                
            }
            
            
            
            
            
            return Disposables.create()
        }
        
    }
    
    
    
    func getFeedsUid( uid : String ) -> Single<[FeedDTO]>{
        return Single.create{ single in
            
            
            var feedModels : [FeedDTO] = []
            self.db.collection("HealthySecretFeed").whereField("uuid", isEqualTo: uid).order(by: "date" , descending: true ).getDocuments() { (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                    single(.failure(err))
                } else {
                    
                    for doc in querySnapshot!.documents {
                        
                        
                        do {
                            let jsonData = try JSONSerialization.data(withJSONObject: doc.data(), options: [])
                            let feed = try JSONDecoder().decode(FeedDTO.self, from: jsonData)
                            
                            
                            feedModels.append(feed)
                            
                            
                        } catch let error {
                            print("Error json parsing \(error)")
                            
                        }
                    }
                    single(.success(feedModels))
                    
                }
                
            }
            
            return Disposables.create()
            
        }
        
    }
    
    func deleteFeed(feedUid:String) -> Completable {
        return Completable.create{ completable in
            
            self.db.collection("HealthySecretFeed").document(feedUid).delete() { err in
                if let err = err {
                    print("Error removing document: \(err)")
                    completable(.error(err))
                } else {
                    print("Document successfully removed!")
                    
                    completable(.completed)
                }
            }
            
            
            
            
            
            return Disposables.create()
        }
        
        
    }
    
    
    
    
    
    
    
}


extension FirebaseService {
    
    //댓글 수정 삭제
    
    
    func deleteComents(  coment : ComentDTO , feedUid : String ) -> Single<[ComentDTO]> {
        return Single.create{ single in
            
            
            
            
            
            
            self.listener = self.db.collection("HealthySecretFeed").whereField("feedUid", isEqualTo: feedUid).addSnapshotListener{  [weak self]  querySnapshot, error in
                guard let self = self else  {return}
                guard let snapshot = querySnapshot else {
                    print("Error fetching snapshots: \(error!)")
                    return
                }
                
                
                snapshot.documentChanges.forEach { diff in
                    
                    
                    print("\(diff) diff")
                    var idx = 0
                    if (diff.type == .modified) {
                        //document 안에있는 Arr 안의 데이터를 삭제하므로 modified 를 찾는다.
                        
                        do{
                            let jsonData = try JSONSerialization.data(withJSONObject: diff.document.data(), options: [])
                            let feed = try JSONDecoder().decode(FeedDTO.self, from: jsonData)
                            
                          
                                if(feed.coments.isEmpty){
                                    single(.success([]))
                                }
                            var outputComents = feed.coments
                                
                                for i in 0..<feed.coments.count{
                                    
                                    
                                    
                                    //리팩
                                    //                                    self.getDocument(key: outputComents[i].uid).subscribe({ event in
                                    //                                        print("getDoc")
                                    //                                        switch(event){
                                    //                                        case.success(let user):
                                    //
                                    //                                            outputComents[i].profileImage = user.profileImage
                                    //                                            outputComents[i].nickname = user.name
                                    //
                                    //
                                    //                                            if( idx+1 >= outputComents.count){
                                    //
                                    //
                                    //                                                single(.success(outputComents))
                                    //
                                    //
                                    //                                            }else{
                                    //                                                idx += 1
                                    //                                            }
                                    //
                                    //
                                    //
                                    //                                        case .failure(let err):
                                    //                                            print(err)
                                    //                                        }
                                    //
                                    //
                                    //                                    }).disposed(by: self.disposeBag )
                                    
                                    
                                    
                                    
                                }
                          
                            
                            
                        }
                        catch{
                            single(.failure(CustomError.isNil))
                            
                        }
                        
                    } else {
                        print("else")
                        
                        if let coment = coment.dictionary {
                            diff.document .reference.updateData([
                                
                                "coments" : FieldValue.arrayRemove([coment])
                                
                            ])
                        }
                        
                    }
                    
                }
                
                
                
                
                
            }
            
            
            return Disposables.create()
        }
        
        
    }
    
    
    
    func updateComents( feedUid : String , coment : ComentDTO  ) -> Single<[ComentDTO]> {
        return Single.create{ [weak self] single in
            guard let self = self else { return Disposables.create()}
            self.listener = self.db.collection("HealthySecretFeed").whereField("feedUid", isEqualTo: feedUid).addSnapshotListener{  querySnapshot, error in
                guard let snapshot = querySnapshot else {
                    print("Error fetching snapshots: \(error!)")
                    return
                }
                
                
                snapshot.documentChanges.forEach { diff in
                    
                    
                    
                    if (diff.type == .modified) {
                        //document 안에있는 Arr 안의 데이터를 추가하므로 modified 를 찾는다.
                        
                        do{
                            let jsonData = try JSONSerialization.data(withJSONObject: diff.document.data(), options: [])
                            let feed = try JSONDecoder().decode(FeedDTO.self, from: jsonData)
                            
                            
                            
                            var coments = feed.coments
                            var index = 0
                            for i in 0..<coments.count {
                                
                                //리팩
                                //                                self.getDocument(key: coments[i].uid ).subscribe({ event in
                                //
                                //                                    switch(event){
                                //                                    case.success(let user):
                                //
                                //
                                //                                        coments[i].profileImage = user.profileImage ?? ""
                                //                                        coments[i].nickname = user.name
                                //
                                //                                        if(index + 1 >= coments.count){
                                //                                            single(.success(coments))
                                //                                        }else{
                                //                                            index += 1
                                //                                        }
                                //
                                //
                                //
                                //
                                //                                    case .failure(_):
                                //                                        single(.failure(CustomError.isNil))
                                //                                    }
                                //
                                //
                                //
                                //                                }).disposed(by: self.disposeBag)
                                
                            }
                            
                            
                            
                        }
                        catch{
                            single(.failure(CustomError.isNil))
                            
                        }
                        
                    } else {
                        
                        
                        if let coment = coment.dictionary {
                            diff.document .reference.updateData([
                                
                                "coments" : FieldValue.arrayUnion([coment])
                                
                            ])
                        }
                        
                    }
                    
                }
                
                
                
                
                
            }
            
            
            
            
            
            
            
            return Disposables.create()
        }
        
    }
    
    func getComents(feedUid : String) -> Single<[ComentDTO]>{
        return Single.create{ [weak self] single in
            
            guard let self = self else {return Disposables.create()}
            
            self.db.collection("HealthySecretFeed").document(feedUid).getDocument{ doc , err in
                
                if let err = err {
                    single(.failure(err))
                }else{
                    guard let data = doc?.data() else {return}
                    do{
                        let jsonData = try JSONSerialization.data(withJSONObject: data , options: [])
                        let feed = try JSONDecoder().decode(FeedDTO.self, from: jsonData)
                        
                        
                        var coments = feed.coments ?? []
                        var index = 0
                        
                        if(coments.isEmpty){
                            single(.success(coments))
                            
                        }else{
                            
                            for i in 0..<coments.count {
                                
                                
                                //리팩
                                //                                self.getDocument(key: coments[i].uid ).subscribe({ event in
                                //
                                //                                    switch(event){
                                //                                    case.success(let user):
                                //
                                //
                                //                                        coments[i].profileImage = user.profileImage ?? ""
                                //                                        coments[i].nickname = user.name
                                //
                                //                                        if(index + 1 >= coments.count){
                                //                                            single(.success(coments))
                                //                                        }else{
                                //                                            index += 1
                                //                                        }
                                //
                                //
                                //
                                //
                                //                                    case .failure(_):
                                //                                        single(.failure(CustomError.isNil))
                                //                                    }
                                //
                                //
                                //
                                //                                }).disposed(by: self.disposeBag)
                                
                            }
                        }
                        
                        
                        
                    }
                    catch{
                        single(.failure(CustomError.isNil))
                        
                    }
                    
                    
                }
                
                
                
                
            }
            
            return Disposables.create()
        }
        
        
        
        
        
    }
    
    
    
    func getFollowsLikes(uid:[String] ) -> Single<[UserModel]>{
        return Single.create{ single in
            
            var usersArr : [UserModel] = []
            
            if(uid.isEmpty){
                single(.success(usersArr))
            }else{
                
                
                
                self.db.collection("HealthySecretUsers").whereField( "uuid" , in : uid ).getDocuments{ query , err in
                    if let err = err{
                        single(.failure(err))
                    }else{
                        
                        let docs = query!.documents
                        for doc in docs {
                            
                            
                            do{
                                
                                let jsonData = try JSONSerialization.data( withJSONObject: doc.data() , options: [] )
                                let user = try JSONDecoder().decode( UserModel.self, from: jsonData )
                                
                                usersArr.append(user)
                                
                            }
                            catch{
                                
                                
                                single(.failure(CustomError.isNil))
                                
                            }
                            
                            
                        }
                                                
                        single(.success(usersArr))
                    }
                    
                    
                }
            }
            
            return Disposables.create()
        }
        
        
        
        
    }
    
    
}



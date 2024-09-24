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
    var query: Query?
    var listener: ListenerRegistration?
    
    
    
    let disposeBag = DisposeBag()
    
    let db =  Firestore.firestore()
    
    
    func getMessage(uid: String) -> Single<String> {
        return Single.create { single in
            self.db.collection("HealthySecretStartMessages").document(uid).getDocument(completion: { doc, err in
                if let err = err {
                    
                    single(.failure(err))
                    
                } else {
                    
                    if let data = doc?.data() {
                        let outputData: String = data["report"] as! String
                        doc?.reference.delete()
                        single(.success(outputData))
                        
                        
                        
                    } else {
                        single(.failure(CustomError.isNil))
                        
                    }
                    
                    
                }
                
                
            })
            
            return Disposables.create()
        }
        
    }
    func deleteDatas(user: User) -> Completable {
        
        
        Completable.create { completable in
            let collection = self.db.collection("HealthySecretUsers")
            let uid = user.uid
            collection.document(uid).delete { err in
                
                if let err = err {
                    completable(.error(err))
                }
            }
            collection.getDocuments { snapshot, err  in
                if let err = err {
                    print("Error removing document: \(err)")
                    completable(.error(err))
                }
                guard let snapshot = snapshot else {return}
                
                for doc in snapshot.documents {
                    
                    doc.reference.updateData([
                        
                        "followings": FieldValue.arrayRemove([uid]),
                        "followers": FieldValue.arrayRemove([uid]),
                        "blocking": FieldValue.arrayRemove([uid]),
                        "blocked": FieldValue.arrayRemove([uid])
                        
                        
                    ])
                    
                }
                
                
                
                
                
                self.db.collection("HealthySecretFeed").getDocuments { snapshot, error in
                    if error != nil { return }
                    
                    guard let snapshot = snapshot else {
                        
                        return
                    }
                    
                    for doc in snapshot.documents {
                        var comentArr: [ComentDTO] = []
                        
                        
                        do {
                            
                            let jsonData = try JSONSerialization.data(withJSONObject: doc.data(), options: [])
                            let creditCard = try JSONDecoder().decode(FeedDTO.self, from: jsonData)
                            
                            print("deleteFeed \(creditCard.uuid) user  \(uid)")
                            
                            
                            if creditCard.uuid.elementsEqual( uid ) {
                                doc.reference.delete()
                            } else {
                                
                                for coment in creditCard.coments where coment.uid == uid {
                                    comentArr.append(coment)

                                    
                                }
                                
                                
                                
                                doc.reference.updateData([
                                    
                                    "likes": FieldValue.arrayRemove([uid]),
                                    "coments": FieldValue.arrayRemove(comentArr)
                                    
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
                    storageReference.listAll { refs, _ in
                        guard let refs = refs else {return}
                        for item in refs.items {
                            print("\(item.name) refsItems")
                            let ref = Storage.storage().reference().child("\(uid)/\(item.name)")
                            ref.delete { _ in
                                
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
    
    func deleteAccount( credential: AuthCredential ) -> Completable {
        return Completable.create { completable in
            if  let user = Auth.auth().currentUser {
                
                user.reauthenticate(with: credential) { result, err in
                    self.signOut().subscribe { event in
                        switch event {
                        case.completed:
                            result?.user.delete { [weak self] error in
                                if let error = error {
                                    print("Firebase Error: ", error)
                                    
                                    
                                } else {
                                    print("user \(user)")
                                    self?.deleteDatas(user: user).subscribe({ event in
                                        switch event {
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
        return Completable.create { completable in
            if (try? Auth.auth().signOut()) != nil {
                completable(.completed)
            } else {
                completable(.error("error" as! Error))
            }
            
            
            return Disposables.create()
        }
        
        
        
        
    }
    
    
    
    public func signUp(email: String, pw: String) -> Completable {
        return Completable.create { completable in
            Auth.auth().createUser(withEmail: email, password: pw) {  [weak self] _, error in
                guard self != nil else { return }
                
                if let error = error {
                    completable(.error(error))
                    return
                } else {
                    completable(.completed)
                    
                }
                
                
            }
            return Disposables.create()
            
        }
        
    }
    
    public func getCurrentUser() -> Single<User> {
        return Single.create { single in
            guard let currentUser = Auth.auth().currentUser else {
                
                single(.failure(FireStoreError.unknown))
                return Disposables.create()
            }
            single(.success(currentUser))
            return Disposables.create()
            
        }
    }
    
    public func signIn(email: String, pw: String) -> Completable {
        return Completable.create { completable in
            Auth.auth()
                .signIn(withEmail: email, password: pw) { [weak self] res, error in
                    guard let self = self else { return }
                    if let error = error {
                        // 에러가 났다면 여기서 처리
                        completable(.error(error))
                        return
                    } else {
                        guard let uid = res?.user.uid else {return completable(.error(CustomError.isNil))}
                        print("로그인 성공")
                        UserDefaults.standard.setValue(uid, forKey: "uid")
                        
                        self.getDocument(key: uid).subscribe({ event in
                            switch event {
                            case(.success(let user)):
                                if CustomFormatter.shared.dateCompare(targetString: user.freezeDate ?? "") {
                                    completable(.completed)
                                    
                                    
                                } else {
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
    
    func signInCredential(credential: AuthCredential) -> Completable {
        
        return Completable.create { completable in
            
            
            
            Auth.auth().signIn(with: credential) { authResult, error in
                if let error = error {
                    print("Error Apple sign in: \(error.localizedDescription)")
                    
                    return
                }
                
                
                guard let authUser = authResult?.user else { return }
                
                UserDefaults.standard.set(authUser.email, forKey: "email")
                UserDefaults.standard.set( authUser.uid, forKey: "uid")
                
                
                
                
                self.getDocument(key: authUser.uid ).subscribe({ event in
                    switch event {
                    case(.success(let user)):
                        if CustomFormatter.shared.dateCompare(targetString: user.freezeDate ?? "") {
                            completable(.completed)
                            
                            
                        } else {
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
    
    func getDocument( key: String ) -> Single<UserModel> {
        return Single.create { [weak self] single in
            
            
            
            self?.db.collection("HealthySecretUsers").document(key).getDocument { doc, err in
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
                } else {
                    single(.failure(CustomError.isNil))
                }
                
                
            }
            
            
            
            
            return Disposables.create()
        }
        
        
        
    }
    
    
    
    
    func createUsers(model: UserModel) -> Completable {
        return Completable.create { completable in
            
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
        Single.create { [weak self] single in guard let self = self else {return Disposables.create()}
            self.db.collection("HealthySecret").getDocuments {(querySnapshot, err) in
                var list: [Row] = []
                
                if let err = err {
                    single(.failure(err))
                    
                    
                } else {
                    for document in querySnapshot!.documents {
                        do {
                            let jsonData = try JSONSerialization.data(withJSONObject: document.data(), options: [])
                            
                            
                            
                            let responseFile  = try JSONDecoder().decode(IngredientsDTO.self, from: jsonData)
                            
                            list = responseFile.row
                            single(.success(list))
                            
                        } catch let err {
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
    
    
    
    func getExercisesList() -> Single<ExerciseDTO> {
        return Single.create { [weak self] single in
            guard let self = self else { return Disposables.create() }
            
            self.db.collection("HealthySecretExercises").getDocuments { snapshot, error in
                
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
    
    
    
    func addDiary(diary: Diary, key: String) -> Completable {
        return Completable.create { completable in
            
            completable(.completed)
            let path = self.db.collection("HealthySecretUsers").document(key)
            
            path.updateData(["diarys": FieldValue.arrayUnion([diary.dictionary!])])
            return Disposables.create()
        }
        
    }
    
    
    func updateIngredients(ingredients: [Ingredients], key: String) -> Completable {
        return Completable.create { completable in
            
            let arr = ingredients.map({
                return $0.dictionary
            })
            
            self.db.collection("HealthySecretUsers").document(key).getDocument { doc, err in
                
                if let err = err {
                    completable(.error(err))
                } else {
                    doc?.reference.updateData([
                        "ingredients": arr
                    ])
                    completable(.completed)
                    
                }
            }
            
            
            
            return Disposables.create()
            
            
        }
        
        
    }
    
    
    func updateExercises(exercise: [ExerciseModel], key: String) -> Completable {
        return Completable.create { completable in
            
            let exercise = exercise.map({
                $0.dictionary
                
            })
            
            
            self.db.collection("HealthySecretUsers").document(key).getDocument { (doc, err) in
                if let err = err {
                    
                    print("error1")
                    
                    completable(.error(err))
                    // Some error occured
                } else {
                    
                    doc?.reference.updateData([
                        "exercise": exercise
                    ])
                    
                    
                    completable(.completed)
                }
            }
            
            
            
            return Disposables.create()
            
            
        }
        
        
    }
    
    
    
    func updateDiary(diary: [Diary], key: String) -> Completable {
        return Completable.create { completable in
            
            let diary = diary.map({
                $0.dictionary
                
            })
            
            
            self.db.collection("HealthySecretUsers").document(key).getDocument { (doc, err) in
                if let err = err {
                    
                    print("error1")
                    
                    completable(.error(err))
                    // Some error occured
                    
                } else {
                    guard let doc = doc else { return }
                    doc.reference.updateData([
                        "diarys": diary
                    ])
                    
                    
                    completable(.completed)
                }
            }
            
            
            
            return Disposables.create()
            
            
        }
        
        
    }
    
}

extension FirebaseService {
    
    func updateSignUpData( signUpModel: SignUpModel, uuid: String ) -> Completable {
        return Completable.create { completable in
            
            self.db.collection("HealthySecretUsers").document( uuid ).getDocument { (doc, err) in
                
                if let err = err {
                    
                    print("error1")
                    
                    completable(.error(err))
                    // Some error occured
                } else {
                    
                    doc?.reference.updateData([
                        "age": signUpModel.age,
                        "tall": signUpModel.tall,
                        "sex": signUpModel.sex,
                        "goalWeight": signUpModel.goalWeight,
                        "nowWeight": signUpModel.nowWeight,
                        "calorie": signUpModel.calorie,
                        "activity": signUpModel.activity
                        
                    ])
                    completable(.completed)
                    
                }
                
                
                
            }
            
            
            
            return Disposables.create()
            
        }
        
        
        
    }
    
    
    func updateValues( valuesDic: [String: String], uuid: String ) -> Completable {
        
        
        
        
        
        return Completable.create { completable in
            
            print("update Values")
            
            
            
            self.db.collection("HealthySecretUsers").document(uuid).getDocument { (doc, err) in
                
                if let err = err {
                    
                    print("error1")
                    
                    completable(.error(err))
                    // Some error occured
                } else {
                    
                    doc?.reference.updateData(
                        valuesDic
                    )
                    
                    
                    completable( .completed)
                    
                    
                }
                
                
                
                
            }
            return Disposables.create()
            
        }
    }
    
    
    func updateFollowers(ownUid: String, opponentUid: String, follow: Bool) -> Completable {
        return Completable.create { completable in
            
            print("\(ownUid), \(opponentUid), \(follow)")
            self.db.collection("HealthySecretUsers").document(ownUid).getDocument { doc, err in
                if let err = err {
                    completable(.error(err))
                } else {
                    
                    if follow {
                        doc?.reference.updateData([
                            
                            "followings": FieldValue.arrayUnion([opponentUid])
                            
                        ])} else {
                            
                            doc?.reference.updateData([
                                
                                "followings": FieldValue.arrayRemove([opponentUid])
                                
                            ])
                        }
                    
                    
                }
                
                self.db.collection("HealthySecretUsers").document(opponentUid).getDocument { doc, err in
                    if let err = err {
                        completable(.error(err))
                    } else {
                        
                        if follow {
                            doc?.reference.updateData([
                                
                                "followers": FieldValue.arrayUnion([ownUid])
                                
                            ])} else {
                                
                                doc?.reference.updateData([
                                    
                                    "followers": FieldValue.arrayRemove([ownUid])
                                    
                                ])
                                
                                
                            }
                        
                        completable(.completed)
                    }
                    
                    
                    
                    
                }
                
                
                
                
            }
            
            
            
            return Disposables.create()
        }
        
    }
    
    func report(url: String, uid: String, uuid: String, event: String) -> Completable {
        return Completable.create { completable in
            
            self.db.collection(url).document(uid).getDocument { doc, err in
                if let err = err {
                    completable(.error(err))
                } else {
                    
                    if event == "feed" {
                        doc?.reference.updateData([
                            
                            "report": FieldValue.arrayUnion([uuid])
                            
                        ])
                        
                        let report = doc?.get("report") as! [String]
                        if report.count >= 5 {
                            
                            
                            self.db.collection("HealthySecretStartMessages").document(uuid).setData(["report": "신고 누적으로 피드가 삭제 되었습니다"])
                            
                            
                            
                        }
                        
                        
                        completable(.completed)
                        
                    } else if event == "coment" {
                        if doc?.data() != nil {
                            doc?.reference.updateData([
                                
                                "report": FieldValue.arrayUnion([uuid])
                                
                            ])
                            
                            let report = doc?.get("report") as! [String]
                            if report.count >= 5 {
                                
                                doc?.reference.delete()
                                
                                self.db.collection("HealthySecretStartMessages").document(uuid).setData(["report": "신고 누적으로 댓글이 삭제 되었습니다"])
                                
                                
                                completable(.error(CustomError.delete))
                                
                                
                                
                            }
                        } else {
                            doc?.reference.setData(["report": [uuid]])
                        }
                        
                        
                        completable(.completed)
                        
                        
                        
                    } else if event == "user" {
                        
                        doc?.reference.updateData([
                            
                            "report": FieldValue.arrayUnion([uuid])
                            
                        ])
                        
                        
                        
                        if let report = doc?.get("report") as? [String] {
                            if report.count >= 5 {
                                
                                
                                
                                doc?.reference.updateData([
                                    
                                    
                                    "freezeDate": CustomFormatter.shared.DateToString(date: Calendar.current.date(byAdding: .month, value: +1, to: Date())!)
                                    
                                    
                                ])
                            }
                            
                            completable(.completed)
                            
                            
                        }
                    } else {
                        completable(.error(CustomError.isNil))
                        
                    }
                }
                
            }
            
            
            
            
            return Disposables.create()
            
            
        }
        
        
        
        
        
    }
    
    func blockUser(ownUid: String, opponentUid: String, block: Bool) -> Completable {
        return Completable.create { completable in
            
            self.db.collection("HealthySecretUsers").document(ownUid).getDocument { doc, err in
                if let err = err {
                    completable(.error(err))
                } else {
                    
                    if block {
                        doc?.reference.updateData([
                            
                            "blocking": FieldValue.arrayUnion([opponentUid]),
                            "followings": FieldValue.arrayRemove([opponentUid]),
                            "followers": FieldValue.arrayRemove([opponentUid])
                            
                        ])
                        
                        
                        self.db.collection("HealthySecretUsers").document(opponentUid).getDocument { doc, err in
                            if let err = err {
                                completable(.error(err))
                            } else {
                                
                                
                                doc?.reference.updateData([
                                    
                                    "blocked": FieldValue.arrayUnion([ownUid]),
                                    "followings": FieldValue.arrayRemove([ownUid]),
                                    "followers": FieldValue.arrayRemove([ownUid])
                                ])
                                
                                
                                
                                
                                completable(.completed)
                            }
                            
                            
                            
                            
                        }
                    } else {
                        
                        doc?.reference.updateData([
                            
                            "blocking": FieldValue.arrayRemove([opponentUid])
                            
                            
                        ])
                        
                        
                        self.db.collection("HealthySecretUsers").document(opponentUid).getDocument { doc, err in
                            if let err = err {
                                completable(.error(err))
                            } else {
                                
                                
                                doc?.reference.updateData([
                                    
                                    "blocked": FieldValue.arrayRemove([ownUid])
                                    
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
    func uploadImage(imageData: Data?, pathRoot: String ) -> Single<String> {
        return Single.create { single in
            guard let imageData = imageData else {
                single(.success(""))
                return Disposables.create()  }
            
            
            let metaData = StorageMetadata()
            metaData.contentType = "image/jpeg"
            let imageName = UUID().uuidString + String(Date().timeIntervalSince1970)
            
            let firebaseReference = Storage.storage().reference().child("\(pathRoot)/\(imageName)")
            
            
            firebaseReference.putData(imageData, metadata: metaData) { _, _ in
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
            
            
            storageReference.delete { error in
                if let error = error {
                    
                    completable(.error(error))
                    
                } else {
                    completable(.completed)
                    
                }
                
            }
            
            
            return Disposables.create()
            
        }
    }
    
    
    
    
    
    
    
    func updateFeed( feedDto: FeedDTO) -> Completable {
        return Completable.create { completable in
            self.db.collection("HealthySecretFeed").document(feedDto.feedUid).getDocument { doc, err in
                if let err = err {
                    completable(.error(err))
                } else {
                    
                    doc?.reference.updateData([
                        "contents": feedDto.contents,
                        "mainImgUrl": feedDto.mainImgUrl
                        
                    ])}
                
                completable(.completed)
                
                
                
                
                
            }
            
            
            
            return Disposables.create()
        }
        
    }
    
    func addFeed(feed: FeedDTO) -> Completable {
        return Completable.create { completable in
            
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
    
    
    func updateFeedLikes( feedUid: String, uuid: String, like: Bool) -> Completable {
        return Completable.create { completable in
            self.db.collection("HealthySecretFeed").document(feedUid).getDocument { doc, err in
                if let err = err {
                    completable(.error(err))
                } else {
                    
                    if like {
                        doc?.reference.updateData([
                            
                            "likes": FieldValue.arrayUnion([uuid])
                            
                        ])} else {
                        
                        doc?.reference.updateData([
                            
                            "likes": FieldValue.arrayRemove([uuid])
                            
                        ])
                    }
                    completable(.completed)
                    
                    
                }
                
                
            }
            
            
            
            return Disposables.create()
        }
        
    }
    
    
    
    
    
    
    
    
    func getFeedPagination(feeds: [FeedDTO], pagesCount: Int, follow: [String], getFollow: Bool, followCount: Int, block: [String]) -> Single<[FeedDTO]> {
        return Single<[FeedDTO]>.create { [weak self] single in
            
            guard let self = self else {return single(.failure(FireStoreError.unknown)) as! Disposable}
            var newFeeds: [FeedDTO] = []
            let lastFeeds: [FeedDTO] = feeds
            var followCount = followCount
            if let query = self.query {
                
                self.requestQuery = query
                
            } else {
                
                self.requestQuery = self.db.collection("HealthySecretFeed")
                    .order(by: "date", descending: true )
                    .limit(to: pagesCount)
            }
            
            self.requestQuery?.getDocuments { [weak self] (snapshot, _) in
                
                guard let self = self else { return }
                print("nniill")
                guard let snapshot = snapshot, let lastDocument = snapshot.documents.last else {
                    single(.failure(CustomError.isNil))
                    
                    return
                }
                
                let next = self.db.collection("HealthySecretFeed")
                    .order(by: "date", descending: true)
                    .limit(to: pagesCount)
                    .start(afterDocument: lastDocument)
                
                self.query = next
                
                
                
                
                _ = snapshot.documents.map({ document in
                    
                    do {
                        let feedModel = try document.data(as: FeedDTO.self)
                        
                        if getFollow {
                            
                            if follow.contains(feedModel.uuid) && !block.contains(feedModel.uuid) {
                                newFeeds.append(feedModel)
                                followCount += 1
                            }
                        } else if !block.contains(feedModel.uuid) {
                            
                            newFeeds.append(feedModel)
                            followCount += 1
                        }
                        
                        
                    } catch {
                        
                        single(.failure(CustomError.isNil))
                    }
                })
                
                let totalFeeds = lastFeeds + newFeeds
                
                print("total \(totalFeeds)")
                
                
                if followCount < 4 || getFollow {
                    getFeedPagination(feeds: totalFeeds, pagesCount: 4, follow: follow, getFollow: getFollow, followCount: followCount, block: block ).subscribe({ event in
                        switch event {
                            
                        case.success(let feeds):
                            
                            print("success")
                            
                            single(.success(feeds))
                        case.failure(let err):
                            if err as! CustomError == CustomError.isNil {
                                
                                if totalFeeds.isEmpty {
                                    single(.failure(CustomError.isNil))
                                }
                                
                                single(.success(totalFeeds))
                                
                            }
                        }
                        
                        
                    }).disposed(by: disposeBag)
                    
                } else {
                    
                    print("else")
                    
                    
                    
                    
                    single(.success(totalFeeds))
                    
                    
                    
                    
                    
                }
                
                
                
                
                
                
                
                
            }
            print("why")
            
            return Disposables.create()
        }
        
    }
    
    
    
    
    
    func getFeedFeedUid(feedUid: String) -> Single<FeedDTO> {
        return Single.create { [weak self] single in
            guard let self = self else { single(.failure(FireStoreError.unknown) )
                return Disposables.create()}
            self.db.collection("HealthySecretFeed").document(feedUid).getDocument { doc, err in
                if let err = err {
                    single(.failure(err))
                } else {
                    if let data = doc?.data() {
                        do {
                            let jsonData = try JSONSerialization.data(withJSONObject: data, options: [])
                            let feed = try JSONDecoder().decode(FeedDTO.self, from: jsonData)
                            single(.success(feed))
                        } catch {
                            
                            single(.failure(CustomError.isNil))
                        }
                        
                    }
                }
                
                
            }
            
            
            
            
            
            return Disposables.create()
        }
        
    }
    
    
    
    func getFeedsUid( uid: String ) -> Single<[FeedDTO]> {
        return Single.create { single in
            
            
            var feedModels: [FeedDTO] = []
            self.db.collection("HealthySecretFeed").whereField("uuid", isEqualTo: uid).order(by: "date", descending: true ).getDocuments { (querySnapshot, err) in
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
    
    func deleteFeed(feedUid: String) -> Completable {
        return Completable.create { completable in
            
            self.db.collection("HealthySecretFeed").document(feedUid).delete { err in
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
    
    // 댓글 수정 삭제
    
    
    func deleteComents(  coment: ComentDTO, feedUid: String ) -> Single<[ComentDTO]> {
        return Single.create { single in
            
            
            
            
            
            
            self.listener = self.db.collection("HealthySecretFeed").whereField("feedUid", isEqualTo: feedUid).addSnapshotListener {  [weak self]  querySnapshot, error in
                guard self != nil else {return}
                guard let snapshot = querySnapshot else {
                    print("Error fetching snapshots: \(error!)")
                    return
                }
                
                
                snapshot.documentChanges.forEach { diff in
                    
                    
                    print("\(diff) diff")
                    if diff.type == .modified {
                        // document 안에있는 Arr 안의 데이터를 삭제하므로 modified 를 찾는다.
                        
                        do {
                            let jsonData = try JSONSerialization.data(withJSONObject: diff.document.data(), options: [])
                            let feed = try JSONDecoder().decode(FeedDTO.self, from: jsonData)
                            
                            
                            if feed.coments.isEmpty {
                                single(.success([]))
                            }
                            single(.success(feed.coments))
                            
                            
                            
                            
                        } catch {
                            single(.failure(CustomError.isNil))
                        }
                        
                    } else {
                        print("else")
                        
                        if let coment = coment.dictionary {
                            diff.document .reference.updateData([
                                
                                "coments": FieldValue.arrayRemove([coment])
                                
                            ])
                        }
                        
                    }
                    
                }
                
                
                
                
                
            }
            
            
            return Disposables.create()
        }
        
        
    }
    
    
    
    func updateComents( feedUid: String, coment: ComentDTO  ) -> Single<[ComentDTO]> {
        return Single.create { [weak self] single in
            guard let self = self else { return Disposables.create()}
            self.listener = self.db.collection("HealthySecretFeed").whereField("feedUid", isEqualTo: feedUid).addSnapshotListener {  querySnapshot, error in
                guard let snapshot = querySnapshot else {
                    print("Error fetching snapshots: \(error!)")
                    return
                }
                
                
                snapshot.documentChanges.forEach { diff in
                    
                    
                    
                    if diff.type == .modified {
                        // document 안에있는 Arr 안의 데이터를 추가하므로 modified 를 찾는다.
                        
                        do {
                            let jsonData = try JSONSerialization.data(withJSONObject: diff.document.data(), options: [])
                            let feed = try JSONDecoder().decode(FeedDTO.self, from: jsonData)
                            let coments = feed.coments
                            
                            single(.success(coments))
                            self.listener?.remove()
                            
                            
                        } catch {
                            single(.failure(CustomError.isNil))
                            
                        }
                        
                    } else {
                        
                        
                        if let coment = coment.dictionary {
                            diff.document .reference.updateData([
                                
                                "coments": FieldValue.arrayUnion([coment])
                                
                            ])
                        }
                        
                    }
                    
                }
                
                
                
                
                
            }
            
            
            
            
            
            
            
            return Disposables.create()
        }
        
    }
    
    func getComents(feedUid: String) -> Single<[ComentDTO]> {
        return Single.create { [weak self] single in
            
            guard let self = self else {return Disposables.create()}
            
            self.db.collection("HealthySecretFeed").document(feedUid).getDocument { doc, err in
                
                if let err = err {
                    single(.failure(err))
                } else {
                    guard let data = doc?.data() else {return}
                    do {
                        let jsonData = try JSONSerialization.data(withJSONObject: data, options: [])
                        let feed = try JSONDecoder().decode(FeedDTO.self, from: jsonData)
                        
                        
                        
                        single(.success(feed.coments))
                        
                        
                    } catch {
                        single(.failure(CustomError.isNil))
                        
                    }
                    
                    
                }
                
                
                
                
            }
            
            return Disposables.create()
        }
        
        
        
        
        
    }
    
    
    
    func getFollowsLikes(uid: [String] ) -> Single<[UserModel]> {
        return Single.create { single in
            
            var usersArr: [UserModel] = []
            
            if uid.isEmpty {
                single(.success(usersArr))
            } else {
                
                
                
                self.db.collection("HealthySecretUsers").whereField( "uuid", in: uid ).getDocuments { query, err in
                    if let err = err {
                        single(.failure(err))
                    } else {
                        
                        let docs = query!.documents
                        for doc in docs {
                            
                            
                            do {
                                
                                let jsonData = try JSONSerialization.data( withJSONObject: doc.data(), options: [] )
                                
                                let user = try JSONDecoder().decode( UserModel.self, from: jsonData )
                                usersArr.append(user)
                                
                            }
                            
                            catch(let err) {
                                print(err)
                                
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

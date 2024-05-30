//
//  SignUpUseCase.swift
//  HealthySecret
//
//  Created by 양승완 on 5/27/24.
//

import Foundation
import RxSwift
import FirebaseAuth

class ProfileUseCase  {
    
    
    
    
    private let disposeBag = DisposeBag()
    private let userRepository : UserRepository
    private let feedRepository : FeedRepository
    private let loginRepository : LoginRepository
    private let fireStorageRepository : FireStorageRepository
    
    init( userRepository : UserRepository , feedRepository : FeedRepository , loginRepository : LoginRepository , fireStorageRepository : FireStorageRepository){
        self.userRepository = userRepository
        self.feedRepository = feedRepository
        self.fireStorageRepository = fireStorageRepository
        self.loginRepository = loginRepository
    }
    
    
    func getUser() -> Single<UserModel>{

        return userRepository.getUser()
    }  
    
    func getUser( uid : String) -> Single<UserModel>{

        return userRepository.getUser( uid : uid )
    }
    
    
    func getFeeds(uid : String) -> Single<[FeedModel]>{
        
        return Single.create{ [weak self] single in
            guard let self else {single(.failure(CustomError.isNil))  
                return Disposables.create()}
            
            feedRepository.getFeedsUid(uid: uid).subscribe({ event in
                switch(event){
                case .success(let feedDtos):
                    var index = 0
                    var feedModels = feedDtos.map{ $0.toDomain(nickname: "" , profileImage: "" ) }
                    for i in 0..<feedDtos.count {
                        self.userRepository.getUser(uid: feedDtos[i].uuid ).subscribe({ event in
                            
                            switch(event){
                            case.success(let user):
                                
                                
                                feedModels[i] = feedDtos[i].toDomain(nickname: user.name , profileImage: user.profileImage ?? "")
                                
                                if(index + 1 >= feedDtos.count){
                                    single(.success(feedModels))
                                }else{
                                    index += 1
                                }
                                
                                
                                
                                
                            case .failure(_):
                                single(.failure(CustomError.isNil))
                            }
                            
                            
                            
                        }).disposed(by: self.disposeBag)
                        
                    }
                    
                    
                case .failure(let err):
                    single( .failure(err))
                }
                
                
            }).disposed(by: disposeBag)
            return Disposables.create()
        }
        

    }
    
    func signOut() -> Completable{
            
            if( UserDefaults.standard.string(forKey: "loginMethod") == "kakao" ){
                
                self.loginRepository.kakaoSignOut().subscribe{ event in
                    switch(event){
                    case.completed:
                        print("completedkakao")
                        
                        
                    case.error(_):
                        print("kako err")

                        
                    }

                }.disposed(by: disposeBag)
                
                
            }
            
        
       
        
        return self.loginRepository.signOut()
        
    }
        
    
    func kakaoSecessionOut() -> Completable {
        return Completable.create{ [weak self] completable in
            guard let email = UserDefaults.standard.string(forKey: "email") , let self else {
                
                completable(.error(CustomError.isNil))
                return Disposables.create()
            }

            self.loginRepository.kakaoGetToken().subscribe({ event in
                
                switch(event){
                case .success(let password):
                    let credential = EmailAuthProvider.credential(withEmail: email, password: password)
                    self.loginRepository.deleteAccount(credential : credential ).subscribe({ com in
                        switch(com){
                        case .completed:
                            
                            self.loginRepository.kakaoSecession().subscribe({ event in
                              
                                completable(event)
                                
                            }).disposed(by: self.disposeBag)

                            
                        case.error(let err):
                            print(err)


                        }
                    }).disposed(by: self.disposeBag)
                case .failure(let err):
                    print(err)
                }
                
            }).disposed(by: disposeBag)
            
            return Disposables.create()
        }

       
        

    }
    
    
    func appleSecession(codeString : String , userId : String , credential : OAuthCredential) -> Completable {
        
        Completable.create{ [weak self] completable in
            guard let self else {
                completable( .error(CustomError.isNil))
                return Disposables.create()}
            let url = URL(string: "https://us-central1-healthysecrets-f1b20.cloudfunctions.net/getRefreshToken?code=\(codeString)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "https://apple.com")!
            _ = URLSession.shared.dataTask(with: url) {(data, response, error) in
                if let data = data {
                    let refreshToken = String(data: data, encoding: .utf8) ?? ""
                    
                    
                    return self.loginRepository.appleSecession(refreshToken : refreshToken, userId: userId).subscribe({ [weak self] event in
                        guard let self else {return}
                        switch(event){
                        case .completed:
                            self.loginRepository.deleteAccount(credential: credential).subscribe({ event in
                                
                                
                                
                            }).disposed(by: disposeBag)
                            
                        case .error(let err):
                            print(err)
                        }
                        
                    }).disposed(by: self.disposeBag)
  
                }else{
                    completable( .error(CustomError.isNil))

                }
            }
            
            
            return Disposables.create()

        }
    }
    
    
    func blockUser( opponentUid: String , block: Bool) -> Completable {
        
        return userRepository.blockUser(opponentUid: opponentUid , block: block)
    }
    
    
    
    
    
    func updateValues(name: String , introduce: String  , uuid: String , image : UIImage? , beforeImage: String, profileChage: Bool ) -> Completable {
        return Completable.create{ [weak self] completable in
            guard let self else { completable( .error(CustomError.isNil) )
                return Disposables.create()}
            
            self.userRepository.updateValues(valuesDic: [ "name" : name , "introduce" : introduce ], uuid: uuid).subscribe({ event in
                switch(event){
                case .completed:
                    completable( .completed )
                case .error(let err):
                    completable( .error(err) )

                }
                
                
                
            }).disposed(by: disposeBag )
            
            
            if( profileChage ){
                guard let imageData = image?.jpegData(compressionQuality: 0.1) else { return Disposables.create() }
                let path = UserDefaults.standard.string(forKey: "uid") ?? "/" + "profile"
                self.fireStorageRepository.uploadImage(imageData: imageData, pathRoot: path).subscribe( { event in
                    switch(event){
                    case .success(let url):
                        self.userRepository.updateValues(valuesDic: [ "name" : name , "introduce" : introduce ], uuid: uuid).subscribe({ event in
                            switch(event){
                            case .completed:
                                print("이미지 업로드 성공")
                            case .error(let err):
                                print("이미지 업로드 실패")
                            }
                            
                            
                        }).disposed(by: self.disposeBag)

                      
                    case .failure(let err):
                        print(err)
                    }
                    
                }).disposed(by: disposeBag)
                
                if !((beforeImage).isEmpty){
                    self.fireStorageRepository.deleteImage(urlString: beforeImage).subscribe{ [weak self] event in
                        guard let self = self else {return}
                        switch(event){
                            
                        case .error(_):
                            print("이미지없음")
                        case .completed:
                            print("success")
                        }
                        
                    }.disposed(by: self.disposeBag)
                    
                }
                
                
            }
            
            
            return Disposables.create()
            
        }
        
        
        
        
        
        
        
        
        
        
    }
    
}

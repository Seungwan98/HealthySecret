//
//  KakaoService.swift
//  HealthySecret
//
//  Created by 양승완 on 2024/01/18.
//

import Foundation
import KakaoSDKAuth
import KakaoSDKUser
import RxSwift

final class KakaoService {
    
    let disposeBag = DisposeBag()
    let firebaseService = FirebaseService()
    
    func kakaoSessionOut() -> Completable {
        return Completable.create{ com in
            UserApi.shared.unlink {(error) in
                        if let error = error {
                            print(error)
                            com(.error(error))
                        }
                        else {
                            print("unlink() success.")
                            com(.completed)
                        }
                    }
            
            return Disposables.create()
            
        }
        
    }
    func kakaoLogout() -> Completable {
        return Completable.create{ com in
            UserApi.shared.logout {(error) in
                        if let error = error {
                            print(error)
                            com(.error(error))
                        }
                        else {
                            print("logout() success.")
                            com(.completed)
                        }
                    }
            
            return Disposables.create()
            
        }
        
    }
    
    func kakaoLogin() -> Single<[String:String]> {
        
        var outputId : String!
        var outputPassword : String!
        var outputName : String!
        
        return Single.create { single in
            
            if AuthApi.hasToken() {
                
                UserApi.shared.accessTokenInfo { token , error in
                    if let error = error {
                        print("_________login error_________")
                        print(error)
                        print("토큰 존재하지 않음.")
                        if UserApi.isKakaoTalkLoginAvailable() {
                            print("카카오톡 존재")
                            UserApi.shared.loginWithKakaoTalk { oauthToken, error in
                                print("1")
                                if let error = error {
                                    print(error)
                                } else {
                                    print("새로운 Login")
                                    
                                    //do something
                                    _ = oauthToken
                                    
                                    // 로그인 성공 시
                                    UserApi.shared.me { kuser, error in
                                        
                                        if let error = error {
                                            print("------KAKAO : user loading failed------")
                                            print(error)
                                            single(.failure(error))
                                        } else {
                                            
                                            guard let email = (kuser?.kakaoAccount?.email) else { return }
                                            guard let pw =  kuser?.id else {return}
                                            guard let name = (kuser?.kakaoAccount?.profile?.nickname) else {return}
                                            
                                            outputId = "kakao_" + email
                                            outputPassword = "kakao_" + String(describing: pw )
                                            outputName = name
                                            
                                            single(.success(["email": outputId , "pw" : outputPassword , "name" : outputName ] ))

                                        }
                                    }
                                    
                                    
                                    
                                }
                            }
                            
                        }
                        else{
                            UserApi.shared.loginWithKakaoAccount { oauthToken, error in
                                print("2")

                                if let error = error {
                                    print(error)
                                } else {
                                    print("새로운 Login")
                                    
                                    //do something
                                    _ = oauthToken
                                    
                                    // 로그인 성공 시
                                    UserApi.shared.me { kuser, error in
                                        
                                        if let error = error {
                                            print("------KAKAO : user loading failed------")
                                            print(error)
                                            single(.failure(error))
                                        } else {
                                            
                                            guard let email = ((kuser?.kakaoAccount?.email)) else { return }
                                            guard let pw =  kuser?.id else {return}
                                            guard let name = ((kuser?.kakaoAccount?.profile?.nickname)) else { return }

                                            
                                            outputId = "kakao_" + email
                                            outputPassword = "kakao_" + String(describing: pw )
                                            outputName = name
                                            single(.success(["email": outputId , "pw" : outputPassword , "name" : outputName  ] ))


                                        }
                                    }
                                }
                                
                                

                           
                            }
                        }
                        
                    }
                    else{
                        print("g")
                        UserApi.shared.me { kuser, error in
                            guard let email = ((kuser?.kakaoAccount?.email)) else { return }
                            guard let pw =  kuser?.id else {return}
                            guard let name  = kuser?.kakaoAccount?.profile?.nickname else {return}
                            
                            outputId = "kakao_" + email
                            outputPassword = "kakao_" + String(describing: pw )
                            outputName = name
                            single(.success(["email" : outputId  , "pw" : outputPassword , "name" : outputName ]))

                        }

                    }
                    
                    
                }
                
                
                
                
            } else {
                if UserApi.isKakaoTalkLoginAvailable() {
                    print("3")
                    UserApi.shared.loginWithKakaoTalk{ oauthToken, error in
                        if let error = error {
                            print(error)
                        } else {
                            print("New Kakao Login")
                            
                            //do something
                            _ = oauthToken
                            
                            // 로그인 성공 시
                            UserApi.shared.me { kuser, error in
                                if let error = error {
                                    print("------KAKAO : user loading failed------")
                                    print(error)
                                } else {
                                    guard let email = ((kuser?.kakaoAccount?.email)) else { return }
                                    guard let pw =  kuser?.id else {return}
                                    guard let name = kuser?.kakaoAccount?.profile?.nickname else {return}
                                    
                                    outputId = "kakao_" + email
                                    outputPassword = "kakao_" + String(describing: pw )
                                    outputName = name
                                    single(.success(["email": outputId , "pw" : outputPassword , "name" : outputName ] ))

                                }
                            }
                            
                            print("갱신")
                        }

                    }
                }
                else {
                    UserApi.shared.loginWithKakaoAccount { oauthToken, error in
                        print("4")
                        
                        if let error = error {
                            print(error)
                        } else {
                            print("New Kakao Login")
                            
                            //do something
                            _ = oauthToken
                            
                            // 로그인 성공 시
                            UserApi.shared.me { kuser, error in
                                if let error = error {
                                    print("------KAKAO : user loading failed------")
                                    print(error)
                                    single(.failure(error))
                                } else {
                                    guard let email = ((kuser?.kakaoAccount?.email)) else { return }
                                    guard let pw =  kuser?.id else {return}
                                    guard let name = kuser?.kakaoAccount?.profile?.nickname else {return}
                                    
                                    print("\(email)")
                                    
                                    outputId = "kakao_" + email
                                    outputPassword = "kakao_" + String(describing: pw )
                                    outputName = name

                                    single(.success(["email": outputId , "pw" : outputPassword , "name" : outputName] ))

                                }
                            }
                            
                        
                        }

                    }
                    
                }
            }
            return Disposables.create()
            
        }
        
    }
    
    
    }

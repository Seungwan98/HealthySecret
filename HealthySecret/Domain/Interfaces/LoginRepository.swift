//
//  LoginRepository.swift
//  HealthySecret
//
//  Created by 양승완 on 5/27/24.
//

import Foundation
import RxSwift
import FirebaseAuth

protocol LoginRepository  {
    func login() -> Completable
    func login(credential: OAuthCredential) -> Completable
    func signUp( email: String, pw: String ) -> Completable
    func signOut() -> Completable
    func kakaoSignOut() -> Completable
    func getCurrentUser() -> Single<User>
    func kakaoGetToken() -> Single<String>
    func deleteAccount(credential: AuthCredential) -> Completable
    func kakaoSecession() -> Completable
    func appleSecession(refreshToken: String, userId: String) -> Completable
}

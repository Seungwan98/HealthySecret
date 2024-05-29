//
//  UserRepository.swift
//  HealthySecret
//
//  Created by 양승완 on 5/27/24.
//

import Foundation
import RxSwift

protocol UserRepository {
    
    func setUser(userModel : UserModel) -> Completable 
    func getUser() -> Single<UserModel>
    func updateUsersIngredients(ingredients : [Ingredients]) -> Completable
    func updateUsersExercises( exercises : [ExerciseModel] ) -> Completable
    func updateUsersDiays( diarys : [Diary] ) -> Completable
    func getUser(uid:String) -> Single<UserModel>
    
    
}

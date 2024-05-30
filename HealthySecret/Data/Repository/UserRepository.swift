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
    func getUser(uid:String) -> Single<UserModel>
    func blockUser( opponentUid : String , block : Bool ) -> Completable

    func updateUsersIngredients(ingredients : [Ingredients]) -> Completable
    func updateUsersExercises( exercises : [ExerciseModel] ) -> Completable
    func updateUsersDiays( diarys : [Diary] ) -> Completable
    func updateValues( valuesDic : Dictionary<String , String> , uuid : String ) -> Completable
    
    
}

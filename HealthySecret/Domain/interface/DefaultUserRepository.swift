//
//  DefaultUserRepository.swift
//  HealthySecret
//
//  Created by 양승완 on 5/27/24.
//

import Foundation
import RxSwift
import Firebase


class DefaultUserRepository : UserRepository{
  
   
   
    
    
    
    
    private let firebaseService : FirebaseService

    
    private let disposeBag = DisposeBag()
    
    init( firebaseService : FirebaseService   ) {
        self.firebaseService = firebaseService
        
        
    }


    func setUser(userModel : UserModel) -> Completable {
        
        return self.firebaseService.createUsers(model: userModel)
            
            

    }
    
    func getUser() -> Single<UserModel> {
        
        guard let uid = UserDefaults.standard.string(forKey: "uid") else { return Single.create{ single in single(.failure(CustomError.isNil)) as! any Disposable   } }
        
        
        
        return self.firebaseService.getDocument(key: uid)
    }
    
    func getUser(uid: String) -> RxSwift.Single<UserModel> {
        
        return self.firebaseService.getDocument(key: uid)
    }
    
    
    
    func getMessage() -> Single<String> {
        
        guard let uid = UserDefaults.standard.string(forKey: "uid") else { return Single.create{ single in single(.failure(CustomError.isNil)) as! any Disposable   } }

        
        return self.firebaseService.getMessage(uid: uid)
        
    }
    
    
    
    func updateUsersIngredients(ingredients : [Ingredients]) -> Completable {
        guard let uid = UserDefaults.standard.string(forKey: "uid") else { return Completable.create{ completable in completable(.error(CustomError.isNil)) as! any Disposable   } }

        return firebaseService.updateIngredients(ingredients: ingredients, key: uid)
    }
      
    
    func updateUsersExercises(exercises : [ExerciseModel]) -> Completable {
        guard let uid = UserDefaults.standard.string(forKey: "uid") else { return Completable.create{ completable in completable(.error(CustomError.isNil)) as! any Disposable   } }

        return self.firebaseService.updateExercises(exercise: exercises, key: uid )
    }
    
    
    func updateUsersDiays(diarys: [Diary]) -> Completable {
        guard let uid = UserDefaults.standard.string(forKey: "uid") else { return Completable.create{ completable in completable(.error(CustomError.isNil)) as! any Disposable   } }
        
        
        return self.firebaseService.updateDiary(diary: diarys, key: uid)
    }
    
    func blockUser( opponentUid : String , block : Bool ) -> Completable {
        guard let uid = UserDefaults.standard.string(forKey: "uid") else { return Completable.create{ completable in completable(.error(CustomError.isNil)) as! any Disposable   } }

        return self.firebaseService.blockUser(ownUid: uid, opponentUid: opponentUid , block : block)
    }
 
    func updateValues( valuesDic : Dictionary< String , String > , uuid : String ) -> Completable {
        return self.firebaseService.updateValues(valuesDic: valuesDic, uuid: uuid)
    }
    
    
    
}

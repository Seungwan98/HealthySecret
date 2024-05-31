
import Foundation
import UIKit

// MARK: - Welcome
struct FeedModel {
    var uuid : String
    var feedUid : String
    var date : String
    var profileImage : String
    var nickname : String
    var likes : [String]
    var contents : String
    var mainImgUrl : [String]
    var coments : [ComentModel]
    
    var report : [String]
 
    
    
    
    init(uuid:String , feedUid : String , date:String , profileImage : String , nickname : String , contents : String , mainImgUrl : [String]  , likes : [String] , report : [String] , coments : [ComentModel]){
        self.uuid = uuid
        self.feedUid = feedUid
        self.date = date
        self.nickname = nickname
        self.contents = contents
        self.mainImgUrl = mainImgUrl
        self.likes = likes
        self.report = report
        self.coments = coments
        self.profileImage = profileImage

    }
    
    func toData() -> FeedDTO {
        
        
        return FeedDTO(uuid: self.uuid, feedUid: self.feedUid, date: self.date, likes: self.likes, contents: self.contents, mainImgUrl: self.mainImgUrl, coments: self.coments.map{ $0.toData() }, report: self.report)
        
    }
   
    
  
    
}

struct ComentModel {
    var coment : String
    var date : String
    var nickname : String
    var profileImage : String
    var uid : String
    var comentUid : String
    var feedUid : String
    
    func toData() -> ComentDTO{
        
        return ComentDTO(coment: self.coment, date: self.date, uid: self.uid, comentUid: self.coment, feedUid: self.feedUid)
        
    }
}



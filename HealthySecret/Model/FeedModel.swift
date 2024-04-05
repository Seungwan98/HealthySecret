
import Foundation
import UIKit

// MARK: - Welcome
struct FeedModel : Codable {
    var uuid : String
    var feedUid : String
    var date : String
    
    var nickname : String
    var likes : [String]
    var contents : String
    var mainImgUrl : [String]
    var coments : [Coment]?
    var profileImage : String?
    
 
    
    
    
    init(uuid:String , feedUid : String , date:String , nickname : String , contents : String , mainImgUrl : [String]  , likes : [String]){
        self.uuid = uuid
        self.feedUid = feedUid
        self.date = date
        self.nickname = nickname
        self.contents = contents
        self.mainImgUrl = mainImgUrl
        self.likes = likes
    }
    
    
    
    enum CodingKeys: String, CodingKey {
        case uuid = "uuid"
        case feedUid = "feedUid"
        case date = "date"
        
        case nickname = "nickname"
        case likes = "likes"
        case contents = "contents"
        case mainImgUrl = "mainImg"
        case coments = "coments"
        case profileImage = "profileImage"
        
        
        
    }
    
    struct Coment : Codable {
        var coment : String
        var date : String
        
    }
}



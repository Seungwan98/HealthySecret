//
//  FeedDTO.swift
//  HealthySecret
//
//  Created by 양승완 on 5/29/24.
//

import Foundation
import UIKit

// MARK: - Welcome
struct FeedDTO: Codable {
    var uuid: String
    var feedUid: String
    var date: String
    var likes: [String]
    var contents: String
    var mainImgUrl: [String]
    var coments: [ComentDTO]
    var report: [String]
 
    
    
    
    
    
    enum CodingKeys: String, CodingKey {
        case uuid = "uuid"
        case feedUid = "feedUid"
        case date = "date"
        case likes = "likes"
        case contents = "contents"
        case mainImgUrl = "mainImgUrl"
        case coments = "coments"
        case report = "report"
        
        
        
    }
    
    
    func toDomain(nickname:String, profileImage: String) -> FeedModel{
        return FeedModel(uuid: self.uuid, feedUid: self.feedUid, date: self.date, profileImage: profileImage, nickname: nickname, contents: self.contents, mainImgUrl: self.mainImgUrl, likes: self.likes, report: self.report, coments: self.coments.map { $0.toDomain(nickname: "", profileImage: "") } )
        
    }
    
}

struct ComentDTO: Codable {
    var coment: String
    var date: String
    var uid: String
    var comentUid: String
    var feedUid: String
    
    
    enum CodingKeys: String, CodingKey {
        case coment = "coment"
        case date = "date"
        case uid = "uid"
        case comentUid = "comentUid"
        case feedUid = "feedUid"
        

    }
    
    func toDomain(nickname:String, profileImage: String) -> ComentModel{
        return ComentModel(coment: self.coment, date: self.date, nickname: nickname, profileImage: profileImage, uid: self.uid, comentUid: self.comentUid, feedUid: self.feedUid)
        
    }
}



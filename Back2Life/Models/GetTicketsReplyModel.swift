//
//  GetTicketsReplyModel.swift
//  Back2Life
//
//  Created by Ios Mac on 21/03/22.
//

import Foundation
struct GetTicketsReplyModel : Codable {
    let status : Int?
    let data : [GetTicketsReplyData]?
    let message : String?

    enum CodingKeys: String, CodingKey {
        case status = "status"
        case data = "data"
        case message = "message"
    }
    
}

struct GetTicketsReplyData : Codable {
    let id : Int?
    let sender_id : Int?
    let receiver_id : Int?
    let message : String?
    let tickets_id : Int?
    let receiverinfo : Receiverinfo?

    enum CodingKeys: String, CodingKey {
        case id = "id"
        case sender_id = "sender_id"
        case receiver_id = "receiver_id"
        case message = "message"
        case tickets_id = "tickets_id"
        case receiverinfo = "receiverinfo"
    }
}


struct Receiverinfo : Codable {
    let name : String?
    let email : String?
    let photo : String?

    enum CodingKeys: String, CodingKey {

        case name = "name"
        case email = "email"
        case photo = "photo"
    }

}

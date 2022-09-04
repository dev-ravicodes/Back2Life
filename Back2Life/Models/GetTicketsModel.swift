//
//  GetTicketsModel.swift
//  Back2Life
//
//  Created by Ios Mac on 21/03/22.
//

import Foundation
struct GetTicketsModel : Codable {
    let status : Int?
    let data : [GetTicketsData]?
    let message : String?

    enum CodingKeys: String, CodingKey {
        case status = "status"
        case data = "data"
        case message = "message"
    }

}


struct GetTicketsData : Codable {
    let id : Int?
    let consumer_id : Int?
    let reason : String?
    let comment : String?
    let status : String?

    enum CodingKeys: String, CodingKey {

        case id = "id"
        case consumer_id = "consumer_id"
        case reason = "reason"
        case comment = "comment"
        case status = "status"
    }

}

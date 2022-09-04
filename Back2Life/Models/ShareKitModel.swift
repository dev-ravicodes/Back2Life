//
//  ShareKitModel.swift
//  Back2Life
//
//  Created by Mohini's Mac on 10/02/22.
//

import Foundation

struct ShareKitModel : Codable {
    let status : Int?
    let data : [ShareKitData]?
    let message : String?

    enum CodingKeys: String, CodingKey {

        case status = "status"
        case data = "data"
        case message = "message"
    }
}

struct ShareKitData : Codable {
    let id : Int?
    let name : String?
    let address : String?
    let photo : String?
    let consumer_id : Int?

    enum CodingKeys: String, CodingKey {

        case id = "id"
        case name = "name"
        case address = "address"
        case photo = "photo"
        case consumer_id = "consumer_id"
    }
}

struct PostShareKitModel : Codable {
    let status : Int?
    let data : SharekitData?
    let message : String?

    enum CodingKeys: String, CodingKey {

        case status = "status"
        case data = "data"
        case message = "message"
    }
}
struct SharekitData : Codable {

}

//
//  LoginModel.swift
//  Back2Life
//
//  Created by Bright on 14/07/21.
//

import Foundation


struct LoginModel : Codable {
    let status : Int?
    let data : loginData?
    let message : String?

    enum CodingKeys: String, CodingKey {
        case status = "status"
        case data = "data"
        case message = "message"
    }
}

struct loginData : Codable {
    let otp : Int?

    enum CodingKeys: String, CodingKey {
      case otp = "otp"
    }
}

struct UserProfileModel: Codable {
    let status: Int?
    let data: UserData?
    let message: String?
}

// MARK: - DataClass
struct UserData: Codable {
    let id : Int?
    let consumer_id : Int?
    let name : String?
    let address : String?
    let pin_code : String?
    let state : String?
    let dob : String?
    let gender : String?
    let id_card : String?
    let photo : String?
    let fcm_token : String?
    let consumer_lat : String?
    let consumer_long : String?
    let phone : String?
    let booking_status : Bool?
    let tester_id : Int?
    let booking_id : Int?
    let tester_number : String?

    enum CodingKeys: String, CodingKey {
        case id = "id"
        case consumer_id = "consumer_id"
        case name = "name"
        case address = "address"
        case pin_code = "pin_code"
        case state = "state"
        case dob = "dob"
        case gender = "gender"
        case id_card = "id_card"
        case photo = "photo"
        case fcm_token = "fcm_token"
        case consumer_lat = "consumer_lat"
        case consumer_long = "consumer_long"
        case phone = "phone"
        case booking_status = "booking_status"
        case tester_id = "tester_id"
        case booking_id = "booking_id"
        case tester_number = "tester_number"

    }
}

//
//  VerifyOtpModel.swift
//  Back2Life
//
//  Created by Bright on 14/07/21.
//

import Foundation

struct VerifyOtpModel : Codable {
    let status : Int?
    let data : VerifyOtpData?
    let message : String?

    enum CodingKeys: String, CodingKey {
        case status = "status"
        case data = "data"
        case message = "message"
    }
}

struct VerifyOtpData : Codable {
    let token : String?

    enum CodingKeys: String, CodingKey {
       case token = "token"
    }
}


//
//  CreateTicketModel.swift
//  Back2Life
//
//  Created by Ios Mac on 21/03/22.
//

import Foundation
struct CreateTicketModel : Codable {
    let status : Int?
    let data : CreateTicketData?
    let message : String?

    enum CodingKeys: String, CodingKey {

        case status = "status"
        case data = "data"
        case message = "message"
    }

}

struct CreateTicketData : Codable {


}

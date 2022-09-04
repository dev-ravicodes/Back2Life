//
//  ReportStatusModel.swift
//  Back2Life
//
//  Created by Mohini's Mac on 07/10/21.
//

import Foundation
//ReportStatusModel

struct ReportStatusModel : Codable {
    let status : Int?
    let data : ReportStatusData?
    let message : String?

    enum CodingKeys: String, CodingKey {

        case status = "status"
        case data = "data"
        case message = "message"
    }
}

struct ReportStatusData : Codable {
    let user_data : [User_data]?
    let booking_data : [Booking_data]?
    let payment_data : [String]?
    let report_Data : [Report_Data]?
    let report_info : report_info?
    
    
    enum CodingKeys: String, CodingKey {

        case user_data = "user_data"
        case booking_data = "booking_data"
        case payment_data = "payment_data"
        case report_Data = "report_Data"
        case report_info = "report_info"
    }
}
struct Booking_data : Codable {
    let id : Int?
    let address : String?
    let date : String?
    let time : String?
    let test_data : Test_data?
    let booking_info : [booking_info]?
    let consumer_id : Int?
    let tester_id : Int?
    let status : String?
    let phone : String?
    
    enum CodingKeys: String, CodingKey {

        case id = "id"
        case address = "address"
        case date = "date"
        case time = "time"
        case test_data = "test_data"
        case booking_info = "booking_info"
        case consumer_id = "consumer_id"
        case tester_id = "tester_id"
        case status = "status"
        case phone = "phone"
    }
}


struct Payment_data : Codable {
    let id : Int?
    let booking_id : Int?
    let transaction_id : String?
    let consumer_id : Int?
    let transaction_type : String?
    let transaction_status : String?
    let transaction_amount : String?
    
}
struct Report_Data : Codable {
    let id : Int?
    let result : String?
    let tester_id : String?
    let order_id : Int?
    let consumer_id : Int?
    let user_name : String?
    let user_id_card : String?
    let kits_photo : String?
    let report_date : String?
    let status : String?
    
    enum CodingKeys: String, CodingKey {

        case id = "id"
        case result = "result"
        case tester_id = "tester_id"
        case order_id = "order_id"
        case consumer_id = "consumer_id"
        case user_name = "user_name"
        case user_id_card = "user_id_card"
        case kits_photo = "kits_photo"
        case report_date = "report_date"
        case status = "status"
    }
}
struct User_data : Codable {
    let consumer_id : Int?
    let phone : String?
    let otp : String?
    let id : Int?
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
    
    enum CodingKeys: String, CodingKey {

        case consumer_id = "consumer_id"
        case phone = "phone"
        case otp = "otp"
        case id = "id"
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
    }
}
struct Test_data : Codable {
    let id : Int?
    let name : String?
    let price : String?
    let number : Int?
    
    enum CodingKeys: String, CodingKey {

        case id = "Id"
        case name = "Name"
        case price = "Price"
        case number = "number"
    }
}

struct report_info : Codable {
    let id : Int?
    let result : String?
    let tester_id : String?
    let order_id : Int?
    let consumer_id : Int?
    let user_name : String?
    let user_id_card : String?
    let kits_photo : String?
    let report_date : String?
    let status : String?
    
    enum CodingKeys: String, CodingKey {

        case id = "id"
        case result = "result"
        case tester_id = "tester_id"
        case order_id = "order_id"
        case consumer_id = "consumer_id"
        case user_name = "user_name"
        case user_id_card = "user_id_card"
        case kits_photo = "kits_photo"
        case report_date = "report_date"
        case status = "status"
    }
}

struct booking_info : Codable {
    let user_name : String?
    let user_id_card : String?
    let kits_photo : String?
    
    enum CodingKeys: String, CodingKey {

        case user_name = "user_name"
        case user_id_card = "user_id_card"
        case kits_photo = "kits_photo"
    }

}

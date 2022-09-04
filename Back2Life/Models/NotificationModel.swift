//
//  NotificationModel.swift
//  Back2Life
//
//  Created by Mohini's Mac on 07/10/21.
//

import Foundation
//NotificationModel
struct NotificationModel : Codable {
    let status : Int?
    let data : [NotificationData]?
    let message : String?
}

struct NotificationData : Codable {
    let id : Int?
    let notification_text : String?
    let consumer_id : Int?
  //  let tester_id : Int?
    let booking_id : Int?
    let created_at : String?
    let name : String?
    let photo : String?
    let dob : String?
   // let id_card : String?
    let order_id : Int?
    let report_id : Int?
    let notification_for : Bool?
    let testerInfo : TesterInfo?
    let test_data : Test_Data?
}
struct Test_Data : Codable {
    let Name : String?
}

struct TesterInfo : Codable {
    let id : Int?
    let name : String?
    let number : String?
    let gender : String?
    let dob : String?
    let id_code : String?
    let photo : String?
    let otp : String?
    let license_photo : String?
    let license_number : String?
    let country : String?
    let fcmToken : String?
    let latitude : String?
    let longitude : String?
    let online_status : String?
}

struct GetOrderListing : Codable {
    let status : Int?
    let data : [orderListingData]?
    let message : String?

    enum CodingKeys: String, CodingKey {

        case status = "status"
        case data = "data"
        case message = "message"
    }
}

struct orderListingData : Codable {
    let id : Int?
    let name : String?
    let address : String?
    let postCode : String?
    let city : String?
    let phoneNumber : String?
    let photo : String?
    let consumer_id : Int?
    let number_of_kits : Int?
    let test_data_info : TestDataInfo?

    enum CodingKeys: String, CodingKey {

        case id = "id"
        case name = "name"
        case address = "address"
        case postCode = "postCode"
        case city = "city"
        case phoneNumber = "phoneNumber"
        case photo = "photo"
        case consumer_id = "consumer_id"
        case number_of_kits = "number_of_kits"
        case test_data_info = "test_data_info"
    }
}

struct TestDataInfo : Codable {
    let number : Int?
    let name : String?
    let price : String?
    let id : Int?

    enum CodingKeys: String, CodingKey {

        case number = "number"
        case name = "Name"
        case price = "Price"
        case id = "Id"
    }
}

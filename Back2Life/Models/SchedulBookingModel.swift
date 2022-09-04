//
//  SchedulBookingModel.swift
//  Back2Life
//
//  Created by Mohini's Mac on 06/10/21.
//

import Foundation

struct OrderListingModel : Codable {
    let status : Int?
    let data : [OrderListingData]?
    let message : String?
}
struct OrderListingData : Codable {
    let id: Int?
    let name: String?
    let address: String?
    let postCode: String?
    let city: String?
    let phoneNumber: String?
    let photo: String?
    let consumer_id: Int?
    let number_of_kits: Int?
    let test_data_info:test_data_info?
}
struct test_data_info: Codable {
    let Price: String?
    let Name: String?
    let Id: Int?
    let number: Int?
}


struct SchedulBookingModel : Codable {
    let status : Int?
    let data : [ScheduleBookingData]?
    let message : String?
}
struct ScheduleBookingData : Codable {
    let id : Int?
    let address : String?
    let booking_info : [Booking_info]?
    let date : String?
    let time : String?
    let status : String?
    let postalCode : String?
    let phone : String?
    let city : String?
    let consumer_id : Int?
    let tester_id : Int?
    let order : Order?
    let test_data_info : String?
    let consumerProfile : ConsumerProfile?
    let tester : Tester?
    
}

struct Booking_info : Codable {
    let user_name : String?
    let user_id_card : String?
    let kits_photo : String?
}

struct Order : Codable {
    let id : Int?
    let name : String?
    let address : String?
    let postCode : String?
    let city : String?
    let phoneNumber : String?
    let photo : String?
    let consumer_id : Int?
    let number_of_kits : Int?
    let number_of_kits_remaining : Int?
    let test_data_info : String?
    let status : String?
}

struct BookingPayment : Codable {
    let id : Int?
    let booking_id : Int?
    let transaction_id : String?
    let consumer_id : Int?
    let transaction_type : String?
    let transaction_status : String?
    let transaction_amount : String?
    
}
struct Tester : Codable {
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

struct ConsumerProfile : Codable {
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
}

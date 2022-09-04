//
//  WelcomeScreenModel.swift
//  Back2Life
//
//  Created by Bright on 15/07/21.
//

import Foundation


struct WelcomeScreenModel : Codable {
    let status : Int?
    let data : [welcomeData]?
    let message : String?

    enum CodingKeys: String, CodingKey {

        case status = "status"
        case data = "data"
        case message = "message"
    }
}

struct welcomeData : Codable {
    let iD : Int?
    let nAME : String?
    let type : [Type]?

    enum CodingKeys: String, CodingKey {

        case iD = "ID"
        case nAME = "NAME"
        case type = "Type"
    }
}

struct Type : Codable {
    let id : Int?
    let name : String?
    let payment : [Payment]?

    enum CodingKeys: String, CodingKey {

        case id = "Id"
        case name = "Name"
        case payment = "payment"
    }
}

struct Payment : Codable {
    let id : Int?
    let name : String?
    let price : String?

    enum CodingKeys: String, CodingKey {

        case id = "Id"
        case name = "Name"
        case price = "Price"
    }
}


struct CustomerProfilePost : Codable {
    let status : Int?
    let data : postData?
    let message : String?

    enum CodingKeys: String, CodingKey {

        case status = "status"
        case data = "data"
        case message = "message"
    }
}

struct postData : Codable {

}


struct GetCustomerProfilePost : Codable {
    let status : Int?
    let data : getPostData?
    let message : String?

    enum CodingKeys: String, CodingKey {

        case status = "status"
        case data = "data"
        case message = "message"
    }
}

struct getPostData : Codable {
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
    }

}


struct BookingPost : Codable {
    let status : Int?
    let data : BookingData?
    let message : String?
    
    enum CodingKeys: String, CodingKey {

        case status = "status"
        case data = "data"
        case message = "message"
    }

}

struct BookingData : Codable {
    let bookingId : Int?
    let order_id : Int?
    enum CodingKeys: String, CodingKey {
        case order_id = "order_id"
        case bookingId = "bookingId"
    }
}


struct SavePayment : Codable {
    let status : Int?
    let data : savePaymentData?
    let message : String?

    enum CodingKeys: String, CodingKey {

        case status = "status"
        case data = "data"
        case message = "message"
    }
}

struct savePaymentData : Codable {
    let booking_id : Int?

    enum CodingKeys: String, CodingKey {

        case booking_id = "booking_id"
    }

}


struct UploadImageModel : Codable {
    let status : Int?
    let data : UploadData?
    let message : String?

    enum CodingKeys: String, CodingKey {

        case status = "status"
        case data = "data"
        case message = "message"
    }
}

struct UploadData : Codable {
    let image : [String]?

    enum CodingKeys: String, CodingKey {

        case image = "image"
    }
}

struct GetTester : Codable {
    let status : Int?
    let data : GetTesterLatLongData?
    let message : String?

    enum CodingKeys: String, CodingKey {

        case status = "status"
        case data = "data"
        case message = "message"
    }
}

struct GetTesterLatLongData : Codable {
    let latitude : String?
    let longitude : String?

    enum CodingKeys: String, CodingKey {

        case latitude = "latitude"
        case longitude = "longitude"
    }

}






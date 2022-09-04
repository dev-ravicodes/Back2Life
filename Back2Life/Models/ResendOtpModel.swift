//
//  ResendOtpModel.swift
//  Back2Life
//
//  Created by Bright on 14/07/21.
//

import Foundation

// MARK: - LoginModel
struct ResendOtpModel: Codable {
    let status: Int
    let data: DataClass
    let message: String
    let body: Body
}

// MARK: - Body
struct Body: Codable {
    let otp: Int
}

// MARK: - DataClass
struct DataClass: Codable {
}

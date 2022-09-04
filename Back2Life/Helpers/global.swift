//
//  global.swift
//  
//
//  Created by mac on 08/11/19.
//  Copyright © 2019 mac. All rights reserved.
//

import Foundation
import CoreLocation

enum MimeType:String
{
    case png,sticker = "image/png"
    case jpg = "image/jpeg"
    case gif = "image/gif"
    case video = "image/video"
}
struct GlobalVariable
{
    static var selectUserType : String! //--- "family" or "driver"
  
    static var user_lat : CLLocationDegrees!
    static var user_long : CLLocationDegrees!
 
  
    static var notification_dict = NSDictionary()
 
}





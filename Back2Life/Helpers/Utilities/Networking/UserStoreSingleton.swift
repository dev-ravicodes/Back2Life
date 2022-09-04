//
//  UserStoreSingleton.swift
//  IsApp
//
//  Created by BrightRootsMohini on 4/1/20.
//  Copyright © 2020 BrightRootsMohini. All rights reserved.
//

import Foundation
import UIKit


class UserStoreSingleton: NSObject{
    static let shared = UserStoreSingleton()
    private override init() {}
    
    var userlat: Double?
    var userLong: Double?
    
    var isLoggedIn : Bool?{
        get{
            return (UserDefaults().object(forKey: "isLoggedIn") as? Bool)
        }set{
            UserDefaults.standard.setValue(newValue, forKey: "isLoggedIn")
        }
    }
    var userType : String?{
        get{
            return (UserDefaults().object(forKey: "userType") as? String)
        }set{
            UserDefaults.standard.setValue(newValue, forKey: "userType")
        }
    }
    var userToken : String?{
        get{
            return (UserDefaults().object(forKey: "userToken") as? String)
        }set{
            UserDefaults.standard.setValue(newValue, forKey: "userToken")
        }
    }
    var phoneNumer : String?{
        get{
            return (UserDefaults().object(forKey: "phoneNumer") as? String)
        }set{
            UserDefaults.standard.setValue(newValue, forKey: "phoneNumer")
        }
    }
    var profileImage : String?{
        get{
            return (UserDefaults().object(forKey: "profileImage") as? String)
        }set{
            UserDefaults.standard.setValue(newValue, forKey: "profileImage")
        }
    }
    var name : String?{
        get{
            return (UserDefaults().object(forKey: "name") as? String)
        }set{
            UserDefaults.standard.setValue(newValue, forKey: "name")
        }
    }
    var cityState : String?{
        get{
            return (UserDefaults().object(forKey: "cityState") as? String)
        }set{
            UserDefaults.standard.setValue(newValue, forKey: "cityState")
        }
    }
    var userID : Int?{
        get{
            return (UserDefaults().object(forKey: "userID") as? Int)
        }set{
            UserDefaults.standard.setValue(newValue, forKey: "userID")
        }
    }
    var email : String?{
        get{
            return (UserDefaults().object(forKey: "email") as? String)
        }set{
            UserDefaults.standard.setValue(newValue, forKey: "email")
        }
    }
    var kitsName : String?{
        get{
            return (UserDefaults().object(forKey: "kitsName") as? String)
        }set{
            UserDefaults.standard.setValue(newValue, forKey: "kitsName")
        }
    }
    var OtpCode : Int?{
        get{
            return (UserDefaults().object(forKey: "Otp") as? Int)
        }set{
            UserDefaults.standard.setValue(newValue, forKey: "Otp")
        }
    }
    
    var currentLat : Double?{
        get{
            return (UserDefaults().object(forKey: "currentLat") as? Double)
        }set{
            UserDefaults.standard.setValue(newValue, forKey: "currentLat")
        }
    }
    var currentLong : Double?{
        get{
            return (UserDefaults().object(forKey: "currentLong") as? Double)
        }set{
            UserDefaults.standard.setValue(newValue, forKey: "currentLong")
        }
    }
    
    var currenBookingtLat : Double?{
        get{
            return (UserDefaults().object(forKey: "currenBookingtLat") as? Double)
        }set{
            UserDefaults.standard.setValue(newValue, forKey: "currenBookingtLat")
        }
    }
    var currenBookingtLong : Double?{
        get{
            return (UserDefaults().object(forKey: "currenBookingtLong") as? Double)
        }set{
            UserDefaults.standard.setValue(newValue, forKey: "currenBookingtLong")
        }
    }
    var bookingID : Int?{
          get{
              return (UserDefaults().object(forKey: "bookingID") as? Int)
          }set{
              UserDefaults.standard.setValue(newValue, forKey: "bookingID")
          }
      }
    var order_id : Int?{
          get{
              return (UserDefaults().object(forKey: "order_id") as? Int)
          }set{
              UserDefaults.standard.setValue(newValue, forKey: "order_id")
          }
      }
      
     var fcmToken : String?{
           get{
               return (UserDefaults().object(forKey: "fcmToken") as? String)
           }set{
               UserDefaults.standard.setValue(newValue, forKey: "fcmToken")
           }
       }
    
    var userRating : Double?{
        get{
            return (UserDefaults().object(forKey: "userRating") as? Double)
        }set{
            UserDefaults.standard.setValue(newValue, forKey: "userRating")
        }
    }
    var PostalCode : String?{
          get{
              return (UserDefaults().object(forKey: "PostalCode") as? String)
          }set{
              UserDefaults.standard.setValue(newValue, forKey: "PostalCode")
          }
      }
    
    var Address : String?{
          get{
              return (UserDefaults().object(forKey: "Address") as? String)
          }set{
              UserDefaults.standard.setValue(newValue, forKey: "Address")
          }
      }
    var realEstateLicenseNumber : String?{
          get{
              return (UserDefaults().object(forKey: "realEstateLicenseNumber") as? String)
          }set{
              UserDefaults.standard.setValue(newValue, forKey: "realEstateLicenseNumber")
          }
      }
    var mailingAddress : String?{
          get{
              return (UserDefaults().object(forKey: "mailingAddress") as? String)
          }set{
              UserDefaults.standard.setValue(newValue, forKey: "mailingAddress")
          }
      }
    var is24HourFormat : Bool?{
        get{
            return (UserDefaults().object(forKey: "is24HourFormat") as? Bool)
        }set{
            UserDefaults.standard.setValue(newValue, forKey: "is24HourFormat")
        }
    }
    var isPayPal : Bool?{
        get{
            return (UserDefaults().object(forKey: "isPayPal") as? Bool)
        }set{
            UserDefaults.standard.setValue(newValue, forKey: "isPayPal")
        }
    }
    var appleEmail : String?{
        get{
            return (UserDefaults().object(forKey: "appleEmail") as? String)
        }set{
            UserDefaults.standard.setValue(newValue, forKey: "appleEmail")
        }
    }
    var brokerageType : String?{
        get{
            return (UserDefaults().object(forKey: "brokerageType") as? String)
        }set{
            UserDefaults.standard.setValue(newValue, forKey: "brokerageType")
        }
    }
}


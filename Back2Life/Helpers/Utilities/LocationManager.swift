//
//  LocationManager.swift
//  ShakoMako
//
//  Created by Mohini's Mac on 15/04/21.
//  Copyright © 2021 ShakoMako. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation


public protocol LocationManagerDelegate : AnyObject{
    func currentLocation(coordinates : CLLocationCoordinate2D)
}


open class LocationManager : NSObject{
    var locationDelegate : LocationManagerDelegate?
    private var locationManager = CLLocationManager()
    private var presentationController : UIViewController?
    static let shared = LocationManager()
        
    public init(controller : UIViewController,locationDelegate : LocationManagerDelegate) {
        super.init()
        self.locationDelegate = locationDelegate
        self.locationManager.delegate = self
        self.locationManager.requestLocation()
        self.locationManager.requestWhenInUseAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.presentationController = controller
    }
    public override init() {}
    func stopUpdatingLocations(){
        self.locationManager.stopUpdatingLocation()
    }
}

extension LocationManager : CLLocationManagerDelegate{
    public func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let loc = locations.last{
            self.locationDelegate?.currentLocation(coordinates: loc.coordinate)
            self.locationManager.stopUpdatingLocation()
        }
    }
    public func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        print(status)
        switch status {
        case .authorizedAlways,.authorizedWhenInUse:
            self.locationManager.startUpdatingLocation()
            break
        case .notDetermined:
            self.locationManager.requestLocation()
            self.locationManager.requestWhenInUseAuthorization()
        default:
            self.locationManager.stopUpdatingLocation()
            let aC = UIAlertController(title: "Location is turned off", message: "Please enable the location from privacy section ", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "Open", style: .default) { (clicked) in
                self.presentationController?.OpenSettings()
            }
            aC.addAction(okAction)
            self.presentationController?.present(aC, animated: true, completion: nil)
            break
        }
    }
    public func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error.localizedDescription)
    }
}

extension UIViewController{
    func OpenSettings() {
        if let url = URL(string: UIApplication.openSettingsURLString) {
            UIApplication.shared.open(url, options: [:], completionHandler: { _ in
                // Handle
            })
        }
    }
}

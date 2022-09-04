//
//  MapLocationViewController.swift
//  Back2Life
//
//  Created by Arzoo Mac on 26/08/21.
//

import UIKit
import GooglePlaces
import CoreLocation
import GoogleMaps

class MapLocationViewController: UIViewController {

    
    @IBOutlet var mapView: GMSMapView!
    @IBOutlet var pinImage: UIImageView!
    
    
    var GoogleMapView:GMSMapView!
    var geoCoder :CLGeocoder!
    
   

    public var longitude:Double = 77.38066792488098
    public var latitude:Double = 28.6517752463408
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.SetUpMap()
           geoCoder = CLGeocoder()
    }
    
    func SetUpMap(){
        let camera = GMSCameraPosition.camera(withLatitude:self.latitude, longitude: self.longitude, zoom: 12)
           
           // self.mapView.bringSubviewToFront(pinImage)
        }
    
    func mapView(_ mapView: GMSMapView, idleAt position: GMSCameraPosition) {
            
            let lat = position.target.latitude
            let lng = position.target.longitude
            
            // Create Location
            let location = CLLocation(latitude: lat, longitude: lng)
            
            // Geocode Location
            geoCoder.reverseGeocodeLocation(location) { (placemarks, error) in
                if let placemarks = placemarks{
                    if let location = placemarks.first?.location{
                        //self.addressTextField.text = (placemarks.first?.name ?? "")+" "+(placemarks.first?.subLocality ?? " ")
                        if let addressDict = (placemarks.first?.addressDictionary as? NSDictionary){
//                            let dict = JSON(addressDict)
//                            self.cityTextField.text = dict["City"].stringValue
//                            var address:String = ""
//                            for data in dict["FormattedAddressLines"].arrayValue{
//                                address = address+" "+data.stringValue
//                            }
                                        
                         // here you will get the Address.
     
     
                        }
                    }
                }
            
            }
        }

}

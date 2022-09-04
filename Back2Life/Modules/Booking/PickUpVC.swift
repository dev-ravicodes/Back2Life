//
//  PickUpVC.swift
//
//
//  Created by MAC on 08/11/19.
//  Copyright © 2019 MAC. All rights reserved.
//

import UIKit
import GoogleMaps
import CoreLocation
//import Alamofire
import NVActivityIndicatorView

class PickUpVC: UIViewController,CLLocationManagerDelegate,NVActivityIndicatorViewable
{
    @IBOutlet weak var addressTextField: UITextField!
    @IBOutlet weak var mapVW: GMSMapView!
    let locationManager : CLLocationManager = CLLocationManager()
    var searchController : UISearchController!
    var tappedMarker = GMSMarker()
    
    @IBOutlet weak var CircleView: UIView!
    var Addressxx: [String] = [""]
    var location : String!
    var address : String!
    var updated_lat : CLLocationDegrees!
    var updated_long : CLLocationDegrees!
    var CameraPositionupdated_lat : CLLocationDegrees!
    var CameraPositionupdated_long : CLLocationDegrees!
    
    var centerMapCoordinate:CLLocationCoordinate2D!
    var update : GMSCameraUpdate!
    var cirlce: GMSCircle!
    var theCenter : CGPoint!
    let insets = UIEdgeInsets(top: 50, left: 50, bottom: 50, right: 50)
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        theCenter =   CircleView.center
        print(theCenter!)
        print("activityIndicator.center before  = \(CircleView.center.x) x \(CircleView.center.y)")
        CircleView.center = view.center
        print("activityIndicator.center after  = \(CircleView.center.x) x \(CircleView.center.y)")
        determineMyCurrentLocation()
    }
    
    func determineMyCurrentLocation()
    {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        mapVW.settings.myLocationButton = true
        mapVW.settings.compassButton = true
        mapVW.settings.zoomGestures = true
        mapVW.delegate = self
        mapVW.isMyLocationEnabled = true
        
        if CLLocationManager.locationServicesEnabled()
        {
            locationManager.startUpdatingLocation()
        }
    }
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation])
    {
        mapVW.clear()
        let userLocation:CLLocation = locations[0] as CLLocation
        locationManager.stopUpdatingLocation()
        
        print("user latitude = \(userLocation.coordinate.latitude)")
        print("user longitude = \(userLocation.coordinate.longitude)")
        
        UserStoreSingleton.shared.userlat = userLocation.coordinate.latitude
        UserStoreSingleton.shared.userLong = userLocation.coordinate.longitude
        let start_position = CLLocationCoordinate2D(latitude: UserStoreSingleton.shared.userlat! , longitude:  UserStoreSingleton.shared.userLong!)
        let marker = GMSMarker(position: start_position)
      //  marker.map = mapVW
      //  mapVW.selectedMarker = marker;
        mapVW.selectedMarker?.isTappable = false
        
        
        let camera = GMSCameraPosition.camera(withLatitude: UserStoreSingleton.shared.userlat!, longitude: UserStoreSingleton.shared.userLong!, zoom: 15)
        mapVW.camera = camera
        mapVW.camera = camera
       
        let reverseGeoCoder = GMSGeocoder()
        let coordinate = CLLocationCoordinate2DMake(userLocation.coordinate.latitude, userLocation.coordinate.longitude)
        reverseGeoCoder.reverseGeocodeCoordinate(coordinate, completionHandler: {(placeMark, error) -> Void in
            if error == nil {
                if let placeMarkObject = placeMark {
                    if placeMarkObject.results()!.count > 0
                    {
                        self.Addressxx = (placeMarkObject.firstResult()?.lines)!
                        print(self.Addressxx)
                        
                        self.address = self.Addressxx[0]
                        //  self.addressTextField.text = self.address
                        self.location = self.Addressxx[0]
                        self.addressTextField.text = self.location
                        UserStoreSingleton.shared.Address = self.addressTextField.text
                        
                     //   UserStoreSingleton.shared.PostalCode = self.Addressxx[1]
                    } else {
                        //Do Nothing
                    }
                } else {
                    //Do Nothing
                }
            } else {
                print(error?.localizedDescription)
            }
        })
        
    }
    
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error)
    {
        print("Error \(error)")
    }
    
    
    func convertAddress()
    {
        let reverseGeoCoder = GMSGeocoder()
        let coordinate = CLLocationCoordinate2DMake(CameraPositionupdated_lat!, CameraPositionupdated_long!)
        reverseGeoCoder.reverseGeocodeCoordinate(coordinate, completionHandler: {(placeMark, error) -> Void in
            if error == nil {
                if let placeMarkObject = placeMark {
                    if placeMarkObject.results()!.count > 0
                    {
                        self.Addressxx = (placeMarkObject.firstResult()?.lines)!
                        print(self.Addressxx)
                        
                        self.address = self.Addressxx[0]
                        //  self.addressTextField.text = self.address
                        self.location = self.Addressxx[0]
                        self.addressTextField.text = self.location
                        UserStoreSingleton.shared.Address = self.addressTextField.text
                        UserStoreSingleton.shared.PostalCode = placeMarkObject.firstResult()?.postalCode
                        
                    } else {
                        //Do Nothing
                    }
                } else {
                    //Do Nothing
                }
            } else {
                print(error?.localizedDescription)
            }
        })
        
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func handleCont(_ sender: Any)  {
        self.navigationController?.popViewController(animated: true)
        //dismiss(animated: true, completion: nil)
    }
    
    @IBAction func back_btn(_ sender: Any)
    {
        self.navigationController?.popViewController(animated: true)
    }
    
}


extension PickUpVC : GMSMapViewDelegate
{
    func mapView(_ mapView: GMSMapView, didTapInfoWindowOf marker: GMSMarker)
    {
        print("didTapInfoWindowOf")
        
    }
    
    func mapView(_ mapView: GMSMapView, didLongPressInfoWindowOf marker: GMSMarker)
    {
        print("didLongPressInfoWindowOf")
    }
    
    
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool
    {
        
        return false
    }
    
    func mapView(_ mapView: GMSMapView, didChange position: GMSCameraPosition)
    {
        CameraPositionupdated_lat = mapView.camera.target.latitude
        CameraPositionupdated_long = mapView.camera.target.longitude
        print("kado\(String(describing: CameraPositionupdated_lat))\(String(describing: CameraPositionupdated_long))")
        UserStoreSingleton.shared.currenBookingtLat = CameraPositionupdated_lat
        UserStoreSingleton.shared.currenBookingtLong =  CameraPositionupdated_long
        convertAddress()
        
        //   centerMapCoordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        print("kadoy\(String(describing: centerMapCoordinate))")
        //  self.placeMarkerOnCenter(centerMapCoordinate:centerMapCoordinate)
    }
    func placeMarkerOnCenter(centerMapCoordinate:CLLocationCoordinate2D) {
        let marker = GMSMarker()
        //  marker.position = centerMapCoordinate
        //  marker.map = self.mapVW
    }
    func mapView(mapView: GMSMapView, didChangeCameraPosition position: GMSCameraPosition){
        let lat = mapView.camera.target.latitude
        print(lat)
        
        let lon = mapView.camera.target.longitude
        print(lon)
        
    }
    
    
    
    
    
    
    func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D)
    {
        mapVW.clear()
        let position = CLLocationCoordinate2D(latitude: coordinate.latitude, longitude: coordinate.longitude)
        let marker = GMSMarker(position: position)
        marker.map = mapVW
        let camera = GMSCameraPosition.camera(withLatitude: coordinate.latitude, longitude: coordinate.longitude, zoom: 15)
        mapVW.camera = camera
        let circleCenter : CLLocationCoordinate2D  = CLLocationCoordinate2DMake(coordinate.latitude,coordinate.longitude);
        
        let circ = GMSCircle(position: circleCenter, radius: CLLocationDistance(1000))
        //    circ.fillColor = UIColor(red: 0.35, green: 0, blue: 0, alpha: 0.05)
        
        //  circ.strokeColor = UIColor.red
        // circ.strokeWidth = 1
        //  circ.map = self.mapVW;
        // circ.isTappable = true;
        //  update = GMSCameraUpdate.fit(circ.bounds())
        // mapVW.animate(with: update)
        
        self.updated_lat = coordinate.latitude
        self.updated_long = coordinate.longitude
        
        
        let reverseGeoCoder = GMSGeocoder()
        let coordinate = CLLocationCoordinate2DMake(self.updated_lat!, self.updated_long!)
        reverseGeoCoder.reverseGeocodeCoordinate(coordinate, completionHandler: {(placeMark, error) -> Void in
            if error == nil {
                if let placeMarkObject = placeMark {
                    if placeMarkObject.results()!.count > 0
                    {
                        self.Addressxx = (placeMarkObject.firstResult()?.lines)!
                        print(self.Addressxx)
                        
                        self.address = self.Addressxx[0]
                        
                        self.location = self.Addressxx[0]
                    } else {
                        //Do Nothing
                    }
                } else {
                    //Do Nothing
                }
            } else {
                print(error?.localizedDescription)
            }
        })
    }
}


//extension GMSCircle {
//func bounds () -> GMSCoordinateBounds {
//    func locationMinMax(_ positive : Bool) -> CLLocationCoordinate2D {
//        let sign: Double = positive ? 1 : -1
//        let dx = sign * self.radius  / 6378000 * (180 / .pi)
//        let lat = position.latitude + dx
//        let lon = position.longitude + dx / cos(position.latitude * .pi / 180)
//        return CLLocationCoordinate2D(latitude: lat, longitude: lon)
//    }
//
//    return GMSCoordinateBounds(coordinate: locationMinMax(true),
//                           coordinate: locationMinMax(false))
//}
//}

//class Circle: UIView {
//    var strokeColor: UIColor
//    var fillColor: UIColor
//    init(frame: CGRect, strokeColor: UIColor, fillColor: UIColor = .clear) {
//        self.strokeColor = strokeColor
//        self.fillColor = fillColor
//        super.init(frame: frame)
//    }
//
//    required init?(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//    override func draw(_ rect: CGRect) {
//        let circlePath = UIBezierPath(arcCenter: CGPoint(x: frame.width / 2, y: frame.height / 2), radius: frame.height / 2, startAngle: CGFloat(0), endAngle: CGFloat.pi * 2, clockwise: true)
//        strokeColor.setStroke()
//        fillColor.setFill()
//        circlePath.lineWidth = 1
//        circlePath.stroke()
//    }
//
//}
//
//
//let circle = Circle(frame: CGRect(x: 0, y: 0, width: 100, height: 100), strokeColor: .red, fillColor: .blue)

//
//  PopReceivedBookingViewController.swift
//  Back2Life
//
//  Created by Sachin Kumar on 22/05/21.
//  Copyright © 2021 Sachin Kumar. All rights reserved.
//

import UIKit
import GooglePlaces
import CoreLocation
import GoogleMaps

class PopReceivedBookingViewController: UIViewController {
    
    //MARK: - Interface Builder Outlets
    
    @IBOutlet weak var mapView: GMSMapView!
    
    var locationManager = CLLocationManager()
    var myLocations: [CLLocation] = []
    let marker = GMSMarker()
    //MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationItem.hidesBackButton = true

        loadMapView()
        self.applyFinishingTouchesToUIElements()
    }
    
    
    @IBAction func weitterAction(_ sender: Any) {
        navigate(.qrbutton)
    }
    
    //MARK: - Helpers
    private func applyFinishingTouchesToUIElements() {
        //  mainView.layer.cornerRadius = 18.0
    }
    
    // MARK: - Layout
    func loadMapView() {
        locationManager.requestWhenInUseAuthorization()
        locationManager.delegate = self
        self.mapView?.isMyLocationEnabled = true

         //Location Manager code to fetch current location
        self.locationManager.startUpdatingLocation()
     }
}

// MARK: - CLLocationManagerDelegate


extension PopReceivedBookingViewController: CLLocationManagerDelegate {
  
  func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
    
    guard status == .authorizedWhenInUse else {
      return
    }
    
    locationManager.startUpdatingLocation()
    mapView.isMyLocationEnabled = true
    mapView.settings.myLocationButton = true
  }
  
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let newLocation = locations.last // find your device location
        mapView.camera = GMSCameraPosition.camera(withTarget: newLocation!.coordinate, zoom: 14.0) // show your device location on map
        mapView.settings.myLocationButton = true // show current location button
        let lat = (newLocation?.coordinate.latitude)! // get current location latitude
        let long = (newLocation?.coordinate.longitude)! //get current location longitude
        
        marker.position = CLLocationCoordinate2DMake(lat,long)
        marker.map = mapView
        print("Current Lat Long - " ,lat, long )
    }

    func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
        mapView.clear()
        DispatchQueue.main.async {
            let position = CLLocationCoordinate2D(latitude: coordinate.latitude, longitude: coordinate.longitude)
            self.marker.position = position
            self.marker.map = mapView
            self.marker.icon = UIImage(named: "location")
            print("New Marker Lat Long - ",coordinate.latitude, coordinate.longitude)
        }
    }
        func cameraMoveToLocation(toLocation: CLLocationCoordinate2D?) {
            if toLocation != nil {
                mapView.camera = GMSCameraPosition.camera(withTarget: toLocation!, zoom: 30)
            }
        }
}


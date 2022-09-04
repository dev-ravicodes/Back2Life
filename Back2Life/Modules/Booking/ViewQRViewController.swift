//
//  ViewQRViewController.swift
//  Back2Life
//
//  Created by Bright on 25/05/21.
//

import UIKit
import Designable
import GooglePlaces
import CoreLocation
import GoogleMaps

class ViewQRViewController: BaseViewController {
    
    
    @IBOutlet weak var btn_WaitTimeQrCode: UIButton!
    @IBOutlet weak var img_ReposrtStatus: UIImageView!
    @IBOutlet weak var lbl_Text: UILabel!
    @IBOutlet weak var imgQRCode: UIImageView!
    @IBOutlet weak var qrpopUpView: UIView!
    @IBOutlet weak var heartPopUp: UIView!
    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet weak var homeButton: DesignableButton!
    @IBOutlet weak var homeImg: UIImageView!
    @IBOutlet weak var phoneImg: UIImageView!
    @IBOutlet weak var callbutton: DesignableButton!
    
    
    var r_FromNoti = false
    var router : HTTPRequest<AuthenticationEndPoint>?
    var locationManager = CLLocationManager()
    var myLocations: [CLLocation] = []
    let marker = GMSMarker()
    var qrcodeImage: CIImage!
    
    var DestLatitude : String!
    var DestLongitude : String!
    
    var arrayPolyline = [GMSPolyline]()
    var selectedRought:String!
    var testerNumber: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        router = HTTPRequest<AuthenticationEndPoint>()
        loadMapView()
        addImageNav()
        qrpopUpView.isHidden = true
        heartPopUp.isHidden = true
        callbutton.isHidden = true
        phoneImg.isHidden = true
        self.navigationItem.setHidesBackButton(true, animated: true)
        
        NotificationCenter.default.addObserver(self, selector : #selector(handleNotification(n:)), name : Notification.Name("notificationData"), object : nil)
        
        if !r_FromNoti {
            ShowQRCode(report: "")
        }
        
        
        
    }
    
    func addImageNav() {
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 253, height: 100))
        imageView.contentMode = .scaleAspectFit
        let image = UIImage(named: "back_to_life_logo")
        imageView.image = image
        navigationItem.titleView = imageView
    }
    
    
    // MARK: - Layout
    func loadMapView() {
        locationManager.requestWhenInUseAuthorization()
        locationManager.delegate = self
        self.mapView?.isMyLocationEnabled = true
        
        //Location Manager code to fetch current location
        self.locationManager.startUpdatingLocation()
    }
    
    @IBAction func backAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func crossAction(_ sender: Any) {
        qrpopUpView.isHidden = true
        qrcodeImage = nil
        //heartPopUp.isHidden = false
    }
    @IBAction func heartAction(_ sender: Any) {
        navigate(.home)
    }
    
    @IBAction func callButtonAction(_ sender: Any) {
        self.callNumber(testnumber: self.testerNumber)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //NotificationCenter.default.addObserver(self, selector : #selector(handleNotification(n:)), name : Notification.Name("notificationData"), object : nil)
        if let isAccepted = UserDefaults.standard.value(forKey: "bookingAccepted") as? Bool {
            if isAccepted {
                homeButton.isHidden = true
            }
            else {
                homeButton.isHidden = false
            }
        }
        
    }
    
    //MARK:- Handle Notification
    @objc func handleNotification(n : NSNotification)
    {
        btn_WaitTimeQrCode.setTitle("ANKUNFT: 10MIN", for: .normal)
        qrpopUpView.isHidden = true
        print(GlobalVariable.notification_dict)
        print(GlobalVariable.notification_dict.value(forKey: "notification_type") as? String?)
        if GlobalVariable.notification_dict.value(forKey: "notification_type") as? String == "accept-booking" {
            let booking_id =  GlobalVariable.notification_dict.value(forKey: "bookingId") as? String
            let tester_id =  GlobalVariable.notification_dict.value(forKey: "tester_id") as? String
            DestLatitude = GlobalVariable.notification_dict.value(forKey: "tester_latitude") as? String
            DestLongitude = GlobalVariable.notification_dict.value(forKey: "tester_longitude") as? String
            callbutton.isHidden = false
            phoneImg.isHidden = false
            homeButton.isHidden = true
            homeImg.isHidden = true
            
            self.getConsumerProfile { (data) in
                if let userData = data{
                    print(userData)
                    self.testerNumber =  userData.tester_number
                    
                }
            }
            //   drawPathDirection()
            if DestLatitude == "" && DestLongitude == ""{
                
            }else{
                   //LoadMapRoute()
            }
        }else if GlobalVariable.notification_dict.value(forKey: "notification_type") as? String == "booking-verify" {
            print("")
            self.heartPopUp.isHidden = false
            
        } else if GlobalVariable.notification_dict.value(forKey: "notification_type") as? String == "cancel-booking" {
            print("")
            if let delegate = UIApplication.shared.delegate as? AppDelegate{
                delegate.setRootController()
            }
            
            
        } else if GlobalVariable.notification_dict.value(forKey: "notification_type") as? String == "booking-report-submitted" {
            print(GlobalVariable.notification_dict.value(forKey: "result"))
            if let bookingId =  GlobalVariable.notification_dict.value(forKey: "result") {
                let str = Int(bookingId as? String ?? "0")
               // navigate(.postivereport(report: str!))
            }
        }
    }
    
    func callNumber(testnumber: String?) {
        if let phoneCallURL = URL(string: "tel://\(testerNumber ?? "")") {
            let application:UIApplication = UIApplication.shared
            if (application.canOpenURL(phoneCallURL)) {
                application.open(phoneCallURL, options: [:], completionHandler: nil)
            }
        }
    }
    
    @IBAction func backToHomeAction(_ sender: Any) {
        navigate(.home)
    }
    
    @IBAction func showQrAction(_ sender: Any) {
        ShowQRCode(report: "")
    }
    
    func ShowQRCode(report: String) {
        qrpopUpView.isHidden = false
        img_ReposrtStatus.image = nil
        
        //        if report == "negative" {
        //            lbl_Text.text = "Negative"
        //            img_ReposrtStatus.image = UIImage.init(named: "negative")
        //        }
        //        else if report == "Positive" {
        //            lbl_Text.text = "Positive"
        //            img_ReposrtStatus.image = UIImage.init(named: "positive")
        //        }
        
        if qrcodeImage == nil {
            
            let qrValue = UserStoreSingleton.shared.bookingID
            let qrString: String?
            
            qrString = String(qrValue ?? 0)
            
            let data = qrString?.data(using: String.Encoding.isoLatin1, allowLossyConversion: false)
            
            let filter = CIFilter(name: "CIQRCodeGenerator")
            
            filter?.setValue(data, forKey: "inputMessage")
            filter?.setValue("Q", forKey: "inputCorrectionLevel")
            
            qrcodeImage = filter?.outputImage
            displayQRCodeImage()
            
        }
        else {
            imgQRCode.image = nil
            qrcodeImage = nil
            //  btnAction.setTitle("Generate", for: UIControl.State.normal)
        }
    }
    
    // MARK: Custom method implementation
    
    func displayQRCodeImage() {
        let scaleX = imgQRCode.frame.size.width / qrcodeImage.extent.size.width
        let scaleY = imgQRCode.frame.size.height / qrcodeImage.extent.size.height
        
        let transformedImage = qrcodeImage.transformed(by: CGAffineTransform(scaleX: scaleX, y: scaleY))
        
        imgQRCode.image = UIImage(ciImage: transformedImage)
    }
    
    func LoadMapRoute()
    {
        let origin = ("\(DestLatitude ?? ""),\(DestLongitude ?? "")")
        let destination = ("\(Double(UserStoreSingleton.shared.currentLat ?? 0.0))\(Double(UserStoreSingleton.shared.currentLong ?? 0.0))")
        let urlString = "https://maps.googleapis.com/maps/api/directions/json?origin=\(origin)&destination=\(destination)&sensor=true&key=\(ApiConstants.ProductionServer.googleAPIKey)"
        
        let url = URL(string: urlString)
        URLSession.shared.dataTask(with: url!, completionHandler:
                                    {
                                        (data, response, error) in
                                        if(error != nil)
                                        {
                                            print("error")
                                        }
                                        else
                                        {
                                            do{
                                                let json = try JSONSerialization.jsonObject(with: data!, options:.allowFragments) as! [String : AnyObject]
                                                let arrRouts = json["routes"] as! NSArray
                                                
                                                for  polyline in self.arrayPolyline
                                                {
                                                    //   polyline.map = nil;
                                                }
                                                
                                                //    self.arrayPolyline.removeAll()
                                                
                                                let pathForRought:GMSMutablePath = GMSMutablePath()
                                                
                                                if (arrRouts.count == 0)
                                                {
                                                    let distance:CLLocationDistance = CLLocation.init(latitude: Double(self.DestLatitude) ?? 0.0, longitude: Double(self.DestLongitude) ?? 0.0).distance(from: CLLocation.init(latitude: UserStoreSingleton.shared.currentLat ?? 0.0, longitude: UserStoreSingleton.shared.currentLong ?? 0.0))
                                                    
                                                    
                                                    //   pathForRought.add(self.source)
                                                    //   pathForRought.add(self.destination)
                                                    
                                                    let polyline = GMSPolyline.init(path: pathForRought)
                                                    self.selectedRought = pathForRought.encodedPath()
                                                    polyline.strokeWidth = 5
                                                    polyline.strokeColor = UIColor.systemPink
                                                    polyline.isTappable = true
                                                    
                                                    self.arrayPolyline.append(polyline)
                                                    
                                                    if (distance > 80)
                                                    {
                                                        polyline.geodesic = false
                                                    }
                                                    else
                                                    {
                                                        polyline.geodesic = true
                                                    }
                                                    
                                                    polyline.map = self.mapView;
                                                }
                                                else
                                                {
                                                    for (index, element) in arrRouts.enumerated()
                                                    {
                                                        let dicData:NSDictionary = element as! NSDictionary
                                                        
                                                        let routeOverviewPolyline = dicData["overview_polyline"] as! NSDictionary
                                                        
                                                        let path =  GMSPath.init(fromEncodedPath: routeOverviewPolyline["points"] as! String)
                                                        
                                                        let polyline = GMSPolyline.init(path: path)
                                                        
                                                        polyline.isTappable = true
                                                        
                                                        self.arrayPolyline.append(polyline)
                                                        
                                                        polyline.strokeWidth = 5
                                                        
                                                        if index == 0
                                                        {
                                                            self.selectedRought = routeOverviewPolyline["points"] as? String
                                                            
                                                            polyline.strokeColor = UIColor.blue;
                                                        }
                                                        else
                                                        {
                                                            polyline.strokeColor = UIColor.darkGray;
                                                        }
                                                        
                                                        polyline.geodesic = true;
                                                    }
                                                    
                                                    for po in self.arrayPolyline.reversed()
                                                    {
                                                        po.map = self.mapView;
                                                    }
                                                }
                                                
                                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5)
                                                {
                                                    let bounds:GMSCoordinateBounds = GMSCoordinateBounds.init(path: GMSPath.init(fromEncodedPath: self.selectedRought)!)
                                                    
                                                    self.mapView.animate(with: GMSCameraUpdate.fit(bounds))
                                                }
                                            }
                                            catch let error as NSError
                                            {
                                                print("error:\(error)")
                                            }
                                        }
                                    }).resume()
    }
    
    //MARK:- Draw PolyLine Path
    func drawPathDirection(){
        
        //  let config = URLSessionConfiguration.default
        //      let session = URLSession(configuration: config)
        
        // let url = URL(string: "\(Google_Map_Direction_Api)\(DestLatitude2 ?? ""),\(DestLongitude2 ?? "")&destination=\(DestLatitude ?? ""),\(DestLongitude ?? "")&sensor=false&mode=driving&key=\(googleApiKey)")!
        
        //   let url  =  URL(string: "https://maps.googleapis.com/maps/api/directions/json?origin=\(DestLatitude ?? ""),\(DestLongitude ?? "")&destination=\(UserStoreSingleton.shared.currentLat ?? 0.0),\( UserStoreSingleton.shared.currentLong ?? 0.0)&sensor=false&mode=driving&key=\(ApiConstants.ProductionServer.googleAPIKey)")
        
        let url = NSURL(string: "https://maps.googleapis.com/maps/api/directions/json?origin=\(18.5235),\(73.7184)&destination=\(30.721761491489826),\(76.71826713431055)&key=\(ApiConstants.ProductionServer.googleAPIKey)")
        print(url)
        let request = NSURLRequest(url: url! as URL)
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        
        let task = session.dataTask(with: request as URLRequest, completionHandler: {(data, response, error) in
                                        
                                        // notice that I can omit the types of data, response and error
                                        do{
                                            let json = try JSONSerialization.jsonObject(with: data!, options:.allowFragments) as! [String : AnyObject]
                                            let routes = json["routes"] as! NSArray
                                            self.mapView.clear()
                                            
                                            OperationQueue.main.addOperation({
                                                let route = routes[0] as! NSDictionary
                                                
                                                let routeOverviewPolyline:NSDictionary = (route ).value(forKey: "overview_polyline") as! NSDictionary
                                                let points = routeOverviewPolyline .object(forKey: "points")
                                                let path = GMSPath.init(fromEncodedPath: points! as! String)
                                                let polyline = GMSPolyline.init(path: path)
                                                polyline.strokeWidth = 3
                                                
                                                
                                                let bounds = GMSCoordinateBounds(path: path!)
                                                self.mapView!.animate(with: GMSCameraUpdate.fit(bounds, withPadding: 30.0))
                                                
                                                polyline.map = self.mapView
                                                
                                                //}
                                            })
                                        }catch let error as NSError{
                                            print("error:\(error)")
                                        }              });
        
        // do whatever you need with the task e.g. run
        task.resume()
    }
    
    func addPolyLineWithEncodedStringInMap(encodedString: String) {
        let camera = GMSCameraPosition.camera(withLatitude: 18.5204, longitude: 73.8567, zoom: 10.0)
        let mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
        mapView.isMyLocationEnabled = true
        
        let path = GMSMutablePath(fromEncodedPath: encodedString)
        let polyLine = GMSPolyline(path: path)
        polyLine.strokeWidth = 5
        polyLine.strokeColor = UIColor.yellow
        polyLine.map = mapView
        
        let smarker = GMSMarker()
        smarker.position = CLLocationCoordinate2D(latitude: 18.5235, longitude: 73.7184)
        smarker.title = "Lavale"
        smarker.snippet = "Maharshtra"
        smarker.map = mapView
        
        let dmarker = GMSMarker()
        dmarker.position = CLLocationCoordinate2D(latitude: 18.7603, longitude: 73.8630)
        dmarker.title = "Chakan"
        dmarker.snippet = "Maharshtra"
        dmarker.map = mapView
        
        view = mapView
        
    }
    
    func getTesterlatLong() {
        var request = URLRequest(url: URL(string: "http://52.14.21.106:5000/api/v1/get-tester-location/269")!,timeoutInterval: Double.infinity)
        request.addValue(UserStoreSingleton.shared.userToken ?? "", forHTTPHeaderField: "Authorization")
        request.httpMethod = "GET"
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            print(response)
            if let _data = data{
                do {
                    let json = try JSONSerialization.jsonObject(with: _data) as! Dictionary<String, AnyObject>
                    print(json)
                    if let response = json["data"] as? [[String:Any]]
                    {
                        DispatchQueue.main.async { [self] in
                            
                        }
                    }
                } catch {
                    print("error")
                }
            }
        }
        task.resume()
    }
    
}

extension ViewQRViewController: CLLocationManagerDelegate {
    
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



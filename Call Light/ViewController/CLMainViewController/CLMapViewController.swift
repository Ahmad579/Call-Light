//
//  CLMapViewController.swift
//  Call Light
//
//  Created by Ahmed Durrani on 14/04/2018.
//  Copyright © 2018 Tech Ease Solution. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import SwiftyUserDefaults
import MapKit
import CoreLocation
import SVProgressHUD


class CLMapViewController: UIViewController , UIGestureRecognizerDelegate, MKMapViewDelegate, CLLocationManagerDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    var locationManager = CLLocationManager()
    
    var row = 0
    var json: JSON = []
    var selected = 0

    var index: Int?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.delegate = self
        locationManager.delegate = self
        mapView.showsUserLocation = true
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.startUpdatingLocation()
        } else {
            locationManager.requestWhenInUseAuthorization()
        }
        
    
        SVProgressHUD.show()
        //        addAnnotations()
        getAllNurse()
        // Do any additional setup after loading the view.
    }
    
    func addAnnotations() {
        //        print ("helloWorld !")
        
        
        for index in 0...self.row {
            let annotation = MKPointAnnotation()
            let annotaoinView = MKAnnotationView()
            var lat = self.json["data"][index]["latitude"].doubleValue
            var lng = self.json["data"][index]["longitude"].doubleValue
            annotation.coordinate = CLLocationCoordinate2D(latitude: lat, longitude: lng)
            mapView.addAnnotation(annotation)
            locationManager.stopUpdatingLocation()
        }
        
        SVProgressHUD.dismiss()
    }

    func getLocation() -> CLLocationCoordinate2D {
        let locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = kCLDistanceFilterNone
        locationManager.startUpdatingLocation()
        let location: CLLocation? = locationManager.location
        //        altitude = Int(location?.altitude)
        let coordinate: CLLocationCoordinate2D? = location?.coordinate
        return coordinate!
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        var coordinate: CLLocationCoordinate2D = getLocation()
        //        print ("latitude: ",coordinate.latitude)
        //        print ("longitude: ",coordinate.longitude)
        
        //        //My location
        //        var myLocation = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
        //
        //        //My buddy's location
        //        var myBuddysLocation = CLLocation(latitude: 59.326354, longitude: 18.072310)
        //
        //        //Measuring my distance to my buddy's (in meters)
        //        var distance = myLocation.distance(from: myBuddysLocation)
        //
        //        //Display the result in km
        //        print(String(format: "The distance to my buddy is %.01fmeters", distance))
        
        // ZOOM on MAP VIEW on user Location
        
        let latitude = coordinate.latitude
        let longitude = coordinate.longitude
        let latDelta:CLLocationDegrees = 0.05
        let lonDelta:CLLocationDegrees = 0.05
        let span = MKCoordinateSpanMake(latDelta, lonDelta)
        let location = CLLocationCoordinate2DMake(latitude, longitude)
        let region = MKCoordinateRegionMake(location, span)
        mapView.setRegion(region, animated: false)
        
    }
    
    
    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
        let latitude = userLocation.coordinate.latitude
        let longitude = userLocation.coordinate.longitude
        let latDelta:CLLocationDegrees = 0.05
        let lonDelta:CLLocationDegrees = 0.05
        let span = MKCoordinateSpanMake(latDelta, lonDelta)
        let location = CLLocationCoordinate2DMake(latitude, longitude)
        let region = MKCoordinateRegionMake(location, span)
        mapView.setRegion(region, animated: false)
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        //        print ("tapped on annotation")
        let a = view.annotation
        //        print(a?.title)
        //        performSegue(withIdentifier: "showNurseSegue", sender: self)
        
    }

    func getAllNurse() {
        
        let url = "http://13.76.213.183/calllight/public/api/v1/nurse/all?api_token=" + localUserData.apiToken!
        let completeUrl = URL(string:url)!
        
      
        
        Alamofire.request(completeUrl, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil).responseJSON{ response in
            //            print(response.request as Any)  // original URL request
            //            print(response.response as Any) // URL response
            //            print(response.result.value as Any)   // result of response serialization
            switch response.result {
            case .success:
                if let value = response.result.value {
                    self.json = JSON(value)
                    //                    print(self.json)
                    self.row = self.json["data"].count
                    //                    print(self.row)
                    //print(self.json[0]["facilityPictures"])
                    self.addAnnotations()
                }
                break
            case .failure(let error):
                print(error)
            }
            
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

//
//  NurseLocationVC.swift
//  Call Light
//
//  Created by Ahmed Durrani on 15/04/2018.
//  Copyright © 2018 Tech Ease Solution. All rights reserved.
//

import UIKit
import MapKit
import Alamofire
import SwiftyJSON
import CoreLocation
import SwiftyUserDefaults
import SVProgressHUD


class NurseLocationVC: UIViewController , UIGestureRecognizerDelegate , MKMapViewDelegate {

    
    var resultSearchController:UISearchController!
    var selectedPin:MKPlacemark?
    let locationManager = CLLocationManager()
    var altitude: Double = 0.0
    var country: String = "empty"
    var zipCode: String = "empty"
    var address: String = "empty"
    var city: String = "empty"
    var state: String = "empty"
    var gender: String = "0"
    var shift: Int = 0
    var type: Int = 0
    var speciality: String = "empty"
    var hospitalName: String = "empty"
    var manualAddress: String = "empty"
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet var gesture1: UILongPressGestureRecognizer!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
        locationManager.startUpdatingLocation()
        // Do any additional setup after loading the view.
        
        mapView.delegate = self
        locationManager.delegate = self
        mapView.showsUserLocation = true
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.startUpdatingLocation()
        } else {
            locationManager.requestWhenInUseAuthorization()
        }
        
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        let locationSearchTable = storyboard!.instantiateViewController(withIdentifier: "LocationSearchTable") as! LocationSearchTable
        resultSearchController = UISearchController(searchResultsController: locationSearchTable)
        resultSearchController?.searchResultsUpdater = locationSearchTable
        
        locationSearchTable.updateSearchResults(for: resultSearchController)
        print("view did load SignUp Location")
        
        let searchBar = resultSearchController!.searchBar
        searchBar.sizeToFit()
        searchBar.placeholder = "Search for places"
        
        self.navigationItem.titleView = searchBar
        
        resultSearchController?.hidesNavigationBarDuringPresentation = false
        resultSearchController?.dimsBackgroundDuringPresentation = true
        definesPresentationContext = true
        
        locationSearchTable.mapView = mapView
        locationSearchTable.handleMapSearchDelegate = self
        
        //        let gestureRecognizer = UITapGestureRecognizer(target: self.view , action: #selector(handleTap(_:)))
        //        gestureRecognizer.delegate = self
        //        print (gestureRecognizer)
        //        self.mapView.addGestureRecognizer(gestureRecognizer)
        //        mapView.addGestureRecognizer(gestureRecognizer)
        
        gesture1.delegate = self
        self.mapView.addGestureRecognizer(gesture1)
        mapView.addGestureRecognizer(gesture1)
        
        navigationController?.isNavigationBarHidden = false
        print (UserDefaults.standard.value(forKey: "address"))
        guard let mAddress =  UserDefaults.standard.value(forKey: "address") else {
            return
        }
        manualAddress = String(describing: UserDefaults.standard.value(forKey: "address")!)
    }
    
    
    //    override func viewWillAppear(_ animated: Bool) {
    //        super.viewWillAppear(animated)
    //        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    //    }
    override func viewDidAppear(_ animated: Bool) {
        if manualAddress != "empty" {
            self.resultSearchController.isActive = true
            self.resultSearchController.becomeFirstResponder()
            self.resultSearchController.searchBar.text = "\(manualAddress)"
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
//    func getLocation() -> CLLocationCoordinate2D {
//        let locationManager = CLLocationManager()
//        locationManager.delegate = self
//        locationManager.desiredAccuracy = kCLLocationAccuracyBest
//        locationManager.distanceFilter = kCLDistanceFilterNone
//        locationManager.startUpdatingLocation()
//        let location: CLLocation? = locationManager.location
//        //        altitude = Int(location?.altitude)
//        let coordinate: CLLocationCoordinate2D? = location?.coordinate
//        return coordinate!
//    }
    
   
    
    
   
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        //        print ("tapped on annotation")
        let a = view.annotation
        //        print(a?.title)
        //        performSegue(withIdentifier: "showNurseSegue", sender: self)
        
    }
    
    @objc func getDirections(){
        guard let selectedPin = selectedPin else { return }
        let mapItem = MKMapItem(placemark: selectedPin)
        let launchOptions = [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving]
        mapItem.openInMaps(launchOptions: launchOptions)
    }
    
    
    @IBAction func handleTap1(_ sender: UILongPressGestureRecognizer) {
        let location = sender.location(in: mapView)
        let coordinate = mapView.convert(location,toCoordinateFrom: mapView)
        
        
        // Add annotation:
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        let allAnnotations = self.mapView.annotations
        //        self.mapView.removeAnnotations(allAnnotations)
        mapView.addAnnotation(annotation)
        //        print("location: \(location)  coordinate: \(coordinate)")
        
        // create the alert
        let alert = UIAlertController(title: "Add Your Location", message: "Would you like to mark this place as your address ?", preferredStyle: UIAlertControllerStyle.alert)
        
        // add the actions (buttons)
        alert.addAction(UIAlertAction(title: "Continue", style: UIAlertActionStyle.default, handler: { action in
            
            SVProgressHUD.show()
            
            // saving data
            var json: JSON = []
            var parameters: Parameters = [:]
            
            // in case of nurse
            parameters = [
                "latitude": coordinate.latitude,
                "longitude": coordinate.longitude,
                "altitude": self.altitude,
                "country": self.country,
                "zip_code": self.zipCode,
                "state": self.state,
                "city": self.city,
                "address": self.address,
                "gender": self.gender,
                "shift": self.shift,
                "type": self.type,
                "speciality": self.speciality,
                "hospital_name": self.hospitalName
                //                "user_id": 5
            ]
            
            print (parameters)
            
            //            let headers: HTTPHeaders = [
            //                "api_token": UserDefaults.standard.string(forKey: "apiToken")!
            //            ]
            
            var url = ""
            
            if localUserData.type == "Hospital" {
                url = "http://13.76.213.183/calllight/public/api/v1/profile/hospitals?api_token="+localUserData.apiToken!
            } else {
                url = "http://13.76.213.183/calllight/public/api/v1/profile/nurses?api_token="+localUserData.apiToken!
            }
            
            //            print("url: ",url)
            let completeUrl = URL(string:url)!
            
            Alamofire.request(completeUrl, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: nil ).responseJSON{ response in
                //                print(response.request as Any)  // original URL request
                //                print(response.response as Any) // URL response
                //                print(response.result.value as Any)   // result of response serialization
                switch response.result {
                case .success:
                    //                    print(response)
                    if let value = response.result.value {
                        json = JSON(value)
                        //                        print(json)
                        
                        //                                                self.profileComplete.set(true, forKey: "profileComplete")
                        Defaults.set(true, forKey: "profileComplete")
                        
                        //                        print (UserDefaults.standard.string(forKey: "UserType"))
                        SVProgressHUD.dismiss()
                        //                        print ("User TYpe:", UserDefaults.standard.string(forKey: "UserType"))
                        
                        if localUserData.type == "Nurse" {
                            //                            self.performSegue(withIdentifier: "NurseProfileSegue", sender: self)
                            
//                            tababarController.selectedIndex = 1
//                            self.navigationController?.popViewController(animated: true)
                            
                            //                            if let vc = self.storyboard?.instantiateViewController(withIdentifier: "NurseMenu") {
                            //                                self.present(vc, animated: true, completion: nil)
                            //                            }
                        } else {
//                            if let vc = self.storyboard?.instantiateViewController(withIdentifier: "nurseTab") {
//                                self.present(vc, animated: true, completion: nil)
//                            }
                        }
                    }
                    
                    break
                case .failure(let error):
                    print(error)
                }
                
            }
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil))
        
        // show the alert
        self.present(alert, animated: true, completion: nil)
        
    }
    
    func handleTap(_ sender: UILongPressGestureRecognizer) {
        
        let location = sender.location(in: mapView)
        let coordinate = mapView.convert(location,toCoordinateFrom: mapView)
        
        
        // Add annotation:
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        let allAnnotations = self.mapView.annotations
        self.mapView.removeAnnotations(allAnnotations)
        mapView.addAnnotation(annotation)
        //        print("location: \(location)  coordinate: \(coordinate)")
        
        // create the alert
        let alert = UIAlertController(title: "Add Your Location", message: "Would you like to mark this place as your address ?", preferredStyle: UIAlertControllerStyle.alert)
        
        // add the actions (buttons)
        alert.addAction(UIAlertAction(title: "Continue", style: UIAlertActionStyle.default, handler: { action in
            
            SVProgressHUD.show()
            
            // saving data
            var json: JSON = []
            var parameters: Parameters = [:]
            
            // in case of nurse
            parameters = [
                "latitude": coordinate.latitude,
                "longitude": coordinate.longitude,
                "altitude": self.altitude,
                "country": self.country,
                "zip_code": self.zipCode,
                "state": self.state,
                "city": self.city,
                "address": self.address,
                "gender": self.gender,
                "shift": self.shift,
                "type": self.type,
                "speciality": self.speciality,
                "hospital_name": self.hospitalName
                //                "user_id": 5
            ]
            
            print (parameters)
            
            let headers: HTTPHeaders = [
                "api_token": UserDefaults.standard.string(forKey: "apiToken")!
            ]
            
            var url = ""
            
            if localUserData.type == "Hospital" {
                url = "http://13.76.213.183/calllight/public/api/v1/profile/hospitals?api_token="+localUserData.apiToken!
            } else {
                url = "http://13.76.213.183/calllight/public/api/v1/profile/nurses?api_token="+localUserData.apiToken!
            }
            
            //            print("url: ",url)
            let completeUrl = URL(string:url)!
            
            Alamofire.request(completeUrl, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers ).responseJSON{ response in
                //                print(response.request as Any)  // original URL request
                //                print(response.response as Any) // URL response
                //                print(response.result.value as Any)   // result of response serialization
                switch response.result {
                case .success:
                    //                    print(response)
                    if let value = response.result.value {
                        json = JSON(value)
                        //                        print(json)
                        
                        //                        self.profileComplete.set(true, forKey: "profileComplete")
                        //                        Defaults.set(true, forKey: "profileComplete")
                        
                        //                        print (UserDefaults.standard.string(forKey: "UserType"))
                        SVProgressHUD.dismiss()
                        
                        //                        print ("User TYpe:", UserDefaults.standard.string(forKey: "UserType"))
                        
                        if localUserData.type == "Nurse" {
                            //                            self.performSegue(withIdentifier: "NurseProfileSegue", sender: self)
                            if let vc = self.storyboard?.instantiateViewController(withIdentifier: "NurseMenu") {
                                self.present(vc, animated: true, completion: nil)
                            }
                        } else {
                            //                                self.performSegue(withIdentifier: "NursesShowSegue", sender: self)
                            if let vc = self.storyboard?.instantiateViewController(withIdentifier: "nurseTab") {
                                self.present(vc, animated: true, completion: nil)
                            }
                        }
                    }
                    
                    break
                case .failure(let error):
                    print(error)
                }
                
            }
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil))
        
        // show the alert
        self.present(alert, animated: true, completion: nil)
        
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

extension NurseLocationVC : CLLocationManagerDelegate {
    private func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            locationManager.requestLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if  let location = locations.first {
            //            print("location:: \(location.coordinate) altitude:: \(location.altitude)")
            let span = MKCoordinateSpanMake(0.05, 0.05)
            let region = MKCoordinateRegion(center: location.coordinate, span: span)
            self.altitude = location.altitude
            //            mapView.setRegion(region, animated: true)
            
            // get address
            let geoCoder = CLGeocoder()
            geoCoder.reverseGeocodeLocation(location, completionHandler: { placemarks, error in
                if let err = error {
                    print(error?.localizedDescription)
                } else if let placemarkArray = placemarks {
                    if let placemark = placemarkArray.first {
                        //                        print("addressDisctionary: \(placemark.addressDictionary)")
                        //                        print("country: \(placemark.country)")
                        
                        if placemark.country != nil {
                            self.country = placemark.country!
                        } else {
                            self.country = "empty"
                        }
                        //                        print("CountryCode: \(placemark.isoCountryCode)")
                        //                        print("name: \(placemark.name)")
                        
                        if placemark.name != nil {
                            self.address = placemark.name!
                        } else {
                            self.address = "empty"
                        }
                        print("postalCode: \(placemark.postalCode)")
                        
                        if placemark.postalCode != nil {
                            self.zipCode = placemark.postalCode!
                        } else {
                            self.zipCode = "empty"
                        }
                        //                        print("landWater: \(placemark.inlandWater)")
                        //                        print("administrativeArea: \(placemark.administrativeArea)")
                        if placemark.administrativeArea != nil {
                            self.state = placemark.administrativeArea!
                        } else {
                            self.state = "empty"
                        }
                        
                        //                        print("location: \(placemark.location)")
                        //                        print("region: \(placemark.region)")
                        //                        print("subLocality: \(placemark.subLocality)")
                        //                        print("locality: \(placemark.locality)")
                        if placemark.locality != nil {
                            self.city = placemark.locality!
                        } else {
                            self.city = "empty"
                        }
                        
                    } else {
                        print("Placemark was nil")
                    }
                } else {
                    print("Unknown error")
                }
            })
            
            let latitude = location.coordinate.latitude
            let longitude = location.coordinate.longitude
            let latDelta:CLLocationDegrees = 0.05
            let lonDelta:CLLocationDegrees = 0.05
            let spanss = MKCoordinateSpanMake(latDelta, lonDelta)
            let location = CLLocationCoordinate2DMake(latitude, longitude)
            let regionss = MKCoordinateRegionMake(location, spanss)
            mapView.setRegion(regionss, animated: false)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("error:: \(error)")
    }
}

extension NurseLocationVC: HandleMapSearch {
    func dropPinZoomIn(placemark:MKPlacemark){
        // stop Updating Location
        //        locationManager.stopUpdatingLocation()
        
        // cache the pin
        selectedPin = placemark
        // clear existing pins
        mapView.removeAnnotations(mapView.annotations)
        let annotation = MKPointAnnotation()
        annotation.coordinate = placemark.coordinate
        annotation.title = placemark.name
        if let city = placemark.locality,
            let state = placemark.administrativeArea {
            annotation.subtitle = "\(city) \(state)"
        }
        mapView.addAnnotation(annotation)
        let span = MKCoordinateSpanMake(0.05, 0.05)
        let region = MKCoordinateRegionMake(placemark.coordinate, span)
        mapView.setRegion(region, animated: true)
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

//
//  NurseHomeVC.swift
//  Call Light
//
//  Created by Ahmed Durrani on 15/04/2018.
//  Copyright © 2018 Tech Ease Solution. All rights reserved.
//

import UIKit
import SwiftyUserDefaults
import SCLAlertView
import CoreLocation
import NVActivityIndicatorView

class NurseHomeVC: UIViewController , CLLocationManagerDelegate , NVActivityIndicatorViewable {
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var image: UIImageView!
    var requestId : Any?
    let ap = UIApplication.shared.delegate as! AppDelegate

    let nurseShift = DefaultsKey<Int>("NurseShift")
    let requestIdOfHospital = DefaultsKey<Int>("RequestId")
    let nurseEndShift = DefaultsKey<Int>("NurseEndShift")
    @IBOutlet weak var lblUserStatus: UILabel!


    @IBOutlet weak var btnNurseShift_Pressed: UIButton!
    @IBOutlet weak var btnNurseTakeABreak   : UIButton!
    @IBOutlet weak var btnEndShift_Pressed  : UIButton!
    @IBOutlet weak var btnEndBreak_Pressed  : UIButton!
    var locationManager = CLLocationManager()
    var distanceInMeters = CLLocationDistance()
    var requestObj : UserResponse?
    @IBOutlet var viewOfPop: CardView!
    @IBOutlet weak var lblNameOfHospital: UILabel!
    @IBOutlet weak var lblAddressOfHospital: UILabel!
    var checkValue = 0
    var isAvailable : Bool?

    let size = CGSize(width: 60, height: 60)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        isAvailable = false ;
        

        let tapGestureRecognizerforDp = UITapGestureRecognizer(target:self, action:#selector(NurseHomeVC.availabilityOfNurse))
        image.isUserInteractionEnabled = true
        image.addGestureRecognizer(tapGestureRecognizerforDp)
        self.viewOfPop.isHidden = true

        
        locationManager.delegate = self
        locationManager.distanceFilter = kCLDistanceFilterNone
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
      
        if Defaults[self.nurseShift] == 1 {

            if Defaults[self.nurseEndShift] == 1 {
                self.btnEndShift_Pressed.isHidden = false
                self.btnNurseTakeABreak.isHidden = false
                self.btnNurseShift_Pressed.isHidden = true


            } else {
                self.btnNurseTakeABreak.isHidden = false
                self.btnNurseShift_Pressed.isHidden = false

            }

        } else {
            self.btnNurseTakeABreak.isHidden = true
            self.btnNurseShift_Pressed.isHidden = true
             check()
            getAllNurseRequest()
        }
        

        
        if btnNurseShift_Pressed.isEnabled {
            if CLLocationManager.locationServicesEnabled() {
                locationManager.startUpdatingLocation()
            } else {
                locationManager.requestWhenInUseAuthorization()
            }
        }
        
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(NurseHomeVC.getAllNurseRequest), name: NSNotification.Name(rawValue: "HospitalRequest"), object: nil)

        // Do any additional setup after loading the view.
    }
    
    @objc func getAllNurseRequest(){
//
        let serviceURL =  NURSEREQUESTFORHOSPITAL  + "?api_token=\(localUserData.apiToken!)&pending_jobs=1"
        
        WebServiceManager.get(params: nil, serviceName: serviceURL, serviceType: "Nurse Request For Hospital", modelType: UserResponse.self, success: { (response) in
            self.requestObj = (response as? UserResponse)
            if self.requestObj?.success == true {
                self.viewOfPop.isHidden = false
                let address = self.requestObj?.historyObject![self.checkValue].hospitalObject?.address
                let city = self.requestObj?.historyObject![self.checkValue].hospitalObject?.city
                let state = self.requestObj?.historyObject![self.checkValue].hospitalObject?.state
                let country = self.requestObj?.historyObject![self.checkValue].hospitalObject?.country
                
                self.lblNameOfHospital.text = self.requestObj?.historyObject![self.checkValue].hospitalObject?.hospitalProfile?.name
                
                self.lblAddressOfHospital.text = "\(address!) \(city!) \(state!) \(country!)"
                
            } else {
//                self.showAlert(title: "Call Light", message: (self.requestObj?.message)!, controller: self)
                self.viewOfPop.isHidden = true

            }
            
            
        }) { (error) in
            
        }
        
    }
    
    
    @IBAction func btnAccept_Pressed(_ sender: UIButton) {
        self.isRequestAceeptOrReject(hasAccepted: 1 , acceptOrReject: NURSEACCEPT , isAcceptOrReject:  true)
    }
    
    @IBAction func btnReject_Pressed(_ sender: UIButton) {
        if self.checkValue >= (((self.requestObj?.historyObject?.count)!)) {
            self.viewOfPop.isHidden = true
        } else {
            updateTheUI(value: self.checkValue)
            self.checkValue += 1

        }
        
    }
    
    func updateTheUI(value : Int) {
        

        let address = self.requestObj?.historyObject![value].hospitalObject?.address
        let city = self.requestObj?.historyObject![value].hospitalObject?.city
        let state = self.requestObj?.historyObject![value].hospitalObject?.state
        let country = self.requestObj?.historyObject![value].hospitalObject?.country
        self.lblNameOfHospital.text = self.requestObj?.historyObject![value].hospitalObject?.hospitalProfile?.name
        self.lblAddressOfHospital.text = "\(address!) \(city!) \(state!) \(country!)"

        UIView.animate(withDuration: 0.5, animations: {
            self.lblNameOfHospital.alpha = 0.0
            self.lblAddressOfHospital.alpha = 0.0


        }, completion: {
            (values: Bool) in
//            self.lblNameOfHospital.text = self.requestObj?.historyObject![value].hospitalObject?.hospitalProfile?.name
//            self.lblAddressOfHospital.text = "\(address!) \(city!) \(state!) \(country!)"

            self.lblNameOfHospital.alpha = 1
            self.lblAddressOfHospital.alpha = 1

        })
        

        
        self.isRequestAceeptOrReject(hasAccepted: 1 , acceptOrReject: NURSEDECLINE , isAcceptOrReject: false)

        
     
        
       
        
//        self.lblAddressOfCustomer.text = self.responseObj?.orderData![value - 1].customerInfo?.addressOfUser
        
        
    }
    @IBAction func btnEndShift_Pressed(_ sender: UIButton) {
        let dateFormatter : DateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd hh:mm:ss"
        let date = Date()
        let dateString = dateFormatter.string(from: date)
        let requestIDs = Defaults[self.requestIdOfHospital]

        let loginParam =  [ "request_id"      : requestIDs ,
                            "shift_ended"     : dateString
            
            ] as [String : Any]
        
        let serviceURL =  NURSESHIFT_END  + "?api_token=\(localUserData.apiToken!)"
        
        WebServiceManager.post(params:loginParam as Dictionary<String, AnyObject> , serviceName: serviceURL, isLoaderShow: true , serviceType: "Shift Start", modelType: UserResponse.self, success: { (response) in
            let responseObj = response as! UserResponse
            
            
            
            if responseObj.success == true {
            
                self.showAlertViewWithTitle(title: "Call Light", message: responseObj.message!, dismissCompletion: {
                
                    self.btnEndShift_Pressed.isHidden = true
                    self.btnNurseShift_Pressed.isHidden = true
                    self.btnEndBreak_Pressed.isHidden = true
                    self.btnNurseTakeABreak.isHidden = true
//                    Defaults[self.ap.available] = 0
                    Defaults[self.nurseShift] = 0
                    Defaults[self.nurseEndShift] = 0
                    self.label.text = "Not Available"
                    self.image.image = UIImage(named: "red")
                    self.label.isHidden = false
                    self.image.isHidden = false
                    self.isAvailable = false
                    self.availabilityOfNurse()
//                    self.availabilityOfNurse()

                })
                
//                self.showAlert(title: "Call Light", message: responseObj.message!, controller: self)
                
                
            }else {
                self.showAlert(title: "Call Light", message: responseObj.message!, controller: self)
                
                
            }
            
        }, fail: { (error) in
        }, showHUD: true)
    }
    
    @objc func hospitalInfo(_ notification: NSNotification) {
//        let userData = notification.userInfo
////        let message = notification.userInfo!["alert"]
//        let dict : NSDictionary?
//        dict = notification.userInfo!["aps"] as?  NSDictionary
//
//        let message = dict?.value(forKey: "alert")
//        print(message!)
//        requestId = userData![AnyHashable("request_id")]!
//        Defaults[self.requestIdOfHospital] = requestId as! Int
//
//            let appearance = SCLAlertView.SCLAppearance(
//                kTitleFont: UIFont(name: "HelveticaNeue", size: 20)!,
//                kTextFont: UIFont(name: "HelveticaNeue", size: 14)!,
//                kButtonFont: UIFont(name: "HelveticaNeue-Bold", size: 14)!,
//                showCloseButton: false,
//                dynamicAnimatorActive: true,
//                buttonsLayout: .horizontal
//            )
//            let alert = SCLAlertView(appearance: appearance)
//            _ = alert.addButton("Accept", target:self, selector:#selector(NurseHomeVC.firstButton))
//            _ = alert.addButton("Reject", target:self, selector:#selector(NurseHomeVC.secondButton))
//            let icon = UIImage(named:"userSelect")
//            let color = UIColor.orange
//
//        _ = alert.showCustom("Nurse", subTitle: message as? String, color: color, circleIconImage: icon!)
        
        
        
        
    }
    
    func getTheHospitalProfile(hospitalId : Any){
        
        let serviceURL = "\(HospitalPROFILE)/\(hospitalId)?api_token=\(localUserData.apiToken!)"
        WebServiceManager.get(params:nil , serviceName: serviceURL, serviceType: "Hospital Profile", modelType: UserData.self, success: { (responseData) in
            
            let responseObj = responseData as! UserResponse
            
         

            
        }) { (error)  in
            self.showAlert(title: KMessageTitle, message: error.description, controller: self)
        }
        
    }
    
    
    @objc func firstButton() {

        self.isRequestAceeptOrReject(hasAccepted: 1 , acceptOrReject: NURSEACCEPT , isAcceptOrReject:  true)
    }
    
    @objc func secondButton() {
        self.isRequestAceeptOrReject(hasAccepted: 1 , acceptOrReject: NURSEDECLINE , isAcceptOrReject: false)
        
    }
    
    func isRequestAceeptOrReject(hasAccepted : Int , acceptOrReject : String , isAcceptOrReject : Bool) {
        
        let requestIds =   self.requestObj?.historyObject![self.checkValue].id
        Defaults[self.requestIdOfHospital] = requestIds!
        let requestIDs = Defaults[self.requestIdOfHospital]
//        UIColor(red: 26/255.0, green: 83/255.0, blue: 155/255.0, alpha: 1.0)
        startAnimating(size, message: "Call Light", messageFont: nil , type: NVActivityIndicatorType(rawValue: 6), color:UIColor.white   , padding: nil, displayTimeThreshold: nil, minimumDisplayTime: nil, backgroundColor: nil , textColor: UIColor.white)
      
        var loginParam : [String : Any]
        if  isAcceptOrReject == true  {
            loginParam =  [ "request_id"      : requestIDs ,
                            "has_accepted"    : 1
                          ] as [String : Any]
            
        } else {
            loginParam =  [ "request_id"      : requestIDs ,
                            "has_declined"    : 1
                ] as [String : Any]
        }
        let serviceURL =  acceptOrReject  + "?api_token=\(localUserData.apiToken!)"
        
        WebServiceManager.post(params:loginParam as Dictionary<String, AnyObject> , serviceName: serviceURL, isLoaderShow: false , serviceType: "Login", modelType: UserResponse.self, success: { (response) in
            self.stopAnimating()

            let responseObj = response as! UserResponse
            
            if responseObj.success == true {
              
                
                    if isAcceptOrReject == true {
                        self.viewOfPop.isHidden = true
                        self.btnNurseTakeABreak.isHidden = false
                        self.btnNurseShift_Pressed.isHidden = false
                        Defaults[self.nurseShift] = 1
                        Defaults[self.ap.available] = 1
                        self.isAvailable = true
                        self.availabilityOfNurse()
                        
                        
                    } else {
                        self.btnNurseTakeABreak.isHidden = true
                        self.btnNurseShift_Pressed.isHidden = true
                        Defaults[self.nurseShift] = 0

                    }
                    
                if self.checkValue >= (((self.requestObj?.historyObject?.count)!)) {
                    self.viewOfPop.isHidden = true
                }
                
              
//                self.showAlert(title: "Call Light", message: responseObj.message!, controller: self)

                
                
            }else {
//                self.showAlert(title: "Call Light", message: responseObj.message!, controller: self)
            }
            
        }, fail: { (error) in
            self.stopAnimating()

        }, showHUD: true)

    }
    
    
    func availabilitySet() {
        if (Defaults[ap.available] == 1 ) {
            UserDefaults.standard.set(1, forKey: "avail" )
            label.text = "Available"
            image.image = UIImage(named: "green")
            //            Defaults.setValue("1", forKey: "avail")
        } else if (Defaults[ap.available] == 0) {
            UserDefaults.standard.set(0, forKey: "avail" )
//            label.text = "Assignment Booked"
//            image.image = UIImage(named: "red")
            
            if Defaults[self.nurseShift] == 1 {
                
                if Defaults[self.nurseEndShift] == 1 {
                    label.text = "Assignment Booked"
                    image.image = UIImage(named: "yellow")
                } else {
                    label.text = "Assignment Booked"
                    image.image = UIImage(named: "yellow")
                }
                
            } else {
                label.text = "Not Available"
                image.image = UIImage(named: "red")
            }
            
            //            Defaults.setValue("0", forKey: "avail")
        } else {
            UserDefaults.standard.set( -1 , forKey: "avail" )
            label.text = "Your Account is Pending Approval"
            image.image = UIImage(named: "nurseDecline.png")
            //            Defaults.setValue("-1", forKey: "avail")
//            self.blur.isHidden = false
        }
    }
    
    func check() {
        //        if let UserDefaults.standard.string(forKey: "avail")
        //       if UserDefaults.standard.string(forKey: "avail") != "-1" {
        if Defaults[ap.available] != nil {
            UserDefaults.standard.set(Defaults[ap.available], forKey: "avail")
        }
        if (Defaults[ap.available] == 1 ) {
            if Defaults[self.nurseShift] == 1 {
                
                if Defaults[self.nurseEndShift] == 1 {
                    label.text = "Assignment Booked"
                    image.image = UIImage(named: "yellow")
                } else {
                    label.text = "Assignment Booked"
                    image.image = UIImage(named: "yellow")
                }
                
            } else {
                label.text = "Available"
                image.image = UIImage(named: "green")
                
            }
           
            //            Defaults.setValue("1", forKey: "avail")
        }
        else if (Defaults[ap.available] == 0) {
            
            if Defaults[self.nurseShift] == 1 {
                
                if Defaults[self.nurseEndShift] == 1 {
                    label.text = "Assignment Booked"
                    image.image = UIImage(named: "yellow")
                    } else {
                    label.text = "Assignment Booked"
                    image.image = UIImage(named: "yellow")
                }
                
            } else {
                label.text = "Not Available"
                image.image = UIImage(named: "red")
            }
        } else {
            label.text = "Your Account is Pending Approval"
            image.image = UIImage(named: "nurseDecline.png")
            Defaults.setValue("-1", forKey: "avail")
        }
    }
    
    @objc func availabilityOfNurse() {
        
        var setAvail = 0
        
        if Defaults[ap.available] == 0 {
            setAvail = 1
        } else {
            setAvail = 0
        }
        let loginParam =  [ "available"      : setAvail
            
                        ] as [String : Any]
        
        let serviceURL =  NURSEAVAILABILITY  + "?api_token=\(localUserData.apiToken!)"

        WebServiceManager.post(params:loginParam as Dictionary<String, AnyObject> , serviceName: serviceURL, isLoaderShow: true , serviceType: "Login", modelType: UserResponse.self, success: { (response) in
            let responseObj = response as! UserResponse
            
            if responseObj.success == true {
                
                if responseObj.availabilityObject?.available == "1" {
                    if self.isAvailable == true  {
                        self.image.isHidden = true
                        self.label.isHidden = true
                    } else {
                        Defaults[self.ap.available] = 1
                        self.availabilitySet()
                    }
                  

                    } else {
                    
                    if self.isAvailable == true  {
                        self.image.isHidden = true
                        self.label.isHidden = true
                    } else {
                        Defaults[self.ap.available] = 0
                        self.availabilitySet()
                    }
                    
                    
                   

                }
                
            }else {
                self.showAlert(title: "Call Light", message: responseObj.message!, controller: self)
                Defaults[self.ap.available] = 0
                self.availabilitySet()

                
            }
            
        }, fail: { (error) in
        }, showHUD: true)

        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    @IBAction func btnTake_Break(_ sender: UIButton) {
      
        let dateFormatter : DateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd hh:mm:ss"
        let date = Date()
        let dateString = dateFormatter.string(from: date)
        
        
        let requestIDs = Defaults[self.requestIdOfHospital]

        let loginParam =  [ "request_id"      : requestIDs ,
                            "lunch_break"     : dateString
            
            ] as [String : Any]
        
        let serviceURL =  NURSELUNCHBREAK  + "?api_token=\(localUserData.apiToken!)"
        
        WebServiceManager.post(params:loginParam as Dictionary<String, AnyObject> , serviceName: serviceURL, isLoaderShow: true , serviceType: "Luanch Break", modelType: UserResponse.self, success: { (response) in
            let responseObj = response as! UserResponse
            
            if responseObj.success == true {
                self.btnNurseTakeABreak.isHidden = true
                self.btnEndBreak_Pressed.isHidden = false

                
            }else {
                self.showAlert(title: "Call Light", message: responseObj.message!, controller: self)
                
                
            }
            
        }, fail: { (error) in
        }, showHUD: true)

        
    }
    
    @IBAction func btnEnd_Break_Pressed(_ sender: UIButton) {
        
        let dateFormatter : DateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd hh:mm:ss"
        let date = Date()
        let dateString = dateFormatter.string(from: date)
        let requestIDs = Defaults[self.requestIdOfHospital]
        let loginParam =  [ "request_id"      : requestIDs ,
                            "lunch_break_ended"     : dateString
            
//            lunch_break_ended

            ] as [String : Any]
        
        let serviceURL =  NURSELUNCHBREAKENDED  + "?api_token=\(localUserData.apiToken!)"
        
        WebServiceManager.post(params:loginParam as Dictionary<String, AnyObject> , serviceName: serviceURL, isLoaderShow: true , serviceType: "Luanch Break", modelType: UserResponse.self, success: { (response) in
            let responseObj = response as! UserResponse
            
            if responseObj.success == true {
                self.btnNurseTakeABreak.isHidden = true
                self.btnEndBreak_Pressed.isHidden = true
                self.btnEndShift_Pressed.isHidden = false

                
            }else {
                self.showAlert(title: "Call Light", message: responseObj.message!, controller: self)
                
                
            }
            
        }, fail: { (error) in
        }, showHUD: true)

    }
    
    @IBAction func btnStartShift_Pressed(_ sender: UIButton) {
        
        
        let dateFormatter : DateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd hh:mm:ss"
        let date = Date()
        let dateString = dateFormatter.string(from: date)
        let requestIDs = Defaults[self.requestIdOfHospital]

        let loginParam =  [ "request_id"      : requestIDs ,
                            "shift_started"   : dateString
                          ] as [String : Any]
        
        let serviceURL =  NURSESHIFTStart  + "?api_token=\(localUserData.apiToken!)"
        
        WebServiceManager.post(params:loginParam as Dictionary<String, AnyObject> , serviceName: serviceURL, isLoaderShow: true , serviceType: "Shift Start", modelType: UserResponse.self, success: { (response) in
            let responseObj = response as! UserResponse
            if responseObj.success == true {
                self.showAlertViewWithTitle(title: "Call Light", message: responseObj.message!, dismissCompletion: {
                    self.btnEndShift_Pressed.isHidden   = false
                    self.btnNurseShift_Pressed.isHidden = true
                    self.btnNurseTakeABreak.isHidden    = false
                    self.btnEndBreak_Pressed.isHidden   = false
                    Defaults[self.nurseEndShift] = 1

                })



                
            }else {
                self.showAlert(title: "Call Light", message: responseObj.message!, controller: self)
                
                
            }
            
        }, fail: { (error) in
        }, showHUD: true)

    }

func getLocation() -> CLLocationCoordinate2D {
    let locationManager = CLLocationManager()
    locationManager.delegate = self
    locationManager.desiredAccuracy = kCLLocationAccuracyBest
    locationManager.distanceFilter = kCLDistanceFilterNone
    locationManager.startUpdatingLocation()
    let location: CLLocation? = locationManager.location
    //        altitude = Int(location?.altitude)
    var coordinate: CLLocationCoordinate2D? = location?.coordinate
    //        if coordinate?.latitude == nil {
    //            coordinate?.latitude = -1
    //            coordinate?.longitude = -1
    //            return coordinate!
    //        }
    return coordinate!
}

//func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//    var coordinate: CLLocationCoordinate2D = getLocation()
//
//    if coordinate.latitude == nil {
//        return
//    }
//    //        print ("latitude: ",coordinate.latitude)
//    //        print ("longitude: ",coordinate.longitude)
//    //
//    //        print ("hospital latitude: ", UserDefaults.standard.double(forKey: "HospitalLat"))
//    //        print ("hospital longitude: ", UserDefaults.standard.double(forKey: "HospitalLong"))
//
//
//    //My location
//    var myLocation = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
//
//    //Hospital location
//    var myBuddysLocation = CLLocation(latitude: UserDefaults.standard.double(forKey: "HospitalLat"), longitude: UserDefaults.standard.double(forKey: "HospitalLong"))
//
//    //Measuring my distance to my buddy's (in meters)
//    var distance = myLocation.distance(from: myBuddysLocation)
//
//    //Display the result in m
//    print(String(format: "The distance to my hospital is %.01fmeters", distance))
//
//    if distance < 50 {
//
//        DispatchQueue.main.async {
//            //                self.startShiftBtn.isHidden = false
//            //                self.startLunchBreakAction.isHidden = false
//
//            self.btnNurseShift_Pressed.isEnabled = true
//            self.btnNurseTakeABreak.isEnabled = true
//            self.locationManager.stopUpdatingLocation()
//            self.locationManager.stopMonitoringSignificantLocationChanges()
//            self.locationManager.delegate = nil
//        }
//        self.label.text = "You are now in vicinity"
//        self.image.isHidden = true
//        //            self.startShiftBtn.isHidden = false
//        //            self.startLunchBreakAction.isHidden = false
//        self.btnNurseShift_Pressed.isEnabled = true
//        self.btnNurseTakeABreak.isEnabled = true
//
//        // create the alert
//        let alert = UIAlertController(title: "SHIFT", message: "You are Near or In Hospital Do you want to start shift ?", preferredStyle: UIAlertControllerStyle.alert)
//
//        // add the actions (buttons)
//        alert.addAction(UIAlertAction(title: "Start Shift", style: UIAlertActionStyle.default, handler: {action in
//            self.StartShift()
//        }))
//        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil))
//
//        // show the alert
//        self.present(alert, animated: true, completion: nil)
//    }
//
//    if distance > 40000 {
//        self.locationManager.stopUpdatingLocation()
//        self.locationManager.stopMonitoringSignificantLocationChanges()
//        self.locationManager.delegate = nil
//    }
//}

}



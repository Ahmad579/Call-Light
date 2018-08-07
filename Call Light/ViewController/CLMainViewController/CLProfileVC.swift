//
//  CLProfileVC.swift
//  Call Light
//
//  Created by Ahmed Durrani on 14/04/2018.
//  Copyright © 2018 Tech Ease Solution. All rights reserved.
//

import UIKit
import MapKit

class CLProfileVC: UIViewController {
    
    var index: Int?
    var hospitalProfile: UserResponse?
    
    @IBOutlet weak var txtHospitalName: UITextField!
    
    @IBOutlet weak var txtPhone: UITextField!
    
    @IBOutlet weak var txtAddress: UITextField!
    @IBOutlet weak var mapView: MKMapView!

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
        getTheHospitalProfile()
    }

    
    func setUpUI(){
        
        txtHospitalName.setLeftPaddingPoints(10)
        txtPhone.setLeftPaddingPoints(10)
        txtAddress.setLeftPaddingPoints(10)

        UtilityHelper.setViewBorder(txtHospitalName, withWidth: 0.9 , andColor: UIColor.white)
        UtilityHelper.setViewBorder(txtPhone, withWidth: 0.9 , andColor: UIColor.white)
        UtilityHelper.setViewBorder(txtAddress, withWidth: 0.9 , andColor: UIColor.white)

        
        txtHospitalName.layer.cornerRadius = 20.0
        txtHospitalName.layer.borderWidth = 0.9
        
        
        txtPhone.layer.cornerRadius = 20.0
        txtPhone.layer.borderWidth = 0.9
        
        txtAddress.layer.cornerRadius = 20.0
        txtAddress.layer.borderWidth = 0.9

        
    }
    func getTheHospitalProfile() {
        
        
        let serviceURL =  HospitalPROFILE + "?api_token=\(localUserData.apiToken!)"
        WebServiceManager.get(params: nil, serviceName: serviceURL, serviceType: "Service List", modelType: UserResponse.self, success: { (response) in
            self.hospitalProfile = (response as! UserResponse)
            if  self.hospitalProfile?.success == true {
                
                if self.hospitalProfile?.selectedNurseList?.hospital_name != "empty" {
                    self.txtHospitalName.text = self.hospitalProfile?.selectedNurseList?.hospital_name
                } else {
                    self.txtHospitalName.text = localUserData.name

                }
                
                self.addAnnotations()

                let city = self.hospitalProfile?.selectedNurseList?.city
                let state = self.hospitalProfile?.selectedNurseList?.state
                let address = self.hospitalProfile?.selectedNurseList?.address
                let country = self.hospitalProfile?.selectedNurseList?.country
                
                
                
                self.txtAddress.text = "\(address!) \(city!) \(state!) \(country!)"
                self.txtPhone.text = localUserData.phone
                
                //                self.showCustomPop(popMessage: (self.responseObj?.message!)!)
            }
            else {
                
                
                //            self.showAlert(title: "blink", message: (self.categoriesList?.message)!, controller: self)
            }
        }) { (error) in
            
            
        }
        
        
    }
    
    @IBAction func btnChangePassword_Pressed(_ sender: UIButton) {
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "CLProfileChanegPass") as? CLProfileChanegPass
        self.navigationController?.pushViewController(vc!, animated: true)
    }
    
    @IBAction func btnLogout_Pressed(_ sender: UIButton) {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateInitialViewController()
        localUserData = nil
        UserDefaults.standard.set(nil  , forKey : "id")
        UserDefaults.standard.set(nil  , forKey : "user_token")
        UserDefaults.standard.set(nil  , forKey : "password")
        UserDefaults.standard.set(nil  , forKey : "email")
        localUserData = nil

        UIApplication.shared.keyWindow?.rootViewController = vc
        
    }
    
    func addAnnotations() {
        
        let annotation = MKPointAnnotation()
        let lat = self.hospitalProfile?.selectedNurseList?.latitude
        let lng = self.hospitalProfile?.selectedNurseList?.longitude
        annotation.coordinate = CLLocationCoordinate2D(latitude: lat!, longitude: lng!)
        mapView.addAnnotation(annotation)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

  

}

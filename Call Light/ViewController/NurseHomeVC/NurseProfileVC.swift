//
//  NurseProfileVC.swift
//  Call Light
//
//  Created by Ahmed Durrani on 15/04/2018.
//  Copyright © 2018 Tech Ease Solution. All rights reserved.
//

import UIKit
import SwiftyUserDefaults

class NurseProfileVC: UIViewController ,  UIPickerViewDelegate, UIPickerViewDataSource {
    
  
    @IBOutlet weak var btnAnythird : UIButton!
    @IBOutlet weak var btn7PMTO7am : UIButton!
    @IBOutlet weak var btn7amTO7pm : UIButton!
    
    @IBOutlet weak var nurseSpeciality: UIPickerView!

    @IBOutlet weak var btnLPNLVN : UIButton!
    @IBOutlet weak var btnRN : UIButton!

    @IBOutlet weak var viewOfSecondRow : UIView!
    @IBOutlet weak var viewOfThirdRow : UIView!
    
    @IBOutlet weak var logOut: UIButton!
    @IBOutlet weak var progressButton: UIButton!
    @IBOutlet weak var changePassword: UIButton!
    let ap = UIApplication.shared.delegate as! AppDelegate

    
    var nurseShiftSelect = 0
    var nurseTypeSelect = 0
    var nurseSexSelect = 0
    var NurseSpecilitySelect = "ER"
    var nurseSpecialitySelect = 0
    

    var pickerData = ["ER", "ICU", "Labor & Delivery", "Med/Surgical", "Cath. Lab"]

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
        
        if localUserData.isVerified == true {
            self.logOut.isEnabled = true
            self.logOut.isHidden = false
            self.changePassword.isEnabled = true
            self.changePassword.isHidden = false
            self.progressButton.setTitle("Save", for: [])
        } else {
            self.logOut.isEnabled = false
            self.logOut.isHidden = true
            self.changePassword.isEnabled = false
            self.changePassword.isHidden = true
        }
        self.nurseSpeciality.delegate = self
        self.nurseSpeciality.dataSource = self

        getTheNurseProfile()

        
        // Do any additional setup after loading the view.
    }
    
   
    func getTheNurseProfile(){
        let serviceURL =  NURSEPROFILE + "?api_token=\(localUserData.apiToken!)"
        WebServiceManager.get(params: nil, serviceName: serviceURL, serviceType: "Nurse Profile", modelType: UserResponse.self, success: { (response) in
            
            let responseObj = response as! UserResponse
            if responseObj.success == true {
                if responseObj.nurseProfile?.shift == "0"{
                    self.nurseShiftSelect = 0

                    self.btnAnythird.backgroundColor = UIColor.clear
                    self.btn7PMTO7am.backgroundColor = UIColor.clear
                    self.btn7amTO7pm.backgroundColor = UIColor.white
                    
                    self.btnAnythird.isSelected = false
                    self.btn7PMTO7am.isSelected = false
                    self.btn7amTO7pm.isSelected = true

                    
                } else if  responseObj.nurseProfile?.shift == "1" {
                    self.nurseShiftSelect = 1

                    self.btnAnythird.backgroundColor = UIColor.clear
                    self.btn7PMTO7am.backgroundColor = UIColor.white
                    self.btn7amTO7pm.backgroundColor = UIColor.clear
                    
                    self.btnAnythird.isSelected = false
                    self.btn7PMTO7am.isSelected = true
                    self.btn7amTO7pm.isSelected = false

                    
                } else {
                    self.nurseShiftSelect = 2
                    
                    self.btnAnythird.backgroundColor = UIColor.white
                    self.btn7PMTO7am.backgroundColor = UIColor.clear
                    self.btn7amTO7pm.backgroundColor = UIColor.clear
                    
                    self.btnAnythird.isSelected = true
                    self.btn7PMTO7am.isSelected = false
                    self.btn7amTO7pm.isSelected = false
                }

                if responseObj.nurseProfile?.type == "0"{
                    self.nurseTypeSelect = 0
                    
                    self.btnLPNLVN.backgroundColor = UIColor.clear
                    self.btnRN.backgroundColor = UIColor.white
                    
                    self.btnLPNLVN.isSelected = false
                    self.btnRN.isSelected = true
                
                } else {
                    self.nurseTypeSelect = 1
                    self.btnLPNLVN.backgroundColor = UIColor.white
                    self.btnRN.backgroundColor = UIColor.clear
                    
                    self.btnLPNLVN.isSelected = true
                    self.btnRN.isSelected = false
                }
                
           
                if responseObj.nurseProfile?.speciality == "0"{
                    self.nurseSpecialitySelect = 0

                    let row: Int = 0
                    
                    self.nurseSpeciality.selectRow(row, inComponent: 0, animated: false)

                    
                  } else if responseObj.nurseProfile?.speciality == "1" {
                    
                        self.nurseSpecialitySelect = 1
                    
                    let row: Int = 1
                    
                    self.nurseSpeciality.selectRow(row, inComponent: 0, animated: false)
                }
                  else if responseObj.nurseProfile?.speciality == "2" {
                    
                    self.nurseSpecialitySelect = 2
                    let row: Int = 2
                    
                    self.nurseSpeciality.selectRow(row, inComponent: 0, animated: false)


                    
                  } else if responseObj.nurseProfile?.speciality == "3" {
                    
                    self.nurseSpecialitySelect = 3
                    let row: Int = 3
                    self.nurseSpeciality.selectRow(row, inComponent: 0, animated: false)
                    

                    
                  } else if responseObj.nurseProfile?.speciality == "4" {
                    
                    self.nurseSpecialitySelect = 4
                    let row: Int = 4
                    
                    self.nurseSpeciality.selectRow(row, inComponent: 0, animated: false)
                }
                
            }
            
            
            
        }) { (error) in
            
        }
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        if localUserData.isVerified == true {
            self.logOut.isEnabled = true
            self.logOut.isHidden = false
            self.progressButton.setTitle("Save", for: [])
        } else {
            self.logOut.isEnabled = false
            self.logOut.isHidden = true
        }
        self.navigationController?.setNavigationBarHidden(true, animated: animated)

    }

    func setUI(){

        btnLPNLVN.backgroundColor = UIColor.clear
        btnRN.backgroundColor = UIColor.white
        
        btnLPNLVN.isSelected = false
        btnRN.isSelected = true

        
        
        btnAnythird.backgroundColor = UIColor.clear
        btn7PMTO7am.backgroundColor = UIColor.clear
        btn7amTO7pm.backgroundColor = UIColor.white
        
        btnAnythird.isSelected = false
        btn7PMTO7am.isSelected = false
        btn7amTO7pm.isSelected = true
        
        UtilityHelper.setViewBorder(viewOfSecondRow, withWidth: 0.9 , andColor: UIColor.white)
        UtilityHelper.setViewBorder(viewOfThirdRow, withWidth: 0.9 , andColor: UIColor.white)
    }
    
    @IBAction func btnSelectShiftType_Pressed(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        
        if sender.tag == 21 {
            self.nurseShiftSelect = 0

            btnAnythird.backgroundColor = UIColor.clear
            btn7PMTO7am.backgroundColor = UIColor.clear
            btn7amTO7pm.backgroundColor = UIColor.white
            
            btnAnythird.isSelected = false
            btn7PMTO7am.isSelected = false
            btn7amTO7pm.isSelected = true
            
        } else if sender.tag == 22 {
            self.nurseShiftSelect = 1

            btnAnythird.backgroundColor = UIColor.clear
            btn7PMTO7am.backgroundColor = UIColor.white
            btn7amTO7pm.backgroundColor = UIColor.clear
            
            btnAnythird.isSelected = false
            btn7PMTO7am.isSelected = true
            btn7amTO7pm.isSelected = false
            
        } else if sender.tag == 23 {
            self.nurseShiftSelect = 2

            btnAnythird.backgroundColor = UIColor.white
            btn7PMTO7am.backgroundColor = UIColor.clear
            btn7amTO7pm.backgroundColor = UIColor.clear
            
            btnAnythird.isSelected = true
            btn7PMTO7am.isSelected = false
            btn7amTO7pm.isSelected = false
            
        }
        
    
    }
    
    @IBAction func btnSelectType_Pressed(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        
        if sender.tag == 11 {
            self.nurseTypeSelect = 0

            btnLPNLVN.backgroundColor = UIColor.clear
            btnRN.backgroundColor = UIColor.white
            
            btnLPNLVN.isSelected = false
            btnRN.isSelected = true
            
        } else if sender.tag == 12 {
            self.nurseTypeSelect = 1
            btnLPNLVN.backgroundColor = UIColor.white
            btnRN.backgroundColor = UIColor.clear
            
            btnLPNLVN.isSelected = true
            btnRN.isSelected = false
            
        }

        
        
    }
    
    @IBAction func saveNurseProfile_Pressed(_ sender: Any) {
        
        if self.NurseSpecilitySelect != "" {
            
            if self.NurseSpecilitySelect == "ER" {
                nurseSpecialitySelect = 0

            } else if self.NurseSpecilitySelect == "ICU" {
                
                nurseSpecialitySelect = 1
                
            } else if self.NurseSpecilitySelect == "Labor & Delivery" {
                nurseSpecialitySelect = 2

            }else if self.NurseSpecilitySelect == "Med/Surgical" {
                nurseSpecialitySelect = 3

            }else if self.NurseSpecilitySelect == "Cath. Lab" {
                nurseSpecialitySelect = 4

            }
            
            
            let param =
                        ["gender"       : "nil",
                         "shift"        : self.nurseShiftSelect,
                         "type"         : self.nurseTypeSelect,
                         "speciality"   : self.nurseSpecialitySelect
                        ] as [String : Any]
         
            let serviceURL =  NURSEPROFILE  + "?api_token=\(localUserData.apiToken!)"
            WebServiceManager.post(params:param as Dictionary<String, AnyObject> , serviceName: serviceURL, isLoaderShow: true, serviceType: "Update Profile", modelType: UserResponse.self, success: { (response) in
                let responseObj = response as! UserResponse
                
                if responseObj.success == true {
                    
                    if localUserData.isVerified != true {
//                        self.performSegue(withIdentifier: "NurseDocsSegue", sender: self)
                    } else {
//                        self.performSegue(withIdentifier: "addLocation", sender: self)

                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "signUpLocation") as? signUpLocation
                    
                        vc?.speciality = self.nurseSpecialitySelect
                        vc?.type = self.nurseTypeSelect
                        vc?.shift = self.nurseShiftSelect
                        self.navigationController?.pushViewController(vc!, animated: true)
                    }

                    self.showAlert(title: "Call Light", message:  responseObj.message! , controller: self)
                    
                    
                    
                }else {
                    self.showAlert(title: "Call Light", message: responseObj.message!, controller: self)
                }
                
            }, fail: { (error) in
            }, showHUD: true)
        
            
        }
    
    }
    
    @IBAction func btnChangePassword_Pressed(_ sender: UIButton) {
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "CLProfileChanegPass") as? CLProfileChanegPass
        self.navigationController?.pushViewController(vc!, animated: true)
    }
    
    @IBAction func btnLogout_Pressed(_ sender: UIButton) {
       
        let loginParam =  [ "available"      : 0
            ] as [String : Any]
        
        let serviceURL =  NURSEAVAILABILITY  + "?api_token=\(localUserData.apiToken!)"
        
        WebServiceManager.post(params:loginParam as Dictionary<String, AnyObject> , serviceName: serviceURL, isLoaderShow: true , serviceType: "Login", modelType: UserResponse.self, success: { (response) in
            let responseObj = response as! UserResponse
            
            if responseObj.success == true {
                
                Defaults[self.ap.available] = 0
                let vc = UIStoryboard(name: "Main", bundle: nil).instantiateInitialViewController()
                localUserData = nil
                UserDefaults.standard.set(nil  , forKey : "id")
                UserDefaults.standard.set(nil  , forKey : "user_token")
                UserDefaults.standard.set(nil  , forKey : "password")
                UserDefaults.standard.set(nil  , forKey : "email")
                Defaults[self.ap.available] = 0
                
                localUserData = nil
                
                UIApplication.shared.keyWindow?.rootViewController = vc
            }else {
                self.showAlert(title: "Call Light", message: responseObj.message!, controller: self)
                Defaults[self.ap.available] = 0
                //                self.availabilitySet()
                
                
            }
            
        }, fail: { (error) in
        }, showHUD: true)
        
      
    }
    
    func availabilityOfNurse() {
        
//        var setAvail = 0
//
//        if Defaults[ap.available] == 0 {
//            setAvail = 1
//        } else {
//            setAvail = 0
//        }
     
        
        
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // The number of columns of data
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    // The number of rows of data
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.pickerData.count
    }
    
    // The data to return for the row and component (column) that's being passed in
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return self.pickerData[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.NurseSpecilitySelect = pickerData[row]

    }
   
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        let attributedString = NSAttributedString(string: pickerData[row] , attributes: [NSAttributedStringKey.foregroundColor : UIColor.white])
        return attributedString
    }

}

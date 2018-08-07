//
//  CLStartVC.swift
//  Call Light
//
//  Created by Ahmed Durrani on 14/04/2018.
//  Copyright © 2018 Tech Ease Solution. All rights reserved.
//

import UIKit

class CLStartVC: UIViewController {
    
    @IBOutlet weak var btnSignUp: UIButton!
    @IBOutlet weak var btnSignIn : UIButton!
    @IBOutlet weak var viewOfButton : UIView!
    
    
    @IBOutlet weak var btnNursePressed : UIButton!
    @IBOutlet weak var btnHospitalPressed : UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        SELECTUSER =  "Nurse"

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setUI(){
        
        btnNursePressed.backgroundColor = UIColor.white
        btnHospitalPressed.backgroundColor = UIColor.clear

        btnNursePressed.isSelected = true
        btnHospitalPressed.isSelected = false
        
        UtilityHelper.setViewBorder(viewOfButton, withWidth: 0.9 , andColor: UIColor.white)
     
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        verifyAutoLogin()
    }
    
    func configureSizeOfViews(){
        NotificationCenter.default.addObserver(self, selector: #selector(CLStartVC.verifyAutoLogin), name: Notification.Name(rawValue: "Auto"), object: nil)
    }
    
    
    @objc func verifyAutoLogin() {
        //        var phone = UserDefaults.standard.string(forKey: "phone")
        let pass = UserDefaults.standard.string(forKey: "password")
        
        let email = UserDefaults.standard.string(forKey: "email")
        var deviceToken =  UserDefaults.standard.value(forKey: "deviceToken") as? String
        let user_token = UserDefaults.standard.string(forKey: "user_token")
        
        
        if user_token != nil && (user_token?.count)! > 0 {
            if deviceToken == nil {
                deviceToken = ""
            }
            let loginParam = [ "email"         : email! ,
                               "password"      : pass! ,
                               "device_type"   : "ios" ,
                               "device_token"  : deviceToken!
                
                            ] as [String : Any]
            WebServiceManager.post(params: loginParam as Dictionary<String, AnyObject>, serviceName: LOGIN, isLoaderShow: true, serviceType: "autologin", modelType: UserResponse.self, success: { (response) in
                let responseObj = response as! UserResponse
                
                if responseObj.success == true {
                    localUserData = responseObj.data
                    
                    if responseObj.data?.isVerified == true {
                        if responseObj.data?.type == "Hospital" {
                            let story = UIStoryboard(name: "Home", bundle: nil)
                            let vc = story.instantiateViewController(withIdentifier: "TabBarViewController")
                            let nav = UINavigationController(rootViewController: vc)
                            nav.isNavigationBarHidden = true
                            UIApplication.shared.keyWindow?.rootViewController = nav
                            
                        } else {
                            let story = UIStoryboard(name: "Home", bundle: nil)
                            let vc = story.instantiateViewController(withIdentifier: "NurseTabBarVC")
                            let nav = UINavigationController(rootViewController: vc)
                            nav.isNavigationBarHidden = true
                            UIApplication.shared.keyWindow?.rootViewController = nav
                        }
                    } else {
                        self.showAlert(title: "Call Light", message: responseObj.message! , controller: self)
                    }
                  

                    
                    
                }else {
                        self.showAlert(title: KMessageTitle, message: responseObj.message!, controller: self)
//                    JSSAlertView().danger(self, title: KMessageTitle , text: responseObj.message!)
                }
            }, fail: { (error) in
                self.showAlert(title: "Error", message: error.localizedDescription, controller: self)
            }, showHUD: true)
        }
    }


    @IBAction func btnNurse_Pressed(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        btnNursePressed.isSelected = true
        btnHospitalPressed.isSelected = false
        btnNursePressed.backgroundColor = UIColor.white
        btnHospitalPressed.backgroundColor = UIColor.clear
        SELECTUSER =  "Nurse"

        
        
    }
    
    @IBAction func btnHospital_Pressed(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        btnNursePressed.isSelected = false
        btnHospitalPressed.isSelected = true
        btnNursePressed.backgroundColor = UIColor.clear
        btnHospitalPressed.backgroundColor = UIColor.white
        SELECTUSER =  "Hospital"

    }
    
    
    
    @IBAction func btnSign_Pressed(_ sender: UIButton) {
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "CLSignInVC") as? CLSignInVC
        self.navigationController?.pushViewController(vc!, animated: true)
    }
    
    @IBAction func btnSignUp_Pressed(_ sender: UIButton) {
    
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "CLSignUpVC") as? CLSignUpVC
        self.navigationController?.pushViewController(vc!, animated: true)
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

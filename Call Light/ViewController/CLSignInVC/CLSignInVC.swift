//
//  CLSignInVC.swift
//  Call Light
//
//  Created by Ahmed Durrani on 14/04/2018.
//  Copyright © 2018 Tech Ease Solution. All rights reserved.
//

import UIKit

class CLSignInVC: UIViewController {
    
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtPassword: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
        // Do any additional setup after loading the view.
    }

    
    func setUpUI(){
//        txtEmail.text = "ahmadyar@ibexglobal.com"
//        txtPassword.text = "123456789"

        
        
        txtEmail.setLeftPaddingPoints(10)
        txtPassword.setLeftPaddingPoints(10)
        
        UtilityHelper.setViewBorder(txtPassword, withWidth: 0.9 , andColor: UIColor.white)
        UtilityHelper.setViewBorder(txtEmail, withWidth: 0.9 , andColor: UIColor.white)
        
        txtPassword.layer.cornerRadius = 20.0
        txtPassword.layer.borderWidth = 0.9
        
        
        txtEmail.layer.cornerRadius = 20.0
        txtEmail.layer.borderWidth = 0.9

        
    }
    
    
    
    @IBAction func btnForgotPassword_Pressed(_ sender: UIButton) {
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "CLForgotPasswordVC") as? CLForgotPasswordVC
        self.navigationController?.pushViewController(vc!, animated: true)

        
    }
    
    @IBAction func btnFacebookLogin_Pressed(_ sender: UIButton) {
        
        
    }
    @IBAction func btnSign_Pressed(_ sender: UIButton) {
        
        
        var deviceToken =  UserDefaults.standard.value(forKey: "deviceToken") as? String
        
        if deviceToken == nil {
            deviceToken = "-1"
        }
        let loginParam =     [ "email"          : txtEmail.text!,
                               "password"       : txtPassword.text!,
                               "device_token"   : deviceToken!
            
            ] as [String : Any]
        
        WebServiceManager.post(params:loginParam as Dictionary<String, AnyObject> , serviceName: LOGIN, isLoaderShow: true, serviceType: "Login", modelType: UserResponse.self, success: { (response) in
            let responseObj = response as! UserResponse
            
            if responseObj.success == true {
                

                
                localUserData = responseObj.data
                UserDefaults.standard.set(self.txtEmail.text! , forKey: "email")
                UserDefaults.standard.set(responseObj.data?.id , forKey: "id")
                UserDefaults.standard.set(self.txtPassword.text! , forKey: "password")
                UserDefaults.standard.set(localUserData.apiToken , forKey: "user_token")
                
                if responseObj.data?.isVerified == true && responseObj.data?.is_accepted == true  {

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
                self.showAlert(title: "Call Light", message: responseObj.message!, controller: self)

                
            }
            
        }, fail: { (error) in
        }, showHUD: true)
        
    }
        
    
    
    @IBAction func btnsignUp_Pressed(_ sender: UIButton) {
    
        self.navigationController?.popViewController(animated: true)

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

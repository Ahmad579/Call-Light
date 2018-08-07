//
//  CLChnagePasswordVC.swift
//  Call Light
//
//  Created by Ahmed Durrani on 14/04/2018.
//  Copyright © 2018 Tech Ease Solution. All rights reserved.
//

import UIKit

class CLChnagePasswordVC: UIViewController {
    
    @IBOutlet weak var txtNewPassword: UITextField!
    @IBOutlet weak var txtConfirmPass: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
        // Do any additional setup after loading the view.
    }
    
    func setUpUI(){
        
        txtNewPassword.setLeftPaddingPoints(10)
        txtConfirmPass.setLeftPaddingPoints(10)
        
        UtilityHelper.setViewBorder(txtNewPassword, withWidth: 0.9 , andColor: UIColor.white)
        UtilityHelper.setViewBorder(txtConfirmPass, withWidth: 0.9 , andColor: UIColor.white)
        
        txtConfirmPass.layer.cornerRadius = 20.0
        txtConfirmPass.layer.borderWidth = 0.9
        
        
        txtNewPassword.layer.cornerRadius = 20.0
        txtNewPassword.layer.borderWidth = 0.9
        
        
    }
    
    
    @IBAction func btnBack_Pressed(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func btnChange_Pressed(_ sender: UIButton) {
        
        let loginParam =  [ "password"               : txtNewPassword.text! ,
                            "password_confirmation"  : txtConfirmPass.text!
            ] as [String : Any]
        
        
        let serviceUrl =  RESET_PASSWORD + "?api_token=\(localUserData.apiToken!)"

        
        WebServiceManager.post(params:loginParam as Dictionary<String, AnyObject> , serviceName: serviceUrl, isLoaderShow: true, serviceType: "Forgot Password", modelType: UserResponse.self, success: { (response) in
            let responseObj = response as! UserResponse
            
            if responseObj.success == true {
                self.showAlert(title: "Call Light", message: responseObj.message!, controller: self)
            }else {
                self.showAlert(title: "Call Light", message: responseObj.message!, controller: self)
            }
            
        }, fail: { (error) in
        }, showHUD: true)
    
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

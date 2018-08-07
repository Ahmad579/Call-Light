//
//  CLForgotPasswordVC.swift
//  Call Light
//
//  Created by Ahmed Durrani on 14/04/2018.
//  Copyright © 2018 Tech Ease Solution. All rights reserved.
//

import UIKit

class CLForgotPasswordVC: UIViewController {
    
    @IBOutlet weak var txtEmail: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
        // Do any additional setup after loading the view.
    }
    
    func setUpUI(){
        
        txtEmail.setLeftPaddingPoints(10)
        
        UtilityHelper.setViewBorder(txtEmail, withWidth: 0.9 , andColor: UIColor.white)
        
        
        
        txtEmail.layer.cornerRadius = 20.0
        txtEmail.layer.borderWidth = 0.9
        
        
    }

    @IBAction func btnReset_Pressed(_ sender: UIButton) {
        
        
        let loginParam =  [ "email"         : txtEmail.text!
            ] as [String : Any]
        
        WebServiceManager.post(params:loginParam as Dictionary<String, AnyObject> , serviceName: FORGOTPASSWORD, isLoaderShow: true, serviceType: "Forgot Password", modelType: UserResponse.self, success: { (response) in
            let responseObj = response as! UserResponse
            
            if responseObj.success == true {
//                localUserData = responseObj.data
                
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "CLVerifyPasswordVC") as? CLVerifyPasswordVC
                vc?.email = self.txtEmail.text!
                self.navigationController?.pushViewController(vc!, animated: true)

                self.showAlert(title: "Call Light", message: responseObj.message!, controller: self)
                
                
            }else {
                self.showAlert(title: "Call Light", message: responseObj.message!, controller: self)
                
                
            }
            
        }, fail: { (error) in
        }, showHUD: true)
        
//
        
        
        
    }

    
    @IBAction func btnBack_Pressed(_ sender: UIButton) {
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

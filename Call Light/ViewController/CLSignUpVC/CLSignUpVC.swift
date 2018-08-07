//
//  CLSignUpVC.swift
//  Call Light
//
//  Created by Ahmed Durrani on 14/04/2018.
//  Copyright © 2018 Tech Ease Solution. All rights reserved.
//

import UIKit

class CLSignUpVC: UIViewController {

    @IBOutlet weak var txtName: UITextField!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var txtConfirmPass: UITextField!
    @IBOutlet weak var txtPhoneNum: UITextField!
    @IBOutlet weak var txtAddress: UITextField!


    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()

        
        // Do any additional setup after loading the view.
    }
    
    func setUpUI(){
        
        txtName.setLeftPaddingPoints(10)
        txtEmail.setLeftPaddingPoints(10)
        txtPassword.setLeftPaddingPoints(10)
        txtConfirmPass.setLeftPaddingPoints(10)
        txtPhoneNum.setLeftPaddingPoints(10)
        txtAddress.setLeftPaddingPoints(10)
        
        if SELECTUSER == "Hospital" {
            txtName.placeholder = "Hospital Name"
            txtEmail.placeholder = "Hospital Email"
            txtPassword.placeholder = "Hospital Password"
            txtConfirmPass.placeholder = "Hospital Confirm Password"
            txtPhoneNum.placeholder = "Hospital Phone Number"
            txtAddress.placeholder = "Hospital Address"
            txtName.placeHolderColor = UIColor.white
            txtEmail.placeHolderColor = UIColor.white
            txtPassword.placeHolderColor = UIColor.white
            txtConfirmPass.placeHolderColor = UIColor.white
            txtPhoneNum.placeHolderColor = UIColor.white
            txtAddress.placeHolderColor = UIColor.white

        } else if SELECTUSER == "Nurse" {
            txtName.placeholder = "Nurse Name"
            txtEmail.placeholder = "Nurse Email"
            txtPassword.placeholder = "Nurse  Password"
            txtConfirmPass.placeholder = "Nurse Confirm Password"
            txtPhoneNum.placeholder = "Nurse Phone Number"
            txtAddress.placeholder = "Nurse Address"
            txtName.placeHolderColor = UIColor.white
            txtEmail.placeHolderColor = UIColor.white
            txtPassword.placeHolderColor = UIColor.white
            txtConfirmPass.placeHolderColor = UIColor.white
            txtPhoneNum.placeHolderColor = UIColor.white
            txtAddress.placeHolderColor = UIColor.white
        }
        

        
        
        UtilityHelper.setViewBorder(txtName, withWidth: 0.9 , andColor: UIColor.white)
        UtilityHelper.setViewBorder(txtEmail, withWidth: 0.9 , andColor: UIColor.white)
        UtilityHelper.setViewBorder(txtPassword, withWidth: 0.9 , andColor: UIColor.white)
        UtilityHelper.setViewBorder(txtConfirmPass, withWidth: 0.9 , andColor: UIColor.white)
        UtilityHelper.setViewBorder(txtPhoneNum, withWidth: 0.9 , andColor: UIColor.white)
        UtilityHelper.setViewBorder(txtAddress, withWidth: 0.9 , andColor: UIColor.white)

        txtName.layer.cornerRadius = 20.0
        txtName.layer.borderWidth = 0.9
        
        
        txtEmail.layer.cornerRadius = 20.0
        txtEmail.layer.borderWidth = 0.9

        txtPassword.layer.cornerRadius = 20.0
        txtPassword.layer.borderWidth = 0.9

        txtConfirmPass.layer.cornerRadius = 20.0
        txtConfirmPass.layer.borderWidth = 0.9

        txtPhoneNum.layer.cornerRadius = 20.0
        txtPhoneNum.layer.borderWidth = 0.9

        txtAddress.layer.cornerRadius = 20.0
        txtAddress.layer.borderWidth = 0.9

        
        
    }
    @IBAction func btnSignUp_Pressed(_ sender: UIButton) {

        var deviceToken =  UserDefaults.standard.value(forKey: "device_token") as? String
        
        if deviceToken == nil {
            deviceToken = "-1"
        }
        let loginParam =  [ "name"           : txtName.text!,
                            "email"          : txtEmail.text!,
                            "phone"          : txtPhoneNum.text! ,
                            "password"       : txtPassword.text! ,
                            "type"           : SELECTUSER ,
                            "device_token"   : deviceToken!
            
            ] as [String : Any]
        
        WebServiceManager.post(params:loginParam as Dictionary<String, AnyObject> , serviceName: SIGNUP, isLoaderShow: true, serviceType: "Login", modelType: UserResponse.self, success: { (response) in
            let responseObj = response as! UserResponse
            
            if responseObj.success == true {
                localUserData = responseObj.data
                self.showAlert(title: "Call Light", message: responseObj.message!, controller: self)
                
                
            }else {
                self.showAlert(title: "Call Light", message: responseObj.message!, controller: self)

                
            }
//        }
        }, fail: { (error) in

        
        }, showHUD: true)
        
    }
        
        
        
    
    
    @IBAction func btnSign_Pressed(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

extension UITextField{
    @IBInspectable var placeHolderColor: UIColor? {
        get {
            return self.placeHolderColor
        }
        set {
            self.attributedPlaceholder = NSAttributedString(string:self.placeholder != nil ? self.placeholder! : "", attributes:[NSAttributedStringKey.foregroundColor: newValue!])
        }
    }
    
    func setLeftPaddingPoints(_ amount:CGFloat){
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.leftView = paddingView
        self.leftViewMode = .always
    }
    func setRightPaddingPoints(_ amount:CGFloat) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.rightView = paddingView
        self.rightViewMode = .always
    }
    
}

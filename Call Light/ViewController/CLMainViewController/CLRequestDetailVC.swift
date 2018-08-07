//
//  CLRequestDetailVC.swift
//  Call Light
//
//  Created by Ahmed Durrani on 14/04/2018.
//  Copyright © 2018 Tech Ease Solution. All rights reserved.
//

import UIKit
import Cosmos
class CLRequestDetailVC: UIViewController {
    
    var nurseList : NurseListObject?
    var doctorId : NurseListObject?

    var startDate: String!
    //    var endDate: String!
    var startTime: String!
    var endTime: String!
    var endTym: Date!
    var choice: Int = 1

    @IBOutlet weak var txtRNorLN: UITextField!
    @IBOutlet weak var txtShiftTime: UITextField!
    @IBOutlet weak var txtAddress: UITextField!

    @IBOutlet weak var shift: UILabel!

    @IBOutlet weak var imgOfNurse: UIImageView!
    
    @IBOutlet weak var lblName: UILabel!
    
    @IBOutlet weak var viewOFrating: CosmosView!
    @IBOutlet weak var btnRequestInDetail: UIButton!
    let ap = UIApplication.shared.delegate as! AppDelegate

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpUI()

        if ap.nursesID.contains((nurseList?.id)!) {
            btnRequestInDetail.isUserInteractionEnabled = false
            btnRequestInDetail.alpha = 0.5;

         print("True")
        } else {
            print("false")
            btnRequestInDetail.isUserInteractionEnabled = true

            btnRequestInDetail.alpha = 1.0;


        }
    
    }
    
    
    func setUpUI(){
//        txtEmail.text = "ahmadyar@ibexglobal.com"
//        txtPassword.text = "123456789"
        
        
        
        txtRNorLN.setLeftPaddingPoints(10)
        txtAddress.setLeftPaddingPoints(10)
        txtRNorLN.setLeftPaddingPoints(10)

        UtilityHelper.setViewBorder(txtRNorLN, withWidth: 0.9 , andColor: UIColor.white)
        UtilityHelper.setViewBorder(txtAddress, withWidth: 0.9 , andColor: UIColor.white)
        UtilityHelper.setViewBorder(txtShiftTime, withWidth: 0.9 , andColor: UIColor.white)

      
        txtShiftTime.layer.cornerRadius = 20.0
        txtShiftTime.layer.borderWidth = 0.9
        
        
        txtAddress.layer.cornerRadius = 20.0
        txtAddress.layer.borderWidth = 0.9

        txtRNorLN.layer.cornerRadius = 20.0
        txtRNorLN.layer.borderWidth = 0.9
        
        
        
        
        txtAddress.setLeftPaddingPoints(20)
        txtRNorLN.setLeftPaddingPoints(20)
        txtShiftTime.setLeftPaddingPoints(20)

        self.lblName.text = self.nurseList?.name
        
        if nurseList?.shift == "0"{
            self.txtShiftTime.text = "7 am to 7 pm"

        } else if nurseList?.shift == "1" {
            self.txtShiftTime.text = "7 pm to 7 am"

        } else {
            self.txtShiftTime.text = "Any time"
            
        }
        
        if nurseList?.type == "0"{
            self.txtRNorLN.text = "RN"
        } else {
            self.txtRNorLN.text = "LVN/LPN"

        }
        
        if let addres = nurseList?.address {
            txtAddress.text = addres
        }
        
        if self.nurseList?.avatar_url == nil {
            
            let cgFloat: CGFloat = self.imgOfNurse.frame.size.width/2.0
            let someFloat = Float(cgFloat)
            WAShareHelper.setViewCornerRadius(imgOfNurse, radius: CGFloat(someFloat))
//            self.cover_image = orignal
     
        } else {
            let cgFloat: CGFloat = imgOfNurse.frame.size.width/2.0
            let someFloat = Float(cgFloat)
            WAShareHelper.setViewCornerRadius(imgOfNurse, radius: CGFloat(someFloat))

        }
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func btnCancel_Pressed(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)

        
    }
    
    @IBAction func btnBack_Pressed(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func requestAction(_ sender: Any) {
        showOptions()
    }

    func showOptions() {
        // current date
        let date = Date()
        let formatter = DateFormatter()
        
        formatter.dateFormat = "yyyy-MM-dd"
        let result = formatter.string(from: date)
        
        // create the alert
        let alert = UIAlertController(title: "Request Nurse", message: "please select from the appropriate options", preferredStyle: UIAlertControllerStyle.alert)
        
        // add the actions (buttons)
        alert.addAction(UIAlertAction(title: "Default Timings", style: UIAlertActionStyle.default, handler: {action in
            if self.txtShiftTime.text == "7 am to 7 pm" {
                self.startTime = "7:00:00"
                self.endTime = "19:00:00"
            } else {
                self.startTime = "19:00:00"
                self.endTime = "7:00:00"
            }
            self.startDate = result
            
            
            
            self.requestSave()
        }))
        
        alert.addAction(UIAlertAction(title: "Custom Timings", style: UIAlertActionStyle.default, handler: { action in
            self.customTimings()
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil))
        
       
        self.present(alert, animated: true, completion: nil)
    }
    
    
    func requestSave() {
        if choice == 1 {
            
            
//            let selectUserId = self.responseObj?.nurseList![indexPath.row].id
//            let hospitalId   = self.hospitalProfile?.selectedNurseList?.id!
//            let serviceURL   =  HOSPITALREQUEST  + "?api_token=\(localUserData.apiToken!)"
            
            let dateFormatter : DateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            let date = Date()
            let dateString = dateFormatter.string(from: date)
            
//            let loginParam =     [ "hospital_id"          : "\(hospitalId!)",
//                "nurse_id"             : "\(selectUserId!)" ,
//                "shift_date"           :    dateString ,
//                "shift_start_time"     : "7:00:00" ,
//                "shift_end_time"       : "19:00:00" ,
//
//                ] as [String : Any]
//
            
            let selectUserId = self.nurseList?.id
            let hospitalId = self.doctorId?.id
            let serviceURL =  HOSPITALREQUEST  + "?api_token=\(localUserData.apiToken!)"
            
            let loginParam =
              [ "hospital_id"          : "\(hospitalId!)",
                "nurse_id"             : "\(selectUserId!)" ,
                "shift_date"           : dateString ,
                "shift_start_time"     : "7:00:00" ,
                "shift_end_time"       : "19:00:00" ,
                
                ] as [String : Any]
            
            WebServiceManager.post(params:loginParam as Dictionary<String, AnyObject> , serviceName: serviceURL, isLoaderShow: true, serviceType: "Login", modelType: UserResponse.self, success: { (response) in
                let responseObj = response as! UserResponse
                
                if responseObj.success == true {
                    
                    self.showAlert(title: "Call Light", message: "Request Sent to Nurse" , controller: self)
                }else {
                    self.showAlert(title: "Call Light", message: responseObj.message!, controller: self)
                    
                    
                }
                
            }, fail: { (error) in
            }, showHUD: true)
            
        } else {
            endTimeSet()

        }
    
    }
    
    func customTimings() {
        // create the alert
        let alert = UIAlertController(title: "Request Nurse", message: "please set start time (default end time is 12 hours from the selected time) \n\n\n\n\n\n\n\n\n\n\n\n", preferredStyle: UIAlertControllerStyle.alert)
        
        // add the actions (buttons)
        alert.addAction(UIAlertAction(title: "Save", style: UIAlertActionStyle.default, handler: {action in
            self.requestSave()
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: {action in
//            self.choice = 1
        }))
        
        // adding custom alert view
        // Start time picker
        let startTimePicker = UIDatePicker(frame:
            CGRect(x: 5, y: 76, width: 260, height: 162))
        startTimePicker.datePickerMode = UIDatePickerMode.time
        startTimePicker.minuteInterval = 30
        startTimePicker.addTarget(self, action: #selector(CLRequestDetailVC.startValueDidChange), for: .valueChanged)
        
        
        //label
        let label = UILabel(frame: CGRect(x: -5, y: 255, width: 200, height: 17))
        //        label.center = CGPoint(x: 0, y: 285)
        label.textAlignment = .center
        label.text = "Standard 12 hours shift"
        
        //switch
        let uiswitch = UISwitch(frame:  CGRect(x: 205, y: 247, width: 0, height: 0))
        uiswitch.isOn = true
        uiswitch.setOn(true, animated: false);
        uiswitch.addTarget(self, action: #selector(CLRequestDetailVC.switchValueDidChange), for: .valueChanged)
        
        // comment this line to use white color
        startTimePicker.backgroundColor = UIColor.lightGray.withAlphaComponent(0.2)
        alert.view.addSubview(startTimePicker)
        alert.view.addSubview(label)
        alert.view.addSubview(uiswitch)
        
        // show the alert
        self.present(alert, animated: true, completion: nil)
    }
    
    @objc func startValueDidChange(sender: UIDatePicker) {
        var date = DateFormatter()
        var time = DateFormatter()
        
        date.dateFormat = "yyyy-MM-dd"
        time.dateFormat = "hh:mm:ss"
        var selectedDate = date.string(from: sender.date)
        var selectedTime = time.string(from: sender.date)
        
        startDate = selectedDate
        startTime = selectedTime
        endTym = sender.date.addingTimeInterval(12*60)
        var entym = time.string(from: endTym)
        endTime = entym
        //        print ("start Value changed", sender.date)
        //        print ("start Value changed", selectedDate)
        //        print ("start Value changed", selectedTime)
    }
    
    @objc func endValueDidChange(sender: UIDatePicker) {
        print ("end value changed",sender.date)
        var date = DateFormatter()
        var time = DateFormatter()
        date.dateFormat = "yyyy-MM-dd"
        time.dateFormat = "hh:mm:ss"
        var selectedDate = date.string(from: sender.date)
        var selectedTime = time.string(from: sender.date)
        startDate = selectedDate
        endTime = selectedTime
        //        print ("start Value changed", sender.date)
        //        print ("start Value changed", selectedDate)
        //        print ("start Value changed", selectedTime)
    }
    
    @objc func switchValueDidChange( ) {
        //        print("value changes")
        var time = DateFormatter()
        time.dateFormat = "hh:mm:ss"
        
        if choice == 1 {
            choice = 0
            if endTym != nil {
                var selectedTime = time.string(from: endTym)
                endTime = selectedTime
            }
        } else {
            choice = 1
        }
    }
    
    func endTimeSet() {
        // create the alert
        let alert = UIAlertController(title: "Request Nurse", message: "please set END time\n\n\n\n\n\n\n\n\n\n", preferredStyle: UIAlertControllerStyle.alert)
        
        // add the actions (buttons)
        alert.addAction(UIAlertAction(title: "Request", style: UIAlertActionStyle.default, handler: {action in
            self.choice = 1
            self.requestSave()
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: {action in
            self.choice = 1
        }))
        
        // adding custom alert view
        // Start time picker
        let endTimePicker = UIDatePicker(frame:
            CGRect(x: 5, y: 73, width: 260, height: 162))
        endTimePicker.datePickerMode = UIDatePickerMode.time
        endTimePicker.minuteInterval = 30
        endTimePicker.addTarget(self, action: #selector(CLRequestDetailVC.endValueDidChange), for: .valueChanged)
        
        // comment this line to use white color
        endTimePicker.backgroundColor = UIColor.lightGray.withAlphaComponent(0.2)
        alert.view.addSubview(endTimePicker)
        
        
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

//
//  CLRequestVC.swift
//  Call Light
//
//  Created by Ahmed Durrani on 14/04/2018.
//  Copyright © 2018 Tech Ease Solution. All rights reserved.
//

import UIKit
import Cosmos
class CLRequestVC: UIViewController {
    
    //
    
    @IBOutlet var tblView: UITableView!
    var responseObj: UserResponse?
    var hospitalProfile: UserResponse?
    var nurseProfile: UserResponse?

    @IBOutlet weak var txtViewRating: UITextView!
    
    @IBOutlet weak var btnAll: UIButton!
    @IBOutlet weak var btnICU : UIButton!
    @IBOutlet weak var btnLabor : UIButton!
    @IBOutlet weak var btnSurgical : UIButton!
    @IBOutlet weak var btnEr : UIButton!
    @IBOutlet weak var btnCathLab : UIButton!
    
    @IBOutlet weak var viewOfFirst : UIView!
    @IBOutlet weak var viewOfSecondRow : UIView!
    @IBOutlet weak var viewOfThirdRow : UIView!


    
    //
    
    @IBOutlet weak var btnAny : UIButton!
    @IBOutlet weak var btnLPNLVN : UIButton!
    @IBOutlet weak var btnRN : UIButton!

    
    //
    
    
    @IBOutlet weak var btnAnythird : UIButton!
    @IBOutlet weak var btn7PMTO7am : UIButton!
    @IBOutlet weak var btn7amTO7pm : UIButton!
    
    var row = 0
    var all = 0
    var time = 0
    var NurseShift = 0
   
    var NurseShiftSelect = 2
    var NurseSpeciality = 5
    var NurseTypeSelect = 2

    var speciality = 0
    
    var ratingOfUser : Double?

    
    var index: Int?
    var nurseId : Any?
   
    @IBOutlet weak var lblNurseName: UILabel!
    @IBOutlet weak var viewOfRating: CosmosView!
    @IBOutlet weak var popOfUserRating: UIView!
    private let refreshControl = UIRefreshControl()
    let ap = UIApplication.shared.delegate as! AppDelegate

    override func viewDidLoad() {
        super.viewDidLoad()
        tblView.register(UINib(nibName: "NurseCell", bundle: nil), forCellReuseIdentifier: "NurseCell")
        popOfUserRating.isHidden = true
        self.txtViewRating.placeholder = "Enter the Comment!"
        viewOfRating.didTouchCosmos = didTouchCosmos
        viewOfRating.didFinishTouchingCosmos = didFinishTouchingCosmos
        NotificationCenter.default.addObserver(self, selector: #selector(CLRequestVC.EndShiftNotify(_:)), name: NSNotification.Name(rawValue: "ShiftEnd"), object: nil)
       if #available(iOS 10.0, *) {
        tblView.refreshControl = refreshControl
        } else {
        tblView.addSubview(refreshControl)
        }
        refreshControl.addTarget(self, action: #selector(refreshWeatherData(_:)), for: .valueChanged)
        
        ratingOfUser = 2.5
        self.viewOfRating.rating = ratingOfUser!

        setUI()
        
        
       

    }
    
    @objc private func refreshWeatherData(_ sender: Any) {
        // Fetch Weather Data
        getFilteredNurse()
    }
    private class func formatValue(_ value: Double) -> String {
        return String(format: "%.2f", value)
    }
    
    private func didTouchCosmos(_ rating: Double) {
        
        print(rating)
    }
    
    private func didFinishTouchingCosmos(_ rating: Double) {
        ratingOfUser = rating
        print(rating)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        btnAll.backgroundColor = UIColor.white
        btnAll.isSelected = true
        
        btnAny.backgroundColor = UIColor.white
        btnAny.isSelected = true
        
        btnAnythird.backgroundColor = UIColor.white
        btnAnythird.isSelected = true
        
        
        btnICU.backgroundColor = UIColor.clear
        btnLabor.backgroundColor = UIColor.clear
        btnSurgical.backgroundColor = UIColor.clear
        btnEr.backgroundColor = UIColor.clear
        btnCathLab.backgroundColor = UIColor.clear
        
        btnICU.isSelected = false
        btnLabor.isSelected = false
        btnSurgical.isSelected = false
        btnEr.isSelected = false
        btnCathLab.isSelected = false

//        btnAny.backgroundColor = UIColor.white
        btnLPNLVN.backgroundColor = UIColor.clear
        btnRN.backgroundColor = UIColor.clear
        
        btnLPNLVN.isSelected = false
        btnRN.isSelected = false
        
        btn7PMTO7am.backgroundColor = UIColor.clear
        btn7amTO7pm.backgroundColor = UIColor.clear
        
        btn7PMTO7am.isSelected = false
        btn7amTO7pm.isSelected = false
        
        
    }
    @IBAction func btnDirectRequestToNurse(_ sender: UIButton) {
        
            let dateFormatter : DateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            let date = Date()
            let dateString = dateFormatter.string(from: date)
            
            
            let formatter = DateFormatter()
            formatter.locale = Locale(identifier: "en_US_POSIX")
            formatter.dateFormat = "h:mm a"
            formatter.amSymbol = "AM"
            formatter.pmSymbol = "PM"
            
            let startDate = formatter.string(from: Date())
            var dateStringCatch = formatter.string(from: Date())
            
            if dateStringCatch.contains("AM") {
                dateStringCatch = dateStringCatch.replacingOccurrences(of: "AM", with: "PM")
                
            } else {
                dateStringCatch = dateStringCatch.replacingOccurrences(of: "PM", with: "AM")
                
            }
            
            let hospitalId   = self.hospitalProfile?.selectedNurseList?.id!
            let loginParam =     [ "api_token"            : localUserData.apiToken!,
                                   "speciality"           : NurseSpeciality ,
                                   "type"                 : NurseTypeSelect ,
                                   "shift"                : NurseShiftSelect ,
                                   "hospital_id"          : hospitalId! ,
                                   "shift_date"           : dateString ,
                                   "shift_start_time"     : startDate ,
                                   "shift_end_time"       : dateStringCatch
                
                ] as [String : Any]

        WebServiceManager.post(params:loginParam as Dictionary<String, AnyObject> , serviceName: DIRECTREQUESTTONURSE, isLoaderShow: true, serviceType: "Direct Request To Nurse", modelType: UserResponse.self, success: { (response) in
                let responseObj = response as! UserResponse
                
                if responseObj.success == true {
                    self.showAlert(title: "Call Light", message: responseObj.message! , controller: self)
                }else {
                    self.showAlert(title: "Call Light", message: responseObj.message!, controller: self)
                    
                    
                }
                
            }, fail: { (error) in
            }, showHUD: true)
      
        
    }
    
    @IBAction func btnRateNurse_pressed(_ sender: UIButton) {
        
        
        let serviceURL =  PROFILERATING  + "?api_token=\(localUserData.apiToken!)"
        
        let loginParam =     [ "rater"           : "Hospital",
                               "rater_id"        : localUserData.id! ,
                               "ratee"           : "Nurse" ,
                               "ratee_id"        : nurseId! ,
                               "rating"          : ratingOfUser! ,
                               "comment"         : self.txtViewRating.text!
            
            ] as [String : Any]
//
        WebServiceManager.post(params:loginParam as Dictionary<String, AnyObject> , serviceName: serviceURL, isLoaderShow: true, serviceType: "Rating", modelType: UserResponse.self, success: { (response) in
            let responseObj = response as! UserResponse
            
            if responseObj.success == true {
                self.showAlert(title: "Call Light", message: responseObj.message! , controller: self)
                
                
                self.popOfUserRating.isHidden = true
                self.getNurseList()
                
                
                
            }else {
                self.showAlert(title: "Call Light", message: responseObj.message!, controller: self)
                self.popOfUserRating.isHidden = true

                
            }
            
        }, fail: { (error) in
        }, showHUD: true)
    }
    
    @objc func EndShiftNotify(_ notification: NSNotification) {
            let userData = notification.userInfo
            nurseId  = userData![AnyHashable("nurse_id")]!
            ap.nursesID = []
            self.getNurseProfile(idOfNurse: nurseId!)
            self.tblView.reloadData()
//
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getNurseList()

    }
    
    func getNurseProfile(idOfNurse : Any){
        let serviceURL =  NURSEPROFILEBYID + "/\(idOfNurse)" + "?api_token=\(localUserData.apiToken!)"
        WebServiceManager.get(params: nil, serviceName: serviceURL, serviceType: "Service List", modelType: UserResponse.self, success: { (response) in
            self.nurseProfile = (response as! UserResponse)
            if  self.nurseProfile?.success == true {
                self.popOfUserRating.isHidden = false
                self.lblNurseName.text = self.nurseProfile?.data?.name
                
                
            }
            else {
            }
        }) { (error) in
            
            
        }

    }
    
    func getTheHospitalProfile() {
        let serviceURL =  HospitalPROFILE + "?api_token=\(localUserData.apiToken!)"
        WebServiceManager.get(params: nil, serviceName: serviceURL, serviceType: "Service List", modelType: UserResponse.self, success: { (response) in
            self.hospitalProfile = (response as! UserResponse)
            if  self.hospitalProfile?.success == true {
            }
            else {
            }
        }) { (error) in
            
            
        }
        
        
    }
    
    func getNurseList() {
        let serviceURL =  NURSELIST + "?api_token=\(localUserData.apiToken!)"
        WebServiceManager.get(params: nil, serviceName: serviceURL, serviceType: "Service List", modelType: UserResponse.self, success: { (response) in
            self.responseObj = (response as! UserResponse)
            self.refreshControl.endRefreshing()

            self.getTheHospitalProfile()
            
            if  self.responseObj?.success == true {
                //                self.showCustomPop(popMessage: (self.responseObj?.message!)!)
                self.tblView.delegate = self
                self.tblView.dataSource = self
                self.tblView.reloadData()
            }
            else {
                
                
                //            self.showAlert(title: "blink", message: (self.categoriesList?.message)!, controller: self)
            }
        }) { (error) in
            
            self.refreshControl.endRefreshing()

        }
    }
    
    
    
    func setUI(){
     
        btnAll.backgroundColor = UIColor.white
        btnICU.backgroundColor = UIColor.clear
        btnLabor.backgroundColor = UIColor.clear
        btnSurgical.backgroundColor = UIColor.clear
        btnEr.backgroundColor = UIColor.clear
        btnCathLab.backgroundColor = UIColor.clear

        btnAll.isSelected = true
        btnICU.isSelected = false
        btnLabor.isSelected = false
        btnSurgical.isSelected = false
        btnEr.isSelected = false
        btnCathLab.isSelected = false

        
       
        
        btnAny.backgroundColor = UIColor.white
        btnLPNLVN.backgroundColor = UIColor.clear
        btnRN.backgroundColor = UIColor.clear
        
        btnAny.isSelected = true
        btnLPNLVN.isSelected = false
        btnRN.isSelected = false

        
       
        
        btnAnythird.backgroundColor = UIColor.white
        btn7PMTO7am.backgroundColor = UIColor.clear
        btn7amTO7pm.backgroundColor = UIColor.clear
        
        btnAnythird.isSelected = true
        btn7PMTO7am.isSelected = false
        btn7amTO7pm.isSelected = false

        
        
        UtilityHelper.setViewBorder(viewOfFirst, withWidth: 0.9 , andColor: UIColor.white)
        UtilityHelper.setViewBorder(viewOfSecondRow, withWidth: 0.9 , andColor: UIColor.white)
        UtilityHelper.setViewBorder(viewOfThirdRow, withWidth: 0.9 , andColor: UIColor.white)
    }

   
    
//    NURSELIST
    
    @IBAction func btnSelectLaborType(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        if sender.tag == 0 {
            all = 0
            NurseSpeciality = 5
          
            btnAll.backgroundColor = UIColor.white
            btnICU.backgroundColor = UIColor.clear
            btnLabor.backgroundColor = UIColor.clear
            btnSurgical.backgroundColor = UIColor.clear
            btnEr.backgroundColor = UIColor.clear
            btnCathLab.backgroundColor = UIColor.clear

            btnAll.isSelected = true
            btnICU.isSelected = false
            btnLabor.isSelected = false
            btnSurgical.isSelected = false
            btnEr.isSelected = false
            btnCathLab.isSelected = false
            getFilteredNurse()

        } else if sender.tag == 1 {
           
            all = 1
            NurseSpeciality = 1

            
            btnAll.backgroundColor = UIColor.clear
            btnICU.backgroundColor = UIColor.white
            btnLabor.backgroundColor = UIColor.clear
            btnSurgical.backgroundColor = UIColor.clear
            btnEr.backgroundColor = UIColor.clear
            btnCathLab.backgroundColor = UIColor.clear

            btnAll.isSelected = false
            btnICU.isSelected = true
            btnLabor.isSelected = false
            btnSurgical.isSelected = false
            btnEr.isSelected = false
            btnCathLab.isSelected = false
            getFilteredNurse()

        } else if sender.tag == 2 {
            
            all = 2
            //            print(self.json)Labor
            NurseSpeciality = 2

//            all = 2
//            //            print(self.json)Labor
//            NurseSpeciality = "Labor+&+Delivery"
//
            btnAll.backgroundColor = UIColor.clear
            btnICU.backgroundColor = UIColor.clear
            btnLabor.backgroundColor = UIColor.white
            btnSurgical.backgroundColor = UIColor.clear
            btnEr.backgroundColor = UIColor.clear
            btnCathLab.backgroundColor = UIColor.clear

            btnAll.isSelected = false
            btnICU.isSelected = false
            btnLabor.isSelected = true
            btnSurgical.isSelected = false
            btnEr.isSelected = false
            btnCathLab.isSelected = false
            getFilteredNurse()

        }
        else if sender.tag == 3 {
            all = 3
            //            print(self.json)Surgical
            NurseSpeciality = 3

            btnAll.backgroundColor = UIColor.clear
            btnICU.backgroundColor = UIColor.clear
            btnLabor.backgroundColor = UIColor.clear
            btnSurgical.backgroundColor = UIColor.white
            btnEr.backgroundColor = UIColor.clear
            btnCathLab.backgroundColor = UIColor.clear

            btnAll.isSelected = false
            btnICU.isSelected = false
            btnLabor.isSelected = false
            btnSurgical.isSelected = true
            btnEr.isSelected = false
            btnCathLab.isSelected = false
            getFilteredNurse()

        }
        else if sender.tag == 4 {
            all = 4
            //            print(self.json)Cath. Lab
            NurseSpeciality = 0
            btnAll.backgroundColor = UIColor.clear
            btnICU.backgroundColor = UIColor.clear
            btnLabor.backgroundColor = UIColor.clear
            btnSurgical.backgroundColor = UIColor.clear
            btnEr.backgroundColor = UIColor.white
            btnCathLab.backgroundColor = UIColor.clear

            btnAll.isSelected = false
            btnICU.isSelected = false
            btnLabor.isSelected = false
            btnSurgical.isSelected = false
            btnEr.isSelected = true
            btnCathLab.isSelected = false
            getFilteredNurse()

        }
        else if sender.tag == 5 {
            all = 5
            NurseSpeciality = 4

            btnAll.backgroundColor = UIColor.clear
            btnICU.backgroundColor = UIColor.clear
            btnLabor.backgroundColor = UIColor.clear
            btnSurgical.backgroundColor = UIColor.clear
            btnEr.backgroundColor = UIColor.clear
            btnCathLab.backgroundColor = UIColor.white
            
            btnAll.isSelected = false
            btnICU.isSelected = false
            btnLabor.isSelected = false
            btnSurgical.isSelected = false
            btnEr.isSelected = false
            btnCathLab.isSelected = true
            getFilteredNurse()
            
        }
            
        else  {
           
            all = 0
            NurseSpeciality = 5
            getFilteredNurse()


        }
    }
    
    @IBAction func btnSecondRowRecord_Pressed(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected

        if sender.tag == 11 {
            
            NurseTypeSelect = 2
//            NurseType = 0
            speciality = 0
            btnAny.backgroundColor = UIColor.white
            btnLPNLVN.backgroundColor = UIColor.clear
            btnRN.backgroundColor = UIColor.clear

            btnAny.isSelected = true
            btnLPNLVN.isSelected = false
            btnRN.isSelected = false
            getFilteredNurse()


        } else if sender.tag == 12 {
            speciality = 1
//            NurseType = 1
            NurseTypeSelect = 1

            btnAny.backgroundColor = UIColor.clear
            btnLPNLVN.backgroundColor = UIColor.white
            btnRN.backgroundColor = UIColor.clear

            btnAny.isSelected = false
            btnLPNLVN.isSelected = true
            btnRN.isSelected = false
            getFilteredNurse()


        } else if sender.tag == 13 {
//            NurseType = 2
            speciality = 2
            NurseTypeSelect = 0

            btnAny.backgroundColor = UIColor.clear
            btnLPNLVN.backgroundColor = UIColor.clear
            btnRN.backgroundColor = UIColor.white

            btnAny.isSelected = false
            btnLPNLVN.isSelected = false
            btnRN.isSelected = true
            getFilteredNurse()


        }
       
        
    }
    
    
    @IBAction func btnThirdRow_Select(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected

        
        if sender.tag == 21 {
            
            
            time = 0
            NurseShift = 0
            NurseShiftSelect = 2
            btnAnythird.backgroundColor = UIColor.white
            btn7PMTO7am.backgroundColor = UIColor.clear
            btn7amTO7pm.backgroundColor = UIColor.clear

            btnAnythird.isSelected = true
            btn7PMTO7am.isSelected = false
            btn7amTO7pm.isSelected = false
            getFilteredNurse()


        } else if sender.tag == 22 {
            time = 1
            NurseShift = 1
            NurseShiftSelect = 1

            btnAnythird.backgroundColor = UIColor.clear
            btn7PMTO7am.backgroundColor = UIColor.white
            btn7amTO7pm.backgroundColor = UIColor.clear

            btnAnythird.isSelected = false
            btn7PMTO7am.isSelected = true
            btn7amTO7pm.isSelected = false
            getFilteredNurse()


        } else if sender.tag == 23 {
            time = 2
            NurseShift = 2
            NurseShiftSelect = 0

            btnAnythird.backgroundColor = UIColor.clear
            btn7PMTO7am.backgroundColor = UIColor.clear
            btn7amTO7pm.backgroundColor = UIColor.white

            btnAnythird.isSelected = false
            btn7PMTO7am.isSelected = false
            btn7amTO7pm.isSelected = true
            getFilteredNurse()


        }

        
    }
    
    
    func getFilteredNurse() {
        
        if NurseTypeSelect == 2 && NurseShiftSelect == 2 && NurseSpeciality == 5 {
            getNurseList()
            return
        }
        let serviceURL =  NURSELIST + "?api_token=\(localUserData.apiToken!)" + "&speciality=\(NurseSpeciality)" + "&type=\(NurseTypeSelect)" + "&shift=\(NurseShiftSelect)"
        WebServiceManager.get(params: nil, serviceName: serviceURL, serviceType: "Service List", modelType: UserResponse.self, success: { (response) in
            self.refreshControl.endRefreshing()

            self.responseObj = (response as! UserResponse)
            
            
            
            if  self.responseObj?.success == true {
                //                self.showCustomPop(popMessage: (self.responseObj?.message!)!)
                self.tblView.delegate = self
                self.tblView.dataSource = self
                self.tblView.reloadData()
            }
            else {
                
                self.refreshControl.endRefreshing()

                //            self.showAlert(title: "blink", message: (self.categoriesList?.message)!, controller: self)
            }
        }) { (error) in
            
            self.refreshControl.endRefreshing()

        }
    
    }
    
    
}

extension CLRequestVC : UITableViewDelegate , UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        var numOfSections: Int = 0
        if    self.responseObj?.nurseList?.isEmpty == false {
            numOfSections = 1
            tblView.backgroundView = nil
        }
        else {
            let noDataLabel = UILabel(frame: CGRect(x: 0, y: 0, width: tblView.bounds.size.width, height: tblView.bounds.size.height))
            noDataLabel.numberOfLines = 10
            if let aSize = UIFont(name: "Axiforma-Book", size: 14) {
                noDataLabel.font = aSize
            }
            noDataLabel.text = "There are currently no data."
            noDataLabel.textColor = UIColor(red: 119.0 / 255.0, green: 119.0 / 255.0, blue: 119.0 / 255.0, alpha: 1.0)
            noDataLabel.textAlignment = .center
            tblView.backgroundView = noDataLabel
            tblView.separatorStyle = .none
        }
        return numOfSections
        
        
        
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return (self.responseObj?.nurseList?.count)!
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "NurseCell", for: indexPath) as? NurseCell
        cell?.delegate = self
        cell?.index = indexPath
        cell?.lblNurseName.text = self.responseObj?.nurseList![indexPath.row].name
        let values = self.responseObj?.nurseList![indexPath.row].id
//        responseObj.selectedNurseList?.available == "1"
        let isNurseSelected = self.responseObj?.nurseList![indexPath.row].available
     
        if   isNurseSelected ==  true {
             cell?.btnSendRequestOrNot.isSelected = false
        } else {
            cell?.btnSendRequestOrNot.isSelected = true

        }
        
        if self.ap.nursesID.index(of: values!) != nil {
            //            checkSelectionStatus.remove(at: index)
            cell?.btnSendRequestOrNot.isSelected = true
        } else {
            cell?.btnSendRequestOrNot.isSelected = false

        }

        
        return cell!
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
//        let vc = self.storyboard?.instantiateViewController(withIdentifier: "MPClientSeeNotaryProfileVC") as? MPClientSeeNotaryProfileVC
//        vc?.selectNotaryList = self.responseObj?.notaryList![indexPath.row]
//        self.navigationController?.pushViewController(vc!, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 73.0
    }
    
}

extension CLRequestVC  : isRequestSend {
    
    func isDoctorSendRequest(checkCell: NurseCell, indexPath: IndexPath) {
        
        
        let selectUserId = self.responseObj?.nurseList![indexPath.row].id
        let hospitalId   = self.hospitalProfile?.selectedNurseList?.id!
        let serviceURL   =  HOSPITALREQUEST  + "?api_token=\(localUserData.apiToken!)"
        
        let dateFormatter : DateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let date = Date()
        let dateString = dateFormatter.string(from: date)
        
        
       
        
        let formatterss = DateFormatter()
        formatterss.locale = Locale(identifier: "en_US_POSIX")
        formatterss.dateFormat = "h:mm a"
        formatterss.amSymbol = "AM"
        formatterss.pmSymbol = "PM"
        
        let startDate = formatterss.string(from: Date())
        var dateStringCatch = formatterss.string(from: Date())
        
        if dateStringCatch.contains("AM") {
            dateStringCatch = dateStringCatch.replacingOccurrences(of: "AM", with: "PM")
            
        } else {
            dateStringCatch = dateStringCatch.replacingOccurrences(of: "PM", with: "AM")
            
        }
        
        
        let loginParam =     [ "hospital_id"          :  "\(hospitalId!)",
                               "nurse_id"             :  "\(selectUserId!)" ,
                               "shift_date"          :    dateString ,
                               "shift_start_time"     :   startDate ,
                               "shift_end_time"       :   dateStringCatch ,

                            ] as [String : Any]
        
        if checkCell.btnSendRequestOrNot.isSelected == true {
            WebServiceManager.post(params:loginParam as Dictionary<String, AnyObject> , serviceName: serviceURL, isLoaderShow: true, serviceType: "Login", modelType: UserResponse.self, success: { (response) in
                
    
                let responseObj = response as! UserResponse
                
                if responseObj.success == true {
                    self.ap.nursesID.append((self.responseObj?.nurseList![indexPath.row].id!)!)
                    checkCell.btnSendRequestOrNot.isSelected = true

                    self.showAlert(title: "Call Light", message: "Request Sent to Nurse" , controller: self)
                }else {
                    self.showAlert(title: "Call Light", message: responseObj.message!, controller: self)
                }
                
            }, fail: { (error) in
            }, showHUD: true)
        } else {
            checkCell.btnSendRequestOrNot.isSelected = true

            self.showAlert(title: "Call Light", message: "Request Already sent to this  Nurse" , controller: self)

        }
      
        
    }
    
    func isDoctorViewNurseProfile(checkCell: NurseCell, indexPath: IndexPath) {
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "CLRequestDetailVC") as? CLRequestDetailVC
        vc?.doctorId = self.hospitalProfile?.selectedNurseList
        vc?.nurseList = self.responseObj?.nurseList![indexPath.row]
        self.navigationController?.pushViewController(vc!, animated: true)
        
        
        
    }
    
    func isCancelRequest(checkCell: NurseCell, indexPath: IndexPath) {
        
    }
    
}

extension UITextView :UITextViewDelegate
{
    
    /// Resize the placeholder when the UITextView bounds change
    override open var bounds: CGRect {
        didSet {
            self.resizePlaceholder()
        }
    }
    
    /// The UITextView placeholder text
    public var placeholder: String? {
        get {
            var placeholderText: String?
            
            if let placeholderLabel = self.viewWithTag(100) as? UILabel {
                placeholderText = placeholderLabel.text
            }
            
            return placeholderText
        }
        set {
            if let placeholderLabel = self.viewWithTag(100) as! UILabel? {
                placeholderLabel.text = newValue
                placeholderLabel.sizeToFit()
            } else {
                self.addPlaceholder(newValue!)
            }
        }
    }
    
    /// When the UITextView did change, show or hide the label based on if the UITextView is empty or not
    ///
    /// - Parameter textView: The UITextView that got updated
    public func textViewDidChange(_ textView: UITextView) {
        if let placeholderLabel = self.viewWithTag(100) as? UILabel {
            placeholderLabel.isHidden = self.text.count > 0
        }
    }
    
    /// Resize the placeholder UILabel to make sure it's in the same position as the UITextView text
    private func resizePlaceholder() {
        if let placeholderLabel = self.viewWithTag(100) as! UILabel? {
            let labelX = self.textContainer.lineFragmentPadding
            let labelY = self.textContainerInset.top - 2
            let labelWidth = self.frame.width - (labelX * 2)
            let labelHeight = placeholderLabel.frame.height
            
            placeholderLabel.frame = CGRect(x: labelX, y: labelY, width: labelWidth, height: labelHeight)
        }
    }
    
    /// Adds a placeholder UILabel to this UITextView
    private func addPlaceholder(_ placeholderText: String) {
        let placeholderLabel = UILabel()
        
        placeholderLabel.text = placeholderText
        placeholderLabel.sizeToFit()
        
        placeholderLabel.font = self.font
        placeholderLabel.textColor = UIColor.lightGray
        placeholderLabel.tag = 100
        
        placeholderLabel.isHidden = self.text.count > 0
        
        self.addSubview(placeholderLabel)
        self.resizePlaceholder()
        self.delegate = self
    }
}


//
//  NurseHistoryVC.swift
//  Call Light
//
//  Created by Ahmed Durrani on 15/04/2018.
//  Copyright © 2018 Tech Ease Solution. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import SwiftyUserDefaults
import SVProgressHUD


class NurseHistoryVC: UIViewController  {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var availableBalance: UILabel!
    @IBOutlet weak var totalBalance: UILabel!
    @IBOutlet weak var withdrawn: UILabel!
    var responseObj: UserResponse?
    private let refreshControl = UIRefreshControl()

    var hasNurseAccepted = [Int]()
    var hasNurseAcceptedNotAccept = [Int]()
    var hasNurseconfirmed = [Int]()
    var hasNurseNotAccepted = [Int]()
    var has_declinedConfirmed = [Int]()
    var has_expiredConfirmed = [Int]()
    var has_ShiftStarted = [Int]()
    var isNurseShifttStarted = [Int]()

    
//    var hasNurseAccepted = [Int]()
//    var hasNurseconfirmed = [Int]()
//    var has_declinedConfirmed = [Int]()
//    var has_expiredConfirmed = [Int]()
    var index: Int?
    
    var json: JSON!
    var row = 0
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        if #available(iOS 10.0, *) {
            tableView.refreshControl = refreshControl
        } else {
            tableView.addSubview(refreshControl)
        }
        refreshControl.addTarget(self, action: #selector(refreshWeatherData(_:)), for: .valueChanged)
        getAllHistoryList()
        
        
        // Do any additional setup after loading the view.
        //        tableView.delegate = self
        //        tableView.dataSource = self
        
        //        loadBalance()
    }
    
    @objc private func refreshWeatherData(_ sender: Any) {
        // Fetch Weather Data
        getAllHistoryList()
    }

    
    func getAllHistoryList() {
        let serviceURL = "http://13.76.213.183/calllight/public/api/v1/hospital/request?api_token=" + localUserData.apiToken!
        
        //        let serviceURL = "\(HospitalPROFILE)/\(hospitalId)?api_token=\(localUserData.apiToken!)"
        WebServiceManager.get(params:nil , serviceName: serviceURL, serviceType: "Hospital History", modelType: UserResponse.self, success: { (responseData) in
            
            self.responseObj = responseData as? UserResponse
            self.refreshControl.endRefreshing()

            if self.responseObj?.success == true {
                for (_ , historyInfo) in (self.responseObj?.historyObject?.enumerated())! {
                    if historyInfo.has_accepted == false {
                        self.hasNurseNotAccepted.append(historyInfo.id!) // Requested
                    }
                    
                    if historyInfo.has_accepted == true {
                        
                        if historyInfo.shift_started == nil &&  historyInfo.shift_ended == nil {
                            self.hasNurseAccepted.append(historyInfo.id!) // Pending
                        } else  if historyInfo.shift_started != nil &&  historyInfo.shift_ended == nil {
                            self.has_ShiftStarted.append(historyInfo.id!) // On Going
                        }
                        else  if historyInfo.shift_started != nil &&  historyInfo.shift_ended != nil {
                            self.isNurseShifttStarted.append(historyInfo.id!) // Completed
                        }
                        //                        self.hasNurseAccepted.append(historyInfo.id!)
                    }
                    if historyInfo.has_confirmed == true {
                        self.hasNurseconfirmed.append(historyInfo.id!)
                    } else
                        if historyInfo.has_declined == true {
                            self.has_declinedConfirmed.append(historyInfo.id!)
                    }
                    if historyInfo.has_expired == true  {
                        self.has_expiredConfirmed.append(historyInfo.id!)
                    }

                    
                    
                }
                
                self.tableView.delegate = self
                self.tableView.dataSource = self
                self.tableView.reloadData()
            }
            
            
            
        }) { (error)  in
            self.refreshControl.endRefreshing()

            self.showAlert(title: KMessageTitle, message: error.description, controller: self)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //        loadRequest()
        //        SVProgressHUD.show()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
//    func numberOfSections(in tableView: UITableView) -> Int {
//        return 1
//    }
//
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        if self.row == 0{
//            var emptyLabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.view.bounds.size.width, height: self.view.bounds.size.height))
//            emptyLabel.text = "No History"
//            emptyLabel.textAlignment = NSTextAlignment.center
//            self.tableView.backgroundView = emptyLabel
//            self.tableView.separatorStyle = UITableViewCellSeparatorStyle.none
//            return 0
//        } else {
//            return self.row
//        }
//    }
//
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return 139
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        var cell = self.tableView.dequeueReusableCell(withIdentifier: "cell") as! CustomCell
//        print (indexPath.row)
//        if self.json["data"][indexPath.row]["has_accepted"].bool == true {
//            cell.balance.isHidden = false
//            cell.confirmed.isHidden = true
//            cell.declined.isHidden = true
//            cell.expired.isHidden = true
//        }
//        if self.json["data"][indexPath.row]["has_confirmed"].bool == true {
//            cell.confirmed.isHidden = false
//            cell.balance.isHidden = true
//            cell.declined.isHidden = true
//            cell.expired.isHidden = true
//        }
//        if self.json["data"][indexPath.row]["has_declined"].bool == true && self.json["data"][indexPath.row]["has_expired"].bool == false {
//            cell.declined.isHidden = false
//            cell.balance.isHidden = true
//            cell.confirmed.isHidden = true
//            cell.expired.isHidden = true
//        }
//        if self.json["data"][indexPath.row]["has_declined"].bool == false && self.json["data"][indexPath.row]["has_expired"].bool == true {
//            cell.expired.isHidden = false
//            cell.balance.isHidden = true
//            cell.confirmed.isHidden = true
//            cell.declined.isHidden = true
//        }
//
//        let startShiftTime = String(describing:self.json["data"][indexPath.row]["shift_start_time"])
//        let endShiftTime = String(describing:self.json["data"][indexPath.row]["shift_end_time"])
//
//        let outFormatter = DateFormatter()
//        outFormatter.timeZone = TimeZone(abbreviation: "UTC")
//        outFormatter.dateFormat = "hh:mm:ss"
//
//        let date = outFormatter.date(from: startShiftTime)!
////        let outStr = outFormatter.string(from: date)
//        print(date) // -> outputs 04:50
//
//
////        let dateFormatter = DateFormatter()
////        dateFormatter.dateFormat = "HH:mm:ss"
////        let date = dateFormatter.date(from: startShiftTime)
//
////        let a:Int = Int(startShiftTime)!
////        let b:Int = Int(endShiftTime)!
////
////        var subTot = b - a
////
////        var total = "\(subTot)"
//        //        let c = b - a
////        if localUserData.type == "Hospital" {
////
////
////            if self.json["data"][indexPath.row]["shift_date"] != nil && self.json["data"][indexPath.row]["shift_started"] != nil {
////                cell.date.text = ""
////                cell.date.text = String(describing: self.json["data"][indexPath.row]["shift_date"])+String(describing: self.json["data"][indexPath.row]["shift_started"])
////            }
////            if self.json["data"][indexPath.row]["hospital"]["user"]["name"] != nil {
////                cell.hospitalName.text = ""
////                cell.hospitalName.text = String(describing: self.json["data"][indexPath.row]["hospital"]["user"]["name"])
////            }
////            if self.json["data"][indexPath.row]["hospital"]["address"] != nil {
////                cell.hospitalLocation.text = ""
////                cell.hospitalLocation.text = String(describing: self.json["data"][indexPath.row]["hospital"]["address"])
////
////            }
////            if self.json["data"][indexPath.row]["nurse"]["user"]["name"] != nil
////            {
////                cell.nurseName.text = ""
////                cell.nurseName.text = String(describing: self.json["data"][indexPath.row]["nurse"]["user"]["name"])
////
////            }
////            if self.json["data"][indexPath.row]["nurse"]["speciality"] != nil && self.json["data"][indexPath.row]["nurse"]["type"] != nil {
////                cell.nurseSpecialityAndType.text = ""
////                cell.nurseSpecialityAndType.text = String(describing: self.json["data"][indexPath.row]["nurse"]["speciality"]) + " - " + String(describing: self.json["data"][indexPath.row]["nurse"]["type"])
////            }
////            //            cell.balance.text = "$\(indexPath.row)"
////
////        } else {
//
//            //            cell.imageView?.image = UIImage(named: "hospitalImage")
//            //            cell.imageView?.layer.cornerRadius = (cell.imageView?.frame.size.width)!/2
//            //            cell.imageView?.clipsToBounds = true
//            //
//            //            cell.textLabel?.text = String(describing: self.json["data"][indexPath.row]["hospital"]["user"]["name"])
//            //            cell.detailTextLabel?.text = String(describing: self.json["data"][indexPath.row]["shift_date"])
//            if self.json["data"][indexPath.row]["shift_date"] != nil {
//                cell.date.text = ""
//                cell.date.text = String(describing: self.json["data"][indexPath.row]["shift_date"])
//            }
//            if self.json["data"][indexPath.row]["hospital"]["user"]["name"] != nil {
//                cell.hospitalName.text = ""
//                cell.hospitalName.text = String(describing: self.json["data"][indexPath.row]["hospital"]["user"]["name"])
//            }
//            if self.json["data"][indexPath.row]["hospital"]["address"] != nil {
//                cell.hospitalLocation.text = ""
//                cell.hospitalLocation.text = String(describing: self.json["data"][indexPath.row]["hospital"]["address"])
//
//            }
//            if self.json["data"][indexPath.row]["nurse"]["user"]["name"] != nil {
//                cell.nurseName.text = ""
//                cell.nurseName.text = String(describing: self.json["data"][indexPath.row]["nurse"]["user"]["name"])
//            }
//            if self.json["data"][indexPath.row]["nurse"]["speciality"] != nil && self.json["data"][indexPath.row]["nurse"]["type"] != nil {
//                cell.nurseSpecialityAndType.text = ""
//                cell.nurseSpecialityAndType.text = String(describing: self.json["data"][indexPath.row]["nurse"]["speciality"]) + " - " + String(describing: self.json["data"][indexPath.row]["nurse"]["type"])
//            }
////        }
//        return cell
//    }
//
//    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//        return "History"
//    }
    
    func loadBalance() {
        
        
        let url = "http://13.76.213.183/calllight/public/api/v1/profile/payments?api_token=" + UserDefaults.standard.string(forKey: "apiToken")! + "&nurse_id=" + UserDefaults.standard.string(forKey: "userID")!
        let completeUrl = URL(string:url)!
        
        
        let headers: HTTPHeaders = [
            "api_token": UserDefaults.standard.string(forKey: "apiToken")!
        ]
        
        Alamofire.request(completeUrl, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: headers ).responseJSON{ response in
            print(response.request as Any)  // original URL request
            print(response.response as Any) // URL response
            print(response.result.value as Any)   // result of response serialization
            switch response.result {
            case .success:
                if let value = response.result.value {
                    self.json = JSON(value)
                    print(self.json)
                    
                    //                    print(self.row)
                    //                    KVLoading.hide()
                    self.availableBalance.text = "$350"
                    self.totalBalance.text = "$400"
                    self.withdrawn.text = "$150"
                }
                break
            case .failure(let error):
                SVProgressHUD.dismiss()
                print(error)
            }
        }
    }
    
    func loadRequest() {
        let url = "http://13.76.213.183/calllight/public/api/v1/hospital/request?api_token=" + localUserData.apiToken!
        let completeUrl = URL(string:url)!
        
        
        
        
        Alamofire.request(completeUrl, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil ).responseJSON{ response in
            //            print(response.request as Any)  // original URL request
            //            print(response.response as Any) // URL response
            //            print(response.result.value as Any)   // result of response serialization
            switch response.result {
            case .success:
                if let value = response.result.value {
                    self.json = JSON(value)
                    print(self.json)
                    self.row = self.json["data"].count
                    //                    print(self.row)
                    SVProgressHUD.dismiss()
                    self.tableView.reloadData()
                }
                break
            case .failure(let error):
                SVProgressHUD.dismiss()
                print(error)
            }
        }
    }

  
}



extension NurseHistoryVC : UITableViewDelegate , UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        var numOfSections: Int = 0
        if    self.responseObj?.historyObject?.isEmpty == false {
            numOfSections = 1
            self.tableView.backgroundView = nil
        }
        else {
            let noDataLabel = UILabel(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: tableView.bounds.size.height))
            noDataLabel.numberOfLines = 10
            if let aSize = UIFont(name: "Axiforma-Book", size: 14) {
                noDataLabel.font = aSize
            }
            noDataLabel.text = "There are currently no data."
            noDataLabel.textColor = UIColor(red: 119.0 / 255.0, green: 119.0 / 255.0, blue: 119.0 / 255.0, alpha: 1.0)
            noDataLabel.textAlignment = .center
            tableView.backgroundView = noDataLabel
            tableView.separatorStyle = .none
        }
        return numOfSections
        
        
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return (self.responseObj?.historyObject?.count)!
    }
    
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//
//        let cell = self.tableView.dequeueReusableCell(withIdentifier: "HistoryCell") as! HistoryCell
//
////        if self.responseObj?.historyObject![indexPath.row].has_accepted == true {
////            cell.balance.isHidden = false
////            cell.confirmed.isHidden = true
////            cell.declined.isHidden = true
////            cell.expired.isHidden = true
////        }
////
////        if self.responseObj?.historyObject![indexPath.row].has_confirmed == true {
////            cell.confirmed.isHidden = false
////            cell.balance.isHidden = true
////            cell.declined.isHidden = true
////            cell.expired.isHidden = true
////
////        }
////        if self.responseObj?.historyObject![indexPath.row].has_declined == true &&  self.responseObj?.historyObject![indexPath.row].has_expired == false {
////            cell.declined.isHidden = false
////            cell.balance.isHidden = true
////            cell.confirmed.isHidden = true
////            cell.expired.isHidden = true
////
////        }
//        if self.responseObj?.historyObject![indexPath.row].has_declined == false &&  self.responseObj?.historyObject![indexPath.row].has_expired == true {
////            cell.expired.isHidden = false
////            cell.balance.isHidden = true
////            cell.confirmed.isHidden = true
////            cell.declined.isHidden = true
////
////        }
//
//
//        if  ((self.responseObj?.historyObject![indexPath.row].shift_date) != nil) {
//            cell.date.text = self.responseObj?.historyObject![indexPath.row].shift_date
//        } else {
//            cell.date.text = " "
//        }
//        if  ((self.responseObj?.historyObject![indexPath.row].hospitalObject?.hospitalProfile?.name) != nil) {
//            cell.hospitalName.text = self.responseObj?.historyObject![indexPath.row].hospitalObject?.hospitalProfile?.name
//        } else {
//            cell.hospitalName.text = " "
//        }
//
//        if  ((self.responseObj?.historyObject![indexPath.row].hospitalObject?.address) != nil) {
//            cell.hospitalLocation.text = self.responseObj?.historyObject![indexPath.row].hospitalObject?.address
//        } else {
//            cell.hospitalLocation.text = " "
//        }
//
//        if  ((self.responseObj?.historyObject![indexPath.row].nurseObject?.nurseProfile?.name) != nil) {
//            cell.hospitalLocation.text = self.responseObj?.historyObject![indexPath.row].hospitalObject?.address
//        } else {
//            cell.hospitalLocation.text = " "
//        }
//        if  ((self.responseObj?.historyObject![indexPath.row].nurseObject?.nurseProfile?.name) != nil) {
//            cell.nurseName.text = self.responseObj?.historyObject![indexPath.row].nurseObject?.nurseProfile?.name
//        } else {
//            cell.nurseName.text = " "
//        }
//        if  ((self.responseObj?.historyObject![indexPath.row].nurseObject?.speciality) != nil) && ((self.responseObj?.historyObject![indexPath.row].nurseObject?.type) != nil)  {
//            let specialityOfNurse = self.responseObj?.historyObject![indexPath.row].nurseObject?.speciality
//            let typeOfNurse = self.responseObj?.historyObject![indexPath.row].nurseObject?.type
//
//            cell.nurseSpecialityAndType.text = "\(specialityOfNurse!) - \(typeOfNurse!) "
//
//        } else {
//            cell.nurseName.text = " "
//        }
//
//        if  ((self.responseObj?.historyObject![indexPath.row].total_job_time) != nil) {
//            let totalJobTime = self.responseObj?.historyObject![indexPath.row].total_job_time
//            cell.totalWorkHour.text = " Total Working Hour : \(totalJobTime!)"
//        } else {
//            cell.nurseName.text = " "
//        }
//
//
//
//
//        return cell
//    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "HistoryCell") as! HistoryCell
        
        cell.balance.isHidden   = true
        cell.confirmed.isHidden = true
        cell.declined.isHidden  = true
        cell.expired.isHidden   = true
        
        
        //        if historyInfo.has_accepted == false {
        //            self.hasNurseNotAccepted.append(historyInfo.id!) // Requested
        //        }
        //        if historyInfo.has_accepted == true {
        //
        //            if historyInfo.shift_started == nil &&  historyInfo.shift_ended == nil {
        //                self.has_ShiftStarted.append(historyInfo.id!) // Pending
        //            } else  if historyInfo.shift_started != nil &&  historyInfo.shift_ended == nil {
        //                self.isNurseShifttStarted.append(historyInfo.id!) // On Going
        //            }
        //            else  if historyInfo.shift_started != nil &&  historyInfo.shift_ended != nil {
        //                self.isNurseShifttStarted.append(historyInfo.id!) // Completed
        //            }
        //            self.hasNurseAccepted.append(historyInfo.id!)
        //        }
        //        if historyInfo.has_confirmed == true {
        //            self.hasNurseconfirmed.append(historyInfo.id!)
        //        } else
        //            if historyInfo.has_declined == true {
        //                self.has_declinedConfirmed.append(historyInfo.id!)
        //        }
        //        if historyInfo.has_expired == true  {
        //            self.has_expiredConfirmed.append(historyInfo.id!)
        //        }
        
        
        if hasNurseNotAccepted.contains((self.responseObj?.historyObject![indexPath.row].id)!) {
            cell.balance.isHidden       = true
            cell.confirmed.isHidden = false
            cell.confirmed.text     = "Requested"
            cell.declined.isHidden  = true
            cell.expired.isHidden   = true
        }
        if hasNurseAccepted.contains((self.responseObj?.historyObject![indexPath.row].id)!) {
            cell.balance.isHidden       = true
            cell.confirmed.isHidden = false
            cell.confirmed.text     = "Pending"
            cell.declined.isHidden  = true
            cell.expired.isHidden   = true
        }
        
        if hasNurseconfirmed.contains((self.responseObj?.historyObject![indexPath.row].id)!) {
            
            cell.confirmed.isHidden = false
            cell.confirmed.text = "job Confirmed"
            //            cell.balance.isHidden = true
            cell.balance.isHidden = true
            cell.declined.isHidden = true
            cell.expired.isHidden = true
        }
        
        if has_declinedConfirmed.contains((self.responseObj?.historyObject![indexPath.row].id)!) {
            cell.declined.isHidden = false
            cell.declined.text = "job declined"
            cell.balance.isHidden = true
            cell.confirmed.isHidden = true
            cell.expired.isHidden = true
        }
        
        if has_expiredConfirmed.contains((self.responseObj?.historyObject![indexPath.row].id)!) {
            
            cell.balance.isHidden = true
            cell.expired.isHidden = false
            cell.expired.text = "job request expired"
            cell.confirmed.isHidden = true
            cell.declined.isHidden = true
        }
        
        if has_ShiftStarted.contains((self.responseObj?.historyObject![indexPath.row].id)!) {
            cell.confirmed.isHidden = false
            cell.confirmed.text = "On going"
            cell.balance.isHidden = true
            cell.expired.isHidden = true
            cell.declined.isHidden = true
        }
        if isNurseShifttStarted.contains((self.responseObj?.historyObject![indexPath.row].id)!) {
            cell.expired.isHidden = true
            cell.confirmed.isHidden = false
            cell.confirmed.text = "Completed"
            cell.balance.isHidden = true
            cell.declined.isHidden = true
        }
        
        
        if  ((self.responseObj?.historyObject![indexPath.row].shift_date) != nil) {
            
            let dateComplete = self.responseObj?.historyObject![indexPath.row].shift_date
            let substring = dateComplete?.dropLast(9)
            let realString = String(substring!)
            
            cell.date.text = realString
        } else {
            cell.date.text = " "
        }
        if  ((self.responseObj?.historyObject![indexPath.row].hospitalObject?.hospitalProfile?.name) != nil) {
            cell.hospitalName.text = self.responseObj?.historyObject![indexPath.row].hospitalObject?.hospitalProfile?.name
        } else {
            cell.hospitalName.text = " "
        }
        
        if  ((self.responseObj?.historyObject![indexPath.row].hospitalObject?.address) != nil) {
            cell.hospitalLocation.text = self.responseObj?.historyObject![indexPath.row].hospitalObject?.address
        } else {
            cell.hospitalLocation.text = " "
        }
        
        if  ((self.responseObj?.historyObject![indexPath.row].nurseObject?.nurseProfile?.name) != nil) {
            cell.hospitalLocation.text = self.responseObj?.historyObject![indexPath.row].hospitalObject?.address
        } else {
            cell.hospitalLocation.text = " "
        }
        if  ((self.responseObj?.historyObject![indexPath.row].nurseObject?.nurseProfile?.name) != nil) {
            cell.nurseName.text = self.responseObj?.historyObject![indexPath.row].nurseObject?.nurseProfile?.name
        } else {
            cell.nurseName.text = " "
        }
        if  ((self.responseObj?.historyObject![indexPath.row].nurseObject?.speciality) != nil) && ((self.responseObj?.historyObject![indexPath.row].nurseObject?.type) != nil)  {
            let specialityOfNurse = self.responseObj?.historyObject![indexPath.row].nurseObject?.speciality
            let typeOfNurse = self.responseObj?.historyObject![indexPath.row].nurseObject?.type
            
            cell.nurseSpecialityAndType.text = "\(specialityOfNurse!) - \(typeOfNurse!) "
            
        } else {
            cell.nurseName.text = " "
        }
        
        if  ((self.responseObj?.historyObject![indexPath.row].total_job_time) != nil) {
            let totalJobTime = self.responseObj?.historyObject![indexPath.row].total_job_time
            cell.totalWorkHour.text = " Total Working Hour : \(totalJobTime!)"
        } else {
            cell.nurseName.text = " "
        }
        
        
        //            if self.json["data"][indexPath.row]["nurse"]["speciality"] != nil && self.json["data"][indexPath.row]["nurse"]["type"] != nil {
        //                cell.nurseSpecialityAndType.text = ""
        //                cell.nurseSpecialityAndType.text = String(describing: self.json["data"][indexPath.row]["nurse"]["speciality"]) + " - " + String(describing: self.json["data"][indexPath.row]["nurse"]["type"])
        //            }
        //            //            cell.balance.text = "$\(indexPath.row)"
        //
        //        } else {
        //
        //            //            cell.imageView?.image = UIImage(named: "hospitalImage")
        //            //            cell.imageView?.layer.cornerRadius = (cell.imageView?.frame.size.width)!/2
        //            //            cell.imageView?.clipsToBounds = true
        //            //
        //            //            cell.textLabel?.text = String(describing: self.json["data"][indexPath.row]["hospital"]["user"]["name"])
        //            //            cell.detailTextLabel?.text = String(describing: self.json["data"][indexPath.row]["shift_date"])
        //            if self.json["data"][indexPath.row]["shift_date"] != nil {
        //                cell.date.text = ""
        //                cell.date.text = String(describing: self.json["data"][indexPath.row]["shift_date"])
        //            }
        //            if self.json["data"][indexPath.row]["hospital"]["user"]["name"] != nil {
        //                cell.hospitalName.text = ""
        //                cell.hospitalName.text = String(describing: self.json["data"][indexPath.row]["hospital"]["user"]["name"])
        //            }
        //            if self.json["data"][indexPath.row]["hospital"]["address"] != nil {
        //                cell.hospitalLocation.text = ""
        //                cell.hospitalLocation.text = String(describing: self.json["data"][indexPath.row]["hospital"]["address"])
        //
        //            }
        //            if self.json["data"][indexPath.row]["nurse"]["user"]["name"] != nil {
        //                cell.nurseName.text = ""
        //                cell.nurseName.text = String(describing: self.json["data"][indexPath.row]["nurse"]["user"]["name"])
        //            }
        //            if self.json["data"][indexPath.row]["nurse"]["speciality"] != nil && self.json["data"][indexPath.row]["nurse"]["type"] != nil {
        //                cell.nurseSpecialityAndType.text = ""
        //                cell.nurseSpecialityAndType.text = String(describing: self.json["data"][indexPath.row]["nurse"]["speciality"]) + " - " + String(describing: self.json["data"][indexPath.row]["nurse"]["type"])
        //            }
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 164.0
    }
    
    
}

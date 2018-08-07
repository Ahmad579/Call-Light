//
//  NurseDocumentVC.swift
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

class NurseDocumentVC: UIViewController , UITableViewDelegate , UITableViewDataSource {
    
    var row = 0
    var json: JSON = []
    let picker = UIImagePickerController()
    var docName: String = ""
    var chosenImage = UIImage()
//    let picker = UIImagePickerController()
//    var docName: String = ""
//    var chosenImage = UIImage()
    
    let photoPicker = PhotoPicker()


    
    @IBOutlet var documentsTableView: UITableView!
    @IBOutlet weak var done: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        //        KVLoading.show()
        self.getAllDocs()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
//        picker.delegate = self
    }
    
    
    func showTheImage(){
        photoPicker.pick(allowsEditing: false, pickerSourceType: .CameraAndPhotoLibrary, controller: self) { (orignal, edited) in
            
            self.chosenImage = orignal!
            
            SVProgressHUD.show()
            self.uploadDocs()

//            self.profilePic.image = orignal
//
//            self.cover_image = orignal
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        if localUserData.isVerified == true {
           
            self.done.setBackgroundImage( UIImage(named: "doneSelect") , for: .normal)
            self.done.isEnabled = false
        } else {
            
            self.done.setBackgroundImage(UIImage(named: "doneUnSelect") , for: .normal)

            self.done.isEnabled = true
        }
        //        self.getAllDocs()
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.row
    }
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func getAllDocs() {
        
        SVProgressHUD.show()
        
        let url = "http://13.76.213.183/calllight/public/api/v1/nurse/documents?api_token=" + localUserData.apiToken!
        let completeUrl = URL(string:url)!
        
     
        if json != nil {
            Alamofire.request(completeUrl, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil ).responseJSON{ response in
                //                print(response.request as Any)  // original URL request
                //                print(response.response as Any) // URL response
                //                print(response.result.value as Any)   // result of response serialization
                switch response.result {
                case .success:
                    if let value = response.result.value {
                        self.json = JSON(value)
                        //                        print(self.json)
                        self.row = self.json["data"].count
                        //                        print(self.row)
                        //print(self.json[0]["facilityPictures"])
                        
                        self.documentsTableView.delegate = self
                        self.documentsTableView.dataSource = self

                        self.documentsTableView.reloadData()
                        SVProgressHUD.dismiss()
                    }
                    break
                case .failure(let error):
                    print(error)
                }
                
            }
        } else {
            self.row = self.json["data"].count
        }
    }
    
    @IBAction func addDocument(_ sender: Any) {
        self.DocName()

    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DocumentsCell", for: indexPath)
        
        // Configure the cell...
        //        print(self.json["data"][indexPath.row]["id"])
        cell.textLabel?.text = String(describing: self.json["data"][indexPath.row]["name"])
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "NurseDocumentDetail") as? NurseDocumentDetail
        vc?.titleOfDocumentName = String(describing: self.json["data"][indexPath.row]["name"])
        vc?.urlOfImage = String(describing: self.json["data"][indexPath.row]["url"])
        self.navigationController?.pushViewController(vc!, animated: true)
    }
    
    // Edit mode
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        documentsTableView.setEditing(editing, animated: true)
    }
    
    // Delete the cell
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCellEditingStyle.delete {
            //            todos.remove(at: indexPath.row)
            //            self.json.dictionaryObject?.removeValue(forKey: indexPath.row)
            self.json["data"].arrayObject?.remove(at: indexPath.row)
            //            print(self.json)
            self.documentsTableView.reloadData()
            //            documentsTableView.deleteRows(at: [indexPath], with: UITableViewRowAnimation.automatic)
        }
    }

    
    func pickImageOptions() {
        // create the alert
        let alert = UIAlertController(title: "Profile Image", message: "Set your profile Image", preferredStyle: UIAlertControllerStyle.alert)
        
        // add the actions (buttons)
        alert.addAction(UIAlertAction(title: "Select from Gallery", style: UIAlertActionStyle.default, handler: {action in
            self.pickImage()
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Take Photo", style: UIAlertActionStyle.default, handler: { action in
           self.showTheImage()
//            self.takeImage()
        }))
        
        // show the alert
        self.present(alert, animated: true, completion: nil)
    }
    
    func pickImage() {
        //        print("hello pick Image")
        picker.allowsEditing = true
        picker.sourceType = .photoLibrary
        picker.mediaTypes = UIImagePickerController.availableMediaTypes(for: .photoLibrary)!
        present(picker, animated: true, completion: nil)
    }
    
    func takeImage() {
        //        print("hello take Image")
        picker.allowsEditing = true
        picker.sourceType = .camera
        picker.mediaTypes = UIImagePickerController.availableMediaTypes(for: .photoLibrary)!
        present(picker, animated: true, completion: nil)
    }
    
    override func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        self.chosenImage = (info[UIImagePickerControllerEditedImage] as! UIImage?)!
        //        profileImage.image = chosenImage
        picker.dismiss(animated: true) {
            SVProgressHUD.show()
            self.uploadDocs()
        }
    }
    
//    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [AnyHashable: Any]) {
//        
//
//
//
//    }
    
    func uploadDocs() {
        SVProgressHUD.show()
        if self.docName != "" {
            
            var parameters = [String: String]()
            
            parameters = [
                "name": self.docName
            ]
            
            
            
            let url = "http://13.76.213.183/calllight/public/api/v1/nurse/documents?api_token=" + localUserData.apiToken!
            let completeUrl = URL(string:url)!
            
            let imageData = UIImageJPEGRepresentation(self.chosenImage, 1)
            //            print ("image data:: \(imageData)")
            //            print ("chosenImage:: \(self.chosenImage)")
            
            
            Alamofire.upload(
                multipartFormData: {
                    multipartFormData in
                    multipartFormData.append(imageData!,
                                             withName: "document",
                                             fileName: "image.jpg",
                                             mimeType: "image/jpeg")
                    for (key, value) in parameters {
                        multipartFormData.append(value.data(using: String.Encoding(rawValue: String.Encoding.utf8.rawValue))!, withName: key)
                    }
            },
                to: completeUrl,
                headers: nil,
                encodingCompletion: { encodingResult in
                    switch encodingResult {
                    case .success(let upload, _, _):
                        upload.responseJSON{ response in
                            //                            print(response)
                            self.getAllDocs()
                        }
                    case .failure(let encodingError):
                        print(encodingError)
                    }
            }
            )
        }
    }
    
    override func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
                picker.dismiss(animated: true) {

    }
    
//    override func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
////        picker.dismiss(animated: true, completion: { _ in })
//        picker.dismiss(animated: true) {
//
//        }
        
    }
    
    func DocName() {
        //        print("DOC NAME")
        //1. Create the alert controller.
        let alert = UIAlertController(title: "Selected Doc", message: "Enter Name of the document", preferredStyle: .alert)
        
        //2. Add the text field. You can configure it however you need.
        alert.addTextField { (textField) in
            textField.placeholder = "Name of the Doc"
        }
        
        // 3. Grab the value from the text field, and print it when the user clicks OK.
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak alert] (_) in
            let textField = alert?.textFields![0] // Force unwrapping because we know it exists.
            //            print("Text field: \(textField?.text)")
            self.docName = textField?.text! as! String
            self.pickImageOptions()
        }))
        
        // 4. Present the alert.
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

//
//  NurseDocumentDetail.swift
//  Call Light
//
//  Created by Ahmed Durrani on 14/05/2018.
//  Copyright © 2018 Tech Ease Solution. All rights reserved.
//

import UIKit

class NurseDocumentDetail: UIViewController {

    var titleOfDocumentName : String?
    var urlOfImage : String?

    @IBOutlet weak var imgOfDocument: UIImageView!
    @IBOutlet weak var documentTitle: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        documentTitle.text = titleOfDocumentName
        WAShareHelper.loadImage(urlstring: urlOfImage!, imageView: imgOfDocument, placeHolder: "")

        // Do any additional setup after loading the view.
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

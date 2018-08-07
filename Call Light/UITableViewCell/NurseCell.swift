//
//  NurseCell.swift
//  Call Light
//
//  Created by Ahmed Durrani on 14/04/2018.
//  Copyright © 2018 Tech Ease Solution. All rights reserved.
//

import UIKit

protocol isRequestSend {
   
    func isDoctorSendRequest(checkCell : NurseCell , indexPath : IndexPath)
    func isDoctorViewNurseProfile(checkCell : NurseCell , indexPath : IndexPath)
    
}


class NurseCell: UITableViewCell {
    
    var delegate: isRequestSend?
    var index: IndexPath?
    @IBOutlet weak var btnSendRequestOrNot: UIButton!


    @IBOutlet weak var lblNurseName: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func btnRequestSend_Pressed(_ sender: UIButton) {
            sender.isSelected = !sender.isSelected
            self.delegate?.isDoctorSendRequest(checkCell : self  , indexPath : index!)
        
        
    }
    
    @IBAction func btnViewDetail_Pressed(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        self.delegate?.isDoctorViewNurseProfile(checkCell : self  , indexPath : index!)
    }
    
   
    
}

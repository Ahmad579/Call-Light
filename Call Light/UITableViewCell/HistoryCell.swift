//
//  HistoryCell.swift
//  Call Light
//
//  Created by Ahmed Durrani on 21/05/2018.
//  Copyright © 2018 Tech Ease Solution. All rights reserved.
//

import UIKit

protocol isRequestCancel {
    func isCancelRequest(checkCell : HistoryCell , indexPath : IndexPath)
}

class HistoryCell: UITableViewCell {
    
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var hospitalName: UILabel!
    @IBOutlet weak var hospitalLocation: UILabel!
    @IBOutlet weak var nurseName: UILabel!
    @IBOutlet weak var nurseSpecialityAndType: UILabel!
    @IBOutlet weak var balance: UILabel!
    @IBOutlet weak var confirmed: UILabel!
    @IBOutlet weak var declined: UILabel!
    @IBOutlet weak var expired: UILabel!
    @IBOutlet weak var totalWorkHour: UILabel!
    @IBOutlet weak var btnCancel: UIButton!
    var delegate: isRequestCancel?
    var index: IndexPath?

  
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
//    override func prepareForReuse() {
//        super.prepareForReuse()
////        confirmed.text = nil
////        declined.text = nil
////        expired.text = nil
////        balance.text = nil
//
//    }
    
//    -(void)prepareForReuse
//    {
//    [super prepareForReuse];
//    lblInviteContactNumber.text =   @"";
//    lblInviteContactName.text =  @"";
//    imgInviteProfile.image =  nil;
//    //     self.sendInvitation.selected = false ;
//
//
//    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @IBAction func btnBtnCancel_Pressed(_ sender: UIButton) {
        self.delegate?.isCancelRequest(checkCell : self  , indexPath : index!)

    }
    
}

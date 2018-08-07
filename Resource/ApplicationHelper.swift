//
//  ApplicationHelper.swift
//  Fevir
//
//  Created by Muhammad Jamshaid on 8/11/16.
//  Copyright © 2016 Muhammad Jamshaid. All rights reserved.
//

import UIKit

class ApplicationHelper: NSObject {

	class func showAlertView(title: String, message: String, onViewController: UIViewController) {
		let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
		let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (action) in

		}
		alertController.addAction(cancelAction)
		let OKAction = UIAlertAction(title: "OK", style: .default) { (action) in

		}
		alertController.addAction(OKAction)
		onViewController.present(alertController, animated: true) {
		}
	}

	class func addRightView(_ uiTextField: UITextField) {

		let paddleView: UIView = UIView(frame: CGRect(x: (uiTextField.frame.size.width - 14), y: 0, width: 14, height: uiTextField.frame.size.height));
		paddleView.backgroundColor = UIColor.yellow
		uiTextField.rightView = paddleView;
		uiTextField.rightViewMode = UITextFieldViewMode.always;
	}
    
    class func addLeftView(_ uiTextField: UITextField) {
       
        uiTextField.leftViewMode = UITextFieldViewMode.always
        let leftImageView = UIImageView()
        leftImageView.image = UIImage(named: "key");
        
        let leftView = UIView()
        leftView.addSubview(leftImageView)
        
        leftView.frame = CGRect(x: 0, y: 0, width: 54, height: 54)
        leftImageView.frame = CGRect(x: 27, y: 20, width: 13, height: 13)
        
        uiTextField.leftView = leftView
    }
    
    class func addOnlyLeftView (_ uiTextField: UITextField){
          uiTextField.leftViewMode = UITextFieldViewMode.always
        let leftView = UIView()
        leftView.frame = CGRect(x: 0, y: 0, width: 54, height: 54)
        uiTextField.leftView = leftView
    }
    
    class func addTextFieldLeftView(_ tetField: UITextField, width: CGFloat) {
        let leftView = UIView()
        leftView.frame = CGRect(x: 0, y: 0, width: width, height: 25)
        tetField.leftViewMode = .always
        tetField.leftView = leftView
    }
    
    
    class func changePlaceHolderColor(_ uiTextField: UITextField,placeholder:String){
        
        
        uiTextField.attributedPlaceholder = NSAttributedString(string:placeholder,
                                                               attributes:[NSAttributedStringKey.foregroundColor: UIColor.white])
    }
    class func checkNull(_ str: String) -> String {
        var str = str
        if ( str == "<null>" || str == "(null)" || str == "0000-00-00" || str == "" || str.characters.count == 0 ||
            str.isEmpty )  {
            str = ""
        }
        return str
        
    }

}

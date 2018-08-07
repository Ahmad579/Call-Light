//
//  UIViewcontrollerExtension.swift
//  WhereApp
//
//  Created by Salman Nasir on 10/03/2017.
//  Copyright © 2017 Ilsainteractive. All rights reserved.
//

import UIKit
import CoreLocation


extension UIViewController {
    
//    func hideTabBottomBar(viewController: UIViewController) {
//        let vc = UIApplication.shared.keyWindow?.rootViewController as! TQHomeRootVC
//        if vc.bottomTabbar != nil {
//            vc.bottomTabbar?.isHidden = !(viewController is HomeVC || viewController is TQCameraVC || viewController is TQPostResponseContainerVC || viewController is TQPostVC || viewController is TQPostContainerPageVC)
//        }
//        
//    }
    
    func showAlert(title: String, message: String, controller: UIViewController?) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alert.addAction(action)
        if controller != nil {
            controller?.present(alert, animated: true, completion: nil)
        }else {
            present(alert, animated: true, completion: nil)
        }
        

    }
    
    func showConfirmationAlertViewWithTitle(title:String,message : String, dismissCompletion:@escaping (AlertViewDismissHandler))
    {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        
        alertController.addAction(UIAlertAction(title: "NO", style: .cancel, handler: { action -> Void in
            //Do some other stuff
            
        }))
        alertController.addAction(UIAlertAction(title: "YES", style: .default, handler: { action -> Void in
            //Do some other stuff
            dismissCompletion()
        }))

        
        present(alertController, animated: true, completion:nil)
    }

    
    func showAlertViewWithTitle(title:String,message : String, dismissCompletion:@escaping (AlertViewDismissHandler))
    {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: { action -> Void in
            //Do some other stuff
            dismissCompletion()
        }))
        
        alertController.addAction(UIAlertAction(title: "Cancel", style: .default, handler: { action -> Void in
            //Do some other stuff
            dismissCompletion()
        }))
        
        present(alertController, animated: true, completion:nil)
    }

    
    @IBAction func popController(_ sender: UIButton) {
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    
//    func updatelocation(){
//      _ =  Location.getLocation(withAccuracy:.block, frequency: .oneShot, onSuccess: { location in
//            print("loc \(location.coordinate.longitude)\(location.coordinate.latitude)")
//            DEVICE_LAT = location.coordinate.latitude
//            DEVICE_LONG = location.coordinate.longitude
//            print(DEVICE_LAT)
//            print(DEVICE_LONG)
//        
//        }) { (last, error) in
//            print("Something bad has occurred \(error)")
//        }
//    }
}

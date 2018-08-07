//
//  CLMainViewController.swift
//  Call Light
//
//  Created by Ahmed Durrani on 14/04/2018.
//  Copyright © 2018 Tech Ease Solution. All rights reserved.
//

import UIKit

class CLMainViewController: UIViewController {
    
    var previousVC: UIViewController?
    var showingIndex: Int = 0
    var pageVC: UIPageViewController?
    @IBOutlet var viewOfButtons: UIView!

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
         setPager()
        self.view.bringSubview(toFront: viewOfButtons)

        // Do any additional setup after loading the view.
    }
    
    func setPager() {
        pageVC = storyboard?.instantiateViewController(withIdentifier: "PageViewControllerMain") as! UIPageViewController?
//        pageVC?.dataSource = self
//        pageVC?.delegate = self
        
        
        let startVC = viewControllerAtIndex(tempIndex: 0)
        _ = startVC.view
        
        pageVC?.setViewControllers([startVC], direction: .forward, animated: true, completion: nil)
        pageVC?.view.frame = CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_HEGHT)
        self.addChildViewController(pageVC!)
        self.view.addSubview((pageVC?.view)!)
        self.pageVC?.didMove(toParentViewController: self)
        
    }
    
    
    func viewControllerAtIndex(tempIndex: Int) -> UIViewController {
        
        if tempIndex == 0 {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "CLRequestVC" ) as! CLRequestVC
            vc.index = 0
            return vc
        }
        else if tempIndex == 1 {
            
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "CLMapViewController" ) as! CLMapViewController
            vc.index = 1
            return vc
        } else if tempIndex == 2  {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "CLProfileVC") as? CLProfileVC
            
            vc?.index = 2
            return vc!
            
        } else {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "CLHistoryVC") as? CLHistoryVC
            
            vc?.index = 3
            return vc!

        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    @IBAction func btntabFirst_Pressed(_ sender: UIButton) {
        
        sender.backgroundColor = UIColor.black
//        showingIndex = sender.tag
//        let startVC = viewControllerAtIndex(tempIndex: 0)
//        _ = startVC.view
//        pageVC?.setViewControllers([startVC], direction:(showingIndex == 3) ? .forward : .reverse, animated: true, completion: nil)

        
    
    }
    
    @IBAction func btnMap_Pressed(_ sender: UIButton) {
        
        //        showingIndex = sender.tag
        let startVC = viewControllerAtIndex(tempIndex: 1)
        _ = startVC.view
        pageVC?.setViewControllers([startVC], direction:(showingIndex == 3) ? .forward : .reverse, animated: true, completion: nil)
        
        
        
    }
    @IBAction func btnProfile_Pressed(_ sender: UIButton) {
        
        //        showingIndex = sender.tag
        let startVC = viewControllerAtIndex(tempIndex: 2)
        _ = startVC.view
        pageVC?.setViewControllers([startVC], direction:(showingIndex == 3) ? .forward : .reverse, animated: true, completion: nil)
        
        
        
    }
    
   
    
    //MARK: IBActions
    @IBAction func buttonTabBar_Pressed(_ sender: UIButton) {
        //        if showingIndex != sender.tag {
                    showingIndex = sender.tag
       if sender.tag == 31
        {
            

////            btnNew.isSelected = true
////            btnMy.isSelected = false
////            btnTrends.isSelected = false
////
////            viewOfNew.backgroundColor = UIColor.black
////            viewOfTrends.backgroundColor = UIColor.clear
////            viewOfMy.backgroundColor = UIColor.clear
////            let startVC = viewControllerAtIndex(tempIndex: sender.tag)
////            _ = startVC.view
////            pageVC?.setViewControllers([startVC], direction:(showingIndex == 2) ? .forward : .reverse, animated: true, completion: nil)

        }
      else if sender.tag == 32
        {
            
            showingIndex = sender.tag
            let startVC = viewControllerAtIndex(tempIndex: sender.tag)
            _ = startVC.view
            pageVC?.setViewControllers([startVC], direction:(showingIndex == 3) ? .forward : .reverse, animated: true, completion: nil)

//////            btnNew.isSelected = false
//////            btnMy.isSelected = false
//////            btnTrends.isSelected = true
//////            viewOfNew.backgroundColor    = UIColor.clear
//////            viewOfTrends.backgroundColor = UIColor.black
//////            viewOfMy.backgroundColor     = UIColor.clear
//////
//////            let startVC = viewControllerAtIndex(tempIndex: sender.tag)
//////            _ = startVC.view
//////            pageVC?.setViewControllers([startVC], direction:(showingIndex == 2) ? .forward : .reverse, animated: true, completion: nil)
////
////
////
////
       }
//
        
}

    @IBAction func btnIsRequestSendToNurseOrNot(_ sender: UIButton) {
        
        let startVC = viewControllerAtIndex(tempIndex: 0)
        _ = startVC.view
        pageVC?.setViewControllers([startVC], direction:(showingIndex == 3) ? .forward : .reverse, animated: true, completion: nil)

    }
    @IBAction func mapOfNurse_Pressed(_ sender: UIButton) {
        let startVC = viewControllerAtIndex(tempIndex: 1)
        _ = startVC.view
        pageVC?.setViewControllers([startVC], direction:(showingIndex == 3) ? .forward : .reverse, animated: true, completion: nil)
    }
    
    @IBAction func btnDoctor_Profile(_ sender: UIButton) {
       let startVC = viewControllerAtIndex(tempIndex: 2)
        _ = startVC.view
        pageVC?.setViewControllers([startVC], direction:(showingIndex == 3) ? .forward : .reverse, animated: true, completion: nil)

    }
    @IBAction func btnHistory_Pressed(_ sender: UIButton) {
        
        let startVC = viewControllerAtIndex(tempIndex: 3)
        _ = startVC.view
        pageVC?.setViewControllers([startVC], direction:(showingIndex == 3) ? .forward : .reverse, animated: true, completion: nil)

        
    }
}

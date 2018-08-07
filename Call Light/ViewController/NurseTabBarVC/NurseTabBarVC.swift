//
//  NurseTabBarVC.swift
//  Call Light
//
//  Created by Ahmed Durrani on 14/04/2018.
//  Copyright © 2018 Tech Ease Solution. All rights reserved.
//

import UIKit

class NurseTabBarVC: UITabBarController {

    var selected_index: Int = 0
    var tabBarArrow: UIView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addTabBarArrow()
        let appearance = UITabBarItem.appearance()
        let attributes = [NSAttributedStringKey.font:UIFont(name: "Montserrat", size: 12)]
        appearance.setTitleTextAttributes(attributes, for: .normal)
        
        let selectedColor   = UIColor.white
        let unselectedColor = UIColor(red: 154/255.0, green: 154/255.0, blue: 154/255.0, alpha: 1.0)
        
        
        self.tabBar.items![0].selectedImage = UIImage(named:"homeSel")!.withRenderingMode(.alwaysOriginal)
        (self.tabBar.items![0] ).image = UIImage(named:"homeUn")!.withRenderingMode(.alwaysOriginal)
        
        self.tabBar.items![2].selectedImage = UIImage(named:"document")!.withRenderingMode(.alwaysOriginal)
        (self.tabBar.items![2] ).image = UIImage(named:"documentUn")!.withRenderingMode(.alwaysOriginal)
        
        self.tabBar.items![1].selectedImage = UIImage(named:"userSelect")!.withRenderingMode(.alwaysOriginal)
        (self.tabBar.items![1] ).image = UIImage(named:"man-user")!.withRenderingMode(.alwaysOriginal)
        
        self.tabBar.items![3].selectedImage = UIImage(named:"placeholder")!.withRenderingMode(.alwaysOriginal)
        (self.tabBar.items![3] ).image = UIImage(named:"placeholderUn")!.withRenderingMode(.alwaysOriginal)

    
        self.tabBar.items![4].selectedImage = UIImage(named:"history-clock-button")!.withRenderingMode(.alwaysOriginal)
        (self.tabBar.items![4] ).image = UIImage(named:"history-clock-buttonUn")!.withRenderingMode(.alwaysOriginal)
        
        
        
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedStringKey.foregroundColor: unselectedColor], for: .normal)
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedStringKey.foregroundColor: selectedColor], for: .selected)

        
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedStringKey.foregroundColor: unselectedColor], for: .normal)
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedStringKey.foregroundColor: selectedColor], for: .selected)
        
        
       
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //        self.tabBar.barTintColor = .blue
        self.tabBar.barTintColor = UIColor(red: 26/255.0, green: 83/255.0, blue: 155/255.0, alpha: 1.0)
        if localUserData.profile_completed == false {
            self.selected_index = 1

        } else {

        }
    }
    
    func addTabBarArrow() {
        tabBarArrow = UIView(frame: CGRect(x: 0, y: view.frame.size.height - 3 , width: tabBar.frame.size.width / CGFloat(tabBar.items?.count ?? Int(0.0)), height: 2))
        // To get the vertical location we start at the bottom of the window, go up by height of the tab bar, go up again by the height of arrow and then come back down 2 pixels so the arrow is slightly on top of the tab bar.
        //tabBarController.tabBar.frame.size.height -
        let verticalLocation: CGFloat = view.frame.size.height - 2
        tabBarArrow?.frame = CGRect(x: horizontalLocationForSelectedTabItem(), y: verticalLocation, width: tabBar.frame.size.width / CGFloat(tabBar.items?.count ?? Int(0.0)), height: 1)
        tabBarArrow?.backgroundColor = UIColor.white
        view.addSubview(tabBarArrow!)
    }
    
    func horizontalLocationForSelectedTabItem() -> CGFloat {
        // A single tab item's width is the entire width of the tab bar divided by number of items
        let tabItemWidth = tabBar.frame.size.width / CGFloat(tabBar.items?.count ?? Int(0.0))
        // A half width is tabItemWidth divided by 2 minus half the width of the arrow
        let halfTabItemWidth: CGFloat = (tabItemWidth / 2.0) - (tabBarArrow!.frame.size.width / 2.0)
        // The horizontal location is the index times the width plus a half width
        //        return  CGFloat((selectedIndex) * tabItemWidth) + halfTabItemWidth
        
        return (CGFloat(selected_index) * CGFloat(tabItemWidth)) + halfTabItemWidth
        
    }
    
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        selected_index = item.tag
        
        let xposition: CGFloat = horizontalLocationForSelectedTabItem()
        UIView.beginAnimations(nil, context: nil)
        UIView.setAnimationDuration(kAnimationDuration)
        var frame: CGRect = tabBarArrow!.frame
        frame.origin.x = xposition
        tabBarArrow?.frame = frame
        UIView.commitAnimations()
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

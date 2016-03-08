//
//  ZGCBaseTabBarController.swift
//  Carcheck
//
//  Created by GaoCheng.Zou on 16/2/14.
//  Copyright © 2016年 GaoCheng.Zou. All rights reserved.
//

import UIKit

class ZGCBaseTabBarController: UITabBarController {
    var vehicleBtn:UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.initTabBarVehicleBtn()
        // Do any additional setup after loading the view.
    }
    
    func initTabBarVehicleBtn() {
        vehicleBtn = UIButton(type: UIButtonType.Custom)
        let img = UIImage(named: "tabbar_car_n")
        vehicleBtn.frame = CGRectMake((KScreenWidth - img!.size.width)/2, (44 - img!.size.height)/2 + 4, img!.size.width, img!.size.height)
        vehicleBtn.setImage(img, forState: UIControlState.Normal)
        vehicleBtn.setImage(UIImage(named: "tabbar_car_h"), forState: UIControlState.Selected)
        vehicleBtn.addTarget(self, action: "vehicleBtnAction", forControlEvents: UIControlEvents.TouchUpInside)
        self.tabBar.addSubview(vehicleBtn)
    }
    
    func vehicleBtnAction() {
        vehicleBtn.selected = !vehicleBtn.selected
    
        let carItemView = ZGCCarItemView(frame: CGRectZero)
        carItemView.show()
        carItemView.didClickButtonAtIndexHandler = {
            (tag:String)-> Void in
            let dic = ["tag":tag]
            NSNotificationCenter.defaultCenter().postNotificationName(TAPTOPUSHVIEWCONTROLLER, object: dic)
            self.vehicleBtn.selected = !self.vehicleBtn.selected
        }
        
        carItemView.didClickHiddenBlockHandler = {
            self.vehicleBtn.selected = !self.vehicleBtn.selected
        }

    }
    
    
    func itemBtnAction(itemBtn:UIButton) {
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

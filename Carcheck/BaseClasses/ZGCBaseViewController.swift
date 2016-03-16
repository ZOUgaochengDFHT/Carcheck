//
//  ZGCBaseViewController.swift
//  Carcheck
//
//  Created by GaoCheng.Zou on 16/2/14.
//  Copyright © 2016年 GaoCheng.Zou. All rights reserved.
//

import UIKit
import MBProgressHUD

class ZGCBaseViewController: UIViewController {

    var customWindow: UIWindow!
    
    var photoListBarView: ZGCPhotoListBarView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "tapToPushViewController:", name: TAPTOPUSHVIEWCONTROLLER, object: nil)
        self.navigationController!.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName:UIColor.whiteColor()]

        
//        self.navigationController?.interactivePopGestureRecognizer?.enabled = true
        
        self.initDismissKeyboardTap()

        self.navigationController?.navigationBar.translucent = false
        // Do any additional setup after loading the view.
        self.view.backgroundColor = UIColor.whiteColor();
        if(self.navigationController!.viewControllers.count > 1){
            self.initHomeButton()
        }
        
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(named: "icon_navbg"), forBarMetrics: UIBarMetrics.Default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        UIApplication.sharedApplication().statusBarStyle = UIStatusBarStyle.LightContent

    }
    
    func initDismissKeyboardTap () {
        /**
         *@利用手势控制键盘的收起
         */
        let tap = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        self.view.addGestureRecognizer(tap)
    }
    
    //创建返回按钮
    func initHomeButton(){
        let homeBtn = UIButton(type: UIButtonType.System)
        homeBtn.frame = CGRectMake(0, 0, 40, 30)
        homeBtn.setTitle("首页", forState: UIControlState.Normal)
        homeBtn.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        homeBtn.addTarget(self, action: Selector("homeButtonClicked"), forControlEvents: UIControlEvents.TouchUpInside)
        let backBtn = UIBarButtonItem(customView: homeBtn)
        let negativeSpacer = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FixedSpace, target: nil, action: nil)
        negativeSpacer.width = -10
        self.navigationItem.leftBarButtonItems = [negativeSpacer, backBtn]
    }
    
    func initBackButton() {
        let backBtn = UIButton(type: UIButtonType.System)
        backBtn.frame = CGRectMake(0, 0, 30, 23)
        var image = UIImage(named: "icon_back")
        image = image!.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal)//解决返回按钮自定义图片始终为蓝色的问题
        backBtn.setImage(image, forState: UIControlState.Normal)
        backBtn.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        backBtn.addTarget(self, action: Selector("backButtonClicked"), forControlEvents: UIControlEvents.TouchUpInside)
        let backBarBtn = UIBarButtonItem(customView: backBtn)
        let negativeSpacer = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FixedSpace, target: nil, action: nil)
        negativeSpacer.width = -10
        self.navigationItem.leftBarButtonItems = [negativeSpacer, backBarBtn]
    }
    
    
    func initUpOrNextView (tapArr:NSArray, imgArr:NSArray) {
        var imgNameArr = imgArr
        if imgArr.count == 0 {
            imgNameArr = ["photo_up", "photo_take", "photo_next"]
        }
        photoListBarView = ZGCPhotoListBarView(frame: CGRectMake(0, KScreenHeight - 49 - NavAndStausHeight, KScreenWidth, 49), target: self, sel: "tabBarTapAction:", imgNameArr: imgNameArr, tapArr: tapArr)
        self.view.addSubview(photoListBarView)
    }
    
    func tabBarTapAction(tap:UITapGestureRecognizer) {
        if tap.view!.tag == 333 {
            self.navigationController?.popViewControllerAnimated(true)
        }
    }
    
    
    
    func homeButtonClicked() {
        
        let alert = UIAlertController(title: nil, message: String("回到首页？"), preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction.init(title: "取消", style: UIAlertActionStyle.Default, handler: { (alertAction:UIAlertAction) -> Void in
            
        }))
        alert.addAction(UIAlertAction.init(title: "确定", style: UIAlertActionStyle.Default, handler: { (alertAction:UIAlertAction) -> Void in
            self.navigationController?.popToRootViewControllerAnimated(true)
        }))
        alert.view.tintColor = ButtonBackGroundColor
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    func backButtonClicked() {
        self.navigationController?.popViewControllerAnimated(true)
//        self.dismissViewControllerAnimated(true, completion: nil)
    }

    
    func showHUD(title:String, image:UIImage, withHiddenDelay delay:NSTimeInterval) {
        self.initCustomWindow()
        
        let hud = MBProgressHUD()
        customWindow.addSubview(hud)
        hud.mode = MBProgressHUDMode.CustomView
        hud.customView = UIImageView.init(image: image)
        hud.labelFont = UIFont.systemFontOfSize(13.0)
        hud.labelText = title
        
        hud.showAnimated(true, whileExecutingBlock: { () -> Void in
            sleep(UInt32(delay))
            }) { () -> Void in
                hud.removeFromSuperview()
                self.customWindow.removeFromSuperview()
                self.customWindow = nil
        }
        
    }
    
    func initCustomWindow() {
        customWindow = UIWindow(frame: CGRectMake(0, 64, KScreenWidth, KScreenHeight))
        customWindow.windowLevel = UIWindowLevelNormal
        customWindow.backgroundColor = UIColor.clearColor()
        customWindow.makeKeyAndVisible()
    }
    
    func showLoadingStatusHUD (title:String) {
        self.initCustomWindow()
        let hud = MBProgressHUD()
        customWindow.addSubview(hud)
        hud.tag = 333
        hud.mode = MBProgressHUDMode.Indeterminate
        hud.labelFont = UIFont.systemFontOfSize(13.0)
        hud.labelText = title
        hud.show(true)
    }
    
    func removeHUD () {
        let hud = customWindow.viewWithTag(333) as! MBProgressHUD
        hud.removeFromSuperview()
        customWindow.removeFromSuperview()
        customWindow = nil
    }
    
    
    func setSelfViewBoundsOriginY(Y:CGFloat) {
        UIView.animateWithDuration(0.35) { () -> Void in
            self.view.bounds = CGRectMake(0, Y, KScreenWidth, KScreenHeight - 64)
        }
    }
    
    
    func showActionSheet (title:String,  completionBlock:(Bool -> Void)?) {
        let alert = UIAlertController(title: nil, message: title, preferredStyle: UIAlertControllerStyle.ActionSheet)
        alert.addAction(UIAlertAction.init(title: "取消", style: UIAlertActionStyle.Default, handler: { (alertAction:UIAlertAction) -> Void in
            
        }))
        alert.addAction(UIAlertAction.init(title: "确定", style: UIAlertActionStyle.Default, handler: { (alertAction:UIAlertAction) -> Void in
            completionBlock!(true)
        }))
        alert.view.tintColor = ButtonBackGroundColor
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    func dismissKeyboard () {
        self.view.endEditing(true)
        self.setSelfViewBoundsOriginY(0)
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

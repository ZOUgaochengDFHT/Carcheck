//
//  ZGCLoginViewController.swift
//  Carcheck
//
//  Created by GaoCheng.Zou on 16/2/18.
//  Copyright © 2016年 GaoCheng.Zou. All rights reserved.
//

import UIKit
import Alamofire
import MBProgressHUD

class ZGCLoginViewController: UIViewController, ZGCCheckBoxDelegate, UITextFieldDelegate {

    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var userTxtField: UITextField!
    @IBOutlet weak var pwdTxtField: UITextField!
    @IBOutlet weak var loginBgScrollView: UIScrollView!
    @IBOutlet weak var warnLabel: UILabel!
    @IBOutlet weak var logoImgView: UIImageView!
    
    @IBOutlet weak var userImgView: UIImageView!
    
    @IBOutlet weak var pwdImgView: UIImageView!
    var customWindow: UIWindow!
    var loginTxtFieldTag: Int!

    
    @IBAction func deleteBtnAction(sender: UIButton) {
        if sender.tag == 100 {
            userTxtField.becomeFirstResponder()
            userTxtField.text = ""
        }else {
            pwdTxtField.becomeFirstResponder()
            pwdTxtField.text = ""
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:", name: "UIKeyboardWillShowNotification", object: nil)

        
        // Do any additional setup after loading the view.
        let check1 = ZGCCheckBox()
        check1.initWithDelegate(self)
        check1.frame = CGRectMake(60, pwdTxtField.bottom + 2, 80, 40)
        check1.setTitle("记住账号", forState: UIControlState.Normal)
        check1.setTitleColor(UIColor.grayColor(), forState: UIControlState.Normal)
        check1.titleLabel?.font = UIFont.systemFontOfSize(13.0)
        loginBgScrollView.addSubview(check1)
        
        let check2 = ZGCCheckBox()
        check2.initWithDelegate(self)
        check2.frame = CGRectMake(check1.right + 10, pwdTxtField.bottom + 2, 80, 40)
        check2.setTitle("自动登录", forState: UIControlState.Normal)
        check2.setTitleColor(UIColor.grayColor(), forState: UIControlState.Normal)
        check2.titleLabel?.font = UIFont.systemFontOfSize(13.0)
        loginBgScrollView.addSubview(check2)
        
        loginButton.backgroundColor = ButtonBackGroundColor
        loginButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        loginButton.layer.cornerRadius = loginButton.height/5
        
//        let userImg = UIImage(named: "login_user")
//        let userImgView = UIImageView.init(frame: CGRectMake(0, 0, (userImg?.size.width)!, (userImg?.size.height)!))
//        userImgView.image = userImg
//        userTxtField.leftView = userImgView
        userTxtField.delegate = self
//        userTxtField.leftViewMode = UITextFieldViewMode.Always
        
//        let pwdImg = UIImage(named: "login_pwd")
//        let pwdImgView = UIImageView.init(frame: CGRectMake(0, 0, (pwdImg?.size.width)!, (pwdImg?.size.height)!))
//        pwdImgView.image = pwdImg
//        pwdTxtField.leftView = pwdImgView
        pwdTxtField.delegate = self
//        pwdTxtField.leftViewMode = UITextFieldViewMode.Always
        
        for i in 0...1 {
            let horizontalLayer = CALayer()
            horizontalLayer.backgroundColor = LoginBottomLayerColor.CGColor
            horizontalLayer.setNeedsDisplay()
            horizontalLayer.anchorPoint = CGPointZero
            loginBgScrollView.layer.addSublayer(horizontalLayer)
            horizontalLayer.bounds = CGRectMake(0, 0, KScreenWidth - 80, 1)
            horizontalLayer.position = CGPointMake(userImgView.left, userTxtField.bottom + 2 + CGFloat(i)*50)
        }
        
        let verticalLayer = CALayer()
        verticalLayer.backgroundColor = LoginBottomLayerColor.CGColor
        verticalLayer.setNeedsDisplay()
        verticalLayer.anchorPoint = CGPointZero
        loginBgScrollView.layer.addSublayer(verticalLayer)
        verticalLayer.bounds = CGRectMake(0, 0, 1, 21)
        verticalLayer.position = CGPointMake(userTxtField.left - 5, userImgView.top + 3)

        
//        let bgView = UIView(frame: CGRectZero)
//        bgView.backgroundColor = UIColor.clearColor()
//        bgView.translatesAutoresizingMaskIntoConstraints = false
//        loginBgScrollView.insertSubview(bgView, belowSubview: logoImgView)
////        loginBgScrollView.translatesAutoresizingMaskIntoConstraints = false
//    
//        
//        //使用AutoLayout时，设置UiScrollView的contentSize只能用子视图的constraints
//        
//        var viewBindingsDict = [String: AnyObject]()
//        viewBindingsDict["bgView"] = bgView
//        let bgViewWidthMetrics = ["margin":(KScreenWidth)]
//        let bgViewWidthConstraints = NSLayoutConstraint.constraintsWithVisualFormat("H:|-[bgView(==margin)]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: bgViewWidthMetrics, views:viewBindingsDict)
//        loginBgScrollView.addConstraints(bgViewWidthConstraints)
//        
//        
//        let bgViewHeightMetrics = ["height":(700)]
//        let bgViewHeightConstraints = NSLayoutConstraint.constraintsWithVisualFormat("V:|-[bgView(==height)]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: bgViewHeightMetrics, views:viewBindingsDict)
//        loginBgScrollView.addConstraints(bgViewHeightConstraints)
//
//        //关键点。非常重要.设置contentsize以滚动。
//        let size = bgView.systemLayoutSizeFittingSize(UILayoutFittingCompressedSize)
//        print(size)
//        loginBgScrollView.contentSize = size

    }
    
    func didSelectedCheckBox(checkBox: ZGCCheckBox, checked: Bool) {
        
    }
    
    @IBAction func loginAction(sender: UIButton) {
        
        if userTxtField.text == "" {
            self.showHUD("用户名不能为空", image: UIImage(), withHiddenDelay: 2)
            return
        }
        
        if pwdTxtField.text == "" {
            self.showHUD("密码不能为空", image: UIImage(), withHiddenDelay: 2)
            return
        }
        
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        // MARK: - 登录
        Alamofire.request(.POST, BaseURLString.stringByAppendingString("user/auth"), parameters: ["username":userTxtField.text!,"password":pwdTxtField.text!], encoding: .JSON).responseJSON {
            response in
            UIApplication.sharedApplication().networkActivityIndicatorVisible = false
            if let json = response.result.value {
                print(json)
                let loginResponseModel = ZGCLoginResonseModel.init(contentWithDic: json as! [NSObject : AnyObject])
                if loginResponseModel.success == 1 {
                    UserDefault.setObject(loginResponseModel.data, forKey: "token")
                    UserDefault.synchronize()
                    let mainStoryBoard = UIStoryboard(name: "Main", bundle: nil)
                    self.view.window?.rootViewController = mainStoryBoard.instantiateInitialViewController()
                    print(loginResponseModel.data)
                    
                    DataService.requestDataWithToken(String(loginResponseModel.data))
                    
                }else {
                    self.showHUD(loginResponseModel.message, image: UIImage(), withHiddenDelay: 2.0)
                    return
                }
            }
        }
    }
    
    func showHUD(title:String, image:UIImage, withHiddenDelay delay:NSTimeInterval) {
        customWindow = UIWindow(frame: CGRectMake(0, 64, KScreenWidth, KScreenHeight))
        customWindow.windowLevel = UIWindowLevelNormal
        customWindow.backgroundColor = UIColor.clearColor()
        customWindow.makeKeyAndVisible()
        
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
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.view.endEditing(true)
        UIView.animateWithDuration(0.35) { () -> Void in
            self.view.bounds = CGRectMake(0, 0, KScreenWidth, KScreenHeight)
        }
        return true
    }
    
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
        loginTxtFieldTag = textField.tag
        return true
    }
    
    
    //监听键盘显示的方法实现
    func keyboardWillShow(notification: NSNotification!) {
        let keyboardSize = (notification.userInfo![UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.CGRectValue()
        UIView.animateWithDuration(0.25, animations: { () -> Void in
            var YOffset:CGFloat!
            if self.loginTxtFieldTag != nil {
                if self.pwdTxtField.bottom > KScreenHeight - (keyboardSize?.height)! {
                    YOffset = (keyboardSize?.height)! - (KScreenHeight - self.pwdTxtField.bottom)
                    UIView.animateWithDuration(0.35) { () -> Void in
                        self.view.bounds = CGRectMake(0, YOffset, KScreenWidth, KScreenHeight)
                    }
                }
            }
            
            
        })
        
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

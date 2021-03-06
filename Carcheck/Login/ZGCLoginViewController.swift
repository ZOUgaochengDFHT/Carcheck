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

    var isRemeber = false
    var isAuto = false
    
    var check1: ZGCCheckBox!
    var check2: ZGCCheckBox!
    
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
        
        /**
         *@利用手势控制键盘的收起
         */
        let tap = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        self.view.addGestureRecognizer(tap)
        
        // Do any additional setup after loading the view.
        check1 = ZGCCheckBox()
        check1.initWithDelegate(self)
        check1.frame = CGRectMake(60, pwdTxtField.bottom + 2, 80, 40)
        check1.setTitle("记住账号", forState: UIControlState.Normal)
        check1.tag = 100
        check1.setTitleColor(UIColor.grayColor(), forState: UIControlState.Normal)
        check1.titleLabel?.font = UIFont.systemFontOfSize(13.0)
        loginBgScrollView.addSubview(check1)
        
        check2 = ZGCCheckBox()
        check2.initWithDelegate(self)
        check2.frame = CGRectMake(check1.right + 10, pwdTxtField.bottom + 2, 80, 40)
        check2.setTitle("自动登录", forState: UIControlState.Normal)
        check2.tag = 101
        check2.setTitleColor(UIColor.grayColor(), forState: UIControlState.Normal)
        check2.titleLabel?.font = UIFont.systemFontOfSize(13.0)
        loginBgScrollView.addSubview(check2)
        
        if UserDefault.objectForKey("username") != nil {
            userTxtField.text = UserDefault.objectForKey("username") as? String
            check1.selected = true
            if UserDefault.objectForKey("isLogined") as! Bool == true {
                check2.selected = true
            }

        }
        
        
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

        
        let metrics = ["tbWidth":KScreenWidth , "tbHeight":KScreenHeight*2]
        
        var viewBindingsDict = [String: AnyObject]()
        viewBindingsDict["loginBgScrollView"] = loginBgScrollView
        
        loginBgScrollView.translatesAutoresizingMaskIntoConstraints = false

        let tbWidthConstraints = NSLayoutConstraint.constraintsWithVisualFormat("H:|-[loginBgScrollView(==tbWidth)]", options: NSLayoutFormatOptions(rawValue: 0), metrics: metrics, views: viewBindingsDict)
        
        let tbHeightConstraints = NSLayoutConstraint.constraintsWithVisualFormat("V:|-0-[loginBgScrollView(==tbHeight)]", options: NSLayoutFormatOptions(rawValue: 0), metrics: metrics, views: viewBindingsDict)
        
        self.view.addConstraints(tbWidthConstraints)
        self.view.addConstraints(tbHeightConstraints)

//        //关键点。非常重要.设置contentsize以滚动。
//        let size = bgView.systemLayoutSizeFittingSize(UILayoutFittingCompressedSize)
//        print(size)
//        loginBgScrollView.contentSize = size

    }
    
    func didSelectedCheckBox(checkBox: ZGCCheckBox, checked: Bool) {
        if checkBox.tag == 101 {
            check2.selected = checked
            if checked == true {
                check1.selected = checked
            }
        }
    }
    
    @IBAction func loginAction(sender: UIButton) {
        
        if userTxtField.text == "" {
            self.showHUD("用户名不能为空", image: UIImage(), withHiddenDelay: 1.0)
            return
        }
        
        if pwdTxtField.text == "" {
            self.showHUD("密码不能为空", image: UIImage(), withHiddenDelay: 1.0)
            return
        }
       
        self.doLogining()
    }
    
    func doLogining () {
        
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        
        self.showLoadingStatusHUD("登录中...")
        // MARK: - 登录
        Alamofire.request(.POST, BaseURLString.stringByAppendingString("user/auth"), parameters: ["username":userTxtField.text!,"password":pwdTxtField.text!], encoding: .JSON).responseJSON {
            response in
            UIApplication.sharedApplication().networkActivityIndicatorVisible = false
            if let json = response.result.value {
                self.removeHUD()
                let loginResponseModel = ZGCLoginResonseModel.init(contentWithDic: json as! [NSObject : AnyObject])
                if loginResponseModel.success == 1 {
                    UserDefault.setObject(loginResponseModel.data, forKey: "token")
                    UserDefault.synchronize()
                    let mainStoryBoard = UIStoryboard(name: "Main", bundle: nil)
                    self.view.window?.rootViewController = mainStoryBoard.instantiateInitialViewController()
                    
                    if self.check2.selected == true {
                        UserDefault.setBool(true, forKey: "isLogined")
                        UserDefault.setObject(self.userTxtField.text!, forKey: "username")
                    }else {
                        if self.check1.selected == true {
                            UserDefault.setObject(self.userTxtField.text!, forKey: "username")
                        }else {
                            if UserDefault.objectForKey("username") != nil {
                                UserDefault.removeObjectForKey("username")
                            }
                        }
                        UserDefault.setBool(false, forKey: "isLogined")
                    }
                    UserDefault.synchronize()
                }else {
                    self.showHUD(loginResponseModel.message, image: UIImage(), withHiddenDelay: 2.0)
                    return
                }
            }
        }

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
    
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if userTxtField.text != "" && pwdTxtField.text != "" {
            self.doLogining() 
        }
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
                    YOffset = (keyboardSize?.height)! - (KScreenHeight - self.check1.bottom + 10)
                    UIView.animateWithDuration(0.35) { () -> Void in
                        self.view.bounds = CGRectMake(0, YOffset, KScreenWidth, KScreenHeight)
                    }
                }
            }
            
            
        })
        
    }
    
    func dismissKeyboard () {
        self.view.endEditing(true)
        UIView.animateWithDuration(0.35) { () -> Void in
            self.view.bounds = CGRectMake(0, 0, KScreenWidth, KScreenHeight)
        }
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

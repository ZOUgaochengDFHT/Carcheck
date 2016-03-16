//
//  ZGCPWDChangeViewController.swift
//  Carcheck
//
//  Created by GaoCheng.Zou on 16/3/15.
//  Copyright © 2016年 GaoCheng.Zou. All rights reserved.
//

import UIKit

import Alamofire
class ZGCPWDChangeViewController: ZGCBaseViewController , UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate{
    
    var passwordChangeTB:UITableView!
    var placeHolderArr:NSArray!
    var oldPassWordStr:NSString!
    var newPassWordStr:NSString!
    var sureNewPassWordStr:NSString!
    
    var isPasswordReset = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "修改密码";
        placeHolderArr = ["您的原密码", "您的新密码（6-16位）", "确认新密码（6-16位）"];
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "textFieldTextDidChange:", name: UITextFieldTextDidChangeNotification, object: nil)
        self.initBackButton()
        
        self.initPasswordChangeTB()
        self.initSubmitBtn()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func initPasswordChangeTB() {
        passwordChangeTB = UITableView(frame: CGRectMake(0, 10, self.view.bounds.size.width, CGFloat(placeHolderArr.count)*40), style: UITableViewStyle.Grouped)
        passwordChangeTB.delegate = self;
        passwordChangeTB.dataSource = self;
        passwordChangeTB.scrollEnabled = false
        passwordChangeTB.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
        self.view.addSubview(passwordChangeTB)
        passwordChangeTB.rowHeight = 40
        passwordChangeTB.tableFooterView = UIView()//去掉多余的cell分割线
    }
    
    func initSubmitBtn() {
        let submitBtn:UIButton = UIButton(type: UIButtonType.Custom)
        submitBtn.layer.cornerRadius = 4.0
        submitBtn.backgroundColor = ButtonBackGroundColor
        submitBtn.setTitle("提交", forState:UIControlState.Normal)
        submitBtn.clipsToBounds = true
        submitBtn.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        submitBtn.titleLabel?.font = UIFont.systemFontOfSize(15.0)
        submitBtn.frame = CGRectMake(20, 140, self.view.bounds.size.width-40, 49)
        self.view.addSubview(submitBtn)
        
        submitBtn.addTarget(self, action: "submitAction", forControlEvents: UIControlEvents.TouchUpInside)
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return placeHolderArr.count;
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.0001;
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let identifier:String = "cell"
        var cell:UITableViewCell? = tableView.dequeueReusableCellWithIdentifier(identifier, forIndexPath: indexPath)
        if cell == nil {
            cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: identifier)
        }
        
        let txfField:UITextField = UITextField()
        txfField.delegate = self
        let leftImgView:UIImageView = UIImageView.init(frame: CGRectMake(0, 0, 20, 20))
        leftImgView.image = UIImage(named: "login_pwd")
        txfField.leftView = leftImgView
        txfField.tag = 100+indexPath.row
        txfField.leftViewMode = UITextFieldViewMode.Always
        txfField.placeholder = placeHolderArr.objectAtIndex(indexPath.row) as? String
        txfField.clearButtonMode = UITextFieldViewMode.Always
        //设置完成按钮
        txfField.returnKeyType = UIReturnKeyType.Done
        txfField.textColor = UIColor.darkGrayColor()
        txfField.font = UIFont(name: "Helvetica", size: 13.0)
        txfField.frame = CGRectMake(10, 0, self.view.bounds.size.width-20, 40)
        cell?.contentView.addSubview(txfField)
        
        return cell!
    }
    
    //监听完成按钮
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
    
    let defaults = NSUserDefaults.standardUserDefaults()
    
    func submitAction() {
        self.view.endEditing(true)
        if (oldPassWordStr == nil) {
            self.showHUD("原密码不能为空" , image: UIImage(), withHiddenDelay: 1.0)
            return
        }else if (newPassWordStr == nil) {
            self.showHUD("密码不能为空" , image: UIImage(), withHiddenDelay: 1.0)
            return
        }else if (newPassWordStr.length < 6 || newPassWordStr.length > 16) {
            self.showHUD("密码长度为6-16字符" , image: UIImage(), withHiddenDelay: 1.0)
            return
        }else if ((sureNewPassWordStr != newPassWordStr) || sureNewPassWordStr == nil) {
            self.showHUD("两次输入长度不一致" , image: UIImage(), withHiddenDelay: 1.0)
            return
        }
        
        
        Alamofire.request(.POST, BaseURLString.stringByAppendingString("user/password"), parameters: ["oldPwd":oldPassWordStr, "newPwd":newPassWordStr], encoding: .JSON, headers: ["token":UserDefault.objectForKey("token") as! String]).responseJSON {response in
            
            if let json = response.result.value {
                print(json)
                if json.objectForKey("success") as! NSNumber == 1 {
                    self.showHUD("密码修改成功！" , image: UIImage(), withHiddenDelay: 1.0)
                    self.navigationController?.popToRootViewControllerAnimated(true)
                }else {
                    self.showHUD("密码修改失败！请检查网络！" , image: UIImage(), withHiddenDelay: 1.0)
                }
                
            }
        }
    }
    
    
    func textFieldTextDidChange(notification:NSNotification) {
        let textField = notification.object as! UITextField
        if textField.tag == 100 {
            oldPassWordStr = textField.text
        }else if textField.tag == 101 {
            newPassWordStr = textField.text
        }else {
            sureNewPassWordStr = textField.text
        }
    }
    
    
    func textFieldShouldClear(textField: UITextField) -> Bool {
        if textField.tag == 100 {
            oldPassWordStr = nil
        }else if textField.tag == 101 {
            newPassWordStr = nil
        }else {
            sureNewPassWordStr = nil
        }
        return true
    }// called when clear button pressed. return NO to ignore (no notifications)
    
    
    /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    }
    */
    
}

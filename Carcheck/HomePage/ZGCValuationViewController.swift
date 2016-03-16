//
//  ZGCValuationViewController.swift
//  Carcheck
//
//  Created by GaoCheng.Zou on 16/3/15.
//  Copyright © 2016年 GaoCheng.Zou. All rights reserved.
//

import UIKit
import Alamofire
class ZGCValuationViewController: ZGCBaseViewController, UITextFieldDelegate {

    var valueTag:Int!
    
    var customDatePickerView: ZGCCustomDatePickerView!
    
    var styleId: String = ""
    var date: String = ""
    var milage: String  = ""
    
    var rightTextField: ZGCCustomTxtField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.initBackButton()
        
        self.navigationItem.title = "车辆估值工具"
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:", name: "UIKeyboardWillShowNotification", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "changeVehicleType", name: CHANGEVEHICLETYPE, object: nil)
       
        
        let preTitleArr = ["车辆型号", "上牌时间", "行驶里程"] as NSArray
        
        preTitleArr.enumerateObjectsUsingBlock { (object, index, stop) -> Void in
            
            let preLabel = UILabel()
            preLabel.frame = CGRectMake(0, 20 + 50 * CGFloat(index), 90, 30)
            preLabel.font = UIFont.systemFontOfSize(15.0)
            preLabel.textAlignment = NSTextAlignment.Right
            preLabel.text = object as? String
            self.view.addSubview(preLabel)
            
            
            if index == 2 {
                self.rightTextField = ZGCCustomTxtField.init(frame: CGRectMake(preLabel.right + 10, preLabel.top, KScreenWidth - 120, 30))
                self.rightTextField.delegate = self
                self.rightTextField.borderStyle = UITextBorderStyle.None
                self.view.addSubview(self.rightTextField)
                self.rightTextField.returnKeyType = UIReturnKeyType.Done
                self.rightTextField.layer.borderColor = kBorderColor.CGColor;
                
                self.rightTextField.layer.borderWidth = 0.5
                self.rightTextField.layer.cornerRadius = 4
                self.rightTextField.clipsToBounds = true
                self.rightTextField.textColor = UIColor.darkGrayColor()
                self.rightTextField.font = UIFont.systemFontOfSize(12.0)
                self.rightTextField.layer.masksToBounds = true
                self.rightTextField.keyboardType = UIKeyboardType.DecimalPad
                let rightLabel = UILabel(frame: CGRectMake(0, 0, 30, 30))
                rightLabel.tag = self.rightTextField.tag
                rightLabel.textAlignment = NSTextAlignment.Right
                rightLabel.textColor = UIColor.lightGrayColor()
                rightLabel.font = UIFont.systemFontOfSize(13.0)
                self.rightTextField.rightView = rightLabel
                rightLabel.text = "km"
                self.rightTextField.rightViewMode = UITextFieldViewMode.Always
                
                
                let checkBaseConfigButton:UIButton = UIButton(type: UIButtonType.Custom)
                checkBaseConfigButton.backgroundColor = ButtonBackGroundColor
                checkBaseConfigButton.setTitle("查 询", forState:UIControlState.Normal)
                checkBaseConfigButton.layer.cornerRadius = 8.0
                checkBaseConfigButton.clipsToBounds = true
                checkBaseConfigButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
                checkBaseConfigButton.titleLabel?.font = UIFont.systemFontOfSize(15.0)
                checkBaseConfigButton.frame = CGRectMake(KScreenWidth/8, self.rightTextField.bottom + 20, KScreenWidth*3/4, 40)
                checkBaseConfigButton.tag = 99
                checkBaseConfigButton.addTarget(self, action: "checkAction:", forControlEvents: UIControlEvents.TouchUpInside)
                self.view.addSubview(checkBaseConfigButton)

            }else {
                
                let rightLabel = UILabel(frame: CGRectMake(preLabel.right + 10, preLabel.top, KScreenWidth - 120, 30))
                rightLabel.tag = 600 + index
                rightLabel.textColor = UIColor.darkGrayColor()
                rightLabel.font = UIFont.systemFontOfSize(12.0)
                rightLabel.layer.borderWidth = 0.5
                rightLabel.layer.cornerRadius = 4
                rightLabel.numberOfLines = 0
                rightLabel.clipsToBounds = true
                rightLabel.layer.borderColor = kBorderColor.CGColor;
                rightLabel.userInteractionEnabled = true
                self.view.addSubview(rightLabel)

                let tap = UITapGestureRecognizer(target: self, action: "tapAction:")
                rightLabel.addGestureRecognizer(tap)
            }
            
        }

        // Do any additional setup after loading the view.
    }
    
    override func backButtonClicked() {
        self.navigationController?.popToRootViewControllerAnimated(true)
    }
    
    func checkAction (btn:UIButton) {
        self.view.endEditing(true)
        milage = rightTextField.text!
        if styleId == "" {
            self.showHUD("请点击选择车辆型号！", image: UIImage(), withHiddenDelay: 1.0)
            return
        }
        
        if date == "" {
            self.showHUD("请点击选择上牌时间！", image: UIImage(), withHiddenDelay: 1.0)
            return
        }
        
        if milage == "" {
            self.showHUD("请填写行驶里程！", image: UIImage(), withHiddenDelay: 1.0)
            return
        }
        
        self.showLoadingStatusHUD("数据请求中...")
        
        Alamofire.request(.POST, BaseURLString.stringByAppendingString("brand/valuation"), parameters: ["username":"zgc", "styleId":styleId,"date":date,"milage":milage], encoding: .JSON, headers: ["token":UserDefault.objectForKey("token") as! String]).responseJSON {response in
            
            if let json = response.result.value {
                print(json)
                let staticModel = ZGCStaticsModel(contentWithDic:json as! [NSObject : AnyObject])
                if staticModel.success == 1 {
                    let valueArr = NSMutableArray()
                    (staticModel.data as NSDictionary).objectForKey("B2CLevelPrice")?.enumerateObjectsUsingBlock({ (object, index, stop) -> Void in
                        let str:String = object as! String
                        valueArr.addObject(str)
                    })
                    valueArr.addObject((staticModel.data as NSDictionary).objectForKey("newCarPrice")!)
                    
                    self.removeHUD()
                    let valuationResultVC = ZGCValuationResultViewController()
                    valuationResultVC.valueArr = valueArr
                    self.navigationController?.pushViewController(valuationResultVC, animated: true)
                }
            }
            
        }

    }
    
    func tapAction (tap:UITapGestureRecognizer) {
        self.view.endEditing(true)
        if tap.view?.tag == 600 {
            let vehicleTypeVC = ZGCVehicleTypeListViewController()
            self.navigationController?.pushViewController(vehicleTypeVC, animated: true)
        }else {
            if customDatePickerView == nil {
                customDatePickerView = ZGCCustomDatePickerView(frame: CGRectMake(0, 0, KScreenWidth, KScreenHeight - 64))
                self.view.addSubview(customDatePickerView)
            }
            customDatePickerView.coverViewPresnt()
            customDatePickerView.getDateFormatStrHandler = {
                (dateStr:String) -> Void in
                let rightLabel = self.view.viewWithTag(601) as! UILabel
                rightLabel.text = dateStr
                self.date = dateStr
            }
        }
    }
    
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
        valueTag = textField.tag
        return true
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.view.endEditing(true)
        self.setSelfViewBoundsOriginY(0)
        return true
    }
    
    //监听键盘显示的方法实现
    func keyboardWillShow(notification: NSNotification!) {
        
        let keyboardSize = (notification.userInfo![UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.CGRectValue()
        UIView.animateWithDuration(0.25, animations: { () -> Void in
            var YOffset:CGFloat!
            if self.valueTag != nil {
                if self.valueTag >= 615 {
                    YOffset = (keyboardSize?.height)! - 49
                    self.setSelfViewBoundsOriginY(YOffset)
                }
            }
        })
    }
    
    func changeVehicleType() {
        let rightLabel = self.view.viewWithTag(600) as! UILabel
        rightLabel.text = UserDefault.objectForKey("brand")?.stringByAppendingString((UserDefault.objectForKey("model") as! String).stringByAppendingString(UserDefault.objectForKey("style") as! String))
        self.styleId = UserDefault.objectForKey("Value") as! String
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

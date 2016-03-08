//
//  ZGCAddConfigView.swift
//  Carcheck
//
//  Created by GaoCheng.Zou on 16/2/19.
//  Copyright © 2016年 GaoCheng.Zou. All rights reserved.
//

import UIKit
typealias SureOrCancelBlock = (attriArr:NSMutableArray) -> Void
typealias WarningContentIsEmptyBlock = (tag:Int) -> Void

class ZGCAddConfigView: UIView , UITextFieldDelegate {

    var sureOrCancelHandler: SureOrCancelBlock!
    var warningContentIsEmptyHander: WarningContentIsEmptyBlock!
    
    var backgroundView: UIView!
    var addConfigView: UIView!
    var addConfigTxtFieldTag: Int!
    var attriArr = NSMutableArray()

    init(frame: CGRect, contentArr:NSMutableArray) {
        super.init(frame: (KeyWindow?.frame)!)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:", name: "UIKeyboardWillShowNotification", object: nil)

        
        self.backgroundView = UIView.init(frame: (KeyWindow?.frame)!)
        self.backgroundView.backgroundColor = UIColor.blackColor()
        self.backgroundView.alpha = 0.5
        self.addSubview(self.backgroundView)
        
        let hiddenTap = UITapGestureRecognizer(target: self, action: "click:")
        self.backgroundView.addGestureRecognizer(hiddenTap)
        
        addConfigView = UIView.init(frame: CGRectMake(KScreenWidth, 0, KScreenWidth*3/4, KScreenWidth*3/4))
        addConfigView.backgroundColor = UIColor.whiteColor()
        addConfigView.center = CGPointMake(CGRectGetMidX((KeyWindow?.frame)!) + KScreenWidth, CGRectGetMidY((KeyWindow?.frame)!))
        addConfigView.userInteractionEnabled = true
        addConfigView.layer.cornerRadius = KScreenWidth/30
        self.addSubview(addConfigView)
        
        let preTitleArr = ["配置名称", "配置说明"] as NSArray
        let iconImgArr = ["config_setting", "config_text"]

        preTitleArr.enumerateObjectsUsingBlock { (object, index, stop) -> Void in
            let iconImg = UIImage(named: iconImgArr[index])
            let iconImgView = UIImageView(frame: CGRectMake(11, 11 + 79*CGFloat(index), (iconImg?.size.width)!, (iconImg?.size.height)!))
            iconImgView.image = iconImg
            self.addConfigView.addSubview(iconImgView)
            let titleLabel = UILabel(frame: CGRectMake(iconImgView.right + 11, iconImgView.top - 11, KScreenWidth/2 - 40, 40))
            titleLabel.text = preTitleArr[index] as? String
            titleLabel.font = UIFont.systemFontOfSize(14.0)
            self.addConfigView.addSubview(titleLabel)
            
            let rightTextField = UITextField.init(frame: CGRectMake(10, titleLabel.bottom, self.addConfigView.width - 20, 40))
            rightTextField.delegate = self
            rightTextField.borderStyle = UITextBorderStyle.None
            self.addConfigView.addSubview(rightTextField)
            rightTextField.textColor = UIColor.darkGrayColor()
            rightTextField.font = UIFont.systemFontOfSize(12.0)
            if contentArr.count > 0 {
                rightTextField.text = contentArr[index] as? String
            }
            rightTextField.tag = 555 + index
            rightTextField.returnKeyType = UIReturnKeyType.Done
        }
        
        for i in 0...3 {
            let horizontalLayer = CALayer()
            horizontalLayer.backgroundColor = CellBgColor.CGColor
            horizontalLayer.setNeedsDisplay()
            horizontalLayer.anchorPoint = CGPointZero
            addConfigView.layer.addSublayer(horizontalLayer)
            horizontalLayer.bounds = CGRectMake(0, 0, addConfigView.width, 0.5)
            horizontalLayer.position = CGPointMake(0, 40 + 40*CGFloat(i))
            
        }
        
        let addConfigButton:UIButton = UIButton(type: UIButtonType.Custom)
        addConfigButton.backgroundColor = ButtonBackGroundColor
        addConfigButton.setTitle("确定", forState:UIControlState.Normal)
        addConfigButton.layer.cornerRadius = 8.0
        addConfigButton.clipsToBounds = true
        addConfigButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        addConfigButton.titleLabel?.font = UIFont.systemFontOfSize(15.0)
        addConfigButton.frame = CGRectMake(addConfigView.width/3, addConfigView.height - 60,  addConfigView.width/3, 40)
        addConfigView.addSubview(addConfigButton)
        addConfigButton.addTarget(self, action: "btnAction:", forControlEvents: UIControlEvents.TouchUpInside)
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.endEditing(true)
        UIView.animateWithDuration(0.35) { () -> Void in
            self.addConfigView.center = CGPointMake(CGRectGetMidX((KeyWindow?.frame)!), CGRectGetMidY((KeyWindow?.frame)!))
        }
        return true
    }

    
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
        self.addConfigTxtFieldTag = textField.tag
        return true
    }
    
    func btnAction(btn:UIButton) {
        var isEmpty = false
        for i in 0...1 {
            let textField = addConfigView.viewWithTag(555 + i) as! UITextField
            if textField.text == "" {
                isEmpty = true
                warningContentIsEmptyHander(tag:textField.tag)
                return
            }
            attriArr.addObject(textField.text!)
        }
        if isEmpty == false {
            sureOrCancelHandler(attriArr: attriArr)
            self.dismiss()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func show () {
        KeyWindow?.addSubview(self)
        UIView.animateWithDuration(0.35) { () -> Void in
            self.addConfigView.center = CGPointMake(CGRectGetMidX((KeyWindow?.frame)!), CGRectGetMidY((KeyWindow?.frame)!))
        }
        
    }
    
    func click(tap:UITapGestureRecognizer) {
        self.dismiss()
    }
    
    func dismiss () {
        self.endEditing(true)
        
        UIView.animateWithDuration(0.35, animations: { () -> Void in
            self.alpha = 0.0
            self.addConfigView.center = CGPointMake(CGRectGetMidX((KeyWindow?.frame)!) + KScreenWidth, CGRectGetMidY((KeyWindow?.frame)!))
            }) { (finished) -> Void in
            self.removeFromSuperview()
        }
    }
    
    //监听键盘显示的方法实现
    func keyboardWillShow(notification: NSNotification!) {
        let keyboardSize = (notification.userInfo![UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.CGRectValue()
        UIView.animateWithDuration(0.35, animations: { () -> Void in
            if self.addConfigTxtFieldTag != nil {
                self.addConfigView.top = KScreenHeight - (keyboardSize?.height)! - 160
            }
            
            
        })
        
    }

}

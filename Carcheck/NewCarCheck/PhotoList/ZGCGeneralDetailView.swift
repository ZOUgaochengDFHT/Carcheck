//
//  ZGCGeneralDetailView.swift
//  Carcheck
//
//  Created by GaoCheng.Zou on 16/3/7.
//  Copyright © 2016年 GaoCheng.Zou. All rights reserved.
//

import UIKit

class ZGCGeneralDetailView: UIView, UITextViewDelegate {

    var sureOrCancelHandler: SureOrCancelBlock!
    var warningContentIsEmptyHander: WarningContentIsEmptyBlock!
    
    var backgroundView: UIView!
    var addConfigView: UIView!
    var addConfigTxtFieldTag: Int!
    var attriArr = NSMutableArray()
    
    init(frame: CGRect, content:String) {
        super.init(frame: (KeyWindow?.frame)!)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:", name: "UIKeyboardWillShowNotification", object: nil)
        
        
        self.backgroundView = UIView.init(frame: (KeyWindow?.frame)!)
        self.backgroundView.backgroundColor = UIColor.blackColor()
        self.backgroundView.alpha = 0.5
        self.addSubview(self.backgroundView)
        
        let hiddenTap = UITapGestureRecognizer(target: self, action: "click:")
        self.backgroundView.addGestureRecognizer(hiddenTap)
        
        addConfigView = UIView.init(frame: CGRectMake(KScreenWidth, 0, KScreenWidth*3/4, 180))
        addConfigView.backgroundColor = UIColor.whiteColor()
        addConfigView.center = CGPointMake(CGRectGetMidX((KeyWindow?.frame)!) + KScreenWidth, CGRectGetMidY((KeyWindow?.frame)!))
        addConfigView.userInteractionEnabled = true
        addConfigView.layer.cornerRadius = KScreenWidth/30
        self.addSubview(addConfigView)
        
        
        let iconImg = UIImage(named: "config_text")
        let iconImgView = UIImageView(frame: CGRectMake(11, 11, (iconImg?.size.width)!, (iconImg?.size.height)!))
        iconImgView.image = iconImg
        self.addConfigView.addSubview(iconImgView)
        let titleLabel = UILabel(frame: CGRectMake(iconImgView.right + 11, iconImgView.top - 11, KScreenWidth/2 - 40, 40))
        titleLabel.text = "概况说明"
        titleLabel.font = UIFont.systemFontOfSize(14.0)
        self.addConfigView.addSubview(titleLabel)
        
        let rightTextView = UITextView.init(frame: CGRectMake(10, titleLabel.bottom, self.addConfigView.width - 20, 80))
        rightTextView.delegate = self
        self.addConfigView.addSubview(rightTextView)
        rightTextView.textColor = UIColor.darkGrayColor()
        rightTextView.text = content
        rightTextView.font = UIFont.systemFontOfSize(12.0)
        rightTextView.tag = 555
        rightTextView.returnKeyType = UIReturnKeyType.Done
        
        for i in 0...1 {
            let horizontalLayer = CALayer()
            horizontalLayer.backgroundColor = CellBgColor.CGColor
            horizontalLayer.setNeedsDisplay()
            horizontalLayer.anchorPoint = CGPointZero
            addConfigView.layer.addSublayer(horizontalLayer)
            horizontalLayer.bounds = CGRectMake(0, 0, addConfigView.width, 0.5)
            horizontalLayer.position = CGPointMake(0, 40 + 80*CGFloat(i))
        }
        
        let addConfigButton:UIButton = UIButton(type: UIButtonType.Custom)
        addConfigButton.backgroundColor = ButtonBackGroundColor
        addConfigButton.setTitle("确定", forState:UIControlState.Normal)
        addConfigButton.layer.cornerRadius = 8.0
        addConfigButton.clipsToBounds = true
        addConfigButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        addConfigButton.titleLabel?.font = UIFont.systemFontOfSize(15.0)
        addConfigButton.frame = CGRectMake(addConfigView.width/3, rightTextView.bottom + 10,  addConfigView.width/3, 40)
        addConfigView.addSubview(addConfigButton)
        addConfigButton.addTarget(self, action: "btnAction:", forControlEvents: UIControlEvents.TouchUpInside)
    }
    
    //监听完成按钮,实现done键完成隐藏
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            self.endEditing(true)
            UIView.animateWithDuration(0.35) { () -> Void in
                self.addConfigView.center = CGPointMake(CGRectGetMidX((KeyWindow?.frame)!), CGRectGetMidY((KeyWindow?.frame)!))
            }
        }
        return true
    }
    
    
    func textViewShouldBeginEditing(textView: UITextView) -> Bool {
        self.addConfigTxtFieldTag = textView.tag
        return true
    }
    
    func btnAction(btn:UIButton) {
        let textView = addConfigView.viewWithTag(555) as! UITextView
        attriArr.addObject(textView.text)
        sureOrCancelHandler(attriArr: attriArr)
        self.dismiss()
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
                self.addConfigView.top = KScreenHeight - (keyboardSize?.height)! - 120
            }
            
            
        })
        
    }

}

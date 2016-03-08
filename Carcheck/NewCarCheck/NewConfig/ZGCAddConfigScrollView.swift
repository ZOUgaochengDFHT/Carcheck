//
//  ZGCAddConfigScrollView.swift
//  Carcheck
//
//  Created by GaoCheng.Zou on 16/2/19.
//  Copyright © 2016年 GaoCheng.Zou. All rights reserved.
//

import UIKit

typealias TapNextToTakesPhotosVCBlock = () -> Void
typealias TapToBaseVehicleConfigVCBlock = () -> Void
typealias TakesPhotosHiddenTabbarBlock = (hidden:Bool) -> Void

class ZGCAddConfigScrollView: UIScrollView {

    var mAttriArr = NSMutableArray()
    var imagePicker: HImagePickerUtils!
    var deleteButton: UIButton!
    var takesPicButton: UIButton!
    var target: AnyObject!
    var picturesArr = NSMutableArray()
    var nextBtn: UIButton!
    var tapToTakesPhotosHandler: TapNextToTakesPhotosVCBlock!
    var takesPhotosHiddenTabbarHandler: TakesPhotosHiddenTabbarBlock!
    var tapToBaseVehicleConfigVCHandler: TapToBaseVehicleConfigVCBlock!
    
    var isCreateNew = true
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        
        
        
        let addConfigButton:UIButton = UIButton(type: UIButtonType.Custom)
        addConfigButton.backgroundColor = ButtonBackGroundColor
        addConfigButton.setTitle("新增配置", forState:UIControlState.Normal)
        addConfigButton.layer.borderColor = kBorderColor.CGColor;
        addConfigButton.layer.borderWidth = 0.5
        addConfigButton.layer.cornerRadius = 8.0
        addConfigButton.clipsToBounds = true
        addConfigButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        addConfigButton.titleLabel?.font = UIFont.systemFontOfSize(15.0)
        addConfigButton.frame = CGRectMake(40 + (KScreenWidth - 60)/2, 20, (KScreenWidth - 60)/2, 30)
        self.addSubview(addConfigButton)
        addConfigButton.tag = 101
        addConfigButton.addTarget(self, action: "btnAction:", forControlEvents: UIControlEvents.TouchUpInside)
        

        
//        deleteButton = UIButton(type: UIButtonType.Custom)
//        deleteButton.backgroundColor = ButtonBackGroundColor
//        deleteButton.setTitle("删除", forState:UIControlState.Normal)
//        deleteButton.layer.borderColor = kBorderColor.CGColor;
//        deleteButton.layer.borderWidth = 0.5
//        deleteButton.layer.cornerRadius = 8.0
//        deleteButton.clipsToBounds = true
//        deleteButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
//        deleteButton.titleLabel?.font = UIFont.systemFontOfSize(15.0)
//        deleteButton.frame = CGRectMake(20, 70, KScreenWidth/4, 30)
//        self.addSubview(deleteButton)
//        deleteButton.tag = 102
//        deleteButton.addTarget(self, action: "btnAction:", forControlEvents: UIControlEvents.TouchUpInside)
//        
//        takesPicButton = UIButton(type: UIButtonType.Custom)
//        takesPicButton.backgroundColor = ButtonBackGroundColor
//        takesPicButton.setTitle("拍照", forState:UIControlState.Normal)
//        takesPicButton.layer.borderColor = kBorderColor.CGColor;
//        takesPicButton.layer.borderWidth = 0.5
//        takesPicButton.layer.cornerRadius = 8.0
//        takesPicButton.clipsToBounds = true
//        takesPicButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
//        takesPicButton.titleLabel?.font = UIFont.systemFontOfSize(15.0)
//        takesPicButton.frame = CGRectMake(deleteButton.right + 10, 70, (KScreenWidth*3/4 - 50), 30)
//        self.addSubview(takesPicButton)
//        takesPicButton.tag = 103
//        takesPicButton.addTarget(self, action: "btnAction:", forControlEvents: UIControlEvents.TouchUpInside)
    }
    
    func btnAction(btn:UIButton) {
        if btn.tag == 99 {
            tapToBaseVehicleConfigVCHandler()
        }else if btn.tag == 100 {
            tapToTakesPhotosHandler()
        } else if btn.tag == 101 {
//            let addConfigView = ZGCAddConfigView.init(frame: CGRectMake(KScreenWidth, 10, KScreenWidth, frame.size.height - 60))
//            addConfigView.show()
//
//            btn.enabled = false
//            addConfigView.sureOrCancelHandler = {
//                (attriArr:NSArray, tag:Int) -> Void in
//                btn.enabled = true
//                UIView.animateWithDuration(0.35, animations: { () -> Void in
//                    addConfigView.left = KScreenWidth
//                    }, completion: { (finished) -> Void in
//                        addConfigView.removeFromSuperview()
//                })
//                // - MARK - 确定
//                if tag == 201 {
//                    self.mAttriArr.addObject(attriArr)
//                    UserDefault.setObject(NSArray(object: self.mAttriArr), forKey: "newVehicleConfigArr")
//                    UserDefault.synchronize()
//                    self.initNewConfigList()
//                    
//                    if self.isCreateNew == true {
//                        UserDefault.setObject("one", forKey: "sqlName")
//                        UserDefault.synchronize()
//                        let configDBManager =  ZGCConfigDBManager.shareInstance()
//                        let config = Config(name: attriArr[0] as? String, instruction: attriArr[1] as? String)
//                        configDBManager.addConfig(config)
//                        
//                        print(((configDBManager.selectConfigs() as NSArray).lastObject as! Config).name)
//
//                        
//                    }
//                    
//                }
//            }
        } else if btn.tag == 102 {
            
        } else if btn.tag == 103 {
            takesPhotosHiddenTabbarHandler(hidden:true)
            /// 拍照
            imagePicker = HImagePickerUtils()// HImagePickerUtils 对象必须为全局变量，不然UIImagePickerController代理方法不会执行
            imagePicker.pickPhotoEnd = {a,b,c in
                self.takesPhotosHiddenTabbarHandler(hidden:false)

                if b == HTakeStatus.Success {
                    self.picturesArr.addObject(a!)
                    
                    let copyPicArr = NSMutableArray(capacity: self.picturesArr.count)
                    copyPicArr.enumerateObjectsUsingBlock({ (object, index, stop) -> Void in
                        copyPicArr.addObject(object)
                    })
                    UserDefault.setObject(NSArray(object: copyPicArr), forKey: "newVehicleConfigPicArr")
                    UserDefault.synchronize()
                    
                    var i = 0
                    var j = 0
                    var k = 0
                    self.picturesArr.enumerateObjectsUsingBlock({ (object, index, stop) -> Void in
                        k = index
                        if index % 3 == 0 && index != 0 {
                            i = 0
                            j++
                        }
                        i = i + 1
                    })
                    
                    let iconImgButton = UIButton.init(frame: CGRectMake(10 + ((KScreenWidth - 40)/3 + 10) * CGFloat(i - 1),  CGFloat(self.mAttriArr.count + 1) * 30.5 + 80 + (((KScreenWidth - 40)*2/9) + 10) * CGFloat(j), (KScreenWidth - 40)/3, (KScreenWidth - 40)*2/9))
                    iconImgButton.setImage(self.picturesArr.lastObject as? UIImage, forState: UIControlState.Normal)
                    iconImgButton.tag = 5000 + self.picturesArr.count - 1
                    iconImgButton.addTarget(self, action: "btnAction:", forControlEvents: UIControlEvents.TouchUpInside)
                    self.addSubview(iconImgButton)
                    if self.picturesArr.count - 1 == k {
                        self.deleteButton.top = iconImgButton.bottom + 20
                        self.takesPicButton.top = self.deleteButton.top
                    }
                    
                    self.contentSize = CGSizeMake(KScreenWidth, self.deleteButton.bottom + 100)
                    self.nextBtn.top = self.deleteButton.bottom + 30
                }
            }
            
            imagePicker.takePhoto(target as! UIViewController)
        } else if btn.tag >= 200  && btn.tag < 5000{
            btn.selected = !btn.selected
            var tag = 1
            if btn.tag % 100 == 1 {
                tag = -1
            }
            let button = self.viewWithTag(btn.tag + tag) as! UIButton
            button.selected = btn.selected
            if btn.selected == true {
                btn.backgroundColor = ButtonBackGroundColor
                button.backgroundColor = ButtonBackGroundColor
            }else {
                btn.backgroundColor = UIColor.clearColor()
                button.backgroundColor = UIColor.clearColor()
            }
        }else {
            btn.selected = !btn.selected
            if btn.selected == true {
                btn.layer.borderColor = ButtonBackGroundColor.CGColor
                btn.layer.borderWidth = 0.5
            }else {
                btn.layer.borderColor = UIColor.clearColor().CGColor
            }
            btn.clipsToBounds = true
        }
        
        
    }
    
    func initNewConfigList () {
        if self.mAttriArr.count == 1 {
            let preTitleArr = ["配置名称", "配置说明"] as NSArray
            preTitleArr.enumerateObjectsUsingBlock { (object, index, stop) -> Void in
                let preTitleLabel = UILabel()
                preTitleLabel.frame = CGRectMake(20 + (KScreenWidth - 40)/2 * CGFloat(index) , 60, (KScreenWidth - 40)/2 , 30)
                preTitleLabel.font = UIFont.systemFontOfSize(13.0)
                preTitleLabel.backgroundColor = UIColor.clearColor()
                preTitleLabel.textAlignment = NSTextAlignment.Center
                preTitleLabel.textColor = UIColor.darkGrayColor()
                preTitleLabel.text = preTitleArr[index] as? String
                self.addSubview(preTitleLabel)
                
                let conButton = UIButton(type: UIButtonType.Custom)
                conButton.backgroundColor = UIColor.clearColor()
                conButton.titleLabel?.font = UIFont.systemFontOfSize(12.0)
                conButton.setTitleColor(UIColor.darkGrayColor(), forState: UIControlState.Normal)
                conButton.frame = CGRectMake(20 + (KScreenWidth - 40)/2 * CGFloat(index) , 90, (KScreenWidth - 40)/2 , 30)
                conButton.tag = (self.mAttriArr.count + 1)*100 + index
                let arr = self.mAttriArr.lastObject as! NSArray
                conButton.setTitle(arr[index] as? String, forState: UIControlState.Normal)
                self.addSubview(conButton)
                conButton.addTarget(self, action: "btnAction:", forControlEvents: UIControlEvents.TouchUpInside)

            }
            
            for var i = 0; i < 3; i++ {
                let horizontalLayer = CALayer()
                horizontalLayer.backgroundColor = UIColor.grayColor().CGColor
                horizontalLayer.setNeedsDisplay()
                horizontalLayer.anchorPoint = CGPointZero
                self.layer.addSublayer(horizontalLayer)
                horizontalLayer.bounds = CGRectMake(0, 0, KScreenWidth - 40, 0.5)
                horizontalLayer.position = CGPointMake(20, 60 + 30*CGFloat(i))

            }

            for var i = 0; i < 3; i++ {
                let verticalLayer = CALayer()
                verticalLayer.backgroundColor = UIColor.grayColor().CGColor
                verticalLayer.setNeedsDisplay()
                verticalLayer.anchorPoint = CGPointZero
                self.layer.addSublayer(verticalLayer)
                verticalLayer.bounds = CGRectMake(0, 0, 0.5, 60)
                verticalLayer.position = CGPointMake(20 + ((KScreenWidth - 40)/2)*CGFloat(i), 60)
            }
            
        }else {
            
            (self.mAttriArr.lastObject as! NSArray).enumerateObjectsUsingBlock({ (object, index, stop) -> Void in
                let conButton = UIButton(type: UIButtonType.Custom)
                conButton.backgroundColor = UIColor.clearColor()
                conButton.titleLabel?.font = UIFont.systemFontOfSize(12.0)
                conButton.setTitleColor(UIColor.darkGrayColor(), forState: UIControlState.Normal)
                conButton.frame = CGRectMake(20 + (KScreenWidth - 40)/2 * CGFloat(index) , 60 + 30*CGFloat(self.mAttriArr.count), (KScreenWidth - 40)/2 , 30)
                let arr = self.mAttriArr.lastObject as! NSArray
                conButton.setTitle(arr[index] as? String, forState: UIControlState.Normal)
                self.addSubview(conButton)
                conButton.tag = (self.mAttriArr.count + 1)*100 + index
                conButton.addTarget(self, action: "btnAction:", forControlEvents: UIControlEvents.TouchUpInside)
                
            })
            
            let horizontalLayer = CALayer()
            horizontalLayer.backgroundColor = UIColor.grayColor().CGColor
            horizontalLayer.setNeedsDisplay()
            horizontalLayer.anchorPoint = CGPointZero
            self.layer.addSublayer(horizontalLayer)
            horizontalLayer.bounds = CGRectMake(0, 0, KScreenWidth - 40, 0.5)
            horizontalLayer.position = CGPointMake(20, 60 + 30*CGFloat(self.mAttriArr.count + 1))
            
            
            for var i = 0; i < 3; i++ {
                let verticalLayer = CALayer()
                verticalLayer.backgroundColor = UIColor.grayColor().CGColor
                verticalLayer.setNeedsDisplay()
                verticalLayer.anchorPoint = CGPointZero
                self.layer.addSublayer(verticalLayer)
                verticalLayer.bounds = CGRectMake(0, 0, 0.5, 30)
                verticalLayer.position = CGPointMake(20 + ((KScreenWidth - 40)/2)*CGFloat(i), 60 + 30*CGFloat(self.mAttriArr.count))
            }


        }
        
        self.deleteButton.top = CGFloat(self.mAttriArr.count + 1) * 30.5 + 80
        self.takesPicButton.top = self.deleteButton.top
        
        /**
        *  调整照片的位置
        */
        if self.picturesArr.count > 0 {
            var j = 0
            self.picturesArr.enumerateObjectsUsingBlock({ (object, index, stop) -> Void in
                if index % 3 == 0 && index != 0 {
                    j++
                }
                let iconImgButton = self.viewWithTag(index + 5000) as! UIButton
                iconImgButton.top = CGFloat(self.mAttriArr.count + 1) * 30.5 + 80 + (((KScreenWidth - 40)*2/9) + 10) * CGFloat(j)
                if index == self.picturesArr.count - 1 {
                    self.deleteButton.top = iconImgButton.bottom + 20
                    self.takesPicButton.top = self.deleteButton.top
                }
            })
        }
        
        self.contentSize = CGSizeMake(KScreenWidth, self.deleteButton.bottom + 100)
        self.nextBtn.top = self.deleteButton.bottom + 30

    }
    
    func initNextButtton () {
        nextBtn = UIButton(type: UIButtonType.Custom)
        nextBtn.backgroundColor = ButtonBackGroundColor
        nextBtn.setTitle("下一步", forState:UIControlState.Normal)
        nextBtn.layer.borderColor = kBorderColor.CGColor;
        nextBtn.layer.borderWidth = 0.5
        nextBtn.layer.cornerRadius = 8.0
        nextBtn.clipsToBounds = true
        nextBtn.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        nextBtn.titleLabel?.font = UIFont.systemFontOfSize(15.0)
        nextBtn.frame = CGRectMake(20, self.deleteButton.bottom + 30, KScreenWidth - 40, 40)
        self.addSubview(nextBtn)
        nextBtn.tag = 100
        nextBtn.addTarget(self, action: "btnAction:", forControlEvents: UIControlEvents.TouchUpInside)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }


}

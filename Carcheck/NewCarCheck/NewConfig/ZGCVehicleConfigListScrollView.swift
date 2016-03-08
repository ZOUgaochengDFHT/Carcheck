//
//  ZGCVehicleConfigListScrollView.swift
//  Carcheck
//
//  Created by GaoCheng.Zou on 16/2/19.
//  Copyright © 2016年 GaoCheng.Zou. All rights reserved.
//

import UIKit

typealias TapSelectedItemBlock = (vehiclePreTitleArr:NSArray, vehicleConTitleArr:NSArray) -> Void
typealias TapToTakesPhotosVCBlock = () -> Void
class ZGCVehicleConfigListScrollView: UIScrollView {
    
    var tapSelectedItemHandler: TapSelectedItemBlock!
    var tapToTakesPhotosHandler: TapToTakesPhotosVCBlock!

    let preTitleArr = ["底盘转向", "安全装备", "操控配置", "外部配置", "内部配置", "座椅配置"] as NSArray
    /*, "多媒体配置", "灯光配置", "玻璃/后视镜", "空调/冰箱", "高科技配置", "随车工具"*/
    let conArr = [[["value":"液压助力", "isOn":"0"], ["value":"电动助力", "isOn":"0"]], [["value":"主驾驶安全气囊", "isOn":"0"], ["value":"副驾驶安全气囊", "isOn":"0"], ["value":"侧气囊", "isOn":"0"], ["value":"气帘", "isOn":"0"], ["value":"膝部气囊", "isOn":"0"], ["value":"遥控钥匙", "isOn":"0"], ["value":"无钥匙启动", "isOn":"0"], ["value":"胎压报警", "isOn":"0"]], [["value":"防抱死制动系统", "isOn":"0"], ["value":"制动力分配", "isOn":"0"], ["value":"牵引力控制系统", "isOn":"0"], ["value":"车身稳定控制系统", "isOn":"0"], ["value":"自动驻车/上坡辅助", "isOn":"0"], ["value":"陡坡缓降", "isOn":"0"], ["value":"可变悬挂", "isOn":"0"]], [["value":"普通天窗", "isOn":"0"], ["value":"全景天窗", "isOn":"0"],["value":"玻璃顶", "isOn":"0"]],  [["value":"多方向功能盘", "isOn":"0"], ["value":"定速巡航", "isOn":"0"],["value":"主动巡航", "isOn":"0"], ["value":"倒车雷达", "isOn":"0"], ["value":"倒车影像", "isOn":"0"],["value":"行车电脑显示屏", "isOn":"0"], ["value":"HUD抬头数字显示", "isOn":"0"]],[["value":"真皮座椅", "isOn":"0"], ["value":"座椅加热", "isOn":"0"],["value":"座椅通风", "isOn":"0"], ["value":"座椅记忆", "isOn":"0"]]] as NSMutableArray
    /*,["GPS导航系统", "蓝牙车载电话","车载电视", "内置硬盘", "收音机","CD/DVD", "中控台彩色大屏"],["疝气大灯", "随动大灯"],["前电动/后手动", "手动摇窗","电动车窗", "后视镜电动折叠", "感应雨刷"],["手动空调", "自动空调","车载冰箱"],["自动泊车", "并线辅助","车道偏离预警", "全景摄像头", "夜视系统"],["备胎", "千斤顶","三脚架"]*/
    override init(frame: CGRect) {
        super.init(frame: frame)
        
       
        
        var count = 0
        conArr.enumerateObjectsUsingBlock { (object, index, stop) -> Void in
            
            let preTitleLabel = UILabel()
            preTitleLabel.frame = CGRectMake(0 , 20 + 30.5*CGFloat(count), 90, 30.5)
            preTitleLabel.font = UIFont.systemFontOfSize(13.0)
            preTitleLabel.backgroundColor = UIColor.clearColor()
            preTitleLabel.textAlignment = NSTextAlignment.Right
            preTitleLabel.textColor = UIColor.darkGrayColor()
            preTitleLabel.text = self.preTitleArr[index] as? String
            self.addSubview(preTitleLabel)
            
            let arr = object as! NSArray
            
            
            var j = 0
            var k = 0;
            for var i = 0; i < arr.count; i++ {
                if i != 0 && i % 2 == 0 {
                    j++
                    k = 0
                }
                
                let conButton = UIButton(type: UIButtonType.Custom)
                conButton.backgroundColor = UIColor.whiteColor()
                conButton.titleLabel?.font = UIFont.systemFontOfSize(12.0)
                conButton.setTitleColor(UIColor.darkGrayColor(), forState: UIControlState.Normal)
                conButton.frame = CGRectMake(100 + ((KScreenWidth - 120)/2)*CGFloat(k), 20.5 + 30.5*CGFloat(j + count), (KScreenWidth - 120)/2, 30)
                conButton.setTitle(arr[i].objectForKey("value") as? String, forState: UIControlState.Normal)
                self.addSubview(conButton)
                conButton.addTarget(self, action: "btnAction:", forControlEvents: UIControlEvents.TouchUpInside)
                
                k = k + 1
            }
            
            
            if arr.count % 2 == 0 {
                count = count + arr.count / 2
            }else {
                count = count + arr.count / 2 + 1
            }
            
         
        }
        
        
        for var i = 0; i < count + 1; i++ {
            let horizontalLayer = CALayer()
            horizontalLayer.backgroundColor = UIColor.grayColor().CGColor
            horizontalLayer.setNeedsDisplay()
            horizontalLayer.anchorPoint = CGPointZero
            self.layer.addSublayer(horizontalLayer)
            horizontalLayer.bounds = CGRectMake(0, 0, KScreenWidth - 120, 0.5)
            horizontalLayer.position = CGPointMake(100, 20 + 30.5*CGFloat(i))
            
        }
        
        for var i = 0; i < 3; i++ {
            let verticalLayer = CALayer()
            verticalLayer.backgroundColor = UIColor.grayColor().CGColor
            verticalLayer.setNeedsDisplay()
            verticalLayer.anchorPoint = CGPointZero
            self.layer.addSublayer(verticalLayer)
            verticalLayer.bounds = CGRectMake(0, 0, 0.5, CGFloat(count)*30.5)
            verticalLayer.position = CGPointMake(100 + ((KScreenWidth - 120)/2)*CGFloat(i), 20)
        }
        
        self.contentSize = CGSizeMake(KScreenWidth, CGFloat(count) * 30.5 + 100)
        
        let nextBtn:UIButton = UIButton(type: UIButtonType.Custom)
        nextBtn.backgroundColor = ButtonBackGroundColor
        nextBtn.setTitle("下一步", forState:UIControlState.Normal)
        nextBtn.layer.borderColor = kBorderColor.CGColor;
        nextBtn.layer.borderWidth = 0.5
        nextBtn.layer.cornerRadius = 8.0
        nextBtn.clipsToBounds = true
        nextBtn.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        nextBtn.titleLabel?.font = UIFont.systemFontOfSize(15.0)
        nextBtn.frame = CGRectMake(20, self.contentSize.height - 50, KScreenWidth - 40, 40)
        self.addSubview(nextBtn)
        nextBtn.tag = 100
        nextBtn.addTarget(self, action: "btnAction:", forControlEvents: UIControlEvents.TouchUpInside)

    }
    
    func btnAction(btn:UIButton) {
        if btn.tag == 100 {
            tapToTakesPhotosHandler()
        }else {
            UserDefault.setObject(preTitleArr, forKey: "vehiclePreTitleArr")
            UserDefault.synchronize()
            UserDefault
            btn.selected = !btn.selected
            if btn.selected == true {
                btn.backgroundColor = ButtonBackGroundColor
            }else {
                btn.backgroundColor = UIColor.whiteColor()
            }
            
            let mConArr = conArr.mutableCopy()
            
            let btnTitle = NSString(string: (btn.titleLabel?.text!)!)
            
            var mArr = NSMutableArray()
            var selectedIndex: Int!
            
            
            mConArr.enumerateObjectsUsingBlock( { (object: AnyObject!, idx: Int, stop: UnsafeMutablePointer<ObjCBool>) -> Void in
                let shouldStop: ObjCBool = true
                
                let arr = object as! NSArray
                mArr = NSMutableArray(array: arr)
                let theIndex = idx
                
                
                arr.enumerateObjectsUsingBlock( { (object: AnyObject!, idx: Int, stop: UnsafeMutablePointer<ObjCBool>) -> Void in
                    let shouldStop: ObjCBool = true
                    var dic = object
                    
                    if btnTitle == NSString(string: object.objectForKey("value") as! String) {
                        selectedIndex = theIndex
                        var isOn = "0"
                        if btn.selected == true {
                            isOn = "1"
                        }
                        dic = ["value":btnTitle, "isOn":isOn]
                        mArr.replaceObjectAtIndex(idx, withObject: dic)
                        stop.initialize(shouldStop)
                    }
                    
                })
                
                if selectedIndex != nil {
                    stop.initialize(shouldStop)
                }
               
            })
            
            self.conArr.replaceObjectAtIndex(selectedIndex, withObject: mArr)
            UserDefault.setObject(preTitleArr, forKey: "vehicleConfigPreTitleArr")
            UserDefault.setObject(NSArray(object: conArr), forKey: "vehicleConfigConTitleArr")
            UserDefault.synchronize()
        }

    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }


}

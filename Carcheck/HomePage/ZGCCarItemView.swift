//
//  ZGCCarItemView.swift
//  Carcheck
//
//  Created by GaoCheng.Zou on 16/2/26.
//  Copyright © 2016年 GaoCheng.Zou. All rights reserved.
//

import UIKit

typealias DidClickButtonAtIndexBlock = (String) -> Void
typealias DidClickHiddenBlock = () -> Void
class ZGCCarItemView: UIView {

    var carItemView:UIImageView!
    var backgroundView:UIView!
    
    var didClickButtonAtIndexHandler:DidClickButtonAtIndexBlock!
    var didClickHiddenBlockHandler:DidClickHiddenBlock!

    let bgImg = UIImage(named: "item_bg")
    var bgImgWidth:CGFloat!
    var bgImgHeight:CGFloat!

    var rightTextField: UITextField!

    let underlineArr = [["img":"item_notupload", "title":"未上传车检"], ["img":"item_toaudit", "title":"待审核车检"], ["img":"item_unpass", "title":"未通过车检"], ["img":"item_pass", "title":"已通过车检"], ["img":"item_newadd", "title":"新增车检"], ["img":"item_carvaluation", "title":"车辆估值"]] as NSArray
    
    override init(frame: CGRect) {
        super.init(frame: (UIApplication.sharedApplication().keyWindow?.frame)!)
        bgImgWidth = bgImg!.size.width
        bgImgHeight = bgImg!.size.height
        self.setUp()
    }
    
    func setUp() {
        /**
        *@背景
        */
        
        self.backgroundView = UIView.init(frame: (UIApplication.sharedApplication().keyWindow?.frame)!)
        self.backgroundView.backgroundColor = UIColor.blackColor()
        self.backgroundView.alpha = 0.5
        self.addSubview(self.backgroundView)
        
        let hiddenTap = UITapGestureRecognizer(target: self, action: "click:")
        self.backgroundView.addGestureRecognizer(hiddenTap)
        
        
        self.carItemView = UIImageView(frame: CGRectMake((KScreenWidth - bgImgWidth)/2, KScreenHeight, bgImgWidth, bgImgHeight))
        //        let keyWindow = UIApplication.sharedApplication().keyWindow
        //        self.carItemView.center = CGPointMake(CGRectGetMidX((keyWindow?.frame)!), -CGRectGetMidY((keyWindow?.frame)!))
        self.carItemView.image = bgImg
        self.carItemView.userInteractionEnabled = true
        self.addSubview(self.carItemView)
        
        var i = 0
        var j = 0
        
        underlineArr.enumerateObjectsUsingBlock { (object, index, stop) -> Void in
            
            if index % 3 == 0 && index != 0{
                j = j + 1
                i = 0
            }
            
            let bgView = UIView(frame: CGRectMake((self.bgImgWidth/3)*CGFloat(i), ((self.bgImgHeight-10)/2)*CGFloat(j), self.bgImgWidth/3, (self.bgImgHeight-10)/2))
            bgView.tag = 100 + index
            self.carItemView.addSubview(bgView)
            
            let tap = UITapGestureRecognizer(target: self, action: "clickTap:")
            bgView.addGestureRecognizer(tap)
            
            let underlineDic = object
            let iconImg = UIImage(named: underlineDic.objectForKey("img") as! String)
            
            let iconImgWidth = iconImg?.size.width
            let iconImgHeight = iconImg?.size.height
            
            
            let iconImgView:UIImageView = UIImageView()
            iconImgView.frame = CGRectMake((bgView.width - iconImgWidth!)/2, 20, iconImgWidth!, iconImgHeight!)
            iconImgView.userInteractionEnabled = true
            bgView.addSubview(iconImgView)
            iconImgView.image = iconImg
            
            let txtLabel = UILabel.init(frame: CGRectMake(0, iconImgView.bottom, bgView.width, bgView.height - iconImgView.height - 20))
            txtLabel.font = UIFont.systemFontOfSize(10.0)
            txtLabel.textAlignment = NSTextAlignment.Center
            txtLabel.text = underlineDic.objectForKey("title") as? String
            bgView.addSubview(txtLabel);
            
            i = i + 1
        }
    }
    
    func clickTap(tap:UITapGestureRecognizer) {
        didClickButtonAtIndexHandler(String(tap.view!.tag))
        self.dismiss()
    }
    
    func show () {
        let keywindow = UIApplication.sharedApplication().keyWindow
        keywindow?.addSubview(self)
        UIView.animateWithDuration(0.25) { () -> Void in
            self.carItemView.top = KScreenHeight - (self.bgImg?.size.height)! - 49
        }
        
    }
    
    func dismiss () {
        UIView.animateWithDuration(0.25) { () -> Void in
            self.alpha = 0.0
            self.carItemView.top = KScreenHeight
        }
    }
    
    func click(tap:UITapGestureRecognizer) {
        didClickHiddenBlockHandler()
        self.dismiss()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

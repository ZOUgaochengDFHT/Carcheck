//
//  ZGCVehicleConfigDetailScrollView.swift
//  Carcheck
//
//  Created by GaoCheng.Zou on 16/2/22.
//  Copyright © 2016年 GaoCheng.Zou. All rights reserved.
//

import UIKit

typealias ClickBtnToBaseConfigVCBlock = () -> Void
class ZGCVehicleConfigDetailScrollView: UIScrollView {

    var toBaseConfigVCHandler: ClickBtnToBaseConfigVCBlock!
    
    init(frame: CGRect, tar:AnyObject, sel:Selector) {
        super.init(frame: frame)
                
        
        let mPreArr = NSMutableArray()
        let conArr = NSMutableArray()
        
        mPreArr.addObject("配置名称")
        conArr.addObject("配置说明")
        
        (ZGCConfigDBManager().selectConfigs() as NSArray).enumerateObjectsUsingBlock { (object, index, stop) -> Void in
            let config = object as! Config
            mPreArr.addObject(config.name!)
            conArr.addObject(config.instruction!)
        }
        
        let editImg = UIImage(named: "detail_edit")
        
        let bgView = UIView(frame: CGRectMake(KScreenWidth - 60, 0, 60, 40))
        self.addSubview(bgView)
        bgView.tag = 778
        
        var editImgView = UIImageView()
        editImgView = UIImageView(frame: CGRectMake(bgView.width - (editImg?.size.width)! - 20, (bgView.height - (editImg?.size.height)!)/2, (editImg?.size.width)!, (editImg?.size.height)!))
        editImgView.image = editImg
        editImgView.userInteractionEnabled = true
        bgView.addSubview(editImgView)
        
        let editTap = UITapGestureRecognizer(target: tar, action:sel)
        bgView.addGestureRecognizer(editTap)
        
        if mPreArr.count > 1 {
            mPreArr.enumerateObjectsUsingBlock { (object, index, stop) -> Void in
                
                let preTitleLabel = UILabel()
                preTitleLabel.frame = CGRectMake(0 , 40 + 40*CGFloat(index), KScreenWidth/3, 40)
                preTitleLabel.font = UIFont.systemFontOfSize(13.0)
                
                var color = UIColor(red: 235/255.0, green: 235/255.0, blue: 235/255.0, alpha: 1.0)
                if index % 2 != 0 {
                    color = UIColor(red: 245/255.0, green: 246/255.0, blue: 246/255.0, alpha: 1.0)
                }
                
                preTitleLabel.backgroundColor = color
                preTitleLabel.textAlignment = NSTextAlignment.Center
                preTitleLabel.textColor = UIColor.darkGrayColor()
                preTitleLabel.text = mPreArr[index] as? String
                self.addSubview(preTitleLabel)
                
                
                
                
                
                let contentLabel = UILabel()
                contentLabel.frame = CGRectMake(preTitleLabel.right , preTitleLabel.top, KScreenWidth*2/3, 40)
                contentLabel.font = UIFont.systemFontOfSize(13.0)
                contentLabel.textAlignment = NSTextAlignment.Center
                var color1 = UIColor(red: 245/255.0, green: 246/255.0, blue: 246/255.0, alpha: 1.0)
                if index % 2 != 0 {
                    color1 = UIColor.whiteColor()
                }
                contentLabel.backgroundColor = color1
                contentLabel.numberOfLines = 0
                contentLabel.textColor = UIColor.darkGrayColor()
                contentLabel.text = conArr[index] as? String
                self.addSubview(contentLabel)
            }

        }
        
        let checkBaseConfigButton:UIButton = UIButton(type: UIButtonType.Custom)
        checkBaseConfigButton.backgroundColor = ButtonBackGroundColor
        checkBaseConfigButton.setTitle("查看基础配置", forState:UIControlState.Normal)
        checkBaseConfigButton.layer.cornerRadius = 8.0
        checkBaseConfigButton.clipsToBounds = true
        checkBaseConfigButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        checkBaseConfigButton.titleLabel?.font = UIFont.systemFontOfSize(15.0)
        checkBaseConfigButton.frame = CGRectMake(KScreenWidth/8, 40 + 40*CGFloat(mPreArr.count + 1), KScreenWidth*3/4, 40)
        checkBaseConfigButton.tag = 99
        checkBaseConfigButton.addTarget(self, action: "btnAction:", forControlEvents: UIControlEvents.TouchUpInside)
        self.addSubview(checkBaseConfigButton)
    }
    
    func btnAction(btn:UIButton) {
        toBaseConfigVCHandler()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

//
//  ZGCPhotoListBarView.swift
//  Carcheck
//
//  Created by GaoCheng.Zou on 16/3/4.
//  Copyright © 2016年 GaoCheng.Zou. All rights reserved.
//

import UIKit

class ZGCPhotoListBarView: UIView {
    
    var imgNameArr:NSArray!
    
    init(frame: CGRect, target: AnyObject, sel:Selector, imgNameArr:NSArray, tapArr:NSArray) {
        super.init(frame: frame)
        
        
        
        self.imgNameArr = imgNameArr
        self.backgroundColor = UIColor(red: 245/255.0, green: 246/255.0, blue: 246/255.0, alpha: 1.0)
        
        imgNameArr.enumerateObjectsUsingBlock { (object, index, stop) -> Void in
            
            let itemWidth = KScreenWidth/CGFloat(imgNameArr.count)
            
            let bgView = UIView(frame: CGRectMake(itemWidth * CGFloat(index), 0, itemWidth, self.height))
            
            let iconImg = UIImage(named: imgNameArr[index] as! String)
            let iconImgView = UIImageView()
            iconImgView.frame = CGRectMake(0, (frame.size.height - (iconImg?.size.height)!)/2, (iconImg?.size.width)!, (iconImg?.size.height)!)
            if index == 0 {
                iconImgView.left = 10
            }else if index == imgNameArr.count - 1 {
                iconImgView.left = bgView.width - (iconImg?.size.width)! - 10
            }else {
                iconImgView.left = (bgView.width - (iconImg?.size.width)!)/2
            }
            iconImgView.image = iconImg
            iconImgView.userInteractionEnabled = true
            bgView.addSubview(iconImgView)
            bgView.tag = 333  + index
            bgView.hidden = false
            let tap = UITapGestureRecognizer(target: target, action:sel)
            bgView.addGestureRecognizer(tap)
            
            self.addSubview(bgView)
            
            tapArr.enumerateObjectsUsingBlock({ (object: AnyObject!, idx: Int, stop: UnsafeMutablePointer<ObjCBool>) -> Void in
                let shouldStop: ObjCBool = true
                if String(bgView.tag) == String(object) {
                    bgView.hidden = true
                    stop.initialize(shouldStop)
                }
            })
        }
        
    }
    
    func setNextHidden(isHidden:Bool) {
        let bgView = self.viewWithTag(335)! as UIView
        if isHidden == true {
            bgView.hidden = true
        }else {
            bgView.hidden = false
        }
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}

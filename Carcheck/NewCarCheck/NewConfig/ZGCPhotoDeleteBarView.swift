//
//  ZGCPhotoDeleteBarView.swift
//  Carcheck
//
//  Created by GaoCheng.Zou on 16/3/4.
//  Copyright © 2016年 GaoCheng.Zou. All rights reserved.
//

import UIKit

class ZGCPhotoDeleteBarView: UIView {
    
    init(frame: CGRect, target: AnyObject, sel:Selector) {
        super.init(frame: frame)
        
        self.backgroundColor = UIColor(red: 245/255.0, green: 246/255.0, blue: 246/255.0, alpha: 1.0)
        
        let label = UILabel(frame: CGRectMake(0, 0, KScreenWidth/5, frame.size.height))
        label.text = "全部删除"
        label.font = UIFont.systemFontOfSize(15.0)
        label.textAlignment = NSTextAlignment.Center
        label.userInteractionEnabled = true
        label.textColor = UIColor(red: 47/255.0, green: 44/255.0, blue: 43/255.0, alpha: 1.0)
        label.tag = 333
        self.addSubview(label)
        
        let labelTap = UITapGestureRecognizer(target: target, action:sel)
        label.addGestureRecognizer(labelTap)
        
        
        let iconImg = UIImage(named: "photo_delete")
        let iconImgView = UIImageView(frame: CGRectMake(KScreenWidth - (iconImg?.size.width)! - 10 , (frame.size.height - (iconImg?.size.height)!)/2, (iconImg?.size.width)!, (iconImg?.size.height)!))
        iconImgView.image = iconImg
        iconImgView.userInteractionEnabled = true
        self.addSubview(iconImgView)
        iconImgView.tag = 222
        let tap = UITapGestureRecognizer(target: target, action:sel)
        iconImgView.addGestureRecognizer(tap)
        
    }
    
    func show() {
        UIView.animateWithDuration(0.35) { () -> Void in
            self.top = KScreenHeight - NavAndStausHeight - 49
        }
    }
    
    func hidden() {
        UIView.animateWithDuration(0.35) { () -> Void in
            self.top = KScreenHeight - NavAndStausHeight
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
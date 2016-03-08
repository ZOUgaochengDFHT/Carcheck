//
//  ZGCTakePhotoView.swift
//  Carcheck
//
//  Created by GaoCheng.Zou on 16/3/2.
//  Copyright © 2016年 GaoCheng.Zou. All rights reserved.
//

import UIKit

class ZGCTakePhotoView: UIView {
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = ButtonBackGroundColor

    }
    
    func initWithTarget(target:AnyObject, sel: Selector) {
        let iconImg = UIImage(named: "config_takePic")
        let iconImgView = UIImageView(frame: CGRectMake((self.frame.size.width - (iconImg?.size.width)!)/2 , (self.frame.size.height - (iconImg?.size.height)!)/2, (iconImg?.size.width)!, (iconImg?.size.height)!))
        iconImgView.image = iconImg
        
        iconImgView.userInteractionEnabled = true
        self.addSubview(iconImgView)
        self.tag = 444
        let tap = UITapGestureRecognizer(target: target, action:sel)
        self.addGestureRecognizer(tap)

    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }


}

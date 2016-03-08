//
//  ZGCEditPhotoView.swift
//  Carcheck
//
//  Created by GaoCheng.Zou on 16/3/4.
//  Copyright © 2016年 GaoCheng.Zou. All rights reserved.
//

import UIKit

class ZGCEditPhotoView: UIImageView {
    
    var aframe:CGRect!

    let editImg = UIImage(named: "photo_edit")
    var editImgView = UIImageView()
    init(frame: CGRect, tar: AnyObject, sel: Selector) {
        super.init(frame: frame)
        
        
        aframe = self.frame
        editImgView = UIImageView(frame: CGRectMake(aframe.size.width - (editImg?.size.width)! - 5, aframe.size.height - (editImg?.size.height)! - 5, (editImg?.size.width)!, (editImg?.size.height)!))
        editImgView.image = editImg
        editImgView.userInteractionEnabled = true
        self.addSubview(editImgView)
        
        let tap = UITapGestureRecognizer(target: tar, action:sel)
        self.addGestureRecognizer(tap)
        
        let editTap = UITapGestureRecognizer(target: tar, action:sel)
        editImgView.addGestureRecognizer(editTap)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    


}

//
//  ZGCPhotoImgView.swift
//  Carcheck
//
//  Created by GaoCheng.Zou on 16/2/26.
//  Copyright © 2016年 GaoCheng.Zou. All rights reserved.
//

import UIKit

typealias ZGCPassDeleteOrAddImgBlock = (image:UIImage, isdelete:Bool) -> Void
class ZGCPhotoImgView: UIImageView {

    var tar: AnyObject!
    var sel: Selector!

    var aframe:CGRect!
    
    var deleteOrAddImgHandler :ZGCPassDeleteOrAddImgBlock!
    
    var selectedImgView = UIImageView()
    var permitEditing:Bool!
    let selectedImg = UIImage(named: "config_selected")

    override init(frame: CGRect) {
        super.init(frame: frame)
                
        aframe = self.frame
        selectedImgView = UIImageView(frame: CGRectMake(aframe.size.width - (selectedImg?.size.width)!, aframe.size.height - (selectedImg?.size.height)!, (selectedImg?.size.width)!, (selectedImg?.size.height)!))
        selectedImgView.userInteractionEnabled = true
        selectedImgView.layer.cornerRadius = (selectedImg?.size.width)!/2
        selectedImgView.clipsToBounds = true
        selectedImgView.backgroundColor = UIColor.whiteColor()
        self.addSubview(selectedImgView)
        
        let tap = UITapGestureRecognizer(target: self, action: "tapAction:")
        self.addGestureRecognizer(tap)
    }

    

    func setSelectedImgViewHiddenOrNot () {
//        if permitEditing == true {
//            selectedImgView.hidden = false
//            selectedImgView.image = selectedImg
//        }else {
//            selectedImgView.hidden = true
//            selectedImgView.image = UIImage()
//        }
    }
    
    func setSelectedImgViewHidden () {
//        selectedImgView.hidden = true
    }
    
    func setSelectedImgViewHiddenisTure (isTrue:Bool) {
        if isTrue == true {
            selectedImgView.hidden = false
        }else {
            selectedImgView.hidden = true
        }
        selectedImgView.image = UIImage()

    }
    

    func tapAction(tap:UITapGestureRecognizer) {
        if selectedImgView.image == selectedImg {
//            self.permitEditing = false
            selectedImgView.image = UIImage()
             deleteOrAddImgHandler(image:self.image!, isdelete:false)
        }else {
            selectedImgView.image = selectedImg
//            self.permitEditing = true
            deleteOrAddImgHandler(image:self.image!, isdelete:true)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

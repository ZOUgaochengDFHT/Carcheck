//
//  ZGCVehicleConfigTableViewCell.swift
//  Carcheck
//
//  Created by GaoCheng.Zou on 16/3/2.
//  Copyright © 2016年 GaoCheng.Zou. All rights reserved.
//

import UIKit

class ZGCVehicleConfigTableViewCell: UITableViewCell {
    
    var dataListArr = NSMutableArray()
    var photoViewArr = NSMutableArray(capacity: 3)
    var titleLabelArr = NSMutableArray(capacity: 2)
    let photoViewWidth = (KScreenWidth - 40)/3
    var permitEditing:Bool!
    var maxCount: Int!
    var section: Int!
    var editImgView: UIImageView!
    var attriArr = NSMutableArray()
    var addImgView: UIImageView!
    var tar: AnyObject!
    var sel: Selector!
    var maxCountThree: Int!
    var takePhotoView :ZGCTakePhotoView!
    var deleteOrAddImgHandler :ZGCPassDeleteOrAddImgBlock!

    var takePhotoViewHidden = false
    var editImgViewhidden = false

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        for index in 0...2 {
            let iconImgView = ZGCPhotoImgView(frame: CGRectMake(10 + (self.photoViewWidth + 10) * CGFloat(index), 5, self.photoViewWidth, self.photoViewWidth))
            iconImgView.permitEditing = false
            iconImgView.setSelectedImgViewHiddenOrNot()
            self.contentView.addSubview(iconImgView)
            photoViewArr.addObject(iconImgView)
            
        }
        
        editImgView = UIImageView(frame: CGRectZero)
        self.contentView.addSubview(editImgView)
        
        addImgView = UIImageView(frame: CGRectZero)
        self.contentView.addSubview(addImgView)
        
        takePhotoView = ZGCTakePhotoView(frame: CGRectZero)
        self.contentView.addSubview(takePhotoView)
        
        
        for i in 0...1 {
            let titleLabel = UILabel(frame: CGRectMake(11 + (KScreenWidth - 50)/2*CGFloat(i), 0, (KScreenWidth - 50)/2, 40))
            self.contentView.addSubview(titleLabel)
            titleLabel.font = UIFont.systemFontOfSize(14.0)
            titleLabelArr.addObject(titleLabel)
        }
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if self.section != nil {
            if self.section == 1 {
                
                if self.attriArr.count > 0 {
                    titleLabelArr.enumerateObjectsUsingBlock({ (object, index, stop) -> Void in
                        let titleLabel = object as! UILabel
                        titleLabel.hidden = true
                        
                    })
                    
                }
                addImgView.hidden = true
                editImgView.hidden = true
                photoViewArr.enumerateObjectsUsingBlock { (object, index, stop) -> Void in
                    
                    let iconImgView = self.photoViewArr[index] as! ZGCPhotoImgView
                    if index < self.dataListArr.count {
                        
                        let iconImg = self.dataListArr[index] as? UIImage
                        iconImgView.userInteractionEnabled = true
                        //必须要有这行代码，否则复用会造成不一样的效果
                        iconImgView.image = iconImg
                        iconImgView.hidden = false
                        
                        self.takePhotoView.userInteractionEnabled = false

                        if self.permitEditing == false {
                            iconImgView.userInteractionEnabled = false
                            iconImgView.setSelectedImgViewHidden()
                            self.takePhotoView.userInteractionEnabled = true
                        }
                        
                        iconImgView.setSelectedImgViewHiddenisTure(self.permitEditing)

                        
                        if self.tag == self.maxCountThree && index == self.dataListArr.count - 1 && self.takePhotoViewHidden == false {
                            self.takePhotoView.frame = iconImgView.frame
                            self.takePhotoView.initWithTarget(self.tar, sel: self.sel)
                            self.takePhotoView.hidden = false
                            iconImgView.image = UIImage()
                            iconImgView.hidden = true
                        }else {
                            self.takePhotoView.hidden = true
                        }
                        
                        iconImgView.deleteOrAddImgHandler = {
                            (image:UIImage, isdelete:Bool) -> Void in
                            self.deleteOrAddImgHandler(image:image, isdelete:isdelete)

                        }
                        
                    }else {
                        iconImgView.hidden = true
                    }
                    
                }
                
            }else {
                
                
                photoViewArr.enumerateObjectsUsingBlock { (object, index, stop) -> Void in
                    let iconImgView = self.photoViewArr[index] as! ZGCPhotoImgView
                    iconImgView.hidden = true
                }

                takePhotoView.hidden = true
                if self.tag == self.maxCount {
                    editImgView.hidden = true
                    let iconImg = UIImage(named: "config_add")
                    addImgView.frame = CGRectMake(KScreenWidth - (iconImg?.size.width)! - 10 , (40 - (iconImg?.size.height)!)/2, (iconImg?.size.width)!, (iconImg?.size.height)!)
                    addImgView.image = iconImg
                    addImgView.userInteractionEnabled = true
                    if self.permitEditing == true {
                        addImgView.userInteractionEnabled = false
                    }
                    
                    addImgView.tag = 500
                    let tap = UITapGestureRecognizer(target: tar, action: sel)
                    addImgView.addGestureRecognizer(tap)
                    addImgView.hidden = false
                    titleLabelArr.enumerateObjectsUsingBlock({ (object, index, stop) -> Void in
                        let titleLabel = object as! UILabel
                        titleLabel.hidden = true
                    })
                }else {
                    if self.attriArr.count > 0 {
                        titleLabelArr.enumerateObjectsUsingBlock({ (object, index, stop) -> Void in
                            let titleLabel = object as! UILabel
                            var str = self.attriArr[index]
                            titleLabel.hidden = false
                            if index == 0 {
                                str = String(self.tag + 1).stringByAppendingString(".  ").stringByAppendingString(str as! String)
                            }else {
                                str = String("   ").stringByAppendingString(str as! String)
                            }
                            titleLabel.text = str as? String
                            
                        })
                        
                    }
                    
                    if editImgViewhidden == false {
                        let editImg = UIImage(named: "config_edit")
                        editImgView.frame = CGRectMake(KScreenWidth - (editImg?.size.width)! - 10, (40 - (editImg?.size.height)!)/2, (editImg?.size.width)!, (editImg?.size.height)!)
                        editImgView.image = editImg
                        editImgView.hidden = false
                        addImgView.hidden = true
                        editImgView.userInteractionEnabled = true
                        if self.permitEditing == true {
                            editImgView.userInteractionEnabled = false
                        }
                        editImgView.tag = 600 + self.tag
                        let tap = UITapGestureRecognizer(target: tar, action: sel)
                        editImgView.addGestureRecognizer(tap)
                    }
                    
                    
                }
                
            }
            

        }
        
    }
    
    func tapToTakePhotos () {
        
    }
    
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}


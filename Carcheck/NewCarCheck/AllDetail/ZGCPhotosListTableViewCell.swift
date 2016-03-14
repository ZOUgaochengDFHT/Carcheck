//
//  ZGCPhotosListTableViewCell.swift
//  Carcheck
//
//  Created by GaoCheng.Zou on 16/2/25.
//  Copyright © 2016年 GaoCheng.Zou. All rights reserved.
//

import UIKit

class ZGCPhotosListTableViewCell: UITableViewCell {

    var dataListArr = NSMutableArray()
    var modelListArr = NSMutableArray()
    var photoViewArr = NSMutableArray(capacity: 3)
    let photoViewWidth = (KScreenWidth - 40)/3
    var permitEditing:Bool!
    
    var deleteOrAddImgHandler :ZGCPassDeleteOrAddImgBlock!

    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        for index in 0...2 {
            let iconImgView = ZGCPhotoImgView(frame: CGRectMake(10 + (self.photoViewWidth + 10) * CGFloat(index), 5, self.photoViewWidth, self.photoViewWidth))
            iconImgView.permitEditing = false
            iconImgView.setSelectedImgViewHiddenOrNot()
            self.contentView.addSubview(iconImgView)
            photoViewArr.addObject(iconImgView)
            
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        photoViewArr.enumerateObjectsUsingBlock { (object, index, stop) -> Void in
            
            let iconImgView = self.photoViewArr[index] as! ZGCPhotoImgView
            if index < self.dataListArr.count {
                
                let iconImg = self.dataListArr[index] as? UIImage
                
                let imgModel = self.modelListArr[index] as? Image

                iconImgView.userInteractionEnabled = true
                //必须要有这行代码，否则复用会造成不一样的效果
                iconImgView.hidden = false
                if imgModel?.path != nil {
                    iconImgView.setImageWithPath(imgModel?.path, placeholderImage: iconImg)
                    iconImgView.pid = imgModel?.pid
                }
                
                if self.permitEditing == false {
                    iconImgView.userInteractionEnabled = false
                    iconImgView.setSelectedImgViewHidden()
                }
                
                iconImgView.setSelectedImgViewHiddenisTure(self.permitEditing)
                
//                
//                if self.tag == self.maxCountThree && index == self.dataListArr.count - 1{
//                    self.takePhotoView.frame = iconImgView.frame
//                    self.takePhotoView.initWithTarget(self.tar, sel: self.sel)
//                    self.takePhotoView.hidden = false
//                    iconImgView.image = UIImage()
//                    iconImgView.hidden = true
//                }else {
//                    self.takePhotoView.hidden = true
//                }
                
                iconImgView.deleteOrAddImgHandler = {
                    (image:UIImage, isdelete:Bool, imgView:ZGCPhotoImgView, tag:Int) -> Void in
                    self.deleteOrAddImgHandler(image:image, isdelete:isdelete, imgView: imgView, tag: tag)
                    
                }
                
            }else {
                iconImgView.hidden = true
            }
            
        }

    }
    

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

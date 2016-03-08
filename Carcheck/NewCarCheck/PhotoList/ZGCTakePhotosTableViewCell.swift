//
//  ZGCTakePhotosTableViewCell.swift
//  Carcheck
//
//  Created by GaoCheng.Zou on 16/3/4.
//  Copyright © 2016年 GaoCheng.Zou. All rights reserved.
//

import UIKit

typealias ClickImgViewToShowBlock = (tag:Int, imgView:ZGCEditPhotoView) -> Void
class ZGCTakePhotosTableViewCell: UITableViewCell {

    var dataListArr = NSMutableArray()
    var photoViewArr = NSMutableArray(capacity: 4)
    let photoViewWidth = (KScreenWidth - 40)/3
    var permitEditing:Bool!
    
    var row: Int!


    var clickImgViewToShowHandler: ClickImgViewToShowBlock!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        for index in 0...2 {
            let editImgView = ZGCEditPhotoView(frame: CGRectMake(10 + (self.photoViewWidth + 10) * CGFloat(index), 5, self.photoViewWidth, self.photoViewWidth), tar: self, sel: "tapAction:")
            self.contentView.addSubview(editImgView)
            photoViewArr.addObject(editImgView)
            
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        photoViewArr.enumerateObjectsUsingBlock { (object, index, stop) -> Void in
            let iconImgView = self.photoViewArr[index] as! ZGCEditPhotoView
            if index < self.dataListArr.count {
                
                iconImgView.userInteractionEnabled = true
                if self.permitEditing == false {
                    iconImgView.userInteractionEnabled = false
                }
                iconImgView.tag = self.row * 3 + index + 800
                iconImgView.backgroundColor = UIColor(red: 189/190.0, green: 189/190.0, blue: 189/190.0, alpha: 1.0)
                iconImgView.editImgView.tag = 3000 + iconImgView.tag

                //必须要有这行代码，否则复用会造成不一样的效果
                iconImgView.hidden = false
                let iconImg = self.dataListArr[index] as? UIImage
                iconImgView.height = (KScreenWidth - 40)/3
                iconImgView.image = iconImg
            }else {
                iconImgView.hidden = true
            }
        }
    }
    
    func tapAction(tap:UITapGestureRecognizer) {
        if tap.view?.tag < 3000 {
            let iconImgView = self.contentView.viewWithTag((tap.view?.tag)!) as! ZGCEditPhotoView
            clickImgViewToShowHandler(tag:(tap.view?.tag)!, imgView:iconImgView)
        }else {
            let iconImgView = ZGCEditPhotoView(frame: CGRectZero, tar: self, sel: "tapAction:")
            clickImgViewToShowHandler(tag:(tap.view?.tag)!, imgView:iconImgView)
        }
        
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

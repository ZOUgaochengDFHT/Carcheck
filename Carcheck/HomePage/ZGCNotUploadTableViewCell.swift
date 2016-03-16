//
//  ZGCNotUploadTableViewCell.swift
//  Carcheck
//
//  Created by GaoCheng.Zou on 16/2/17.
//  Copyright © 2016年 GaoCheng.Zou. All rights reserved.
//

import UIKit
typealias UploadCarCheckMessageBlock = (Int, UnUpload) -> Void
typealias CheckOrChangeDetailBlock = (Int, ZGCItemListModel) -> Void
class ZGCNotUploadTableViewCell: UITableViewCell {
    var contentLabel: UILabel!
    
    var notuploadModel: UnUpload!
    var itemListModel: ZGCItemListModel!
    var index: Int!
    var uploadCarCheckMessageHandler: UploadCarCheckMessageBlock!
    var checkOrChangeDetailHandler: CheckOrChangeDetailBlock!
    
    var notUploadBtn: UIButton!
    
    var iconImgView: UIImageView!
    
   let preTitleArr = ["保存时间：", "当前状态：", "车牌号：", "车主姓名：", "车型号："] as NSArray

    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        preTitleArr.enumerateObjectsUsingBlock { (object, index, stop) -> Void in
            self.contentLabel = UILabel()
            self.contentLabel.textColor = UIColor.lightGrayColor()
            self.contentLabel.font = UIFont.systemFontOfSize(13.0)
            self.contentLabel.backgroundColor = UIColor.clearColor()
            self.contentLabel.frame = CGRectMake(20, 5 + 21 * CGFloat(index), KScreenWidth-40, 21)
            self.contentLabel.tag = 100 + index
            self.contentView.addSubview(self.contentLabel)
            self.contentLabel.text = object as? String

        }
        
        notUploadBtn = UIButton(type: UIButtonType.Custom)
        notUploadBtn.layer.cornerRadius = 8.0
        notUploadBtn.backgroundColor = ButtonBackGroundColor
        notUploadBtn.clipsToBounds = true
        notUploadBtn.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        notUploadBtn.titleLabel?.font = UIFont.systemFontOfSize(15.0)
        notUploadBtn.frame = CGRectMake(20, 110, KScreenWidth - 40, 40)
        self.contentView.addSubview(notUploadBtn)
        notUploadBtn.addTarget(self, action: "uploadBtnAction", forControlEvents: UIControlEvents.TouchUpInside)
        
        let iconImg = UIImage(named: "item_toaudit2")
        
        let iconImgWidth = iconImg?.size.width
        let iconImgHeight = iconImg?.size.height
        
        iconImgView = UIImageView()
        iconImgView.frame = CGRectMake(KScreenWidth - iconImgWidth! * 2, 20, iconImgWidth!, iconImgHeight!)
        self.contentView.addSubview(iconImgView)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    
        var contentArr = NSArray()
        if index != nil {
            if index == 0 {
                notUploadBtn.setTitle("上传", forState:UIControlState.Normal)
                contentArr = [notuploadModel.saveTime!, notuploadModel.state!, notuploadModel.licenseNo!, notuploadModel.name!, notuploadModel.vehicleType!]
            }else {
                contentArr = [itemListModel.date!, Util.getWordWithStatus(itemListModel.status!), itemListModel.carnum!, itemListModel.owner!, itemListModel.carspec!]
                var titleStr = "详情"
                var iconImgStr = "item_toaudit2"
                if index == 2 {
                    titleStr = "修改"
                    iconImgStr = "item_unpass"
                }else if index == 3 {
                    titleStr = "查看"
                    iconImgStr = "item_pass"
                }
                iconImgView.image = UIImage(named: iconImgStr)
                notUploadBtn.setTitle(titleStr, forState:UIControlState.Normal)

            }
            
            preTitleArr.enumerateObjectsUsingBlock { (object, index, stop) -> Void in
                self.contentLabel = self.contentView.viewWithTag(100 + index) as! UILabel
                self.contentLabel.text = (object as? String)?.stringByAppendingString(contentArr[index] as! String)
            }
        }

        
      

    }
    
    func uploadBtnAction() {
        if index == 0 {
            uploadCarCheckMessageHandler(self.tag, notuploadModel)
        }else {
            checkOrChangeDetailHandler(self.tag, itemListModel)
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

//
//  ZGCNotUploadTableViewCell.swift
//  Carcheck
//
//  Created by GaoCheng.Zou on 16/2/17.
//  Copyright © 2016年 GaoCheng.Zou. All rights reserved.
//

import UIKit
typealias UploadCarCheckMessageBlock = (Int, UnUpload) -> Void

class ZGCNotUploadTableViewCell: UITableViewCell {
    var contentLabel: UILabel!
    
    var notuploadModel: UnUpload!
    
    
    var uploadCarCheckMessageHandler: UploadCarCheckMessageBlock!
    
    
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
        
        let notUploadBtn:UIButton = UIButton(type: UIButtonType.Custom)
        notUploadBtn.layer.cornerRadius = 8.0
        notUploadBtn.backgroundColor = ButtonBackGroundColor
        notUploadBtn.setTitle("上传", forState:UIControlState.Normal)
        notUploadBtn.clipsToBounds = true
        notUploadBtn.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        notUploadBtn.titleLabel?.font = UIFont.systemFontOfSize(15.0)
        notUploadBtn.frame = CGRectMake(20, 110, KScreenWidth - 40, 40)
        self.contentView.addSubview(notUploadBtn)
        notUploadBtn.addTarget(self, action: "uploadBtnAction", forControlEvents: UIControlEvents.TouchUpInside)
                
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        var contentArr = [notuploadModel.saveTime, notuploadModel.state, notuploadModel.licenseNo, notuploadModel.name, notuploadModel.vehicleType]
        
        preTitleArr.enumerateObjectsUsingBlock { (object, index, stop) -> Void in
            self.contentLabel = self.contentView.viewWithTag(100 + index) as! UILabel
            self.contentLabel.text = (object as? String)?.stringByAppendingString(contentArr[index]!)
        }

    }
    
    func uploadBtnAction() {
        uploadCarCheckMessageHandler(self.tag, notuploadModel)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

//
//  ZGCTakePhotosTableView.swift
//  Carcheck
//
//  Created by GaoCheng.Zou on 16/2/19.
//  Copyright © 2016年 GaoCheng.Zou. All rights reserved.
//

import UIKit
typealias TakesPhotosBtnActionBlock = (tag:Int) -> Void
typealias TapToShowMjPhotoBrowerBlock = (tap:UITapGestureRecognizer) -> Void


public let bgGrayColor = UIColor(red: 213/255.0, green: 213/255.0, blue: 213/255.0, alpha: 1.0)

public let BigImgViewBgColor = UIColor(red: 78/255.0, green: 76/255.0, blue: 75/255.0, alpha: 1.0)

class ZGCTakePhotosTableView: BaseTableView , UITextFieldDelegate {
    
    var takesPhotosBtnHandler: TakesPhotosBtnActionBlock!
    var showMJPhotoBrower: TapToShowMjPhotoBrowerBlock!
    
    var photosNum: String!
    var currentPage: String!
    var photoImg: UIImage!
    var btnTitle: String!
    var currentStoreImgArr: NSMutableArray!
    var currentImageModelArr = NSMutableArray()
    var clickImgViewToShowHandler: ClickImgViewToShowBlock!


    override init(frame: CGRect, style: UITableViewStyle) {
        super.init(frame: frame, style: style)
        self.registerClass(ZGCTakePhotosTableViewCell.self, forCellReuseIdentifier: "ZGCTakePhotosTableViewCell")
        self.rowHeight = (KScreenWidth - 40)/3 + 10
//        self.separatorStyle = UITableViewCellSeparatorStyle.None
        
    }
    
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
    
    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let bgView = UIView()
        bgView.backgroundColor = UIColor.whiteColor()
        
        let preLabel = UILabel(frame: CGRectMake(10, 0, KScreenWidth - 20, 30))
        preLabel.textColor = UIColor.darkTextColor()
        preLabel.textAlignment = NSTextAlignment.Right
        preLabel.font = UIFont.systemFontOfSize(15.0)
        preLabel.text = currentPage.stringByAppendingString("/").stringByAppendingString(photosNum)
        bgView.addSubview(preLabel)
        return bgView
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if currentStoreImgArr != nil && currentStoreImgArr.count > 0 {
            return currentStoreImgArr.count;
        }
        return 1
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
//        let cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: identifier) ///这样写不会出现复用问题
        let cell = tableView.dequeueReusableCellWithIdentifier("ZGCTakePhotosTableViewCell", forIndexPath: indexPath) as! ZGCTakePhotosTableViewCell
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        cell.permitEditing = true
        cell.row = indexPath.row 
        if currentStoreImgArr != nil && currentStoreImgArr.count > 0 {
            cell.dataListArr = currentStoreImgArr[indexPath.row] as! NSMutableArray
            cell.modelListArr = currentImageModelArr[indexPath.row] as! NSMutableArray

        }
        cell.clickImgViewToShowHandler = {
            (tag:Int, imgView:ZGCEditPhotoView) -> Void in
            self.clickImgViewToShowHandler(tag:tag, imgView: imgView)
        }
        return cell
        
    }
    
    func btnAction(btn:UIButton) {
        takesPhotosBtnHandler(tag: btn.tag)
    }

    func tapToShowMjPhotoBrower(tap:UITapGestureRecognizer) {
        showMJPhotoBrower(tap:tap)
    }


    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

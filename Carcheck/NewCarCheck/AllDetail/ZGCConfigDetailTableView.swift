//
//  ZGCConfigDetailTableView.swift
//  Carcheck
//
//  Created by GaoCheng.Zou on 16/3/9.
//  Copyright © 2016年 GaoCheng.Zou. All rights reserved.
//

import UIKit

typealias ToVehicleBaseConfigVCBlock = () -> Void
class ZGCConfigDetailTableView: UITableView, UITableViewDelegate, UITableViewDataSource {

    var vehicleConfigScrollView: ZGCVehicleConfigListScrollView!
    var addConfigScrollView: ZGCAddConfigScrollView!
    var isCreateNew = true
    var rightBtn:UIButton!
    var permitEditing = false
    
    let identifier = "ZGCVehicleConfigTableViewCell"
        
    var array2D = NSMutableArray()
    
    var attri2DArr = NSMutableArray()
    
    var arrayModel2D = NSMutableArray()

    
    var selectedIndex: Int!
    
    var photoDeleteBarView: ZGCPhotoDeleteBarView!
    
    var deleteOrAddImgArr = NSMutableArray()
    
    var dir:String!
    
    var tar:AnyObject!
    var sel:Selector!
    
    var isEditingOrNot = true

    
    var toVehicleBaseConfigVCHandler:ToVehicleBaseConfigVCBlock!
    
    var imageModelArr = NSMutableArray()
    override init(frame: CGRect, style: UITableViewStyle) {
        super.init(frame: frame, style: style)
        
        self.delegate = self
        self.dataSource = self
        let cellNib:UINib = UINib(nibName: identifier, bundle: nil)
        self.registerNib(cellNib, forCellReuseIdentifier: identifier)
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 1 {
            return self.array2D.count
        }
        return self.attri2DArr.count
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if section == 1 {
            return NavAndStausHeight*2
        }
        return 0.0001
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.section == 1 {
            return (KScreenWidth - 40)/3 + 10
        }
        return 40
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell:ZGCVehicleConfigTableViewCell = tableView.dequeueReusableCellWithIdentifier(identifier, forIndexPath: indexPath) as! ZGCVehicleConfigTableViewCell
        
        cell.tar = self
        cell.sel = "tapAction:"
        cell.section = indexPath.section
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        cell.tag = indexPath.row
        cell.permitEditing = permitEditing
        if indexPath.section == 0 {
            cell.editImgViewhidden = true
            cell.maxCount = self.attri2DArr.count
            if indexPath.row != self.attri2DArr.count {
                cell.attriArr = attri2DArr[indexPath.row] as! NSMutableArray
            }
        }else {
            cell.maxCountThree = array2D.count - 1
            cell.dataListArr = array2D[indexPath.row] as! NSMutableArray
            cell.modelListArr = arrayModel2D[indexPath.row] as! NSMutableArray
            cell.takePhotoViewHidden = true
            cell.deleteOrAddImgHandler = {
                (image:UIImage, isdelete:Bool, imgView:ZGCPhotoImgView, tag:Int) -> Void in
                if isdelete == true {
                    self.deleteOrAddImgArr.addObject(image)
                }else {
                    self.deleteOrAddImgArr.removeObject(image)
                }
            }
        }
        
        return cell
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let bgView = UIView()
        bgView.backgroundColor = UIColor.whiteColor()
        var iconImgArr = NSArray()
        var titleArr = NSArray()
        if section == 0 {
            iconImgArr = ["config_setting", "config_text"]
            titleArr = ["配置名称", "配置说明"]
        }else {
            iconImgArr = ["config_photo"]
            titleArr = ["拍照列表"]
        }
        
        iconImgArr.enumerateObjectsUsingBlock { (object, index, stop) -> Void in
            let viewWidth = KScreenWidth - 40
            let view = UIView(frame: CGRectMake((viewWidth/2)*CGFloat(index), 0, viewWidth/2, 40))
            bgView.addSubview(view)
            let iconImg = UIImage(named: object as! String)
            let iconImgView = UIImageView(frame: CGRectMake(11, 11, (iconImg?.size.width)!, (iconImg?.size.height)!))
            iconImgView.image = iconImg
            view.addSubview(iconImgView)
            let titleLabel = UILabel(frame: CGRectMake(iconImgView.right + 11, 0, viewWidth/2 - 40, 40))
            titleLabel.text = titleArr[index] as? String
            titleLabel.font = UIFont.systemFontOfSize(14.0)
            view.addSubview(titleLabel)
        }
        
        if section == 0 {
            let editImg = UIImage(named: "detail_edit")
            
            let bgView = UIView(frame: CGRectMake(KScreenWidth - 60, 0, 60, 40))
            self.addSubview(bgView)
            bgView.tag = 778
            
            var editImgView = UIImageView()
            editImgView = UIImageView(frame: CGRectMake(bgView.width - (editImg?.size.width)! - 20, (bgView.height - (editImg?.size.height)!)/2, (editImg?.size.width)!, (editImg?.size.height)!))
            editImgView.image = editImg
            editImgView.userInteractionEnabled = true
            bgView.addSubview(editImgView)
            
            let editTap = UITapGestureRecognizer(target: tar, action:sel)
            bgView.addGestureRecognizer(editTap)
            
            bgView.hidden = !self.isEditingOrNot
        }
        
        return bgView
        
    }
    
    func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let bgView = UIView()
        bgView.backgroundColor = UIColor.whiteColor()
        if section == 1 {
            let checkBaseConfigButton:UIButton = UIButton(type: UIButtonType.Custom)
            checkBaseConfigButton.backgroundColor = ButtonBackGroundColor
            checkBaseConfigButton.setTitle("查看基础配置", forState:UIControlState.Normal)
            checkBaseConfigButton.layer.cornerRadius = 8.0
            checkBaseConfigButton.clipsToBounds = true
            checkBaseConfigButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
            checkBaseConfigButton.titleLabel?.font = UIFont.systemFontOfSize(15.0)
            checkBaseConfigButton.frame = CGRectMake(KScreenWidth/8, 4.5, KScreenWidth*3/4, 40)
            checkBaseConfigButton.tag = 99
            checkBaseConfigButton.addTarget(self, action: "btnAction:", forControlEvents: UIControlEvents.TouchUpInside)
            bgView.addSubview(checkBaseConfigButton)
        }
        
        return bgView
    }

    
    func btnAction(btn:UIButton) {
        toVehicleBaseConfigVCHandler()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

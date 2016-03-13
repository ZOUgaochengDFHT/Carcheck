//
//  ZGCCustomPickerView.swift
//  Carcheck
//
//  Created by GaoCheng.Zou on 16/3/11.
//  Copyright © 2016年 GaoCheng.Zou. All rights reserved.
//

import UIKit

typealias GetFormatStrBlock = (str:String) -> Void
class ZGCCustomPickerView: UIView, UIPickerViewDataSource, UIPickerViewDelegate {
    
    var pickerView: UIPickerView!
    var coverView: UIView!
    var pickerToolBar: UIToolbar!
    var rowOneNum: NSNumber!
    var rowThreeNum: NSNumber!

    var getFormatStrHandler: GetFormatStrBlock!
    
    var rowOneArr = NSMutableArray()
    var rowThreeArr = NSMutableArray()

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        for index in 0...20 {
            rowOneArr.addObject(index)
            if index <= 9 {
                rowThreeArr.addObject(index)
            }
        }
        
        self.initCoverView()
        self.initPickerView()
        
  
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func initPickerView () {
        
        
        pickerToolBar = UIToolbar.init(frame: CGRectMake(0, KScreenHeight - NavAndStausHeight, KScreenWidth, pickerToolBarHeight))
        pickerToolBar.sizeToFit()
        pickerToolBar.translucent = true
        
        
        let cancelBtn = UIBarButtonItem.init(title: "取消  ", style: UIBarButtonItemStyle.Plain, target: self, action: "toolBarClick:")
        cancelBtn.tintColor = ButtonBackGroundColor
        
        let flexSpace = UIBarButtonItem.init(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: self, action: nil)
        
        let sureBtn = UIBarButtonItem.init(title: "确定  ", style: UIBarButtonItemStyle.Plain, target: self, action: "toolBarClick:")
        sureBtn.tag = 235
        sureBtn.tintColor = ButtonBackGroundColor
        let barItems = [cancelBtn, flexSpace, sureBtn]
        
        pickerToolBar.setItems(barItems, animated: true)
        pickerToolBar.clipsToBounds = true
        self.addSubview(pickerToolBar)
        
        pickerView = UIPickerView.init(frame: CGRectZero)
        pickerView.showsSelectionIndicator = true
        pickerView.dataSource = self
        pickerView.delegate = self
        pickerView.backgroundColor = UIColor.whiteColor()
        pickerView.frame = CGRectMake(0, pickerToolBar.bottom, KScreenWidth, datePickerHeight)
        self.addSubview(pickerView)
    }
    
    func initCoverView () {
        coverView = UIView.init(frame: CGRectMake(0, 0, KScreenWidth, KScreenHeight - NavAndStausHeight))
        coverView.alpha = 0.0
        coverView.backgroundColor = UIColor.blackColor()
        coverView.hidden = true
        self.addSubview(coverView)
        
        let tap = UITapGestureRecognizer(target: self, action: "coverViewHidden")
        coverView.addGestureRecognizer(tap)
    }
    
    func coverViewPresnt () {
        self.hidden = false
        UIView.animateWithDuration(0.25) { () -> Void in
            self.coverView.hidden = false
            self.coverView.alpha = 0.5
            self.pickerToolBar.frame.origin.y = KScreenHeight - datePickerHeight - NavAndStausHeight - pickerToolBarHeight
            self.pickerView.top = self.pickerToolBar.bottom
        }
    }
    
    /**
     *@隐藏housekeeperServiceTypePickerView
     */
    func coverViewHidden () {
        UIView.animateWithDuration(0.25, animations: { () -> Void in
            self.coverView.hidden = true
            self.coverView.alpha = 0.0
            self.pickerToolBar.frame.origin.y = KScreenHeight
            self.pickerView.top = self.pickerToolBar.bottom
            }) { (finished) -> Void in
                self.hidden = true
        }
    }
    
    /**
     *@自定义工具栏
     */
    func toolBarClick(barButtonItem:UIBarButtonItem) {
        if barButtonItem.tag == 235 {
            var conStr = String("\(rowOneNum)\(".")\(rowThreeNum)\(" L")")
            if rowThreeNum == nil && rowOneNum == nil {
                conStr = String("\("0.0 L")")
            }else if rowOneNum == nil  {
                conStr = String("\("0.")\(rowThreeNum)\("L")")
            }else if rowThreeNum == nil {
                conStr = String("\(rowOneNum)\(".0 L")")
            }
            getFormatStrHandler(str: conStr)
        }
        self.coverViewHidden()
    }
    
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 3
    }
    
    func pickerView(pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 35.0
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if component == 0 {
            return 21
        }else if component == 1 {
            return 1
        }
        return 10
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if component == 0 {
            rowOneNum = rowOneArr[row] as! NSNumber
        }else if component == 2 {
            rowThreeNum = rowThreeArr[row] as! NSNumber
        }
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if component == 0 {
            return String(rowOneArr[row] as! NSNumber)
        }else if component == 1 {
            return "."
        }else {
            return String(rowThreeArr[row] as! NSNumber)
        }
    }
    
    func pickerView(pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusingView view: UIView?) -> UIView {
        
        let contentLabel:UILabel!
        if view == nil {
            contentLabel = UILabel()
            contentLabel.textAlignment = NSTextAlignment.Center
            contentLabel.backgroundColor = UIColor.clearColor()
            if component == 1 {
                contentLabel.font = UIFont.systemFontOfSize(30.0)
            }else {
                contentLabel.font = UIFont.systemFontOfSize(16.0)
            }
        }else {
            contentLabel = view as! UILabel
        }
        contentLabel.text = self.pickerView(pickerView, titleForRow: row, forComponent: component)
        return contentLabel
    }
    

    
}


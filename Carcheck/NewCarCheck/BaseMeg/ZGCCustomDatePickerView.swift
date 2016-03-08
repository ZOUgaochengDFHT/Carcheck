//
//  ZGCCustomDatePickerView.swift
//  Carcheck
//
//  Created by GaoCheng.Zou on 16/3/2.
//  Copyright © 2016年 GaoCheng.Zou. All rights reserved.
//

import UIKit

public let datePickerHeight:CGFloat = 200
public let pickerToolBarHeight:CGFloat = 40
typealias GetDateFormatStrBlock = (dateStr:String) -> Void




class ZGCCustomDatePickerView: UIView {
    
    var datePicker: UIDatePicker!
    var coverView: UIView!
    var pickerToolBar: UIToolbar!
    var dateStr: String!
    var getDateFormatStrHandler: GetDateFormatStrBlock!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.initCoverView()
        self.initDatePickerView()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    func initDatePickerView () {
        
        
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
        
        datePicker = UIDatePicker.init(frame: CGRectZero)
        datePicker.backgroundColor = UIColor.whiteColor()
        datePicker.datePickerMode = UIDatePickerMode.Date
        datePicker.frame = CGRectMake(0, pickerToolBar.bottom, KScreenWidth, datePickerHeight)
        datePicker.locale = NSLocale(localeIdentifier: "zh_Hans_CN")
        datePicker.addTarget(self, action: "dateChange", forControlEvents: UIControlEvents.ValueChanged)
        
//        let nowDate = NSDate(timeIntervalSinceNow: 3600)
//        datePicker.minimumDate = nowDate
        self.addSubview(datePicker)
    }
    
    /**
     *@日期改变时获取当前的日期字符串
     */
    func dateChange() {
        dateStr = GetFormateDate(datePicker.date)
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
            self.datePicker.top = self.pickerToolBar.bottom
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
            self.datePicker.top = self.pickerToolBar.bottom
            }) { (finished) -> Void in
                self.hidden = true
        }
    }
    
    /**
     *@自定义工具栏
     */
    func toolBarClick(barButtonItem:UIBarButtonItem) {
        if barButtonItem.tag == 235 {
            if dateStr == nil {
                dateStr = GetFormateDate(NSDate(timeIntervalSinceNow: 3600) )
            }
            getDateFormatStrHandler(dateStr: dateStr)
        }
        self.coverViewHidden()
    }

}

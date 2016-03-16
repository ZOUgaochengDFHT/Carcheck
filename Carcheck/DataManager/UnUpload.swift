//
//  UnUpload.swift
//  Carcheck
//
//  Created by GaoCheng.Zou on 16/3/8.
//  Copyright © 2016年 GaoCheng.Zou. All rights reserved.
//

import UIKit

class UnUpload: NSObject {
    //定义属性
    var saveTime:String? //保存时间
    var state:String? //当前状态
    var licenseNo: String? //车牌
    var name: String? //车主姓名
    var vehicleType: String? //车辆型号
    var formatStr: String? //上传数据字符串
    var itemId: String? //上传zip包所在路径
    var databasePath: String? //数据库路径
    
    init(name:String?, saveTime:String?, state:String?, licenseNo:String?, vehicleType:String?, formatStr:String?, itemId: String?, databasePath:String?) {
        self.name = name
        self.vehicleType = vehicleType
        self.saveTime = saveTime
        self.state = state
        self.licenseNo = licenseNo
        self.formatStr = formatStr
        self.itemId = itemId
        self.databasePath = databasePath

    }
}

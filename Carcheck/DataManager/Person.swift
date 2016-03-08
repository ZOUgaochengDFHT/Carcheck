//
//  Person.swift
//  SaupFMDB
//
//  Created by 卲 鵬 on 15/9/1.
//  Copyright (c) 2015年 pshao. All rights reserved.
//

import UIKit

class Person: NSObject {
    //定义属性
    var type: String? //业务类型
    var name: String? //车主姓名
    var phone: String? //联系方式
    var licenseNo: String? //车牌
    var location: String? //车辆所在地
    var vin: String? //车辆VIN码
    var engineNo: String? //发动机号
    var regisDate: String? //注册日期
    var vehicleType: String? //车辆型号
    var vehicleEmiss: String? //车辆排量
    var transmType: String? //变速器类型
    var driveWay: String? //驱动方式
    var fuelType: String? //燃油类型
    var manufacDate: String? //出厂日期
    var licenseType: String? //车牌类型
    var envirProStand: String? //环保标准
    var mileage: String? //行驶里程
    var bodyColor: String? //车身颜色
    var carKeys: String? //车钥匙
    var pid: String?
    
    init(type:String?,name:String?,phone:String?, licenseNo:String?, location:String?, vin:String?, engineNo:String?, regisDate:String? , vehicleType:String?, vehicleEmiss:String?, transmType:String? , driveWay:String?, fuelType:String?, manufacDate:String?, licenseType:String?, envirProStand:String? , mileage:String?, bodyColor:String?, carKeys:String?, pid: String?){
        self.type = type
        self.name = name
        self.phone = phone
        self.licenseNo = licenseNo
        self.location = location
        self.vin = vin
        self.engineNo = engineNo
        self.regisDate = regisDate
        self.vehicleType = vehicleType
        self.vehicleEmiss = vehicleEmiss
        self.transmType = transmType
        self.driveWay = driveWay
        self.fuelType = fuelType
        self.manufacDate = manufacDate
        self.licenseType = licenseType
        self.envirProStand = envirProStand
        self.mileage = mileage
        self.bodyColor = bodyColor
        self.carKeys = carKeys
        self.pid = pid
    }
}

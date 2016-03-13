//
//  ValueOrIllegal.swift
//  Carcheck
//
//  Created by GaoCheng.Zou on 16/3/10.
//  Copyright © 2016年 GaoCheng.Zou. All rights reserved.
//

import UIKit

class ValueOrIllegal: NSObject {
    //定义属性
    var illegalScore:String? //保存时间
    var illegalTimes:String? //当前状态
    var illegalPenalty: String? //车牌
    var valueBad: String? //车主姓名
    var valueNormal: String? //车辆型号
    var valueGood: String? //数据库路径
    var valueNew: String? //数据库路径
    var demandLoans: String? //数据库路径
    
    init(illegalScore:String?, illegalTimes:String?, illegalPenalty:String?, valueBad:String?, valueNormal:String?, valueGood:String?, valueNew:String?, demandLoans:String?) {
        self.illegalScore = illegalScore
        self.illegalTimes = illegalTimes
        self.illegalPenalty = illegalPenalty
        self.valueBad = valueBad
        self.valueNormal = valueNormal
        self.valueGood = valueGood
        self.valueNew = valueNew
        self.demandLoans = demandLoans
    }
}

//
//  Config.swift
//  Carcheck
//
//  Created by GaoCheng.Zou on 16/3/1.
//  Copyright © 2016年 GaoCheng.Zou. All rights reserved.
//

import UIKit

class Config: NSObject {
    //定义属性
    var name: String? //配置名称
    var instruction: String? //配置说明
    var pid: String?

    
    init(name:String?, instruction:String?, pid: String?) {
        self.name = name
        self.instruction = instruction
        self.pid = pid
    }
}

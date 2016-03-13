//
//  Image.swift
//  Carcheck
//
//  Created by GaoCheng.Zou on 16/3/8.
//  Copyright © 2016年 GaoCheng.Zou. All rights reserved.
//

import UIKit

class Image: NSObject {
    var path: String? //路径
    var instruction: String? //概述说明
    var location: String? //位置
    var pid: String?
    
    init(path:String?, instruction: String?, location: String?, pid: String?) {
        self.path = path
        self.instruction = instruction
        self.location = location
        self.pid = pid
    }
}

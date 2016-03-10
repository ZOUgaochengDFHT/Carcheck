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
    var pid: String?
    var instruction: String? //概述说明
    
    init(path:String?, pid: String?, instruction: String?) {
        self.path = path
        self.pid = pid
        self.instruction = instruction
    }
}

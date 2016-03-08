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
    
    init(path:String?, pid: String?) {
        self.path = path
        self.pid = pid
    }
}

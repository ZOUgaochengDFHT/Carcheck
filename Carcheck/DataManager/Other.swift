//
//  Other.swift
//  Carcheck
//
//  Created by GaoCheng.Zou on 16/3/9.
//  Copyright © 2016年 GaoCheng.Zou. All rights reserved.
//

import UIKit

class Other: NSObject {
    var styleId: String? //路径
    var licenseTypeNum: String?
    
    init(styleId:String?, licenseTypeNum: String?) {
        self.styleId = styleId
        self.licenseTypeNum = licenseTypeNum
    }
}

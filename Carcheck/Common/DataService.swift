//
//  DataService.swift
//  Carcheck
//
//  Created by GaoCheng.Zou on 16/3/9.
//  Copyright © 2016年 GaoCheng.Zou. All rights reserved.
//

import UIKit
import Alamofire

typealias RequestCompletion = (json:AnyObject) -> Void

/*
适配器模式是设计模式中的一种，很容易理解：我的 APP 需要一个获取某一个 URL 返回的字符串的功能，我现在选择的是 Alamofire，但是正在发展的 Pitaya 看起来不错，我以后想替换成 Pitaya，所以我封装了一层我自己的网络接口，用来屏蔽底层细节，到时候只需要修改这个类，不需要再深入项目中改那么多接口调用了。适配器模式听起来高大上，其实这是我们在日常编码中非常常用的设计模式。
*/
/// 封装多级接口
class DataService: NSObject {
    
    static func requestWithUrl(url:String , parameters:[String: AnyObject], completion:RequestCompletion) -> Void{
        
    }
    
}
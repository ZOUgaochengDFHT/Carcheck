//
//  Common.swift
//  Carcheck
//
//  Created by GaoCheng.Zou on 16/2/14.
//  Copyright © 2016年 GaoCheng.Zou. All rights reserved.
//

import Foundation
import UIKit

public let NavAndStausHeight:CGFloat  = 64.0
public let TabBarHeight:CGFloat  = 49.0

public let KeyWindow = UIApplication.sharedApplication().keyWindow


public let UserDefault = NSUserDefaults.standardUserDefaults()

public let FileManager = NSFileManager.defaultManager()

// MARK: - BaseURL
public let BaseURLString: String = "https://api.zrlh.net/"


//public let documentsFolder = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0]


// MARK: - 设备屏幕宽高
public let KScreenWidth = UIScreen.mainScreen().bounds.size.width
public let KScreenHeight = UIScreen.mainScreen().bounds.size.height

// MARK: - 获取系统版本
func SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(versionStr:String) -> Bool {
    return UIDevice.currentDevice().systemVersion.compare(versionStr, options: NSStringCompareOptions.NumericSearch, range: nil, locale: nil) != NSComparisonResult.OrderedAscending
}
func SYSTEM_VERSION_LESS_THAN(versionStr:String) -> Bool {
    return UIDevice.currentDevice().systemVersion.compare(versionStr, options: NSStringCompareOptions.NumericSearch, range: nil, locale: nil) != NSComparisonResult.OrderedDescending
}
// MARK: - 颜色值
public let kBorderColor = UIColor(red: 166/255.0, green: 166/255.0, blue: 177/255.0, alpha: 1.0)
public let ButtonBackGroundColor = UIColor(red: 212/255.0, green: 13/255.0, blue: 9/255.0, alpha: 1.0)
public let LoginBottomLayerColor = UIColor(red: 212/255.0, green: 213/255.0, blue: 213/255.0, alpha: 1.0)

public let CellBgColor = UIColor(red: 235/255.0, green: 235/255.0, blue: 235/255.0, alpha: 1.0)


// MARK: - 
public let TAPTOPUSHVIEWCONTROLLER = "TAPTOPUSHVIEWCONTROLLER"

public let SETBUTTONENABLEDFALSE = "SETBUTTONENABLEDFALSE"
public let SETBUTTONENABLEDTRUE = "SETBUTTONENABLEDTRUE"

public let CHANGEVEHICLETYPE = "CHANGEVEHICLETYPE"

public let DELETECHOOSEIMG  = "DELETECHOOSEIMG"

public let DocumentsDirectory = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true)[0]

func CreateSubDocumentsDirectory () -> String{
//    var documentsDirectory: String?
//    var paths: [AnyObject] = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true)
//    documentsDirectory = paths[0] as? String
    
    let copyStr = (GetCurrentDateTransformToDateStrTwo() as NSString).mutableCopy() //使用mutableCopy深复制对象，是深复制后得到的变量不回受原变量的改变而变化

    
    let subDir = (DocumentsDirectory as NSString).stringByAppendingPathComponent(copyStr as! String)
    
    UserDefault.setObject(subDir, forKey: "subDir")
    UserDefault.synchronize()
    
    CreateSubDirectories(subDir)
    return subDir
}

func CreateSubDirectories (dir:String) {
    do {
        try FileManager.createDirectoryAtPath(dir, withIntermediateDirectories: false, attributes: nil)
        print(dir)
    } catch let error as NSError {
        NSLog("\(error.localizedDescription)")
    }
}

func WriteImageDataToFile (image:UIImage, dir:String, imgName:String) {
    let savePath = dir + "/".stringByAppendingString(imgName).stringByAppendingString(".png")
    let data = UIImagePNGRepresentation(image)
    NSFileManager.defaultManager().createFileAtPath(savePath, contents: data, attributes: nil)
}

func GetFormateDate (date:NSDate) -> String {
    let cal = NSCalendar.currentCalendar()
    let component = cal.components([.Day, .Month, .Year], fromDate: date)
    let nsDateString = String(format: "%4ld-%02ld-%02ld", component.year, component.month, component.day)
    return nsDateString
}


func GetCurrentDateTransformToDateStr () -> String {
    let dateFormatter = NSDateFormatter() as NSDateFormatter
    dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
    let currentDateStr = dateFormatter.stringFromDate(NSDate())
    return currentDateStr
}

func GetCurrentDateTransformToDateStrTwo () -> String {
    let dateFormatter = NSDateFormatter() as NSDateFormatter
    dateFormatter.dateFormat = "yyyyMMddHHmmss"
    let currentDateStr = dateFormatter.stringFromDate(NSDate())
    return currentDateStr
}

public let GetLocationURL =  "http://int.dpool.sina.com.cn/iplookup/iplookup.php?format=json"


//图片等比例压缩
func ImageWithImageSimple(image:UIImage,scaledToSize newSize:CGSize) -> UIImage {
    var width:CGFloat!
    var height:CGFloat!
    //等比例缩放
    if image.size.width/newSize.width >= image.size.height / newSize.height {
        width = newSize.width
        height = image.size.height / (image.size.width/newSize.width)
    } else{
        height = newSize.height
        width = image.size.width / (image.size.height/newSize.height)
    }
    let sizeImageSmall = CGSizeMake(width, height)
    
    UIGraphicsBeginImageContext(sizeImageSmall);
    image.drawInRect(CGRectMake(0,0,sizeImageSmall.width,sizeImageSmall.height))
    let newImage:UIImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}


/*/**
*@只获取日期字符串到天数
*/
+ (NSString*)getUploadFormateDateTwo:(NSDate*)date {
NSDate *confromTimesp = date;
NSCalendar  * cal = [NSCalendar  currentCalendar];
NSUInteger unitFlags = NSCalendarUnitDay|NSCalendarUnitMonth|NSCalendarUnitYear|NSCalendarUnitHour|NSCalendarUnitMinute;
NSDateComponents * conponent = [cal components:unitFlags fromDate:confromTimesp];
NSInteger year = [conponent year];
NSInteger month = [conponent month];
NSInteger day = [conponent day];
NSString *  nsDateString = [NSString  stringWithFormat:@"%4ld年%0ld月%02ld日",(long)year,(long)month,(long)day];
return nsDateString;
}*/




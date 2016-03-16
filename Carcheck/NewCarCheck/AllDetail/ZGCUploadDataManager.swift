//
//  ZGCUploadDataManager.swift
//  Carcheck
//
//  Created by GaoCheng.Zou on 16/3/15.
//  Copyright © 2016年 GaoCheng.Zou. All rights reserved.
//

import UIKit
import Alamofire
import ZipArchive
typealias RequestDataCompletionBlock = (isSuccess:Bool) -> Void
class ZGCUploadDataManager: NSObject {
    
    var requestDataHandler: RequestDataCompletionBlock!
    
    override init() {
        super.init()
        
        var l_zipfile: String!
        
        let tabTitleArr = ["车辆正面与车主合照","左前45度","左后45度","右后45度"] as NSArray
        
        //压缩图片数据，并zip打包
        let zipArchive = ZipArchive()
        
        l_zipfile = "\(UserDefault.objectForKey("subDir") as! String)\("/test.zip")"
        
        zipArchive.CreateZipFile2(l_zipfile)
        
        
        
        let dir = UserDefault.objectForKey("subDir")?.stringByAppendingPathComponent("车辆配置-加装配置")
        
        let confImages = NSMutableArray()
        
        (ZGCImageDBManager().selectImages() as NSArray).enumerateObjectsUsingBlock({ (object, index, stop) -> Void in
            let imageModel = object as! Image
            
            ///不能直接打包文件夹，而需要通过设置newname为文件夹目录
            if FileManager.isExecutableFileAtPath(dir!) == true {
                
                let pathStr = imageModel.path! as NSString
                let zipStr =  pathStr.substringToIndex(pathStr.length - 3).stringByAppendingString("jpg")
                let name = NSString(string: "车辆配置-加装配置").stringByAppendingPathComponent((zipStr as NSString).lastPathComponent)
                let ret = zipArchive.addFileToZip(zipStr as String, newname:name)
                print(ret)
                
                confImages.addObject(name)
            }
            
            
        })
        
        let carImages = NSMutableDictionary()
        
        tabTitleArr.enumerateObjectsUsingBlock { (object, index, stop) -> Void in
            
            let tableName = String("\("T_ImageTwo")\(index)")
            
            let  dir = NSString(string: UserDefault.objectForKey("subDir")!.stringByAppendingString("/拍照列表")).stringByAppendingPathComponent(tabTitleArr[index] as! String)
            let array = NSMutableArray()
            (ZGCImageTwoDBManager().selectImages(tableName) as NSArray).enumerateObjectsUsingBlock({ (object, index, stop) -> Void in
                let imageModel = object as! Image
                ///不能直接打包文件夹，而需要通过设置newname为文件夹目录
                if FileManager.isExecutableFileAtPath(dir) == true {
                    
                    let pathStr = imageModel.path! as NSString
                    let zipStr =  pathStr.substringToIndex(pathStr.length - 3).stringByAppendingString("jpg")
                    let name = (tabTitleArr[index] as! NSString).stringByAppendingPathComponent((zipStr as NSString).lastPathComponent)
                    let ret = zipArchive.addFileToZip(zipStr, newname:name)
                    print(ret)
                    
                    let dic = ["path":name, "description":imageModel.instruction!, "location":imageModel.location!] as NSDictionary
                    array.addObject(dic)
                }
                
            })
            
            carImages.setObject(array, forKey: tabTitleArr[index] as! String)
            
        }
        
        zipArchive.CloseZipFile2()
        
        
        let carinfos = NSMutableArray()
        
        (ZGCConfigDBManager().selectConfigs() as NSArray).enumerateObjectsUsingBlock { (object, index, stop) -> Void in
            let config = object as! Config
            
            let dic = ["confitem":config.instruction!, "confitemtype":"", "confname":config.name!] as NSDictionary
            carinfos.addObject(dic)
        }
        
        
        
        let value = (ZGCillegalValueDBManager().selectValueOrIllegals() as NSArray).lastObject as! ValueOrIllegal
        
        let person = (ZGCPersonDBManager().selectPerson() as NSArray).lastObject as! Person
        
        let other = (ZGCOtherDBManager().selectOthers() as NSArray).lastObject as! Other
        
        let baseinfo = ["carinfoid":"", "type":person.type!,
            "owner":person.name!, "carnum":person.licenseNo!,
            "carnumtype":other.licenseTypeNum!, "mobile":person.phone!,
            "location":person.location!, "vin":person.vin!,
            "engine":person.engineNo!, "registerdate":person.regisDate!,
            "carspec":person.vehicleType!, "pailiang":person.vehicleEmiss!,
            "biansuqi":person.transmType!, "qudong":person.driveWay!,
            "ranyou":person.fuelType!, "productdate":person.manufacDate!,
            "huanbao":person.envirProStand!, "distance":person.mileage!,
            "carcolor":person.bodyColor!, "keynum":person.carKeys!,
            "carvalue":value.demandLoans!] as NSMutableDictionary
        
        let paramsDic = ["baseinfo":baseinfo, "carinfos":carinfos, "confImages":confImages, "carImages":carImages] as NSMutableDictionary
        
        
        var data:NSData!
        do {
            data = try NSJSONSerialization.dataWithJSONObject(paramsDic, options: .PrettyPrinted)
            
            //            let json = try NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments)
            //            print(json)
            
        }catch {
            
        }
        // MARK: - 登录
        Alamofire.upload(.POST, BaseURLString.stringByAppendingString("pingche/submit"), headers: ["token":UserDefault.objectForKey("token") as! String], multipartFormData: { multipartFormData in
            
            multipartFormData.appendBodyPart(data: data, name: "data")
            multipartFormData.appendBodyPart(fileURL: NSURL(fileURLWithPath: l_zipfile), name: "file")
            
            }, encodingMemoryThreshold: 0) { encodingResult in
                switch encodingResult {
                case .Success(let upload, _, _):
                    upload.responseJSON { response in
                        debugPrint(response)
                        if let json = response.result.value {
                            var success = false
                            if json.objectForKey("success") as! NSNumber == 1 {
                                success = true
                            }
                            if json.objectForKey("success") as! NSNumber == 1 {
                                
                                UserDefault.setObject("T_UnUpload", forKey: "tableName")
                                let unUpload = UnUpload(name: person.name, saveTime: GetCurrentDateTransformToDateStr(), state: "未上传", licenseNo: person.licenseNo , vehicleType: person.vehicleType, formatStr: "", itemId: "", databasePath:UserDefault.objectForKey("subDir") as? String)
                                ZGCUnUploadManager().deleteUnUpload(unUpload, tableName: "T_UnUpload")
                                
                                let toAudit = UnUpload(name: person.name, saveTime: GetCurrentDateTransformToDateStr(), state: "待审核", licenseNo: person.licenseNo , vehicleType: person.vehicleType, formatStr: "", itemId: json.objectForKey("data") as? String, databasePath:UserDefault.objectForKey("subDir") as? String)
                                
                                UserDefault.setObject("T_ToAudit", forKey: "tableName")
                                ZGCUnUploadManager().addUnUpload(toAudit, tableName: "T_ToAudit")
                            }
                            
                            self.requestDataHandler(isSuccess:success)

                        }
                        
                    }
                case .Failure(let encodingError):
                    print(encodingError)
                }
                
        }

        
    }
    
    
}


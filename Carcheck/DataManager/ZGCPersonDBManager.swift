//
//  ZGCPersonDBManager.swift
//  Carcheck
//
//  Created by GaoCheng.Zou on 16/3/1.
//  Copyright © 2016年 GaoCheng.Zou. All rights reserved.
//

import UIKit
import FMDB

class ZGCPersonDBManager: NSObject {
    
    let dbPath:String
    let dbBase:FMDatabase
    var uuid: String!
    
    
    // MARK: >> 单例化
    class func shareInstance() -> ZGCPersonDBManager{
        struct psSingle{
            static var onceToken:dispatch_once_t = 0;
            static var instance:ZGCPersonDBManager? = nil
        }
        //保证单例只创建一次
        dispatch_once(&psSingle.onceToken,{
            psSingle.instance = ZGCPersonDBManager()
        })
        return psSingle.instance!
    }
    
    
    // MARK: >> 创建数据库，打开数据库
    override init() {
        
        
        let documentsFolder = UserDefault.objectForKey("subDir") as! String

        let path = NSString(string: documentsFolder).stringByAppendingPathComponent("data".stringByAppendingString(".sqlite"))
                
        self.dbPath = path
        
        
        //创建数据库
        dbBase =  FMDatabase(path: path as String)
        
        //打开数据库
        if dbBase.open(){
            let createSql:String = "CREATE TABLE IF NOT EXISTS T_Person (id INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT, type TEXT,name TEXT,phone TEXT, licenseNo TEXT,location TEXT,vin TEXT, engineNo TEXT,regisDate TEXT,vehicleType TEXT, vehicleEmiss TEXT,transmType TEXT,driveWay TEXT, fuelType TEXT,manufacDate TEXT,licenseType TEXT,envirProStand TEXT, mileage TEXT,bodyColor TEXT,carKeys TEXT,pid TEXT)"
            if dbBase.executeUpdate(createSql, withArgumentsInArray: nil){
                print("数据库创建成功！")
            }else{
                print("数据库创建失败！failed:\(dbBase.lastErrorMessage())")
            }
        }else{
            print("Unable to open database!")
            
        }
        
    }
    
    
    
    // MARK: >> 增
    func addPerson(p:Person) {
        
        dbBase.open();
        
        let arr:[AnyObject] = [p.type!,p.name!,p.phone!,p.licenseNo!,p.location!,p.vin!,p.engineNo!,p.regisDate!,p.vehicleType!,p.vehicleEmiss!,p.transmType!,p.driveWay!,p.fuelType!,p.manufacDate!,p.licenseType!,p.envirProStand!,p.mileage!,p.bodyColor!,p.carKeys!, p.pid!];
        
        if !self.dbBase.executeUpdate("insert into T_Person (type ,name, phone,licenseNo, location, vin,engineNo, regisDate, vehicleType,vehicleEmiss, transmType, driveWay,fuelType, manufacDate,licenseType,envirProStand,mileage, bodyColor, carKeys, pid) values (?, ?, ?,?, ?, ?,?, ?, ?,?, ?, ?,?, ?, ?,?, ?,?, ?, ?)", withArgumentsInArray: arr) {
            print("添加1条数据失败！: \(dbBase.lastErrorMessage())")
        }else{
            print("添加1条数据成功！: \(p.carKeys)")
            
        }
        
        dbBase.close();
    }
    
    
    // MARK: >> 删
    func deletePerson(p:Person) {
        
        dbBase.open();
        
        if !self.dbBase.executeUpdate("delete from T_Person where pid = (?)", withArgumentsInArray: [p.pid!]) {
            print("删除1条数据失败！: \(dbBase.lastErrorMessage())")
        }else{
            print("删除1条数据成功！: \(p.pid)")
            
        }
        dbBase.close();
        
        
    }
    
    // MARK: >> 改
    func updatePerson(p:Person) {
        dbBase.open();
        
        let arr:[AnyObject] = [p.type!,p.name!,p.phone!,p.licenseNo!,p.location!,p.vin!,p.engineNo!,p.regisDate!,p.vehicleType!,p.vehicleEmiss!,p.transmType!,p.driveWay!,p.fuelType!,p.manufacDate!,p.licenseType!,p.envirProStand!,p.mileage!,p.bodyColor!,p.carKeys!, p.pid!];
        
        
        if !self.dbBase .executeUpdate("update T_Person set type = (?), name = (?),phone = (?),licenseNo = (?),location = (?),vin = (?),engineNo = (?),regisDate = (?),vehicleType = (?),vehicleEmiss = (?),transmType = (?),driveWay = (?),fuelType = (?),manufacDate = (?),licenseType = (?),envirProStand = (?),mileage = (?),bodyColor = (?), carKeys = (?) where pid = (?)", withArgumentsInArray:arr) {
            print("修改1条数据失败！: \(dbBase.lastErrorMessage())")
        }else{
            print("修改1条数据成功！: \(p.licenseType)")
            
        }
        dbBase.close();
        
    }
    
    // MARK: >> 查
    func selectPersons() -> NSArray {
        dbBase.open();
//        var persons=[Person]()
        var persons = NSArray()
        
        if let rs = dbBase.executeQuery("select type, name, phone,licenseNo, location, vin,engineNo, regisDate, vehicleType,vehicleEmiss, transmType, driveWay,fuelType, manufacDate, licenseType,envirProStand,mileage, bodyColor, carKeys, pid from T_Person", withArgumentsInArray: nil) {
            while rs.next() {
                
                let type:String = rs.stringForColumn("type") as String
                let name:String = rs.stringForColumn("name") as String
                let phone:String = rs.stringForColumn("phone") as String
                let licenseNo:String = rs.stringForColumn("licenseNo") as String
                let location:String = rs.stringForColumn("location") as String
                let vin:String = rs.stringForColumn("vin") as String
                let engineNo:String = rs.stringForColumn("engineNo") as String
                let regisDate:String = rs.stringForColumn("regisDate") as String
                let vehicleType:String = rs.stringForColumn("vehicleType") as String
                let vehicleEmiss:String = rs.stringForColumn("vehicleEmiss") as String
                let transmType:String = rs.stringForColumn("transmType") as String
                let driveWay:String = rs.stringForColumn("driveWay") as String
                let fuelType:String = rs.stringForColumn("fuelType") as String
                let manufacDate:String = rs.stringForColumn("manufacDate") as String
                let licenseType:String = rs.stringForColumn("licenseType") as String
                let envirProStand:String = rs.stringForColumn("envirProStand") as String
                let mileage:String = rs.stringForColumn("mileage") as String
                let bodyColor:String = rs.stringForColumn("bodyColor") as String
                let carKeys:String = rs.stringForColumn("carKeys") as String
                let pid:String = rs.stringForColumn("pid") as String

                
//                let p:Person = Person(type: type, name: name, phone: phone, licenseNo: licenseNo, location: location, vin: vin, engineNo: engineNo, regisDate: regisDate, vehicleType: vehicleType, vehicleEmiss: vehicleEmiss, transmType: transmType, driveWay: driveWay, fuelType: fuelType, manufacDate: manufacDate, envirProStand: envirProStand, mileage: mileage, bodyColor: bodyColor, carKeys: carKeys)
                persons = [type, name, phone, licenseNo, location, vin, engineNo, regisDate, vehicleType, vehicleEmiss, transmType, driveWay, fuelType, manufacDate, licenseType,envirProStand, mileage, bodyColor, carKeys, pid]
            }
        } else {
            
            print("查询失败 failed: \(dbBase.lastErrorMessage())")
            
        }
        dbBase.close();
        
        return persons
        
    }
    
    
    // MARK: >> 保证线程安全
    // TODO: 示例-增,查
    //FMDatabaseQueue这么设计的目的是让我们避免发生并发访问数据库的问题，因为对数据库的访问可能是随机的（在任何时候）、不同线程间（不同的网络回调等）的请求。内置一个Serial队列后，FMDatabaseQueue就变成线程安全了，所有的数据库访问都是同步执行，而且这比使用@synchronized或NSLock要高效得多。
    
    func safeaddPerson(p:Person){
        
        // 创建，最好放在一个单例的类中
        let queue:FMDatabaseQueue = FMDatabaseQueue(path: self.dbPath)
        
        queue.inDatabase { (db:FMDatabase!) -> Void in
            
            //You can do something in here...
            db.open();
            
            //增
            let arr:[AnyObject] = [p.type!,p.name!,p.phone!];
            
            if !self.dbBase.executeUpdate("insert into T_Person (type ,name, phone) values (?, ?, ?)", withArgumentsInArray: arr) {
                print("添加1条数据失败！: \(db.lastErrorMessage())")
            }else{
                print("添加1条数据成功！: \(p.type)")
                
            }
            //查
            if let rs = db.executeQuery("select type, name, phone from T_Person", withArgumentsInArray: nil) {
                while rs.next() {
                    //                    let type:String = rs.stringForColumn("type") as String
                    //                    let name:String = rs.stringForColumn("name") as String
                    //                    let phone:String = rs.stringForColumn("phone") as String
                    //                    let licenseNo:String = rs.stringForColumn("licenseNo") as String
                    //                    let location:String = rs.stringForColumn("location") as String
                    //                    let vin:String = rs.stringForColumn("vin") as String
                    //                    let engineNo:String = rs.stringForColumn("engineNo") as String
                    //                    let regisDate:String = rs.stringForColumn("regisDate") as String
                    //                    let vehicleType:String = rs.stringForColumn("vehicleType") as String
                    //                    let vehicleEmiss:String = rs.stringForColumn("vehicleEmiss") as String
                    //                    let transmType:String = rs.stringForColumn("transmType") as String
                    //                    let driveWay:String = rs.stringForColumn("driveWay") as String
                    //                    let fuelType:String = rs.stringForColumn("fuelType") as String
                    //                    let manufacDate:String = rs.stringForColumn("manufacDate") as String
                    //                    let envirProStand:String = rs.stringForColumn("envirProStand") as String
                    //                    let mileage:String = rs.stringForColumn("mileage") as String
                    //                    let bodyColor:String = rs.stringForColumn("bodyColor") as String
                    //                    let carKeys:String = rs.stringForColumn("carKeys") as String
                }
            } else {
                print("查询失败 failed: \(db.lastErrorMessage())")
            }
            db.close();
            
        }
    }
}



//
//  ZGCUnUploadManager.swift
//  Carcheck
//
//  Created by GaoCheng.Zou on 16/3/8.
//  Copyright © 2016年 GaoCheng.Zou. All rights reserved.
//

import UIKit
import FMDB

class ZGCUnUploadManager: NSObject {
    let dbPath:String
    let dbBase:FMDatabase
    var uuid: String!
    
    
    // MARK: >> 单例化
    class func shareInstance()->ZGCUnUploadManager{
        struct psSingle{
            static var onceToken:dispatch_once_t = 0;
            static var instance:ZGCUnUploadManager? = nil
        }
        //保证单例只创建一次
        dispatch_once(&psSingle.onceToken,{
            psSingle.instance = ZGCUnUploadManager()
        })
        return psSingle.instance!
    }
    
    
    // MARK: >> 创建数据库，打开数据库
    override init() {
            
        let path = NSString(string: DocumentsDirectory).stringByAppendingPathComponent("item".stringByAppendingString(".sqlite"))
        self.dbPath = path
        
        let tableName = UserDefault.objectForKey("tableName") as! String
        //创建数据库
        dbBase =  FMDatabase(path: path as String)
        
        //打开数据库
        if dbBase.open(){
            let createSql:String = "CREATE TABLE IF NOT EXISTS ".stringByAppendingString(tableName).stringByAppendingString(" (id INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT, name TEXT,saveTime TEXT, licenseNo TEXT,state TEXT, vehicleType TEXT, databasePath TEXT)")
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
    func addUnUpload(u:UnUpload, tableName:String) {
        
        dbBase.open();
        
        let arr:[AnyObject] = [u.name!, u.state!, u.saveTime!, u.vehicleType!, u.licenseNo!, u.databasePath!];
        
        if !self.dbBase.executeUpdate("insert into ".stringByAppendingString(tableName).stringByAppendingString("(name ,state, saveTime ,vehicleType, licenseNo, databasePath) values (?, ?, ?, ?, ?, ?)"), withArgumentsInArray: arr) {
            print("添加1条数据失败！: \(dbBase.lastErrorMessage())")
        }else{
            print("添加1条数据成功！: \(u.databasePath)")
            
        }
        
        dbBase.close();
    }
    
    
    // MARK: >> 删
    func deleteUnUpload(u:UnUpload, tableName:String) {
        
        dbBase.open();
        
        if !self.dbBase.executeUpdate("delete from ".stringByAppendingString(tableName).stringByAppendingString(" where databasePath = (?)"), withArgumentsInArray: [u.databasePath!]) {
            print("删除1条数据失败！: \(dbBase.lastErrorMessage())")
        }else{
            print("删除1条数据成功！: \(u.databasePath)")
            
        }
        dbBase.close();
        
        
    }
    
    // MARK: >> 改
    func updateUnUpload(u:UnUpload, tableName:String) {
        dbBase.open();
        
        let arr:[AnyObject] = [u.name!, u.state!, u.saveTime!, u.vehicleType!, u.licenseNo!, u.databasePath!];
        
        
        if !self.dbBase .executeUpdate("update ".stringByAppendingString(tableName).stringByAppendingString(" set name = (?), state = (?), saveTime = (?), vehicleType = (?), licenseNo = (?), databasePath = (?)"), withArgumentsInArray:arr) {
            print("修改1条数据失败！: \(dbBase.lastErrorMessage())")
        }else{
            print("修改1条数据成功！: \(u.databasePath)")
            
        }
        dbBase.close();
        
    }
    
    // MARK: >> 查
    func selectUnUploads(tableName:String) -> Array<UnUpload> {
        dbBase.open();
        var unUploads = [UnUpload]()
        
        if let rs = dbBase.executeQuery("select name ,state, saveTime ,vehicleType, licenseNo, databasePath from ".stringByAppendingString(tableName), withArgumentsInArray: nil) {
            while rs.next() {
                
                let name:String = rs.stringForColumn("name") as String
                let saveTime:String = rs.stringForColumn("saveTime") as String
                let state:String = rs.stringForColumn("state") as String
                let licenseNo:String = rs.stringForColumn("licenseNo") as String
                let vehicleType:String = rs.stringForColumn("vehicleType") as String
                let databasePath:String = rs.stringForColumn("databasePath") as String

                
                let c:UnUpload = UnUpload(name: name, saveTime: saveTime, state: state, licenseNo: licenseNo, vehicleType: vehicleType, databasePath: databasePath)
                unUploads.append(c)
            }
        } else {
            
            print("查询失败 failed: \(dbBase.lastErrorMessage())")
            
        }
        dbBase.close();
        
        return unUploads
        
    }
    
    
    // MARK: >> 保证线程安全
    // TODO: 示例-增,查
    //FMDatabaseQueue这么设计的目的是让我们避免发生并发访问数据库的问题，因为对数据库的访问可能是随机的（在任何时候）、不同线程间（不同的网络回调等）的请求。内置一个Serial队列后，FMDatabaseQueue就变成线程安全了，所有的数据库访问都是同步执行，而且这比使用@synchronized或NSLock要高效得多。
    
    func safeaddUnUpload(u:UnUpload, tableName:String){
        
        // 创建，最好放在一个单例的类中
        let queue:FMDatabaseQueue = FMDatabaseQueue(path: self.dbPath)
        
        queue.inDatabase { (db:FMDatabase!) -> Void in
            
            //You can do something in here...
            db.open();
            
            //增
            let arr:[AnyObject] = [u.name!, u.state!, u.saveTime!, u.vehicleType!, u.licenseNo!, u.databasePath!];
            
            if !self.dbBase.executeUpdate("insert into ".stringByAppendingString(tableName).stringByAppendingString(" (name ,state, saveTime ,vehicleType, licenseNo, databasePath) values (?, ?, ?, ?, ?, ?)"), withArgumentsInArray: arr) {
                print("添加1条数据失败！: \(db.lastErrorMessage())")
            }else{
                print("添加1条数据成功！: \(u.databasePath)")
                
            }
            //查
            if let rs = db.executeQuery("select name ,state, saveTime ,vehicleType, licenseNo, databasePath from ".stringByAppendingString(tableName), withArgumentsInArray: nil) {
                while rs.next() {
                    
                }
            } else {
                print("查询失败 failed: \(db.lastErrorMessage())")
            }
            db.close();
            
        }
    }

}

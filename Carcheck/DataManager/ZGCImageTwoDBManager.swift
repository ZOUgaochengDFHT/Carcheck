//
//  ZGCImageTwoDBManager.swift
//  Carcheck
//
//  Created by GaoCheng.Zou on 16/3/8.
//  Copyright © 2016年 GaoCheng.Zou. All rights reserved.
//

import UIKit
import FMDB

class ZGCImageTwoDBManager: NSObject {
    let dbPath:String
    let dbBase:FMDatabase
    var uuid: String!
    
    
    // MARK: >> 单例化
    class func shareInstance() -> ZGCImageTwoDBManager{
        struct psSingle{
            static var onceToken: dispatch_once_t = 0;
            static var instance: ZGCImageTwoDBManager? = nil
        }
        //保证单例只创建一次
        dispatch_once(&psSingle.onceToken,{
            psSingle.instance = ZGCImageTwoDBManager()
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
            let createSql:String = "CREATE TABLE IF NOT EXISTS T_ImageTwo (id INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT, path TEXT, pid TEXT)"
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
    func addImage(c:Image) {
        
        dbBase.open();
        
        let arr:[AnyObject] = [c.path!, c.pid!];
        
        if !self.dbBase.executeUpdate("insert into T_ImageTwo (path , pid) values (?, ?)", withArgumentsInArray: arr) {
            print("添加1条数据失败！: \(dbBase.lastErrorMessage())")
        }else{
            print("添加1条数据成功！: \(c.path)")
            
        }
        
        dbBase.close();
    }
    
    
    // MARK: >> 删
    func deleteImage(c:Image) {
        
        dbBase.open();
        
        if !self.dbBase.executeUpdate("delete from T_ImageTwo where pid = (?)", withArgumentsInArray: [c.pid!]) {
            print("删除1条数据失败！: \(dbBase.lastErrorMessage())")
        }else{
            print("删除1条数据成功！: \(c.pid)")
            
        }
        dbBase.close();
        
        
    }
    
    // MARK: >> 改
    func updateImage(c:Image) {
        dbBase.open();
        
        let arr:[AnyObject] = [c.path!, c.pid!];
        
        
        if !self.dbBase .executeUpdate("update T_ImageTwo set path = (?) where pid = (?)", withArgumentsInArray:arr) {
            print("修改1条数据失败！: \(dbBase.lastErrorMessage())")
        }else{
            print("修改1条数据成功！: \(c.pid)")
            
        }
        dbBase.close();
        
    }
    
    // MARK: >> 查
    func selectImages() -> Array<Image> {
        dbBase.open();
        var configs=[Image]()
        
        if let rs = dbBase.executeQuery("select path, pid from T_ImageTwo", withArgumentsInArray: nil) {
            while rs.next() {
                
                let path:String = rs.stringForColumn("path") as String
                let pid:String = rs.stringForColumn("pid") as String
                
                
                let c:Image = Image(path: path , pid: pid)
                configs.append(c)
            }
        } else {
            
            print("查询失败 failed: \(dbBase.lastErrorMessage())")
            
        }
        dbBase.close();
        
        return configs
        
    }
    
    
    // MARK: >> 保证线程安全
    // TODO: 示例-增,查
    //FMDatabaseQueue这么设计的目的是让我们避免发生并发访问数据库的问题，因为对数据库的访问可能是随机的（在任何时候）、不同线程间（不同的网络回调等）的请求。内置一个Serial队列后，FMDatabaseQueue就变成线程安全了，所有的数据库访问都是同步执行，而且这比使用@synchronized或NSLock要高效得多。
    
    func safeaddImage(c:Image){
        
        // 创建，最好放在一个单例的类中
        let queue:FMDatabaseQueue = FMDatabaseQueue(path: self.dbPath)
        
        queue.inDatabase { (db:FMDatabase!) -> Void in
            
            //You can do something in here...
            db.open();
            
            //增
            let arr:[AnyObject] = [c.path!, c.pid!];
            
            if !self.dbBase.executeUpdate("insert into T_ImageTwo (name ,instruction) values (?, ?)", withArgumentsInArray: arr) {
                print("添加1条数据失败！: \(db.lastErrorMessage())")
            }else{
                print("添加1条数据成功！: \(c.pid)")
                
            }
            //查
            if let rs = db.executeQuery("select name, instruction from T_ImageTwo", withArgumentsInArray: nil) {
                while rs.next() {
                    
                }
            } else {
                print("查询失败 failed: \(db.lastErrorMessage())")
            }
            db.close();
            
        }
    }

}

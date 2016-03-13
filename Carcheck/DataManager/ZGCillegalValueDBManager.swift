//
//  ZGCillegalValueDBManager.swift
//  Carcheck
//
//  Created by GaoCheng.Zou on 16/3/10.
//  Copyright © 2016年 GaoCheng.Zou. All rights reserved.
//


import UIKit
import FMDB

class ZGCillegalValueDBManager: NSObject {
    
    let dbPath:String
    let dbBase:FMDatabase
    var uuid: String!
    
    
    // MARK: >> 单例化
    class func shareInstance()->ZGCillegalValueDBManager{
        struct psSingle{
            static var onceToken:dispatch_once_t = 0;
            static var instance:ZGCillegalValueDBManager? = nil
        }
        //保证单例只创建一次
        dispatch_once(&psSingle.onceToken,{
            psSingle.instance = ZGCillegalValueDBManager()
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
            let createSql:String = "CREATE TABLE IF NOT EXISTS T_ValueOrIllegal (id INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT, illegalScore TEXT,illegalTimes TEXT,illegalPenalty TEXT, valueBad TEXT,valueNormal TEXT,valueGood TEXT, valueNew TEXT,demandLoans TEXT)"
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
    func addValueOrIllegal(c:ValueOrIllegal) {
        
        dbBase.open();
        
        /*self.illegalScore = illegalScore
        self.illegalTimes = illegalTimes
        self.illegalPenalty = illegalPenalty
        self.valueBad = valueBad
        self.valueNormal = valueNormal
        self.valueGood = valueGood
        self.valueNew = valueNew
        self.demandLoans = demandLoans*/
        
        let arr:[AnyObject] = [c.illegalScore!, c.illegalTimes!, c.illegalPenalty!, c.valueBad!, c.valueNormal!, c.valueGood!, c.valueNew!, c.demandLoans!];
        
        if !self.dbBase.executeUpdate("insert into T_ValueOrIllegal (illegalScore ,illegalTimes, illegalPenalty, valueBad ,valueNormal, valueGood, valueNew ,demandLoans) values (?, ?, ?, ?, ?, ?, ?, ?)", withArgumentsInArray: arr) {
            print("添加1条数据失败！: \(dbBase.lastErrorMessage())")
        }else{
            print("添加1条数据成功！: \(c.demandLoans)")
            
        }
        
        dbBase.close();
    }
    
    
    // MARK: >> 删
    func deleteValueOrIllegal(c:ValueOrIllegal)  {
        
        dbBase.open();
        
        if !self.dbBase.executeUpdate("delete from T_ValueOrIllegal where demandLoans = (?)", withArgumentsInArray: [c.demandLoans!]) {
            print("删除1条数据失败！: \(dbBase.lastErrorMessage())")
        }else{
            print("删除1条数据成功！: \(c.demandLoans)")
            
        }
        dbBase.close();
        
        
    }
    
    // MARK: >> 改
    func updateValueOrIllegal(c:ValueOrIllegal) {
        dbBase.open();
        
        let arr:[AnyObject] = [c.illegalScore!, c.illegalTimes!, c.illegalPenalty!, c.valueBad!, c.valueNormal!, c.valueGood!, c.valueNew!, c.demandLoans!];
        
        
        if !self.dbBase .executeUpdate("update T_ValueOrIllegal set illegalScore = (?), illegalTimes = (?), illegalPenalty = (?), valueBad = (?), valueNormal = (?), valueGood = (?), valueNew = (?) where demandLoans = (?)", withArgumentsInArray:arr) {
            print("修改1条数据失败！: \(dbBase.lastErrorMessage())")
        }else{
            print("修改1条数据成功！: \(c.demandLoans)")
            
        }
        dbBase.close();
        
    }
    
    // MARK: >> 查
    func selectValueOrIllegals() -> Array<ValueOrIllegal> {
        dbBase.open();
        var configs=[ValueOrIllegal]()
        
        if let rs = dbBase.executeQuery("select illegalScore ,illegalTimes, illegalPenalty, valueBad ,valueNormal, valueGood, valueNew ,demandLoans from T_ValueOrIllegal", withArgumentsInArray: nil) {
            while rs.next() {
                
                let illegalScore:String = rs.stringForColumn("illegalScore") as String
                let illegalTimes:String = rs.stringForColumn("illegalTimes") as String
                let illegalPenalty:String = rs.stringForColumn("illegalPenalty") as String
                let valueBad:String = rs.stringForColumn("valueBad") as String
                let valueNormal:String = rs.stringForColumn("valueNormal") as String
                let valueGood:String = rs.stringForColumn("valueGood") as String
                let valueNew:String = rs.stringForColumn("valueNew") as String
                let demandLoans:String = rs.stringForColumn("demandLoans") as String
                
                
                let c:ValueOrIllegal = ValueOrIllegal(illegalScore: illegalScore, illegalTimes: illegalTimes, illegalPenalty: illegalPenalty, valueBad: valueBad, valueNormal: valueNormal, valueGood: valueGood, valueNew: valueNew, demandLoans: demandLoans)
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
    
    func safeaddConfig(c:Config){
        
        // 创建，最好放在一个单例的类中
        let queue:FMDatabaseQueue = FMDatabaseQueue(path: self.dbPath)
        
        queue.inDatabase { (db:FMDatabase!) -> Void in
            
            //You can do something in here...
            db.open();
            
            //增
            let arr:[AnyObject] = [c.name!, c.instruction!, c.pid!];
            
            if !self.dbBase.executeUpdate("insert into T_ValueOrIllegal (name ,instruction) values (?, ?)", withArgumentsInArray: arr) {
                print("添加1条数据失败！: \(db.lastErrorMessage())")
            }else{
                print("添加1条数据成功！: \(c.pid)")
                
            }
            //查
            if let rs = db.executeQuery("select name, instruction from T_ValueOrIllegal", withArgumentsInArray: nil) {
                while rs.next() {
                    
                }
            } else {
                print("查询失败 failed: \(db.lastErrorMessage())")
            }
            db.close();
            
        }
    }
}

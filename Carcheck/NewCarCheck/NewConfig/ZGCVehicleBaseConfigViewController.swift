//
//  ZGCVehicleBaseConfigViewController.swift
//  Carcheck
//
//  Created by GaoCheng.Zou on 16/3/1.
//  Copyright © 2016年 GaoCheng.Zou. All rights reserved.
//

import UIKit
import Alamofire
class ZGCVehicleBaseConfigViewController: ZGCBaseViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var baseConfigTableView: UITableView!
    @IBOutlet weak var carTypeTitleLabel: UILabel!
    
    var pre2DModelArr = NSMutableArray()
    
    var sectionNameArr = NSMutableArray()
    
    var conDic: NSDictionary!

    let identifier = "ZGCBaseConfigTableViewCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "基础配置"
        baseConfigTableView.delegate = self
        baseConfigTableView.dataSource = self
        let cellNib:UINib = UINib(nibName: identifier, bundle: nil)
        baseConfigTableView.registerNib(cellNib, forCellReuseIdentifier: identifier)
        baseConfigTableView.tableFooterView = UIView()
        
        carTypeTitleLabel.text = UserDefault.objectForKey("brand")?.stringByAppendingString((UserDefault.objectForKey("model") as! String).stringByAppendingString(UserDefault.objectForKey("style") as! String))
        
        self.showLoadingStatusHUD("")
        
        Alamofire.request(.GET, BaseURLString.stringByAppendingString("brand/group"), parameters: nil, encoding: .JSON, headers: ["token" : UserDefault.objectForKey("token") as! String]).responseJSON {
            response in
            
            if let json = response.result.value {
                let dataArr = (json as! NSMutableDictionary).objectForKey("data") as! NSArray
                dataArr.enumerateObjectsUsingBlock({ (object, index, stop) -> Void in
                    self.sectionNameArr.addObject(object.objectForKey("Name")!)
                    
                    let fieldsModelArr = NSMutableArray()
                    
                    (object.objectForKey("Fields") as! NSArray).enumerateObjectsUsingBlock({ (object, index, stop) -> Void in
                        let fieldsModel = ZGCFieldsModel.init(contentWithDic: object as! [NSObject : AnyObject])
                        fieldsModelArr.addObject(fieldsModel)
                    })
                    
                    self.pre2DModelArr.addObject(fieldsModelArr.mutableCopy())
                })
                
            }
            
            let other = (ZGCOtherDBManager().selectOthers() as NSArray).lastObject as! Other
            

            
            Alamofire.request(.GET, BaseURLString.stringByAppendingString("brand/params?styleId=").stringByAppendingString(other.styleId! as String), parameters: nil, encoding: .JSON, headers: ["token" : UserDefault.objectForKey("token") as! String]).responseJSON {
                response in
                
                if let json = response.result.value {
                    let dataArr = (json as! NSMutableDictionary).objectForKey("data") as! NSArray
                    
                     self.conDic = dataArr.lastObject?.objectForKey("List")?.lastObject as! NSDictionary

                     self.baseConfigTableView.reloadData()

                    self.removeHUD()
                }
            }

        }
        
                // Do any additional setup after loading the view.
    }
    
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return self.sectionNameArr.count
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (self.pre2DModelArr[section] as! NSMutableArray).count
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
    
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.0001
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell:ZGCBaseConfigTableViewCell = tableView.dequeueReusableCellWithIdentifier(identifier, forIndexPath: indexPath) as! ZGCBaseConfigTableViewCell
        let arr = pre2DModelArr[indexPath.section] as! NSMutableArray
        let fieldsModel = arr[indexPath.row] as! ZGCFieldsModel
        cell.fieldsModel = fieldsModel
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        cell.conDic = self.conDic
        return cell
    }

    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        
        let titleLabel = UILabel()
        titleLabel.backgroundColor = UIColor(red: 241/255.0, green: 242/255.0, blue: 244/255.0, alpha: 1.0)
        titleLabel.text = "  ".stringByAppendingString((self.sectionNameArr[section] as? String)!)
        return titleLabel
    }

    

    override func initHomeButton() {
        self.initBackButton()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

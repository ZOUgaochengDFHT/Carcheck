//
//  ZGCNotUploadViewController.swift
//  Carcheck
//
//  Created by GaoCheng.Zou on 16/2/17.
//  Copyright © 2016年 GaoCheng.Zou. All rights reserved.
//

import UIKit

class ZGCNotUploadViewController: ZGCBaseViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var notUploadTableView: UITableView!
    
    var isFromBaseTabBar:Bool!
    
    var modelArr = NSMutableArray()
    
    var index:Int!
    
    let identifier = "ZGCNotUploadTableViewCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        notUploadTableView.delegate = self;
        notUploadTableView.dataSource = self;
        notUploadTableView.registerClass(ZGCNotUploadTableViewCell.self, forCellReuseIdentifier: identifier)
        notUploadTableView.tableFooterView = UIView()//去掉多余的cell分割线
        notUploadTableView.tableHeaderView?.backgroundColor = UIColor.whiteColor()
        
    
        let tableNameArr = ["T_UnUpload", "T_ToAudit", "T_UnPass", "T_Pass"]
        UserDefault.setObject(tableNameArr[index], forKey: "tableName")
        UserDefault.synchronize()
        
        let unUploadArr = ZGCUnUploadManager().selectUnUploads() as NSArray
        if unUploadArr.count > 0 {
            unUploadArr.enumerateObjectsUsingBlock({ (object, index, stop) -> Void in
                self.modelArr.addObject(object)
            })
        }
        
        notUploadTableView.reloadData()
        
        self.initBackButton()
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return modelArr.count
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 160  
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell:ZGCNotUploadTableViewCell = tableView.dequeueReusableCellWithIdentifier(identifier, forIndexPath: indexPath) as! ZGCNotUploadTableViewCell
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        cell.notuploadModel = modelArr[indexPath.section] as! UnUpload
        cell.tag = indexPath.section
        cell.contentView.backgroundColor = CellBgColor
        
        cell.uploadCarCheckMessageHandler = {(tag:Int, model:UnUpload) -> Void in
            let carValueDetailVC = ZGCCarValueDetailViewController()
            self.navigationController?.pushViewController(carValueDetailVC, animated: true)
        }
        
        return cell
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10
    }
    
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.0001
    }
    
    func tableView(tableView: UITableView, editingStyleForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCellEditingStyle {
        return UITableViewCellEditingStyle.Delete
    }
    
    func tableView(tableView: UITableView, titleForDeleteConfirmationButtonForRowAtIndexPath indexPath: NSIndexPath) -> String? {
        return "删除"
    }
    
    func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
        let notuploadModel = modelArr[indexPath.section] as! UnUpload
        let shareAction = UITableViewRowAction(style: UITableViewRowActionStyle.Default, title: "删除" , handler: { (action:UITableViewRowAction!, indexPath:NSIndexPath!) -> Void in
            
        })
        let rateAction = UITableViewRowAction(style: UITableViewRowActionStyle.Normal, title: "查看" , handler: { (action:UITableViewRowAction!, indexPath:NSIndexPath!) -> Void in
            UserDefault.setObject(notuploadModel.databasePath, forKey: "subDir")
            UserDefault.synchronize()
            let configDetailVC = ZGCCarValueDetailViewController()
            self.navigationController?.pushViewController(configDetailVC, animated: true)
        })
        shareAction.backgroundColor = ButtonBackGroundColor
    
        return [shareAction,rateAction]
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
//        self.attri2DArr.removeObjectAtIndex(indexPath.row)
//        vehicleConfigTableView.reloadData()
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

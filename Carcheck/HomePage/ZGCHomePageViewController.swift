//
//  ZGCHomePageViewController.swift
//  Carcheck
//
//  Created by GaoCheng.Zou on 16/2/14.
//  Copyright © 2016年 GaoCheng.Zou. All rights reserved.
//

import UIKit
import Alamofire

class ZGCHomePageViewController: ZGCBaseViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var homeTableView: UITableView!
    var staticsModel = ZGCStaticsModel()
    
    var attriArr = NSArray()
    
    let subArr = ["次", "辆", "辆", "", "秒"]
    
    let addImg = UIImage(named: "base_add")


    var addImgViewWidth: CGFloat!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "首页"
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), { () -> Void in
            
            let tableNameArr = ["T_UnUpload", "T_ToAudit", "T_UnPass", "T_Pass"] 
            
            (tableNameArr as NSArray).enumerateObjectsUsingBlock({ (object, index , stop) -> Void in
                UserDefault.setObject(object, forKey: "tableName")
                UserDefault.synchronize()
                let manager = ZGCUnUploadManager()
                print(manager)
            })
            
        })
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "networkDidRegister:", name: kJPFNetworkDidRegisterNotification, object: nil)



        
        addImgViewWidth = KScreenWidth/2 < (addImg?.size.width)! ? KScreenWidth/2 : (addImg?.size.width)!

        
        // Do any additional setup after loading the view.
        
        UserDefault.setObject("one", forKey: "sqlName")
        UserDefault.synchronize()
        
        homeTableView.delegate = self;
        homeTableView.dataSource = self;
        homeTableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
        homeTableView.tableFooterView = UIView()//去掉多余的cell分割线
        homeTableView.rowHeight = addImgViewWidth + 350
        homeTableView.separatorStyle = UITableViewCellSeparatorStyle.None
        
        
        self.showLoadingStatusHUD("数据加载中...")

        
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true

        Alamofire.request(.GET, BaseURLString.stringByAppendingString("pingche/statistic"), parameters: nil, encoding: .JSON, headers: ["token":UserDefault.objectForKey("token") as! String]).responseJSON {
            response in
            self.removeHUD()
            UIApplication.sharedApplication().networkActivityIndicatorVisible = false
            if let json = response.result.value {
                self.staticsModel = ZGCStaticsModel(contentWithDic: json as! [NSObject : AnyObject])
                if self.staticsModel.code == 200 && self.staticsModel.success == 1 {
                    let dic = self.staticsModel.data as NSDictionary
                    self.attriArr = [["pre":"累积采集次数：", "txt":String(dic.objectForKey("collect")!)], ["pre":"车辆通过数：", "txt":String(dic.objectForKey("pass")!)], ["pre":"车辆未通过数：", "txt":String(dic.objectForKey("unpass")!)], ["pre":"通过率：", "txt":String(dic.objectForKey("rate")!)], ["pre":"平均采集时间：", "txt":String(dic.objectForKey("avgtime")!)]]
                    self.homeTableView.reloadData()
                }
           }
        }
        
        
        
    }
    

    func networkDidRegister(notification:NSNotification) {
        print("RegistrationID\((notification.userInfo! as NSDictionary).objectForKey("RegistrationID"))")
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "cell")
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        
        let bgImg = UIImage(named: "base_bg")

        
        let iconImgView:UIImageView = UIImageView()
        iconImgView.frame = CGRectMake((KScreenWidth - (bgImg?.size.width)!)/2 > 0 ? (KScreenWidth - (bgImg?.size.width)!)/2 : 0 , 0, (bgImg?.size.width)! > KScreenWidth ? KScreenWidth : (bgImg?.size.width)!, (bgImg?.size.width)! > KScreenWidth ? (bgImg?.size.height)! * (KScreenWidth/(bgImg?.size.width)!) : (bgImg?.size.height)!)
        iconImgView.userInteractionEnabled = true
        cell.contentView.addSubview(iconImgView)
        iconImgView.image = bgImg
        
        let addBtn:UIButton = UIButton(type: UIButtonType.Custom)
        addBtn.frame = CGRectMake(KScreenWidth/2 < (addImg?.size.width)! ? KScreenWidth/4 : (KScreenWidth - (addImg?.size.width)!)/2, 100, addImgViewWidth, addImgViewWidth)
        addBtn.tag = 100
        addBtn.setImage(addImg, forState: UIControlState.Normal)
        cell.contentView.addSubview(addBtn)
        addBtn.addTarget(self, action: "addBtnAction", forControlEvents: UIControlEvents.TouchUpInside)
      
        
        if attriArr.count > 0 {
            
            let titLabel = UILabel.init(frame: CGRectMake(0, addBtn.bottom + 50, KScreenWidth, 20))
            titLabel.font = UIFont.systemFontOfSize(20.0)
            titLabel.textAlignment = NSTextAlignment.Center
            titLabel.text = "我的工作统计"
            cell.contentView.addSubview(titLabel);
            
            attriArr.enumerateObjectsUsingBlock { (object, index, stop) -> Void in
                
                let attriDic = self.attriArr[index]
                
                let preLabel = UILabel.init(frame: CGRectMake(0, titLabel.bottom + 30 + 30 * CGFloat(index), KScreenWidth/2, 20))
                preLabel.font = UIFont.systemFontOfSize(15.0)
                preLabel.textAlignment = NSTextAlignment.Right
                preLabel.text = attriDic.objectForKey("pre") as? String
                cell.contentView.addSubview(preLabel);
                
                let txtLabel = UILabel.init(frame: CGRectMake(KScreenWidth/2, preLabel.top, KScreenWidth/2, 20))
                txtLabel.font = UIFont.systemFontOfSize(15.0)
                txtLabel.text = (attriDic.objectForKey("txt") as! String).stringByAppendingString(self.subArr[index])
                cell.contentView.addSubview(txtLabel);
            }
        }
        return cell
    }
    

    func addBtnAction() {
        let addCarCheckVC = ZGCAddCarCheckViewController()
        addCarCheckVC.isCreateNew = true
        addCarCheckVC.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(addCarCheckVC, animated: true)
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

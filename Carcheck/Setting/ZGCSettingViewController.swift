//
//  ZGCSettingViewController.swift
//  Carcheck
//
//  Created by GaoCheng.Zou on 16/2/14.
//  Copyright © 2016年 GaoCheng.Zou. All rights reserved.
//

import UIKit
import Alamofire
import SDWebImage
class ZGCSettingViewController: ZGCBaseViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var settingListTableView: UITableView!
    
    var infoModel: ZGCInfoModel!
    
    var attriArr = NSArray()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "设置"

        self.view.backgroundColor = UIColor.whiteColor()
        // Do any additional setup after loading the view.
        
        settingListTableView.delegate = self;
        settingListTableView.dataSource = self;
        settingListTableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
        settingListTableView.separatorStyle = UITableViewCellSeparatorStyle.None
        settingListTableView.tableFooterView = UIView()//去掉多余的cell分割线
        settingListTableView.backgroundColor = UIColor.clearColor()
        
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        // MARK: -
        self.showLoadingStatusHUD("数据加载中...")

        Alamofire.request(.GET, BaseURLString.stringByAppendingString("user/info"), parameters: nil, encoding: .JSON, headers: ["token":UserDefault.objectForKey("token") as! String]).responseJSON { (response) -> Void in
            UIApplication.sharedApplication().networkActivityIndicatorVisible = false
            self.removeHUD()
            let json = response.result.value
            
            print(json)
            let staticsModel = ZGCStaticsModel(contentWithDic: json as! [NSObject : AnyObject])

            if staticsModel.code == 0 && staticsModel.success == 1 {

                self.infoModel = ZGCInfoModel.init(contentWithDic: staticsModel.data as [NSObject : AnyObject])
                
                self.attriArr = [["pre":"用户姓名：", "content":self.infoModel.name], ["pre":"所属门店：", "content":self.infoModel.departmentName], ["pre":"员工级别：", "content":self.infoModel.roleName]]
                
                self.settingListTableView.reloadData()
            }
            
        }
        
 
        
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 240
        }
        return 40
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "cell")
        
        if attriArr.count > 0 {
            if indexPath.row == 0 {
                

                let settingPortraitImg = UIImage(named: "setting_portrait")
                let iconImgView = UIImageView.init(frame: CGRectMake((KScreenWidth - (settingPortraitImg?.size.width)!)/2, (240 - (settingPortraitImg?.size.height)!)/2, (settingPortraitImg?.size.width)!, (settingPortraitImg?.size.height)!))
                iconImgView.sd_setImageWithURL(NSURL(string: self.infoModel.img), placeholderImage: nil)
                cell.contentView.addSubview(iconImgView)
            }else {
                let attriDic = attriArr[indexPath.row - 1]
                
                let preLabel = UILabel.init(frame: CGRectMake(40, 10, 80, 20))
                preLabel.font = UIFont.systemFontOfSize(14.0)
                preLabel.text = attriDic.objectForKey("pre") as? String
                cell.contentView.addSubview(preLabel);
                
                let txtLabel = UILabel.init(frame: CGRectMake(120, 10, 100, 20))
                txtLabel.font = UIFont.systemFontOfSize(14.0)
                txtLabel.text = attriDic.objectForKey("content") as? String
                cell.contentView.addSubview(txtLabel);
            }
        }
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        return cell
    }
    
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.001
    }
    
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 130
    }
    
    
    func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let bgView = UIView()
        bgView.backgroundColor = UIColor.whiteColor()
        let submitBtn:UIButton = UIButton(type: UIButtonType.Custom)
        submitBtn.layer.cornerRadius = 8.0
        submitBtn.backgroundColor = ButtonBackGroundColor
        submitBtn.setTitle("修改密码", forState:UIControlState.Normal)
        submitBtn.clipsToBounds = true
        submitBtn.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        submitBtn.titleLabel?.font = UIFont.systemFontOfSize(15.0)
        submitBtn.frame = CGRectMake(40, 10, KScreenWidth-80, 49)
        submitBtn.tag = 100
        bgView.addSubview(submitBtn)
        
        submitBtn.addTarget(self, action: "btnAction:", forControlEvents: UIControlEvents.TouchUpInside)
        
        let exitBtn:UIButton = UIButton(type: UIButtonType.Custom)
        exitBtn.layer.cornerRadius = 8.0
        exitBtn.backgroundColor = ButtonBackGroundColor
        exitBtn.setTitle("退出账号", forState:UIControlState.Normal)
        exitBtn.clipsToBounds = true
        exitBtn.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        exitBtn.titleLabel?.font = UIFont.systemFontOfSize(15.0)
        exitBtn.frame = CGRectMake(40, 70, KScreenWidth-80, 49)
        exitBtn.tag = 101
        bgView.addSubview(exitBtn)
        
        exitBtn.addTarget(self, action: "btnAction:", forControlEvents: UIControlEvents.TouchUpInside)
        return bgView
    }
    
    func btnAction(btn:UIButton) {
        if btn.tag == 100 {
            let passwordChangeVC = ZGCPWDChangeViewController()
            passwordChangeVC.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(passwordChangeVC, animated: true)
        }else {
            let loginVC = ZGCLoginViewController()
            self.view.window?.rootViewController = loginVC
        }
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

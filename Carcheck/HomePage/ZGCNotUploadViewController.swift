//
//  ZGCNotUploadViewController.swift
//  Carcheck
//
//  Created by GaoCheng.Zou on 16/2/17.
//  Copyright © 2016年 GaoCheng.Zou. All rights reserved.
//

import UIKit
import Alamofire
class ZGCNotUploadViewController: ZGCBaseViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var notUploadTableView: UITableView!
    
    var isFromBaseTabBar:Bool!
    
    var modelArr = NSMutableArray()
    
    var index:Int!
    
    let identifier = "ZGCNotUploadTableViewCell"
    
    let tableNameArr = ["T_UnUpload", "T_ToAudit", "T_UnPass", "T_Pass"]
    
    var page: Int = 1
    var status: String = ""
    var keyword: String = ""
    
    var searchBar: CustomSearchBar!
    
    var emptyImgView: UIImageView!
    
    var unUploadArr: NSArray!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        notUploadTableView.delegate = self;
        notUploadTableView.dataSource = self;
        notUploadTableView.registerClass(ZGCNotUploadTableViewCell.self, forCellReuseIdentifier: identifier)
        notUploadTableView.tableFooterView = UIView()//去掉多余的cell分割线
        notUploadTableView.tableHeaderView?.backgroundColor = UIColor.whiteColor()
        
        UserDefault.setObject(tableNameArr[index], forKey: "tableName")
        UserDefault.synchronize()
        
        self.status = Util.getNumWithStatus(Int32(index))
        
        if index != 0 {
            self.requestData(String(self.page), status: self.status, keyWord: self.keyword)
        }else {
           self.reloadUnUploadData()
        }
        
        
        self.initBackButton()
        
        self.initCustomSearchBar()
    }
    
    override func initDismissKeyboardTap() {
        
    }
    
    override func backButtonClicked() {
        self.navigationController?.popToRootViewControllerAnimated(true)
    }
    
    func reloadUnUploadData () {
        self.modelArr.removeAllObjects()
        
        unUploadArr = ZGCUnUploadManager().selectUnUploads(tableNameArr[index]) as NSArray
        if unUploadArr.count > 0 {
            unUploadArr.enumerateObjectsUsingBlock({ (object, index, stop) -> Void in
                self.modelArr.addObject(object)
            })
        }else {
            self.initEmptyImageView()
        }
        
        notUploadTableView.reloadData()

    }
    
    func requestData (page:String, status:String, keyWord:String) {
        
        let paramDic = ["page":page, "status":status, "keyword":keyWord]
        
        Alamofire.request(.POST, BaseURLString.stringByAppendingString("pingche/searchlist"), parameters: paramDic, encoding: .JSON, headers: ["token":UserDefault.objectForKey("token") as! String]).responseJSON {response in
            
            if let json = response.result.value {
                if json.objectForKey("success") as! NSNumber == 1 {
                    (json.objectForKey("data") as! NSArray).enumerateObjectsUsingBlock({ (object, index, stop) -> Void in
                        let itemListModel = ZGCItemListModel(contentWithDic: object as! [NSObject : AnyObject])
                        self.modelArr.addObject(itemListModel)
                    })
                    
                    
                    if self.modelArr.count == 0 {
                        self.initEmptyImageView()
                    }else {
                        if self.emptyImgView != nil {
                            self.emptyImgView.removeFromSuperview()
                        }
                    }
                    self.notUploadTableView.reloadData()
                    
                }
                
            }
        }
    }
    
    func initEmptyImageView () {
        let emptyImg = UIImage(named: "ic_empty")
        let emptyWidth = emptyImg?.size.width
        
        emptyImgView = UIImageView()
        emptyImgView.frame = CGRectMake((KScreenWidth - emptyWidth!)/2, (KScreenHeight - NavAndStausHeight - emptyWidth!)/2, emptyWidth!, emptyWidth!)
        self.view.addSubview(emptyImgView)
        emptyImgView.image = emptyImg
        
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
        cell.tag = indexPath.section
        cell.index = index
        if index == 0 {
            cell.notuploadModel = modelArr[indexPath.section] as! UnUpload
        }else {
            cell.itemListModel = modelArr[indexPath.section] as! ZGCItemListModel
        }
        cell.contentView.backgroundColor = CellBgColor
        
        cell.uploadCarCheckMessageHandler = {(tag:Int, model:UnUpload) -> Void in
            if ZGCillegalValueDBManager().selectValueOrIllegals().count == 0 {
                
            }
            let value = (ZGCillegalValueDBManager().selectValueOrIllegals() as NSArray).lastObject as! ValueOrIllegal
            if value.demandLoans == "" {
                self.showHUD("请填写贷款需求再上传", image: UIImage(), withHiddenDelay: 1.0)
                return
            }else {
                self.showLoadingStatusHUD("数据上传中...")
                let uploadData = ZGCUploadDataManager()
                uploadData.requestDataHandler = {
                    (isSuccess:Bool) -> Void in
                    self.removeHUD()
                    if isSuccess == true {
                        self.showHUD("数据上传成功！", image: UIImage(), withHiddenDelay: 1.0)
                        self.reloadUnUploadData()
                    }else {
                        self.showHUD("数据上传失败！请检查网络！", image: UIImage(), withHiddenDelay: 1.0)
                    }
                }
            }
        }
        
        cell.checkOrChangeDetailHandler = {
            (tag:Int, model:ZGCItemListModel) -> Void in
            let unUploadArr = ZGCUnUploadManager().selectUnUploads(self.tableNameArr[self.index]) as NSArray
            if unUploadArr.count > 0 {
                unUploadArr.enumerateObjectsUsingBlock({ (object, index, stop) -> Void in
                    let shouldStop:ObjCBool = true
                    let unUploadModel = object as! UnUpload
                    if unUploadModel.itemId == model.itemID {
                        UserDefault.setObject(unUploadModel.databasePath, forKey: "subDir")
                        UserDefault.synchronize()
                        let configDetailVC = ZGCCarValueDetailViewController()
                        if index != 2 {
                            configDetailVC.isEditingOrNot = false
                        }
                        self.navigationController?.pushViewController(configDetailVC, animated: true)
                        stop.initialize(shouldStop)
                    }
                })
            }

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
        if index == 0 {
            let shareAction = UITableViewRowAction(style: UITableViewRowActionStyle.Default, title: "删除" , handler: { (action:UITableViewRowAction!, indexPath:NSIndexPath!) -> Void in
                
                self.deleteCellAction(indexPath.section)
                
            })
            
            shareAction.backgroundColor = ButtonBackGroundColor
            
            return [shareAction]

        }else {
            return []
        }
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        self.deleteCellAction(indexPath.section)
    }
    
    func deleteCellAction (index:Int) {
        let notuploadModel = self.modelArr[index] as! UnUpload
        
        ZGCUnUploadManager().deleteUnUpload(notuploadModel, tableName: self.tableNameArr[self.index])
        
        self.modelArr.removeObjectAtIndex(index)
        
        self.notUploadTableView.reloadData()
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if index == 0 {
            let notuploadModel = modelArr[indexPath.section] as! UnUpload
            UserDefault.setObject(notuploadModel.databasePath, forKey: "subDir")
            UserDefault.synchronize()
            let configDetailVC = ZGCCarValueDetailViewController()
            configDetailVC.isEditingOrNot = false
            self.navigationController?.pushViewController(configDetailVC, animated: true)
        }
    }

    
    func initCustomSearchBar () {
        
        searchBar = CustomSearchBar(frame: CGRectMake(0, 0, KScreenWidth*5/16, 30))
        searchBar.setPlaceholder("", tintColor: ButtonBackGroundColor, sel: "customSearchBarVoiceButtonClicked", target: self)

        let btn = UIBarButtonItem(customView: searchBar)
        let negativeSpacer = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FixedSpace, target: nil, action: nil)
        negativeSpacer.width = -10
        self.navigationItem.rightBarButtonItems = [negativeSpacer, btn]
        
        
        searchBar.searchBtnHandler = {
            (searchStr:String) -> Void in
            self.loadDataBySearchCondition(searchStr)

        }
    }
    
    func loadDataBySearchCondition (searchStr:String) {
        self.modelArr.removeAllObjects()
        if index != 0 {
            self.requestData("0", status: self.status, keyWord: searchStr)
        }else {
            let resultArr = NSMutableArray()
            if searchStr != "" {
                if ChineseInclude.isIncludeChineseInString(searchStr) == false {
                    unUploadArr.enumerateObjectsUsingBlock({ (object, index, stop) -> Void in
                        let unUploadModel = object as! UnUpload
                        let contentStr = "\(unUploadModel.name)\(unUploadModel.licenseNo)\(unUploadModel.vehicleType)"
                        if ChineseInclude.isIncludeChineseInString(contentStr) {
                            let tempPinYinStr:NSString = PinYinForObjc.chineseConvertToPinYin(contentStr)
                            let titleResult:NSRange = tempPinYinStr.rangeOfString(searchStr, options: NSStringCompareOptions.CaseInsensitiveSearch)
                            if titleResult.length > 0 {
                                resultArr.addObject(unUploadModel)
                            }
                            
                            let tempPinYinHeadStr:NSString = PinYinForObjc.chineseConvertToPinYinHead(contentStr)
                            let titleHeadResult:NSRange = tempPinYinHeadStr.rangeOfString(searchStr, options: NSStringCompareOptions.CaseInsensitiveSearch)
                            if titleHeadResult.length > 0 {
                                resultArr.addObject(unUploadModel)
                            }
                        }else {
                            let titleResult:NSRange = NSString(string: contentStr).rangeOfString(searchStr, options: NSStringCompareOptions.CaseInsensitiveSearch)
                            if titleResult.length > 0 {
                                resultArr.addObject(unUploadModel)
                            }
                        }
                        
                    })
                }
                self.modelArr = resultArr.mutableCopy() as! NSMutableArray
                notUploadTableView.reloadData()
            }else {
                self.reloadUnUploadData()
            }
            
          
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        self.view.endEditing(true)
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

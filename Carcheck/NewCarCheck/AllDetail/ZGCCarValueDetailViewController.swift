//
//  ZGCCarValueDetailViewController.swift
//  Carcheck
//
//  Created by GaoCheng.Zou on 16/2/17.
//  Copyright © 2016年 GaoCheng.Zou. All rights reserved.
//

import UIKit
import Alamofire

class ZGCCarValueDetailViewController: ZGCBaseViewController, UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate,  UITextFieldDelegate {
    
    var carBaseScrollView: ZGCCarBaseScrollView!
    @IBOutlet weak var photosListTableView: UITableView!
    var totalStoreImgArr = NSMutableArray()
    var array3D = NSMutableArray()
    var rightBtn:UIButton!
    var permitEditing = false
    
    let identifier = "ZGCPhotosListTableViewCell"
    var deleteOrAddImgArr = NSMutableArray()
    var photoDeleteBarView: ZGCPhotoDeleteBarView!
    
    var configDetailScrollView: ZGCVehicleConfigDetailScrollView!
    
    var configDetailTableView: ZGCConfigDetailTableView!
    var allTotalCount = 0
    
    var rightTextField: UITextField!
    
    var picturesArr = NSMutableArray()
    var attri2DArr = NSMutableArray()
    var array2D = NSMutableArray()
    
    var tabTitleArr = ["车辆正面车主合照","左前45度","左后45度","右后45度","右前45度"] as NSArray

    
    let preTitleArr = ["业务类型", "车主姓名", "联系方式", "车牌号", "车辆所在地", "车辆VIN码", "发动机号", "注册日期", "车辆型号", "车辆排量", "变速器类型", "驱动方式", "燃油类型", "出厂日期", "车牌类型", "环保标准", "行驶里程", "车身颜色", "车钥匙"] as NSArray

    override func viewDidLoad() {
        super.viewDidLoad()
        
        UserDefault.setObject(preTitleArr, forKey: "baseInfoPreTitleArr")
        UserDefault.synchronize()
        
        self.initHomeButton()
        
        let customTitleView = UIView(frame: CGRectMake(0, 0, KScreenWidth*2/3, 44))
        
        let titleLabel = UILabel(frame: CGRectMake(0, 0, KScreenWidth*2/3, 21))
        titleLabel.text = "详情估值"
        titleLabel.textAlignment = NSTextAlignment.Center
        customTitleView.addSubview(titleLabel)
        titleLabel.textColor = UIColor.whiteColor()

        
        let itemsArr = ["基本信息", "照片列表", "车辆配置"]
        let segmentedControl = UISegmentedControl.init(items: itemsArr)
        segmentedControl.frame = CGRectMake(0, titleLabel.bottom,  KScreenWidth*2/3, 21)
        segmentedControl.tintColor = UIColor.whiteColor()
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.addTarget(self, action: "segmentedControlIndexChange:", forControlEvents: UIControlEvents.ValueChanged)
        customTitleView.addSubview(segmentedControl)
        
        self.navigationItem.titleView = customTitleView
        
        self.initRightBtn()
        

//        self.getSqliteOrDocumentsData()
        
        photosListTableView.delegate = self
        photosListTableView.dataSource = self
        photosListTableView.registerClass(ZGCPhotosListTableViewCell.self, forCellReuseIdentifier: identifier)
        photosListTableView.rowHeight = (KScreenWidth - 40)/3 + 10
        photosListTableView.tableFooterView = UIView()
        photosListTableView.hidden = true
        photosListTableView.separatorStyle = UITableViewCellSeparatorStyle.None
        photosListTableView.delaysContentTouches = false
        
        
        
        carBaseScrollView = ZGCCarBaseScrollView.init(frame: CGRectMake(0, 49, KScreenWidth, KScreenHeight - NavAndStausHeight - 98), tar:self, sel:"tapAction:")
        carBaseScrollView.backgroundColor = UIColor.clearColor()
        self.view.addSubview(carBaseScrollView)
        carBaseScrollView.delegate = self
        

        
        configDetailTableView = ZGCConfigDetailTableView(frame: CGRectMake(0, carBaseScrollView.top, KScreenWidth, carBaseScrollView.height), style: UITableViewStyle.Plain)
        configDetailTableView.tar = self
        configDetailTableView.sel = "tapAction:"
        self.configDetailTableView.array2D = array2D
        self.configDetailTableView.attri2DArr = attri2DArr
        configDetailTableView.hidden = true
        self.view.addSubview(configDetailTableView)
        
        self.initUpOrNextView(NSArray(), imgArr: ["detail_save", "detail_upload"])
        
        let bgView = UIView(frame: CGRectMake(0, 0, KScreenWidth, 49))
        bgView.backgroundColor = UIColor(red: 89/255.0, green: 79/255.0, blue: 77/255.0, alpha: 1.0)
        self.view.addSubview(bgView)
        
        let preTitleLabel = UILabel()
        preTitleLabel.frame = CGRectMake(0 , 3, (KScreenWidth-20)/4, 43)
        preTitleLabel.font = UIFont.systemFontOfSize(13.0)
        preTitleLabel.backgroundColor = UIColor.clearColor()
        preTitleLabel.textAlignment = NSTextAlignment.Right
        preTitleLabel.textColor = UIColor.whiteColor()
        preTitleLabel.text = "贷款需求"
        bgView.addSubview(preTitleLabel)
        
        
        rightTextField = UITextField.init(frame: CGRectMake(preTitleLabel.right + 10, preTitleLabel.top, (KScreenWidth - 20)/2, preTitleLabel.height))
        rightTextField.delegate = self
        rightTextField.borderStyle = UITextBorderStyle.None
        rightTextField.layer.borderColor = UIColor(red: 212/255.0, green: 213/255.0, blue: 213/255.0, alpha: 1.0).CGColor
        rightTextField.layer.borderWidth = 1.0
        rightTextField.layer.cornerRadius = 8.0
        rightTextField.tintColor = UIColor.whiteColor()
        rightTextField.textColor = UIColor.whiteColor()
        rightTextField.returnKeyType = UIReturnKeyType.Done
        bgView.addSubview(rightTextField)
        
        
        let suffixTitleLabel = UILabel()
        suffixTitleLabel.frame = CGRectMake(rightTextField.right + 10 , rightTextField.top, (KScreenWidth - 20)/4, preTitleLabel.height)
        suffixTitleLabel.font = UIFont.systemFontOfSize(13.0)
        suffixTitleLabel.backgroundColor = UIColor.clearColor()
        suffixTitleLabel.textColor = UIColor.whiteColor()
        suffixTitleLabel.text = "万元"
        bgView.addSubview(suffixTitleLabel)

        
        (ZGCImageTwoDBManager().selectImages() as NSArray).enumerateObjectsUsingBlock({ (object, index, stop4) -> Void in
            let image = object as! Image
            print(image.path!)
        })
        
        
        
        // Do any additional setup after loading the view.
    }
    
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        self.attri2DArr.removeAllObjects()
        self.picturesArr.removeAllObjects()
        self.getSqliteOrDocumentsData()
    }
    
    func getSqliteOrDocumentsData () {
        (ZGCConfigDBManager().selectConfigs() as NSArray).enumerateObjectsUsingBlock { (object, index, stop) -> Void in
            let config = object as! Config
            let attriArr = NSMutableArray()
            attriArr.addObject(config.name!)
            attriArr.addObject(config.instruction!)
            self.attri2DArr.addObject(attriArr.mutableCopy())
        }
        
        let dir = UserDefault.objectForKey("subDir")?.stringByAppendingPathComponent("车辆配置-加装配置")
        
        if FileManager.isExecutableFileAtPath(dir!) {
            
            (ZGCImageDBManager().selectImages() as NSArray).enumerateObjectsUsingBlock({ (object, index, stop) -> Void in
                let image = object as! Image
                print(image.path)
                let aImage = UIImage(named: image.path!)
                self.picturesArr.addObject(aImage!)
                
            })
            
            self.createArray2D()
//            if self.picturesArr.count > 1 {
//                self.rightBtn.hidden = false
//            }else {
//                self.rightBtn.hidden = true
//            }
            
        }
        
        
        if totalStoreImgArr.count > 0 {
            self.createArray3D()
        }else {
            
            self.tabTitleArr.enumerateObjectsUsingBlock { (object, index, stop) -> Void in
                let dir = NSString(string: UserDefault.objectForKey("subDir")!.stringByAppendingString("/拍照列表")).stringByAppendingPathComponent(object as! String)
                
                if FileManager.isExecutableFileAtPath(dir) {
                    self.rightBtn.hidden = false
                    let currentDirArr:NSArray!
                    do {
                        try currentDirArr = FileManager.contentsOfDirectoryAtPath(dir)
                        
                        let currentStoreImgArr = NSMutableArray()
                        
                        currentDirArr.enumerateObjectsUsingBlock({ (object, index, stop) -> Void in
                            let image = UIImage(named: dir.stringByAppendingString("/").stringByAppendingString(object as! String))
                            print(dir.stringByAppendingString("/").stringByAppendingString(object as! String))
                            currentStoreImgArr.addObject(image!)
                        })
                        
                        self.totalStoreImgArr.addObject(currentStoreImgArr)
                    } catch let error as NSError {
                        NSLog("\(error.localizedDescription)")
                    }
                }else {
                    self.totalStoreImgArr.addObject(NSMutableArray())
                }
            }
            self.createArray3D()
        }

    }
    
    func initRightBtn() {
        rightBtn = UIButton(type: UIButtonType.Custom)
        rightBtn.frame = CGRectMake(0, 0, 40, 30)
        rightBtn.setTitle("选择", forState: UIControlState.Normal)
        rightBtn.titleLabel?.font = UIFont.systemFontOfSize(15.0)
        rightBtn.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        rightBtn.backgroundColor = UIColor.clearColor()
        rightBtn.hidden = true

        rightBtn.addTarget(self, action: Selector("rightButtonClicked:"), forControlEvents: UIControlEvents.TouchUpInside)
        let btn = UIBarButtonItem(customView: rightBtn)
        let negativeSpacer = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FixedSpace, target: nil, action: nil)
        negativeSpacer.width = -10
        self.navigationItem.rightBarButtonItems = [negativeSpacer, btn]
    }
    
    func rightButtonClicked (btn:UIButton) {
        if btn.titleLabel?.text == "选择" {
            btn.setTitle("取消", forState: UIControlState.Normal)
            permitEditing = true
            if photoDeleteBarView == nil {
                photoDeleteBarView = ZGCPhotoDeleteBarView(frame: CGRectMake(0, KScreenHeight - NavAndStausHeight, KScreenHeight, 49), target: self, sel: "tapAction:")
                self.view.addSubview(photoDeleteBarView)
            }
            photoDeleteBarView.show()
        }else {
            btn.setTitle("选择", forState: UIControlState.Normal)
            permitEditing = false
            photoDeleteBarView.hidden()
            self.deleteOrAddImgArr.removeAllObjects()
        }
        photosListTableView.reloadData()
    }
    
    override func backButtonClicked() {
        super.backButtonClicked()
    }
    
    func segmentedControlIndexChange(segmentedControl:UISegmentedControl) {
        switch segmentedControl.selectedSegmentIndex {
        case 0:
            configDetailTableView.hidden = true
            carBaseScrollView.hidden = false
            photosListTableView.hidden = true
            rightBtn.hidden = true
            break
        case 1:
            configDetailTableView.hidden = true
            photosListTableView.hidden = false
            carBaseScrollView.hidden = true
            if self.totalStoreImgArr.count > 0 {
                rightBtn.hidden = false
            }else {
                rightBtn.hidden = true
            }
            break
        case 2:
            configDetailTableView.hidden = false
            carBaseScrollView.hidden = true
            rightBtn.hidden = true
            if photosListTableView != nil {
                photosListTableView.hidden = true
            }   
            break
        default:
            break
        }
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
//        return 1
        return tabTitleArr.count
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var count:Int!
        if totalStoreImgArr.count == 0 {
            count = 0
        }else {
            let array = totalStoreImgArr[section] as! NSMutableArray
            count = array.count/3
            if array.count == 0 {
                count = 0
            }else {
                if array.count%3 > 0 {
                    count = count + 1
                }
            }
        }
   
        return count
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
    
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.0001
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        
        let titleLabel = UILabel(frame: CGRectMake(0, 0 ,KScreenWidth/2, 30))
        titleLabel.backgroundColor = UIColor.clearColor()
        titleLabel.textColor = UIColor(red: 71/255.0, green: 69/255.0, blue: 69/255.0, alpha: 1.0)
        titleLabel.text = "  ".stringByAppendingString((tabTitleArr[section] as? String)!)
        titleLabel.font = UIFont.systemFontOfSize(14.0)
        view.addSubview(titleLabel)
        
        let bgView = UIView(frame: CGRectMake(KScreenWidth - 60, 0, 60, 40))
        view.addSubview(bgView)
        bgView.tag = 778 + section
        let editImg = UIImage(named: "detail_edit")

        var editImgView = UIImageView()
        editImgView = UIImageView(frame: CGRectMake(bgView.width - (editImg?.size.width)! - 20, (bgView.height - (editImg?.size.height)!)/2, (editImg?.size.width)!, (editImg?.size.height)!))
        editImgView.image = editImg
        editImgView.userInteractionEnabled = !permitEditing
        bgView.addSubview(editImgView)
        bgView.tag = 5000 + section
        
        let editTap = UITapGestureRecognizer(target: self, action:"tapAction:")
        bgView.addGestureRecognizer(editTap)
        
        return view
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell:ZGCPhotosListTableViewCell = tableView.dequeueReusableCellWithIdentifier(identifier, forIndexPath: indexPath) as! ZGCPhotosListTableViewCell
        cell.tag = 10 * indexPath.section + indexPath.row
        cell.permitEditing = permitEditing
        cell.dataListArr = (array3D[indexPath.section] as! NSMutableArray)[indexPath.row] as! NSMutableArray
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        
        cell.deleteOrAddImgHandler = {
            (image:UIImage, isdelete:Bool) -> Void in
            if isdelete == true {
                self.deleteOrAddImgArr.addObject(image)
            }else {
                self.deleteOrAddImgArr.removeObject(image)
            }
        }
        return cell
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        if rightTextField.text != nil {
            carBaseScrollView.setLastStr(rightTextField.text!)
        }
        self.view.endEditing(true)
        UIView.animateWithDuration(0.25, animations: { () -> Void in
            self.setSelfViewBoundsOriginY(0)
        })
    }
    
    override func tabBarTapAction(tap: UITapGestureRecognizer) {
        super.tabBarTapAction(tap)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func tapAction(tap:UITapGestureRecognizer) {
        let indexTap = tap.view?.tag
        if indexTap == 777 {
            let addCarCheckVC = ZGCAddCarCheckViewController()
            self.navigationController?.pushViewController(addCarCheckVC, animated: true)
        }else if indexTap == 778 {
            let vehicleConfigVC = ZGCVehicleConfigViewController()
            self.navigationController?.pushViewController(vehicleConfigVC, animated: true)
        }else if indexTap == 333 || indexTap == 222 {
            if indexTap == 333 {
                self.showActionSheet("删除全部图片？", completionBlock: { (finished) -> Void in
                   self.deleteAllImage()
                })
            }else {
                if self.deleteOrAddImgArr.count > 0 {
                    self.showActionSheet("删除所选图片？", completionBlock: { (finished) -> Void in                        
                        
                        if self.deleteOrAddImgArr.count == self.allTotalCount {
                           self.deleteAllImage()
                        }else {
                            let copyImgArr = self.totalStoreImgArr.mutableCopy() as! NSMutableArray
                            
                            self.deleteOrAddImgArr.enumerateObjectsUsingBlock( { (object, index, stop) -> Void in
                                let deleteImg = object as! UIImage
                                
                                self.totalStoreImgArr.enumerateObjectsUsingBlock({ (object, index, stop1) -> Void in
                                    let shouldStop: ObjCBool = true
                                    let mArr = (object as! NSMutableArray).mutableCopy()
                                    let selectedIndex = index
                                    
                                   (object as! NSMutableArray).enumerateObjectsUsingBlock({ (object, index, stop) -> Void in
                                    
                                        let img = object as! UIImage
                                        if img == deleteImg {
                                            mArr.removeObjectAtIndex(index)
                                            copyImgArr.replaceObjectAtIndex(selectedIndex, withObject: mArr.mutableCopy())
                                            
                                            
                                            (ZGCImageTwoDBManager().selectImages() as NSArray).enumerateObjectsUsingBlock({ (object, index, stop) -> Void in
                                                let image = object as! Image
                                                let aImage:UIImage = UIImage(named: image.path!)!
                                                print(aImage)
                                                if aImage == deleteImg {
                                                    do {
                                                        try FileManager.removeItemAtPath(image.path!)
                                                        ZGCImageTwoDBManager().deleteImage(image)
                                                    } catch let error as NSError {
                                                        NSLog("\(error.localizedDescription)")
                                                    }
                                                    stop1.initialize(shouldStop)
                                                }
                                            })
                         
                                        }
                                    })
                                })
                                
                            })
                            self.deleteOrAddImgArr.removeAllObjects()
                            self.totalStoreImgArr = copyImgArr.mutableCopy() as! NSMutableArray
                            self.createArray3D()
                            
                        }
                    })
                    
                }else {
                    self.showHUD("请先选取需要删除的图片！", image: UIImage(), withHiddenDelay: 1.0)
                    return
                }
            }

        }else if indexTap >= 5000 {
            let takePhotosVC = ZGCTakesPhotosListViewController()
            takePhotosVC.selectedIndex = indexTap! - 5000
            takePhotosVC.totalStoreImgArr = totalStoreImgArr
            self.navigationController?.pushViewController(takePhotosVC, animated: true)
        }
        
    }
    
    func deleteAllImage () {
        self.totalStoreImgArr.removeAllObjects()
        self.createArray3D()
        self.photoDeleteBarView.hidden()
        self.rightButtonClicked(self.rightBtn)
        self.rightBtn.hidden = true
        self.deleteOrAddImgArr.removeAllObjects()
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), { () -> Void in
            (ZGCImageTwoDBManager().selectImages() as NSArray).enumerateObjectsUsingBlock({ (object, index, stop) -> Void in
                let image = object as! Image
                print(image.path!)
                ZGCImageTwoDBManager().deleteImage(image)
                
                do {
                    try FileManager.removeItemAtPath(image.path!)
                } catch let error as NSError {
                    NSLog("\(error.localizedDescription)")
                }
            })
            //
            //            print(ZGCImageDBManager.shareInstance().selectImages())
            //            let currentDirArr:NSArray!
            //            do {
            //                try currentDirArr = FileManager.contentsOfDirectoryAtPath(self.dir)
            //                print(currentDirArr)
            //
            //            } catch let error as NSError {
            //                NSLog("\(error.localizedDescription)")
            //            }
        })
    }
    
    func createArray3D () {
        let array2DCount = 3
        array3D = NSMutableArray(capacity: totalStoreImgArr.count)
        
        totalStoreImgArr.enumerateObjectsUsingBlock { (object, index, stop) -> Void in
            let array2D = NSMutableArray()
            var array = NSMutableArray()
            let objectArr = object
            objectArr.enumerateObjectsUsingBlock({ (object, index, stop) -> Void in
                if objectArr.count > 3 {
                    if array.count % 3  == 0 && index != 0 {
                        array2D.addObject(array.mutableCopy())
                        array = NSMutableArray(capacity: array2DCount)
                    }
                }
                
                array.addObject(object)
                self.allTotalCount = self.allTotalCount + 1
                if objectArr.count <= 3 {
                    if array.count == objectArr.count {
                        array2D.addObject(array)
                    }
                }else {
                    if index >= Int(array.count/3)*3 && index == objectArr.count - 1 {
                        array2D.addObject(array)
                    }
                }
                
            })
            self.array3D.addObject(array2D)
        }
        
        photosListTableView.reloadData()

    }
    
    func createArray2D () {        
        let array2DCount:Int = 3
        self.array2D.removeAllObjects()
        
        var array = NSMutableArray(capacity: array2DCount)
        self.picturesArr.enumerateObjectsUsingBlock { (object, index, stop) -> Void in
            
            array.addObject(object)
            if array.count % array2DCount  == 0 && index != 0 {
                self.array2D.addObject(array.mutableCopy())
                array = NSMutableArray(capacity: array2DCount)
            }else if self.picturesArr.count % array2DCount  < array2DCount && self.picturesArr.count == index + 1 {
                self.array2D.addObject(array.mutableCopy())
            }
        }
        
        self.configDetailTableView.reloadData()

    }

    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        carBaseScrollView.setLastStr(textField.text!)
        self.view.endEditing(true)
        return true
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

//
//  ZGCVehicleConfigViewController.swift
//  Carcheck
//
//  Created by GaoCheng.Zou on 16/3/2.
//  Copyright © 2016年 GaoCheng.Zou. All rights reserved.
//

import UIKit
class ZGCVehicleConfigViewController: ZGCBaseViewController, UITableViewDelegate, UITableViewDataSource, SKPhotoBrowserDelegate {
    
    @IBOutlet weak var vehicleConfigTableView: UITableView!
    
    @IBOutlet weak var carTypeTitleLabel: UILabel!
    var vehicleConfigScrollView: ZGCVehicleConfigListScrollView!
    var addConfigScrollView: ZGCAddConfigScrollView!
    var isCreateNew = false
    var rightBtn:UIButton!
    var permitEditing = false
    
    var imagePicker: HImagePickerUtils!
    
    let identifier = "ZGCVehicleConfigTableViewCell"
    
    var imageModelsArr = NSMutableArray()
    var picturesArr = NSMutableArray()
    var noCompressArr = NSMutableArray()

    var array2D = NSMutableArray()
    
    var arrayPic2D = NSMutableArray()
    
    var rowHeight: CGFloat!
    
    var attri2DArr = NSMutableArray()
    
    var selectedIndex: Int!
    
    var photoDeleteBarView: ZGCPhotoDeleteBarView!
    
    var deleteOrAddImgPidArr = NSMutableArray()
    
    var dir:String!
    
    var images = [SKPhoto]()
    


    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "车辆配置-加装配置"
        
        self.rowHeight = (KScreenWidth - 40)/3 + 10

        imagePicker = HImagePickerUtils()// HImagePickerUtils 对象必须为全局变量，不然UIImagePickerController代理方法不会执行

        
        (ZGCConfigDBManager().selectConfigs() as NSArray).enumerateObjectsUsingBlock { (object, index, stop) -> Void in
            let config = object as! Config
            let attriArr = NSMutableArray()
            attriArr.addObject(config.name!)
            attriArr.addObject(config.instruction!)
            self.attri2DArr.addObject(attriArr.mutableCopy())
        }
        
        vehicleConfigTableView.delegate = self
        vehicleConfigTableView.dataSource = self
        let cellNib:UINib = UINib(nibName: identifier, bundle: nil)
        vehicleConfigTableView.registerNib(cellNib, forCellReuseIdentifier: identifier)
        vehicleConfigTableView.tableFooterView = UIView()
        vehicleConfigTableView.backgroundColor = UIColor.whiteColor()
        
        self.initRightBtn()
        
        carTypeTitleLabel.text = UserDefault.objectForKey("brand")?.stringByAppendingString((UserDefault.objectForKey("model") as! String).stringByAppendingString(UserDefault.objectForKey("style") as! String))
        carTypeTitleLabel.textColor = UIColor.darkGrayColor()
    

        if array2D.count == 0 {
            array2D.addObject(NSMutableArray(object: Image(path: "", instruction: "", location: "", pid: "")))
            arrayPic2D.addObject(NSMutableArray(object: UIImage(named: "config_takePic")!))
        }
        
        self.initUpOrNextView(["334"], imgArr: NSArray())
        
        
        dir = UserDefault.objectForKey("subDir")?.stringByAppendingPathComponent(self.navigationItem.title!)
        
        if FileManager.isExecutableFileAtPath(self.dir) {
            
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), { () -> Void in
                (ZGCImageDBManager().selectImages() as NSArray).enumerateObjectsUsingBlock({ (object, index, stop) -> Void in
                    let image = object as! Image
                    let aImage = UIImage(named: image.path!)
                    self.noCompressArr.addObject(aImage!)
                    self.picturesArr.addObject(UIImage(named: "config_takePic")!)
                    self.imageModelsArr.addObject(image)
                })
                
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    self.createArray2D()
                    if self.noCompressArr.count > 0 {
                        self.rightBtn.hidden = false
                    }else {
                        self.rightBtn.hidden = true
                    }
                })
            })
            
        }else {
            CreateSubDirectories(self.dir)
        }

    }
    
    
    func initRightBtn() {
        rightBtn = UIButton(type: UIButtonType.Custom)
        rightBtn.frame = CGRectMake(0, 0, 40, 30)
        rightBtn.setTitle("选择", forState: UIControlState.Normal)
        rightBtn.titleLabel?.font = UIFont.systemFontOfSize(15.0)
        rightBtn.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        rightBtn.backgroundColor = UIColor.clearColor()
        self.rightBtn.hidden = true
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
        }
        vehicleConfigTableView.reloadData()
    }

    
    override func tabBarTapAction(tap: UITapGestureRecognizer) {
        super.tabBarTapAction(tap)
        if tap.view!.tag == 335 {
            if isCreateNew == true {
                let takesPhotosListVC = ZGCTakesPhotosListViewController()
                self.navigationController?.pushViewController(takesPhotosListVC, animated: true)
            }else {
                let carvalueDetailVC = ZGCCarValueDetailViewController()
                self.navigationController?.pushViewController(carvalueDetailVC, animated: true)
            }

        }
    }
    
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 1 {
            if self.imageModelsArr.count > 0 {
                return self.array2D.count
            }
            return 1
        }
        if self.attri2DArr.count > 0 {
            return self.attri2DArr.count + 1
        }
        return 1
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if section == 1 {
            return NavAndStausHeight*2
        }
        return 0.0001
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.section == 1 {
            return rowHeight
        }
        return 40
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell:ZGCVehicleConfigTableViewCell = tableView.dequeueReusableCellWithIdentifier(identifier, forIndexPath: indexPath) as! ZGCVehicleConfigTableViewCell
        

        cell.tar = self
        cell.sel = "tapAction:"
        cell.section = indexPath.section
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        cell.tag = indexPath.row
        cell.permitEditing = permitEditing
        if indexPath.section == 0 {
            cell.maxCount = self.attri2DArr.count
            if indexPath.row != self.attri2DArr.count {
                cell.attriArr = attri2DArr[indexPath.row] as! NSMutableArray
            }
        }else {
            cell.maxCountThree = array2D.count - 1
            cell.modelListArr = array2D[indexPath.row] as! NSMutableArray
            cell.dataListArr = arrayPic2D[indexPath.row] as! NSMutableArray
            cell.deleteOrAddImgHandler = {
                (image:UIImage, isdelete:Bool, imgView:ZGCPhotoImgView, tag:Int) -> Void in
                
                if self.permitEditing == true {
                    if isdelete == true {
                        self.deleteOrAddImgPidArr.addObject(imgView.pid)
                    }else {
                        self.deleteOrAddImgPidArr.removeObject(imgView.pid)
                    }
                }else {
                    
                    self.images.removeAll()
                    
                    self.noCompressArr.enumerateObjectsUsingBlock({ (object, index, stop) -> Void in
                        let photo = SKPhoto.photoWithImage(object as! UIImage)
                        self.images.append(photo)
                    })
                    let index = tag - 1000
                    let browser = SKPhotoBrowser(originImage: self.noCompressArr[index] as! UIImage, photos: self.images, animatedFromView: imgView)
                    browser.isNewConfig = true
                    browser.initializePageIndex(index)
                    browser.delegate = self
                    
                    // Can hide the action button by setting to false
                    browser.displayAction = true
                    
                    // Optional action button titles (if left off, it uses activity controller
                    // browser.actionButtonTitles = ["Do One Action", "Do Another Action"]
                    
                    self.presentViewController(browser, animated: true, completion: {})
                }
                
            }
        }
        
        return cell
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let bgView = UIView()
        bgView.backgroundColor = UIColor.whiteColor()
        var iconImgArr = NSArray()
        var titleArr = NSArray()
        if section == 0 {
            iconImgArr = ["config_setting", "config_text"]
            titleArr = ["配置名称", "配置说明"]
        }else {
            iconImgArr = ["config_photo"]
            titleArr = ["拍照列表"]
        }
        
        iconImgArr.enumerateObjectsUsingBlock { (object, index, stop) -> Void in
            let viewWidth = KScreenWidth - 40
            let view = UIView(frame: CGRectMake((viewWidth/2)*CGFloat(index), 0, viewWidth/2, 40))
            bgView.addSubview(view)
            let iconImg = UIImage(named: object as! String)
            let iconImgView = UIImageView(frame: CGRectMake(11, 11, (iconImg?.size.width)!, (iconImg?.size.height)!))
            iconImgView.image = iconImg
            view.addSubview(iconImgView)
            let titleLabel = UILabel(frame: CGRectMake(iconImgView.right + 11, 0, viewWidth/2 - 40, 40))
            titleLabel.text = titleArr[index] as? String
            titleLabel.font = UIFont.systemFontOfSize(14.0)
            view.addSubview(titleLabel)
        }

        return bgView

    }
    
    func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let bgView = UIView()
        bgView.backgroundColor = UIColor.whiteColor()
        if section == 1 {
            let checkBaseConfigButton:UIButton = UIButton(type: UIButtonType.Custom)
            checkBaseConfigButton.backgroundColor = ButtonBackGroundColor
            checkBaseConfigButton.setTitle("查看基础配置", forState:UIControlState.Normal)
            checkBaseConfigButton.layer.cornerRadius = 8.0
            checkBaseConfigButton.clipsToBounds = true
            checkBaseConfigButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
            checkBaseConfigButton.titleLabel?.font = UIFont.systemFontOfSize(15.0)
            checkBaseConfigButton.frame = CGRectMake(KScreenWidth/8, 4.5, KScreenWidth*3/4, 40)
            checkBaseConfigButton.tag = 99
            checkBaseConfigButton.addTarget(self, action: "btnAction:", forControlEvents: UIControlEvents.TouchUpInside)
            bgView.addSubview(checkBaseConfigButton)
        }

        return bgView
    }
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        if (indexPath.section == 0 && indexPath.row == self.attri2DArr.count) || indexPath.section == 1 {
            return false
        }
        if self.permitEditing == true {
            return false
        }
        return true
    }
    
    func tableView(tableView: UITableView, editingStyleForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCellEditingStyle {
        return UITableViewCellEditingStyle.Delete
    }
    
    func tableView(tableView: UITableView, titleForDeleteConfirmationButtonForRowAtIndexPath indexPath: NSIndexPath) -> String? {
        return "删除"
    }
    
    func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
        let shareAction = UITableViewRowAction(style: UITableViewRowActionStyle.Default, title: "删除" , handler: { (action:UITableViewRowAction!, indexPath:NSIndexPath!) -> Void in
            
            let attriArr = self.attri2DArr[indexPath.row] as! NSMutableArray
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), { () -> Void in
                let configDBManager =  ZGCConfigDBManager()
                let config = Config(name: attriArr[0] as? String, instruction: attriArr[1] as? String, pid:String(indexPath.row))
                configDBManager.deleteConfig(config)
                //更新配置项pid、删除旧数据、重新写入
                let newConfigsArr = NSMutableArray()
                (configDBManager.selectConfigs() as NSArray).enumerateObjectsUsingBlock({ (object, index, stop) -> Void in
                    let config = object as! Config
                    newConfigsArr.addObject(Config(name: config.name, instruction: config.instruction, pid: String(index)))
                    configDBManager.deleteConfig(config)
                })
                
                newConfigsArr.enumerateObjectsUsingBlock({ (object, index, stop) -> Void in
                    let config = object as! Config
                    configDBManager.addConfig(config)
                })
            })
            self.attri2DArr.removeObjectAtIndex(indexPath.row)
            self.vehicleConfigTableView.reloadData()
        })
        
        shareAction.backgroundColor = ButtonBackGroundColor
        
        return [shareAction]
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
    }

    func btnAction (btn:UIButton) {
        if btn.tag == 99 {
            if isCreateNew == true {
                let vehicleBaseConfigVC = ZGCVehicleBaseConfigViewController()
                self.navigationController?.pushViewController(vehicleBaseConfigVC, animated: true)
            }
        }
    }

    func tapAction (tap:UITapGestureRecognizer) {
        let indexTap = Int((tap.view?.tag)!)
        
        if indexTap == 500 || indexTap >= 600 {
            var contentArr = NSMutableArray()
            selectedIndex = indexTap
            if tap.view?.tag != 500 {
                contentArr = attri2DArr[indexTap - 600] as! NSMutableArray
            }
            let addConfigView = ZGCAddConfigView(frame: CGRectZero, contentArr: contentArr)
            addConfigView.show()
            
            addConfigView.warningContentIsEmptyHander = {
                (tag:Int)-> Void in
                var warnStr = "配置名称不能为空"
                if tag != 555 {
                    warnStr = "配置说明不能为空"
                }
                self.showHUD(warnStr, image: UIImage(), withHiddenDelay: 1.0)
            }
            
            addConfigView.sureOrCancelHandler = {
                (attriArr:NSMutableArray)-> Void in
                if self.selectedIndex != 500 {
                    self.attri2DArr.replaceObjectAtIndex(self.selectedIndex - 600, withObject: attriArr)
                }else {
                    self.attri2DArr.addObject(attriArr)
                }
                self.vehicleConfigTableView.reloadData()
                
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), { () -> Void in
                    
                    let configDBManager =  ZGCConfigDBManager()
                    var pid:String!
                    if self.selectedIndex == 500 {
                        pid = String (self.attri2DArr.count - 1)
                    }else {
                        pid = String (self.selectedIndex - 600)

                    }

                    let config = Config(name: attriArr[0] as? String, instruction: attriArr[1] as? String, pid:pid)
                    if self.selectedIndex == 500 {
                        configDBManager.addConfig(config)
                    }else {
                        configDBManager.updateConfig(config)
                    }
                })
            }
        } else if indexTap == 333 || indexTap == 222 {
            if indexTap == 333 {
                self.showActionSheet("删除全部图片？", completionBlock: { (finished) -> Void in
                    self.deleteAllImage()
                })
            }else {
                if self.deleteOrAddImgPidArr.count > 0 {
                    self.showActionSheet("删除所选图片？", completionBlock: { (finished) -> Void in
                        
                        if self.deleteOrAddImgPidArr.count == self.imageModelsArr.count - 1 {
                            self.deleteAllImage()
                        }else {
                            let copyImgArr = self.imageModelsArr.mutableCopy() as! NSMutableArray
                            let copyPicArr = self.picturesArr.mutableCopy() as! NSMutableArray
                            let deleteIndexArr = NSMutableArray()
                            self.deleteOrAddImgPidArr.enumerateObjectsUsingBlock( {(object, index, stop) -> Void in
                                let deleteImgPid:String = object as! String
                                self.imageModelsArr.enumerateObjectsUsingBlock({ (object, index, stop) -> Void in
                                    let shouldStop: ObjCBool = true
                                    
                                    let img = object as! Image
                                    if img.pid == deleteImgPid {
                                        deleteIndexArr.addObject(index)
                                        
                                        ZGCImageDBManager().deleteImage(img)
                                        do {
                                            try FileManager.removeItemAtPath(img.path!)
                                        } catch let error as NSError {
                                            NSLog("\(error.localizedDescription)")
                                        }
                                        
                                        stop.initialize(shouldStop)
                                    }
                                })
                                
                            })
                            
                            var copyDeleteIndexArr = NSArray()
                            
                            copyDeleteIndexArr = deleteIndexArr.sortedArrayUsingComparator({ (obj1:AnyObject, obj2:AnyObject) -> NSComparisonResult in
                                if Int(obj1 as! NSNumber) < Int(obj2 as! NSNumber) {
                                    return NSComparisonResult.OrderedDescending
                                }else {
                                    return NSComparisonResult.OrderedSame
                                }
                            })
                            
                            for object in copyDeleteIndexArr.count - 1...0 {
                                copyImgArr.removeObjectAtIndex(Int(object as NSNumber))
                                copyPicArr.removeObjectAtIndex(Int(object as NSNumber))
                            }
                            
                            self.deleteOrAddImgPidArr.removeAllObjects()
                            copyImgArr.removeLastObject()
                            copyPicArr.removeLastObject()
                            self.imageModelsArr = copyImgArr.mutableCopy() as! NSMutableArray
                            self.picturesArr = copyPicArr.mutableCopy() as! NSMutableArray
                            self.createArray2D()
                            
                        }
                    })

                }else {
                    self.showHUD("请先选取需要删除的图片！", image: UIImage(), withHiddenDelay: 1.0)
                    return
                }
            }
            
        } else if indexTap == 444 {
            
            imagePicker.pickPhotoEnd = {a,b,c in
                
                if b == HTakeStatus.Success {
                    self.rightBtn.hidden = false

                    if self.imageModelsArr.count > 0 {
                        self.imageModelsArr.removeLastObject()
                        self.picturesArr.removeLastObject()
                    }
                    
                    self.noCompressArr.addObject(a!)
                    
                    
                    let copyStr = (GetCurrentDateTransformToDateStrTwo() as NSString).mutableCopy() //使用mutableCopy深复制对象，是深复制后得到的变量不会因原变量的改变而变化

                    
                    let image = Image(path: self.dir.stringByAppendingString("/").stringByAppendingString(copyStr as! String).stringByAppendingString(".png"), instruction:"", location:"", pid: copyStr as? String)
                    let manager = ZGCImageDBManager()
                    manager.addImage(image)
                    
                    self.picturesArr.addObject(ImageWithImageSimple(a!, scaledToSize: CGSizeMake((KScreenWidth - 40)/3, (KScreenWidth - 40)/3)))
                    
                    self.imageModelsArr.addObject(image)

                    
                    self.createArray2D()

                    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), { () -> Void in
                        WriteImageDataToFile(a!, dir: self.dir, imgName:copyStr as! String)
                        Util.convertPngToJpg(a!, path:self.dir, imageName:copyStr as! String)
                    })
                    
                }
            }
            imagePicker.takePhoto(self)

        }
        
    }
    
    func deleteAllImage () {
        self.imageModelsArr.removeAllObjects()
        self.picturesArr.removeAllObjects()
        self.createArray2D()
        self.photoDeleteBarView.hidden()
        self.rightButtonClicked(self.rightBtn)
        self.rightBtn.hidden = true
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), { () -> Void in
            (ZGCImageDBManager().selectImages() as NSArray).enumerateObjectsUsingBlock({ (object, index, stop) -> Void in
                let image = object as! Image
                ZGCImageDBManager().deleteImage(image)
                
                do {
                try FileManager.removeItemAtPath(image.path!)
                } catch let error as NSError {
                    NSLog("\(error.localizedDescription)")
                }
            })

        })

    }
    
    func createArray2D () {
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), { () -> Void in
            self.imageModelsArr.addObject(Image(path: "", instruction: "", location: "", pid: ""))
            self.picturesArr.addObject(UIImage(named: "config_takePic")!)
            
            let array2DCount:Int = 3
            self.array2D.removeAllObjects()
            self.arrayPic2D.removeAllObjects()

            
            var array = NSMutableArray(capacity: array2DCount)
            self.imageModelsArr.enumerateObjectsUsingBlock { (object, index, stop) -> Void in
                array.addObject(object)
                if array.count % array2DCount  == 0 && index != 0 {
                    self.array2D.addObject(array.mutableCopy())
                    array = NSMutableArray(capacity: array2DCount)
                }else if self.imageModelsArr.count % array2DCount  < array2DCount && self.imageModelsArr.count == index + 1 {
                    self.array2D.addObject(array.mutableCopy())
                }
            }
            
            var arrayModel = NSMutableArray(capacity: array2DCount)
            self.picturesArr.enumerateObjectsUsingBlock({ (object, index, stop) -> Void in
                arrayModel.addObject(object)
                if arrayModel.count % array2DCount  == 0 && index != 0 {
                    self.arrayPic2D.addObject(arrayModel.mutableCopy())
                    arrayModel = NSMutableArray(capacity: array2DCount)
                }else if self.picturesArr.count % array2DCount  < array2DCount && self.picturesArr.count == index + 1 {
                    self.arrayPic2D.addObject(arrayModel.mutableCopy())
                }
            })
            
            
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                self.vehicleConfigTableView.reloadData()
            })

        })

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


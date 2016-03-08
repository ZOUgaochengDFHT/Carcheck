//
//  ZGCTakesPhotosListViewController.swift
//  Carcheck
//
//  Created by GaoCheng.Zou on 16/2/19.
//  Copyright © 2016年 GaoCheng.Zou. All rights reserved.
//

import UIKit

class ZGCTakesPhotosListViewController: ZGCBaseViewController, BaseTableViewDelegate, SUNSlideSwitchViewDelegate , UIImagePickerControllerDelegate, UINavigationControllerDelegate, SKPhotoBrowserDelegate {
    
    var slideSwitchView: SUNSlideSwitchView!
    var takesPhotosTableView: ZGCTakePhotosTableView!
    var takesPhotosTableViewArr = NSMutableArray()
    var window: UIWindow!
    var imagePicker: HImagePickerUtils!
    var selectedIndex: Int!
    var takesPhotosFinished = false
    var currentStoreImgArr = NSMutableArray()
    var totalStoreImgArr = NSMutableArray()

    var currentImg: UIImage!
    
    var tabTitleArr = ["车辆正面车主合照","左前45度","左后45度","右后45度","右前45度"] as NSArray
    var images = [SKPhoto]()
    var isFirst = false

    var dir: String!
    var attri2DArr =  NSMutableArray()
    
    
//    let tabTitleArr = ["车辆正面与车主合照","左前45度","左后45度","右后45度","右前45度","车辆铭牌","发动机舱内车架号","组合仪表","仪表台","前排座椅","后排座椅","后备箱备胎工具","发动机舱","发动机舱后侧防火墙","左前大灯框架","右前大灯框架","左前减震座","右前减震座","左纵梁","右纵梁"] as NSArray
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.initHomeButton()
        
        self.totalStoreImgArr = NSMutableArray(capacity: self.tabTitleArr.count)
        // Do any additional setup after loading the view.
        self.initSlideSwitchView()
        
    }
    
    func initSlideSwitchView () {
        
        slideSwitchView = SUNSlideSwitchView.init(frame: CGRectMake(0, 0, KScreenWidth, KScreenHeight))
        slideSwitchView.backgroundColor = UIColor.clearColor()
        if selectedIndex != nil {
            slideSwitchView.userSelectedChannelID = 100 + selectedIndex
        }
        slideSwitchView.slideSwitchViewDelegate = self
        self.view.addSubview(slideSwitchView)
        
        let customTitleView = UIView(frame: CGRectMake(0, 0, KScreenWidth*2/3, 44))
        
        let titleLabel = UILabel(frame: CGRectMake(0, 0, KScreenWidth*2/3, 21))
        titleLabel.text = "拍照列表"
        titleLabel.textColor = UIColor.whiteColor()
        titleLabel.textAlignment = NSTextAlignment.Center
        customTitleView.addSubview(titleLabel)
        
        slideSwitchView.topScrollView.top = titleLabel.bottom
        customTitleView.addSubview(slideSwitchView.topScrollView)
        
        self.navigationItem.titleView = customTitleView
        
        
        tabTitleArr.enumerateObjectsUsingBlock { (object, index, stop) -> Void in
            self.takesPhotosTableView = ZGCTakePhotosTableView(frame: CGRectZero)
            self.takesPhotosTableView.titleText = object as! String
            self.takesPhotosTableView.refreshDelegate = self
            self.takesPhotosTableView.currentPage = String(index + 1)
            self.takesPhotosTableView.btnTitle = "下一项"
            self.takesPhotosTableView.photosNum = String(self.tabTitleArr.count)
            self.view.addSubview(self.takesPhotosTableView)
            self.takesPhotosTableViewArr.addObject(self.takesPhotosTableView)
        }
        
        slideSwitchView.buildUI()
    }
    
    func slideSwitchView(view: SUNSlideSwitchView!, viewOfTab number: UInt) -> UITableView! {
        return self.takesPhotosTableViewArr[Int(number)] as! ZGCTakePhotosTableView
    }
    
    func numberOfTab(view: SUNSlideSwitchView!) -> UInt {
        return UInt(self.tabTitleArr.count)
    }
    
    func slideSwitchView(view: SUNSlideSwitchView!, didselectTab number: UInt) {
        selectedIndex = Int(number)
        
        self.currentStoreImgArr.removeAllObjects()
        
        if self.totalStoreImgArr.count > 0 {
            if Int(number) < self.totalStoreImgArr.count  {
                self.currentStoreImgArr = self.totalStoreImgArr[Int(number)] as! NSMutableArray
                self.createArray2D()
            }
 

        }else {
            CreateSubDirectories((UserDefault.objectForKey("subDir")?.stringByAppendingPathComponent("拍照列表"))!)
            
            dir = NSString(string: UserDefault.objectForKey("subDir")!.stringByAppendingString("/拍照列表")).stringByAppendingPathComponent(self.tabTitleArr[selectedIndex] as! String)
            
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), { () -> Void in
                if FileManager.isExecutableFileAtPath(self.dir) {
                    let currentDirArr:NSArray!
                    do {
                        try currentDirArr = FileManager.contentsOfDirectoryAtPath(self.dir)
                        self.currentStoreImgArr.removeLastObject()
                        
                        currentDirArr.enumerateObjectsUsingBlock({ (object, index, stop) -> Void in
                            let image = UIImage(named: self.dir.stringByAppendingString("/").stringByAppendingString(object as! String))
                            self.currentStoreImgArr.addObject(image!)
                        })
                        
                        dispatch_async(dispatch_get_main_queue(), { () -> Void in
                            self.createArray2D()
                            self.setPhotoListBarView()
                            
                        })
                    } catch let error as NSError {
                        NSLog("\(error.localizedDescription)")
                    }
                }else {
                    CreateSubDirectories(self.dir)
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        self.setPhotoListBarView()
                    })
                    
                }
            })

        }
    
    }
    
    func setPhotoListBarView () {
        if self.isFirst == false {
            var tapArr = NSArray()
            if self.currentStoreImgArr.count == 0 {
                tapArr = ["335"]
            }
            self.initUpOrNextView(tapArr, imgArr: NSArray())
            self.isFirst = true
        }else {
            if self.currentStoreImgArr.count == 0 {
                self.photoListBarView.setNextHidden(true)
            }else {
                self.photoListBarView.setNextHidden(false)
            }
        }
    }
    
    
    func presentImagePickerSheet() {
        
//        weak var weakSelf = self
        imagePicker = HImagePickerUtils()// HImagePickerUtils 对象必须为全局变量，不然UIImagePickerController代理方法不会执行
        imagePicker.pickPhotoEnd = {a,b,c in
            if b == HTakeStatus.Success {
//                self.takesPhotosTableView = self.takesPhotosTableViewArr[self.selectedIndex] as! ZGCTakePhotosTableView
//                self.takesPhotosTableView.photoImg = a
                self.currentImg = a
                self.currentStoreImgArr.addObject(self.currentImg)
                
                self.attri2DArr.addObject("")
//                
//                self.createArray2D()
//                
//                self.takesPhotosTableView.reloadData()

//
//                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), { () -> Void in
//                    WriteImageDataToFile(a!, dir: self.dir, imgName: String(self.currentStoreImgArr.count - 1))
//                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
//                        self.createArray2D()
//                        if self.currentStoreImgArr.count == 0 {
//                            self.photoListBarView.setNextHidden(true)
//                        }else {
//                            self.photoListBarView.setNextHidden(false)
//                        }
//                    })
//
//                })
                
                
                self.createArray2D()
                if self.currentStoreImgArr.count == 0 {
                    self.photoListBarView.setNextHidden(true)
                }else {
                    self.photoListBarView.setNextHidden(false)
                }

                
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), { () -> Void in
                    
                    
                    if UserDefault.objectForKey("ImageIndexArr") == nil {
                        
                        let indexArr = NSMutableArray()
                        let d:Double = 0
                        indexArr.addObject(d)
                        UserDefault.setObject(NSArray(object: indexArr), forKey: "ImageIndexArr")
                    }else {
                        
                        let indexArr = (UserDefault.objectForKey("ImageIndexArr")?.lastObject)!.mutableCopy()
                        var d = indexArr.lastObject as! Double
                        d = d + 1
                        indexArr.addObject(d)
                        UserDefault.setObject(NSArray(object: indexArr), forKey: "ImageIndexArr")
                    }
                    UserDefault.synchronize()
                    
                    let indexArr = (UserDefault.objectForKey("ImageIndexArr")?.lastObject)!.mutableCopy()
                    let d = indexArr.lastObject as! Double
                    
                    WriteImageDataToFile(a!, dir: self.dir, imgName: String(d))
                    
                    let image = Image(path: self.dir.stringByAppendingString("/").stringByAppendingString(String(d)).stringByAppendingString(".png"), pid: String(d))
                    let manager = ZGCImageTwoDBManager()
                    manager.addImage(image)
                })

                
//                if self.tabTitleArr.count == self.totalStoreImgArr.count + 1 {
//                    /**
//                    *  完成
//                    */
//                    self.takesPhotosTableView.btnTitle = "完成"
//                    self.takesPhotosFinished = true
//                }
            }
        }
        
        imagePicker.takePhoto(self)
    }
    
    // MARK: UIImagePickerControllerDelegate
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func tabBarTapAction(tap: UITapGestureRecognizer) {
        if tap.view?.tag == 334 {
            self.presentImagePickerSheet()
        }else if tap.view!.tag == 335 {
            
            if self.selectedIndex + 1 > self.totalStoreImgArr.count {
                self.totalStoreImgArr.addObject(self.currentStoreImgArr.mutableCopy())
            }else {
                self.totalStoreImgArr.replaceObjectAtIndex(self.selectedIndex, withObject: self.currentStoreImgArr.mutableCopy())
            }
            
            
            if self.selectedIndex == tabTitleArr.count - 1 {
                let carDetailVC = ZGCCarValueDetailViewController()
                carDetailVC.totalStoreImgArr = self.totalStoreImgArr
                carDetailVC.tabTitleArr = self.tabTitleArr
                self.navigationController?.pushViewController(carDetailVC, animated: true)
            }else {
                /**
                 *  下一项
                 */
                self.setSlideSwicthViewAniamtionWithSelectedIndex(self.selectedIndex + 1)
            }
   
        }else {
            if self.selectedIndex == 0 {
                super.tabBarTapAction(tap)
            }else {
                /**
                 *  上一项
                 */
                if self.selectedIndex + 1 > self.totalStoreImgArr.count {
                    self.totalStoreImgArr.addObject(self.currentStoreImgArr.mutableCopy())
                }else {
                    self.totalStoreImgArr.replaceObjectAtIndex(self.selectedIndex, withObject: self.currentStoreImgArr.mutableCopy())
                }
                self.setSlideSwicthViewAniamtionWithSelectedIndex(self.selectedIndex - 1)
     
            }
      
        }
    }
    
    func setSlideSwicthViewAniamtionWithSelectedIndex (selectedIndex: Int) {
        let button = self.slideSwitchView.topScrollView.viewWithTag(100 + selectedIndex) as! UIButton
        self.slideSwitchView.selectNameButton(button)
    }
    
    func createArray2D () {
        
        let array2D = NSMutableArray()
        
        let array2DCount:Int = 3
        
        var array = NSMutableArray(capacity: array2DCount)
        self.currentStoreImgArr.enumerateObjectsUsingBlock { (object, index, stop) -> Void in
            
            array.addObject(object)
            if array.count % array2DCount  == 0 && index != 0 {
                array2D.addObject(array.mutableCopy())
                array = NSMutableArray(capacity: array2DCount)
            }else if self.currentStoreImgArr.count % array2DCount  < array2DCount && self.currentStoreImgArr.count == index + 1 {
                array2D.addObject(array.mutableCopy())
            }
        }
        self.takesPhotosTableView = self.takesPhotosTableViewArr[self.selectedIndex] as! ZGCTakePhotosTableView
        self.takesPhotosTableView.currentStoreImgArr = array2D
        self.takesPhotosTableView.reloadData()
        
        
        
        self.takesPhotosTableView.clickImgViewToShowHandler = {
            (tag:Int, imgView:ZGCEditPhotoView) -> Void in
            if tag > 3000 {                
                let generalDetailView = ZGCGeneralDetailView(frame: CGRectZero, content: self.attri2DArr[tag - 3800] as! String)
                generalDetailView.show()
                generalDetailView.sureOrCancelHandler = {
                    (attriArr:NSMutableArray)-> Void in
                    self.attri2DArr.replaceObjectAtIndex(tag - 3800, withObject: attriArr.lastObject!)
                }
            }else {
                self.images.removeAll()
                
                self.currentStoreImgArr.enumerateObjectsUsingBlock({ (object, index, stop) -> Void in
                    let photo = SKPhoto.photoWithImage(object as! UIImage)
                    self.images.append(photo)
                })
                let index = tag - 800
                let browser = SKPhotoBrowser(originImage: self.currentStoreImgArr[index] as! UIImage, photos: self.images, animatedFromView: imgView)
                browser.attri2DArr = self.attri2DArr
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
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}

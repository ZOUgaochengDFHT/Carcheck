//
//  ZGCAddCarCheckViewController.swift
//  Carcheck
//
//  Created by GaoCheng.Zou on 16/2/18.
//  Copyright © 2016年 GaoCheng.Zou. All rights reserved.
//

import UIKit
import Alamofire
class ZGCAddCarCheckViewController: ZGCBaseViewController, LMComBoxViewDelegate, UITextFieldDelegate, UIScrollViewDelegate {

    var bgScrollView: UIScrollView!
    var isOpened: Bool!
    var staticsModel = ZGCStaticsModel()
    var totalTitleListArr = NSMutableArray()
    var imagePicker: HImagePickerUtils!
    var comboxScrollView: LMContainsLMComboxScrollView!
    var txtFieldTag: Int!
    var txtFieldTop: CGFloat!
    var contentArr = NSMutableArray()
    var conLabel: UILabel!
    var customDatePickerView: ZGCCustomDatePickerView!
    var licenseTypeNum = 0
    
    var isCreateNew = false
    var dbManager: ZGCPersonDBManager!
    
    var conArr = NSArray()
    
    let preTitleArr = ["业务类型", "车主姓名", "联系方式", "车牌号", "车辆所在地", "车辆VIN码", "发动机号", "注册日期", "车辆型号", "车辆排量", "变速器类型", "驱动方式", "燃油类型", "出厂日期", "车牌类型", "环保标准", "行驶里程", "车身颜色", "车钥匙"] as NSArray

    func selectAtIndex(index: Int32, inCombox _combox: LMComBoxView!) {
        print(index)
        let comboxIndex = _combox.tag - 200
        let titleArr = _combox.titlesList
        let comboxStr = titleArr[Int(index)]
        if comboxIndex == 3 {
            let mStr = NSMutableString(string: self.contentArr[comboxIndex] as! String)
            mStr.replaceCharactersInRange(NSMakeRange(0, 1), withString: comboxStr as! String)
            self.contentArr.replaceObjectAtIndex(comboxIndex, withObject: mStr)
        }else {
            if comboxIndex == 14 {
                licenseTypeNum = Int(index)
            }
            self.contentArr.replaceObjectAtIndex(comboxIndex, withObject: comboxStr)
        }

        self.view.endEditing(true)
        UIView.animateWithDuration(0.25) { () -> Void in
            self.setSelfViewBoundsOriginY(0)
        }
    }
    
    func setUpBgScrollView () {
        var i = 0
        preTitleArr.enumerateObjectsUsingBlock { (object, index, stop) -> Void in
            var comBoxWidth = KScreenWidth*2/3
            var leftMargin:CGFloat = 100.00
            let height:CGFloat = 0.0
            if index == 0 || index == 3 || index == 18 || (index >= 14 && index <= 15) || (index >= 10 && index <= 12) {
                
                let titleArr = self.totalTitleListArr[i] as! NSMutableArray
                self.contentArr.insertObject(titleArr[0], atIndex: index)
                if index == 3 {
                    comBoxWidth = KScreenWidth/6
                    leftMargin = leftMargin + comBoxWidth + 10
                    self.initrightTextField(KScreenWidth*2/3 - comBoxWidth - 10, index: index, leftMargin: leftMargin, height: height)
                }
                let comBox = LMComBoxView.init(frame: CGRectMake(100, 20 + 50 * CGFloat(index) + height, comBoxWidth, 30))
                comBox.backgroundColor = UIColor.clearColor()
                comBox.arrowImgName = "down_dark0.png"
                comBox.delegate = self
                comBox.titlesList = self.totalTitleListArr[i] as! NSMutableArray
                if self.isCreateNew == false {
                    let str = self.conArr[index] as! String
                    comBox.titlesList.enumerateObjectsUsingBlock({ (object: AnyObject!, idx: Int, stop: UnsafeMutablePointer<ObjCBool>) -> Void in
                        let shouldStop: ObjCBool = true
                        if (str == String(object) && index != 3) || (index == 3 && (str as NSString).substringToIndex(1) == String(object)) {
                            comBox.defaultIndex = Int32(idx)
                            stop.initialize(shouldStop)
                        }
                    })
                }
                
                comBox.supView = self.comboxScrollView
                comBox.defaultSettings()
                comBox.tag = 200 + index
                i = i + 1

                
                comBox.tableHeight = Float(comBox.titlesList.count) * Float(comBox.height)
                comBox.layer.cornerRadius = 4.0
                comBox.layer.borderColor = kBorderColor.CGColor
                comBox.layer.borderWidth = 0.5
                comBox.clipsToBounds = true
                self.comboxScrollView.addSubview(comBox)
                
                comBox.tapLMComBoxViewHandler = {
                    self.view.endEditing(true)
                    UIView.animateWithDuration(0.25) { () -> Void in
                        self.setSelfViewBoundsOriginY(0)
                    }
                };
            }else {
                if index == 8 {
                    self.initVehicleTypeChooseLabel(comBoxWidth, index: index, leftMargin: leftMargin, height:height)
                }else {
                    self.initrightTextField(comBoxWidth, index: index, leftMargin: leftMargin, height:height)
                }
            }
        }
    }
    
    func initrightTextField (comBoxWidth:CGFloat, index:Int, leftMargin:CGFloat, height:CGFloat) {
        let rightTextField = ZGCCustomTxtField.init(frame: CGRectMake(leftMargin, 20 + 50 * CGFloat(index) + height, comBoxWidth, 30))
        rightTextField.delegate = self
        rightTextField.borderStyle = UITextBorderStyle.None
        self.comboxScrollView.addSubview(rightTextField)
        rightTextField.returnKeyType = UIReturnKeyType.Done
        rightTextField.layer.borderColor = kBorderColor.CGColor;
        rightTextField.layer.borderWidth = 0.5
        rightTextField.layer.cornerRadius = 4
        rightTextField.clipsToBounds = true
        if isCreateNew == true {
            rightTextField.text = "qq"
        }else {
            rightTextField.text = conArr[index] as? String
            if index == 3 {
                rightTextField.text = (conArr[index] as! NSString).substringFromIndex(1)
            }
        }
        rightTextField.textColor = UIColor.darkGrayColor()
        rightTextField.font = UIFont.systemFontOfSize(12.0)
        rightTextField.tag = 600 + index
        rightTextField.layer.masksToBounds = true
        if index == 3 {
            self.initRightImgView("base_takePic", rightTextField: rightTextField)
            self.contentArr.insertObject(self.contentArr[index].stringByAppendingString(rightTextField.text!), atIndex: index)
        }else {
            self.contentArr.insertObject(rightTextField.text!, atIndex: index)
            if index == 7 || index == 13 {
                self.initRightImgView("base_calendar", rightTextField: rightTextField)
            }
        }

    }
    
    func initRightImgView (imgName:String, rightTextField:ZGCCustomTxtField) {
        let rightImgView = UIImageView(image: UIImage(named: imgName))
        rightImgView.userInteractionEnabled = true
        rightImgView.tag = rightTextField.tag
        rightTextField.rightView = rightImgView
        rightTextField.rightViewMode = UITextFieldViewMode.Always
        let tap = UITapGestureRecognizer(target: self, action: "tapAction:")
        rightImgView.addGestureRecognizer(tap)
    }
    
    func tapAction(tap:UITapGestureRecognizer) {
        comboxScrollView.closeAllTheComBoxView()
        self.view.endEditing(true)
        UIView.animateWithDuration(0.25) { () -> Void in
            self.setSelfViewBoundsOriginY(0)
        }

        if tap.view?.tag == 603 {
            self.presentImagePickerSheet()
        }else {
            
            if customDatePickerView == nil {
                customDatePickerView = ZGCCustomDatePickerView(frame: CGRectMake(0, 0, KScreenWidth, KScreenHeight - 64))
                self.view.addSubview(customDatePickerView)
            }
            customDatePickerView.coverViewPresnt()
            customDatePickerView.getDateFormatStrHandler = {
                (dateStr:String) -> Void in
                let rightTextField = self.comboxScrollView.viewWithTag((tap.view?.tag)!) as! UITextField!
                rightTextField.text = dateStr
                
                self.contentArr.replaceObjectAtIndex((tap.view?.tag)! - 600, withObject: dateStr)

            }
        }
    }
    
    func initVehicleTypeChooseLabel (comBoxWidth:CGFloat, index:Int, leftMargin:CGFloat, height:CGFloat) {
        conLabel = UILabel()
        conLabel.frame = CGRectMake(leftMargin, 20 + 50 * CGFloat(index) + height, comBoxWidth, 30)
        conLabel.font = UIFont.systemFontOfSize(12.0)
        conLabel.layer.borderColor = kBorderColor.CGColor;
        conLabel.layer.borderWidth = 0.5
        conLabel.layer.cornerRadius = 4
        conLabel.numberOfLines = 0
        conLabel.textColor = UIColor.darkGrayColor()
        if isCreateNew == true {
            conLabel.text = ""
        }else {
            conLabel.text = conArr[index] as? String
        }
        self.contentArr.insertObject(conLabel.text!, atIndex: index)
        self.comboxScrollView.addSubview(conLabel)
        conLabel.userInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: "tapToVehicleTypeVC")
        conLabel.addGestureRecognizer(tap)
    }
    
    func tapToVehicleTypeVC() {
        let vehicleTypeVC = ZGCVehicleTypeListViewController()
        self.navigationController?.pushViewController(vehicleTypeVC, animated: true)
    }
    
    // - MARK - 行驶证扫描
    func initScanningBtn (index:Int) {
        let scanningBtn:UIButton = UIButton(type: UIButtonType.Custom)
        scanningBtn.backgroundColor = ButtonBackGroundColor
        scanningBtn.setTitle("行驶证扫描", forState:UIControlState.Normal)
        scanningBtn.clipsToBounds = true
        scanningBtn.layer.borderColor = kBorderColor.CGColor;
        scanningBtn.layer.borderWidth = 0.5
        scanningBtn.layer.cornerRadius = 12.5
        scanningBtn.clipsToBounds = true
        scanningBtn.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        scanningBtn.titleLabel?.font = UIFont.systemFontOfSize(14.0)
        scanningBtn.frame = CGRectMake(20, 20 + 50 * CGFloat(index) + 50, KScreenWidth - 40, 25)
        self.comboxScrollView.addSubview(scanningBtn)
        scanningBtn.tag = 100
        scanningBtn.addTarget(self, action: "btnAction:", forControlEvents: UIControlEvents.TouchUpInside)
    }
 
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        isOpened = false
        self.navigationItem.title = "基本信息"
        contentArr = NSMutableArray(capacity: preTitleArr.count)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:", name: "UIKeyboardWillShowNotification", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "changeVehicleType", name: CHANGEVEHICLETYPE, object: nil)
        

        if self.isCreateNew == false {
            dbManager = ZGCPersonDBManager()
            conArr = dbManager.selectPersons()
        }

        self.showLoadingStatusHUD("")
        
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        Alamofire.request(.GET, BaseURLString.stringByAppendingString("dict/baseinfo"), parameters: nil, encoding: .JSON, headers: ["token":UserDefault.objectForKey("token") as! String]).responseJSON {
            response in
            UIApplication.sharedApplication().networkActivityIndicatorVisible = false
            self.removeHUD()
            if let json = response.result.value {
                self.staticsModel = ZGCStaticsModel(contentWithDic: json as! [NSObject : AnyObject])
                
                let dic = self.staticsModel.data as NSDictionary
                
                let typeArr = NSMutableArray()
                (dic.objectForKey("type") as! NSArray).enumerateObjectsUsingBlock({ (object, index, stop) -> Void in
                    let name = object.objectForKey("name")
                    typeArr.addObject(name!)
                })
                
                let biansuqiArr = NSMutableArray()
                (dic.objectForKey("biansuqi") as! NSArray).enumerateObjectsUsingBlock({ (object, index, stop) -> Void in
                    let name = object.objectForKey("name")
                    biansuqiArr.addObject(name!)
                })
                
                let qudongArr = NSMutableArray()
                (dic.objectForKey("qudong") as! NSArray).enumerateObjectsUsingBlock({ (object, index, stop) -> Void in
                    let name = object.objectForKey("name")
                    qudongArr.addObject(name!)
                })
                
                let ranyouArr = NSMutableArray()
                (dic.objectForKey("ranyou") as! NSArray).enumerateObjectsUsingBlock({ (object, index, stop) -> Void in
                    let name = object.objectForKey("name")
                    ranyouArr.addObject(name!)
                })
                
                let huanbaoArr = NSMutableArray()
                (dic.objectForKey("huanbao") as! NSArray).enumerateObjectsUsingBlock({ (object, index, stop) -> Void in
                    let name = object.objectForKey("name")
                    huanbaoArr.addObject(name!)
                })
                
                let chepaiArray = NSMutableArray()
                (dic.objectForKey("chepai") as! NSArray).enumerateObjectsUsingBlock({ (object, index, stop) -> Void in
                    let value = object.objectForKey("value")
                    chepaiArray.addObject(value!)
                })
                
                let chepaiArr = ["京", "沪", "津","渝", "翼", "晋","辽", "吉", "黑","苏", "浙", "皖","闽", "赣", "鲁","豫", "鄂", "琼","川","贵", "云", "陕","甘", "青", "蒙","桂", "藏","宁", "新", "港","澳", "台"] as NSMutableArray
                let keysArr = ["1把", "2把", "3把"] as NSMutableArray
                
                self.totalTitleListArr = [typeArr, chepaiArr, biansuqiArr, qudongArr, ranyouArr, chepaiArray,  huanbaoArr, keysArr]
                
                self.initViews()
                
               

            }
        }
        
        
                // Do any additional setup after loading the view.
    }
    
    
    func initViews() {
        bgScrollView = UIScrollView.init(frame: CGRectMake(0, 0, KScreenWidth, KScreenHeight - 64))
        self.view.addSubview(bgScrollView)
        bgScrollView.delegate = self
        bgScrollView.contentSize = CGSizeMake(KScreenWidth, 100 + 50 * CGFloat(preTitleArr.count) + 50)
        
        
        comboxScrollView = LMContainsLMComboxScrollView.init(frame: CGRectMake(0, 0, KScreenWidth, bgScrollView.contentSize.height))
        comboxScrollView.backgroundColor = UIColor.clearColor()
        comboxScrollView.showsHorizontalScrollIndicator = false
        comboxScrollView.showsVerticalScrollIndicator = false
        bgScrollView.addSubview(comboxScrollView)
        
        self.setUpBgScrollView()
        
        preTitleArr.enumerateObjectsUsingBlock { (object, index, stop) -> Void in
            let preLabel = UILabel()
            preLabel.frame = CGRectMake(0, 20 + 50 * CGFloat(index), 90, 30)
            preLabel.font = UIFont.systemFontOfSize(15.0)
            preLabel.textAlignment = NSTextAlignment.Right
            preLabel.text = self.preTitleArr[index] as? String
            self.comboxScrollView.addSubview(preLabel)
        }
        
        
        self.initUpOrNextView(["333", "334"], imgArr: NSArray())
    
    }
    
    func presentImagePickerSheet() {
        //        weak var weakSelf = self
        imagePicker = HImagePickerUtils()// HImagePickerUtils 对象必须为全局变量，不然UIImagePickerController代理方法不会执行
        imagePicker.pickPhotoEnd = {a,b,c in
            if b == HTakeStatus.Success {
                
                let url = BaseURLString.stringByAppendingString("recognize/drivingLicense")
                
                Alamofire.request(.POST, url, parameters: ["image" : "license.png"], encoding: .JSON, headers: ["token" : UserDefault.objectForKey("token") as! String]).responseJSON {
                    response in
                    if let json = response.result.value {
                        print(json)
                    }
                }
            }
        }
        
        imagePicker.takePhoto(self)
    }

    
    // - MARK - 
    
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
        comboxScrollView.closeAllTheComBoxView()
        txtFieldTag = textField.tag
        txtFieldTop = textField.top
        return true
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.view.endEditing(true)
        UIView.animateWithDuration(0.25) { () -> Void in
            self.setSelfViewBoundsOriginY(0)
        }
        return true
    }
    
    
    //监听键盘显示的方法实现
    func keyboardWillShow(notification: NSNotification!) {
        let keyboardSize = (notification.userInfo![UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.CGRectValue()
        UIView.animateWithDuration(0.25, animations: { () -> Void in
            var YOffset:CGFloat!
            if self.txtFieldTag != nil {
                if self.txtFieldTag >= 615 {
                    YOffset = (keyboardSize?.height)! - 49
                    self.setSelfViewBoundsOriginY(YOffset)
                }
            }
        })
    }
    
    func changeVehicleType() {
        conLabel.text = UserDefault.objectForKey("brand")?.stringByAppendingString((UserDefault.objectForKey("model") as! String).stringByAppendingString(UserDefault.objectForKey("style") as! String))
    }
    
    override func tabBarTapAction(tap: UITapGestureRecognizer) {
        super.tabBarTapAction(tap)
        
        comboxScrollView.closeAllTheComBoxView()
        if tap.view!.tag == 335 {
            if isCreateNew == true {
                preTitleArr.enumerateObjectsUsingBlock({ (object, index, stop) -> Void in
                    if index != 0 && index != 18 && index != 15 && index != 14 && (index < 10 || index > 12) && index != 8 {
                        let rightTextField = self.comboxScrollView.viewWithTag(600 + index) as! UITextField
                        if index == 3 {
                            let mStr = NSMutableString(string: self.contentArr[index] as! String)
                            mStr.replaceCharactersInRange(NSMakeRange(1, mStr.length - 1), withString: rightTextField.text!)
                            self.contentArr.replaceObjectAtIndex(index, withObject: mStr)
                        }else {
                            self.contentArr.replaceObjectAtIndex(index, withObject: rightTextField.text!)
                        }
                    }else if index == 8 {
                        self.contentArr.replaceObjectAtIndex(index, withObject: self.conLabel.text!)
                    }
                })

            }
            
            if contentArr.count > 19 {
                contentArr.removeLastObject()
            }
            
            var unPass = false
            contentArr.enumerateObjectsUsingBlock({ (object, index, stop) -> Void in
                if object as! String == "" {
                    unPass = true
                    return
                }
            })
            
            if unPass == true {
                self.showHUD("请填写完成所有表格！", image: UIImage(), withHiddenDelay: 1.0)
                return
            }
            
   
            // -MARK:- 添加数据到数据库
            let person = Person(type: contentArr[0] as? String, name: contentArr[1] as? String, phone: contentArr[2] as? String, licenseNo: contentArr[3] as? String, location: contentArr[4] as? String, vin: contentArr[5] as? String, engineNo: contentArr[6] as? String, regisDate: contentArr[7] as? String, vehicleType: contentArr[8] as? String, vehicleEmiss: contentArr[9] as? String, transmType: contentArr[10] as? String, driveWay: contentArr[11] as? String, fuelType: contentArr[12] as? String, manufacDate: contentArr[13] as? String, licenseType: contentArr[14] as? String, envirProStand: contentArr[15] as? String, mileage: contentArr[16] as? String, bodyColor: contentArr[17] as? String, carKeys: contentArr[18] as? String, pid:"person")
            
            if self.isCreateNew == true {
                isCreateNew = false
                
                if UserDefault.objectForKey("indexArr") == nil {
                    
                    let indexArr = NSMutableArray()
                    let d:Double = 1000
                    indexArr.addObject(d)
                    UserDefault.setObject(NSArray(object: indexArr), forKey: "indexArr")
                }else {
                    
                    let indexArr = (UserDefault.objectForKey("indexArr")?.lastObject)!.mutableCopy()
                    var d = indexArr.lastObject as! Double
                    d = d + 1
                    indexArr.addObject(d)
                    UserDefault.setObject(NSArray(object: indexArr), forKey: "indexArr")
                }
                UserDefault.synchronize()
                
                let subDir = CreateSubDocumentsDirectory()
                self.dbManager = ZGCPersonDBManager()
                
                let dateStr = GetCurrentDateTransformToDateStr()
                let unUpload = UnUpload(name: "", saveTime: dateStr, state: "未上传", licenseNo: "", vehicleType: "", databasePath:subDir)
                ZGCUnUploadManager().addUnUpload(unUpload, tableName: "T_UnUpload")
                
                let other = Other(styleId:UserDefault.objectForKey("Value") as? String, licenseTypeNum: String(licenseTypeNum))
                let otherDBManager = ZGCOtherDBManager()
                otherDBManager.addOther(other)
                
            }
            
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), { () -> Void in

                if self.dbManager.selectPersons().count > 0 {
                    self.dbManager.updatePerson(person)
                }else {
                    self.dbManager.addPerson(person)                    
                }
            })

            
            let vehicleConfigVC = ZGCVehicleConfigViewController()
            self.navigationController?.pushViewController(vehicleConfigVC, animated: true)
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

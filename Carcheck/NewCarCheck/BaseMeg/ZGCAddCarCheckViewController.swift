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
    
    var customPickerView: ZGCCustomPickerView!

    var licenseTypeNum: String!
    
    var isCreateNew = false
    var dbManager: ZGCPersonDBManager!
    
    var conArr = NSArray()
    
    var chepaiKeyArr = NSMutableArray()
    
    let preTitleArr = ["业务类型", "车主姓名", "联系方式", "车牌号", "车辆所在地", "车辆VIN码", "发动机号", "注册日期", "车辆型号", "车辆排量", "变速器类型", "驱动方式", "燃油类型", "出厂日期", "车牌类型", "环保标准", "行驶里程", "车身颜色", "车钥匙"] as NSArray
    
    let placeHolderArr = ["", "请输入车主姓名", "请输入11位手机号码", "请填写5位车牌号", "请填写车辆所在地", "请填写机动行驶本上的17位车辆识别码", "请填写机动行驶本上的发动机号", "请填写机动行驶本上的注册日期", "请填写具体汽车的品牌型号", "请填写车辆排量", "", "", "", "请填写车辆的出厂日期", "", "", "请填写汽车行驶表的里程数", "请填写车身颜色", ""] as NSArray

    func selectAtIndex(index: Int32, inCombox _combox: LMComBoxView!) {
        let comboxIndex = _combox.tag - 200
        let titleArr = _combox.titlesList
        let comboxStr = titleArr[Int(index)]
        if comboxIndex == 3 {
            let mStr = NSMutableString(string: self.contentArr[comboxIndex] as! String)
            mStr.replaceCharactersInRange(NSMakeRange(0, 1), withString: comboxStr as! String)
            self.contentArr.replaceObjectAtIndex(comboxIndex, withObject: mStr)
        }else {
            if comboxIndex == 14 {
                licenseTypeNum = self.chepaiKeyArr[Int(index)] as! String
            }
            self.contentArr.replaceObjectAtIndex(comboxIndex, withObject: comboxStr)
        }
        
        if self.isCreateNew == false {
            self.updatePerson()
        }

        self.view.endEditing(true)
        UIView.animateWithDuration(0.25) { () -> Void in
            self.setSelfViewBoundsOriginY(0)
        }
    }
    
    func setUpBgScrollView () {
        var i = 0
        preTitleArr.enumerateObjectsUsingBlock { (object, index, stop) -> Void in
            var comBoxWidth = KScreenWidth*2/3 - 10
            var leftMargin:CGFloat = 100.00
            let height:CGFloat = 0.0
            if index == 0 || index == 3 || index == 18 || (index >= 14 && index <= 15) || (index >= 10 && index <= 12) {
                
                let titleArr = self.totalTitleListArr[i] as! NSMutableArray
                self.contentArr.insertObject(titleArr[0], atIndex: index)
                if index == 3 {
                    comBoxWidth = KScreenWidth/6
                    leftMargin = leftMargin + comBoxWidth + 10
                    self.initrightTextField(KScreenWidth*2/3 - comBoxWidth - 20, index: index, leftMargin: leftMargin, height: height)
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
                
                self.comboxScrollView.tapToClose = {
                    UIView.animateWithDuration(0.25) { () -> Void in
                        self.setSelfViewBoundsOriginY(0)
                    }
                }
                
                comBox.tapLMComBoxViewHandler = {
                    self.view.endEditing(true)
                    UIView.animateWithDuration(0.25) { () -> Void in
                        self.setSelfViewBoundsOriginY(0)
                    }
                };
            }else {
                
                self.initrightTextField(comBoxWidth, index: index, leftMargin: leftMargin, height:height)

//                if index == 8 || index == 9 {
//                    self.initVehicleTypeChooseLabel(comBoxWidth, index: index, leftMargin: leftMargin, height:height)
//                }else {
//                }
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
        if index == 2 {
            rightTextField.keyboardType = UIKeyboardType.NumberPad
        }else if index == 16  {
            rightTextField.keyboardType = UIKeyboardType.DecimalPad

        }
        rightTextField.layer.borderWidth = 0.5
        rightTextField.layer.cornerRadius = 4
        rightTextField.placeholder = self.placeHolderArr[index] as? String
        rightTextField.clipsToBounds = true
        if isCreateNew == true {
            rightTextField.text = ""
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
            if index == 7 || index == 8 || index == 9 || index == 13 {
                self.initRightImgView("base_calendar", rightTextField: rightTextField)
            }
        }

    }
    
    func initRightImgView (imgName:String, rightTextField:ZGCCustomTxtField) {
        let rightImgView = UIImageView(image: UIImage(named: imgName))
        rightImgView.userInteractionEnabled = true
        rightImgView.tag = rightTextField.tag
        if rightTextField.tag != 608 && rightTextField.tag != 609 {
            rightTextField.rightView = rightImgView
            rightTextField.rightViewMode = UITextFieldViewMode.Always
        }

        let tap = UITapGestureRecognizer(target: self, action: "tapAction:")
        if rightTextField.tag == 603 {
            rightImgView.addGestureRecognizer(tap)
        }else {
            rightTextField.addGestureRecognizer(tap)
        }
    }
    
    override func initDismissKeyboardTap() {
        
    }
    
    func tapAction(tap:UITapGestureRecognizer) {
        comboxScrollView.closeAllTheComBoxView()
        self.view.endEditing(true)
        UIView.animateWithDuration(0.25) { () -> Void in
            self.setSelfViewBoundsOriginY(0)
        }

        if tap.view?.tag == 603 {
            self.presentImagePickerSheet()
        }else if tap.view?.tag == 608 {
            let vehicleTypeVC = ZGCVehicleTypeListViewController()
            self.navigationController?.pushViewController(vehicleTypeVC, animated: true)

        }else if tap.view?.tag == 609 {
            if customPickerView == nil {
                customPickerView = ZGCCustomPickerView(frame: CGRectMake(0, 0, KScreenWidth, KScreenHeight - 64))
                self.view.addSubview(customPickerView)
            }
            customPickerView.coverViewPresnt()
            customPickerView.getFormatStrHandler = {
                (str:String) -> Void in
               let textField = self.comboxScrollView.viewWithTag(609) as! UITextField
                textField.text = str
                self.contentArr.replaceObjectAtIndex(9, withObject: textField.text!)
                
                if self.isCreateNew == false {
                    self.updatePerson()
                }
            }
            
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
        conLabel.tag = 400 + index
        conLabel.textColor = UIColor.darkGrayColor()
        if isCreateNew == true {
            conLabel.text = ""
        }else {
            conLabel.text = conArr[index] as? String
        }
        self.contentArr.insertObject(conLabel.text!, atIndex: index)
        self.comboxScrollView.addSubview(conLabel)
        conLabel.userInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: "tapAction:")
        conLabel.addGestureRecognizer(tap)
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
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "textFieldTextDidChange:", name: "UITextFieldTextDidChangeNotification", object: nil)

        
        if self.isCreateNew == false {
            dbManager = ZGCPersonDBManager()
            conArr = dbManager.selectPersons()
        }

        self.showLoadingStatusHUD("数据加载中...")
                
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        Alamofire.request(.GET, BaseURLString.stringByAppendingString("dict/baseinfo"), parameters: nil, encoding: .JSON, headers: ["token":UserDefault.objectForKey("token") as! String]).responseJSON {
            response in
            UIApplication.sharedApplication().networkActivityIndicatorVisible = false
            self.removeHUD()
            if let json = response.result.value {
                print(json)

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
                    let key = object.objectForKey("key")
                    self.chepaiKeyArr.addObject(key!)
                })
                
                let chepaiArr = ["京", "沪", "津","渝", "冀", "晋","辽", "吉", "黑","苏", "浙", "皖","闽", "赣", "鲁","豫", "鄂", "琼","川","贵", "云", "陕","甘", "青", "蒙","桂", "藏","宁", "新", "港","澳", "台"] as NSMutableArray
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
                
                self.showLoadingStatusHUD("数据加载中...")

                let copyStr = (GetCurrentDateTransformToDateStrTwo() as NSString).mutableCopy() //使用mutableCopy深复制对象，是深复制后得到的变量不回受原变量的改变而变化
                
                let jpgImage = Util.convertPngToJpg(UIImage(named: "base_license")!, path: DocumentsDirectory, imageName: "\(copyStr)\(".jpg")")
                let image = ImageWithImageSimple(jpgImage, scaledToSize: CGSizeMake(KScreenWidth, KScreenWidth))
                Alamofire.upload(.POST, BaseURLString.stringByAppendingString("recognize/drivingLicense"), headers: ["token":UserDefault.objectForKey("token") as! String], multipartFormData: { multipartFormData in
                    
                    multipartFormData.appendBodyPart(data: UIImageJPEGRepresentation(image, 0.5)!, name: "image", fileName: "license.jpg", mimeType: "image/jpg")
                    
                    }, encodingMemoryThreshold: 0) { encodingResult in
                        self.removeHUD()
                        switch encodingResult {
                        case .Success(let upload, _, _):
                            upload.responseJSON { response in
                                debugPrint(response)
                                if let json = response.result.value {
                                    let model = ZGCStaticsModel(contentWithDic: json as! [NSObject : AnyObject])
                                    if model.success == 1 {
                                        self.contentArr.replaceObjectAtIndex(3, withObject: (model.data as NSDictionary).objectForKey("carnum")!)
                                        self.contentArr.replaceObjectAtIndex(4, withObject: (model.data as NSDictionary).objectForKey("location")!)
                                        self.contentArr.replaceObjectAtIndex(5, withObject: (model.data as NSDictionary).objectForKey("vin")!)
                                        self.contentArr.replaceObjectAtIndex(6, withObject: (model.data as NSDictionary).objectForKey("engineSN")!)
                                        self.contentArr.replaceObjectAtIndex(7, withObject: (model.data as NSDictionary).objectForKey("regDate")!)
                                        
                                        self.resetRightTextFieldtext()
                                        self.resetComboxContent((model.data as NSDictionary).objectForKey("carnum")! as! String)
                                        if self.isCreateNew == false {
                                            self.updatePerson()
                                        }
                                    }
                                }
                                
                            }
                        case .Failure(let encodingError):
                            print(encodingError)
                        }
                        
                }
            }
        }
        
        imagePicker.takePhoto(self)
    }
    
    func resetRightTextFieldtext () {
        for index in 3...7 {
            let rightTextField = self.comboxScrollView.viewWithTag(600 + index) as! UITextField!
            rightTextField.text = self.contentArr[index] as? String
            if index == 3 {
                rightTextField.text = (contentArr[index] as! NSString).substringFromIndex(1)
            }
        }
    }
    
    func resetComboxContent (text:String) {
        let comBox = self.comboxScrollView.viewWithTag(203) as! LMComBoxView
        
        comBox.titlesList.enumerateObjectsUsingBlock({ (object: AnyObject!, idx: Int, stop: UnsafeMutablePointer<ObjCBool>) -> Void in
            let shouldStop: ObjCBool = true
            if ((text as NSString).substringToIndex(1) == String(object)) {
                comBox.defaultIndex = Int32(idx)
                comBox.reloadData()
                stop.initialize(shouldStop)
            }
        })
    }

    func scrollViewDidScroll(scrollView: UIScrollView) {
        self.view.endEditing(true)
        UIView.animateWithDuration(0.25) { () -> Void in
            self.setSelfViewBoundsOriginY(0)
        }
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
        
        if self.txtFieldTag != nil {
            let textField = self.comboxScrollView.viewWithTag(self.txtFieldTag) as! ZGCCustomTxtField
            
            if self.txtFieldTag == 607 ||  self.txtFieldTag ==  608 ||  self.txtFieldTag ==  609 ||  self.txtFieldTag ==  613 {
                textField.resignFirstResponder()
            }
        }
        
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
        let txtField = self.comboxScrollView.viewWithTag(608) as! UITextField
        txtField.text = UserDefault.objectForKey("brand")?.stringByAppendingString((UserDefault.objectForKey("model") as! String).stringByAppendingString(UserDefault.objectForKey("style") as! String))
        if self.isCreateNew == false {
            contentArr.replaceObjectAtIndex(conLabel.tag - 400, withObject: txtField.text!)
            self.updatePerson()
        }
    }
    
    override func tabBarTapAction(tap: UITapGestureRecognizer) {
        super.tabBarTapAction(tap)
        comboxScrollView.closeAllTheComBoxView()
        
        if tap.view!.tag == 335 {
            if isCreateNew == true {
                preTitleArr.enumerateObjectsUsingBlock({ (object, index, stop) -> Void in
                    if index != 0 && index != 18 && index != 15 && index != 14 && (index < 10 || index > 12)  {
                        let rightTextField = self.comboxScrollView.viewWithTag(600 + index) as! UITextField
                        if index == 3 {
                            let mStr = NSMutableString(string: self.contentArr[index] as! String)
                            mStr.replaceCharactersInRange(NSMakeRange(1, mStr.length - 1), withString: rightTextField.text!)
                            self.contentArr.replaceObjectAtIndex(index, withObject: mStr)
                        }else {
                            self.contentArr.replaceObjectAtIndex(index, withObject: rightTextField.text!)
                        }
                    }
                    
//                    else if index == 8 || index == 9 {
//                        self.conLabel = self.comboxScrollView.viewWithTag(400 + index) as! UILabel
//                        self.contentArr.replaceObjectAtIndex(index, withObject: self.conLabel.text!)
//                    }
                })

            }
            
            if Util.verificationMobile(self.contentArr[2] as! String) == false {
                self.showHUD("您输入的联系方式不合法", image: UIImage(), withHiddenDelay: 1.0)
                return
            }
            
            if Util.validateCarNo((contentArr[3] as! NSString).substringFromIndex(1)) == false {
                self.showHUD("您输入的车牌号不合法", image: UIImage(), withHiddenDelay: 1.0)
                return
            }
            
            if Util.validateVinNo(contentArr[5] as! String) == false {
                self.showHUD("您输入的车辆VIN码不合法", image: UIImage(), withHiddenDelay: 1.0)
                return
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
            
            
            
            
            if self.isCreateNew == true {
                
                let subDir = CreateSubDocumentsDirectory()
                
                let dateStr = GetCurrentDateTransformToDateStr()
                let unUpload = UnUpload(name: self.contentArr[1] as? String, saveTime: dateStr, state: "未上传", licenseNo: self.contentArr[3] as? String, vehicleType: self.contentArr[8] as? String, formatStr: "", itemId: "", databasePath:subDir)
                ZGCUnUploadManager().addUnUpload(unUpload, tableName: "T_UnUpload")
                
                if licenseTypeNum == nil {
                    licenseTypeNum = self.chepaiKeyArr[0] as! String
                }
                let other = Other(styleId:UserDefault.objectForKey("Value") as? String, licenseTypeNum: licenseTypeNum)
                let otherDBManager = ZGCOtherDBManager()
                otherDBManager.addOther(other)
                
                self.dbManager = ZGCPersonDBManager()
                
                self.updatePerson()
                
            }
            
            if isCreateNew == true {
                let vehicleConfigVC = ZGCVehicleConfigViewController()
                vehicleConfigVC.isCreateNew = isCreateNew
                self.navigationController?.pushViewController(vehicleConfigVC, animated: true)
            }else {
                let carvalueDetailVC = ZGCCarValueDetailViewController()
                self.navigationController?.pushViewController(carvalueDetailVC, animated: true)
            }
            
            self.checkValuationAndIllegal()

            
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), { () -> Void in
                
                let dir = (UserDefault.objectForKey("subDir")?.stringByAppendingPathComponent("拍照列表"))!
                if !FileManager.isExecutableFileAtPath(dir) {
                    CreateSubDirectories((UserDefault.objectForKey("subDir")?.stringByAppendingPathComponent("拍照列表"))!)
//                    let tabTitleArr = ["车辆正面与车主合照","左前45度","左后45度","右后45度","右前45度","车辆铭牌","发动机舱内车架号","组合仪表","仪表台","前排座椅","后排座椅","后备箱备胎工具","发动机舱","发动机舱后侧防火墙","左前大灯框架","右前大灯框架","左前减震座","右前减震座","左纵梁","右纵梁"] as NSArray
                    
                    let tabTitleArr = ["车辆正面与车主合照","左前45度","左后45度","右后45度"] as NSArray

                    
                    
                    let imgTwoTableNameArr = NSMutableArray(capacity: tabTitleArr.count)
                    
                    tabTitleArr.enumerateObjectsUsingBlock({ (object, index, stop) -> Void in
                        imgTwoTableNameArr.addObject(String("\("T_ImageTwo")\(index)"))
                        let  dir = NSString(string: UserDefault.objectForKey("subDir")!.stringByAppendingString("/拍照列表")).stringByAppendingPathComponent(object as! String)
                        CreateSubDirectories(dir)
                    })
                    
                    imgTwoTableNameArr.enumerateObjectsUsingBlock({ (object, index, stop) -> Void in
                        UserDefault.setObject(object, forKey: "ImageTwoTableName")
                        UserDefault.synchronize()
                        let manager = ZGCImageTwoDBManager()
                        print(manager)
                    })
                    
                    
                }
                
            })
            
            


        }
    }
    
    func updatePerson () {
        // -MARK:- 添加数据到数据库
        let person = Person(type: contentArr[0] as? String, name: contentArr[1] as? String, phone: contentArr[2] as? String, licenseNo: contentArr[3] as? String, location: contentArr[4] as? String, vin: contentArr[5] as? String, engineNo: contentArr[6] as? String, regisDate: contentArr[7] as? String, vehicleType: contentArr[8] as? String, vehicleEmiss: contentArr[9] as? String, transmType: contentArr[10] as? String, driveWay: contentArr[11] as? String, fuelType: contentArr[12] as? String, manufacDate: contentArr[13] as? String, licenseType: contentArr[14] as? String, envirProStand: contentArr[15] as? String, mileage: contentArr[16] as? String, bodyColor: contentArr[17] as? String, carKeys: contentArr[18] as? String, pid:"person")
        
        if self.dbManager.selectPersons().count > 0 {
            self.dbManager.updatePerson(person)
        }else {
            self.dbManager.addPerson(person)
        }
    }
    
    func textFieldTextDidChange(notification:NSNotification) {
        if self.txtFieldTag != nil {
            let textField = notification.object as! UITextField!
            if self.isCreateNew == false {
                contentArr.replaceObjectAtIndex(textField.tag - 600, withObject: textField.text!)
                self.updatePerson()
            }
        }

    }
    
    func checkValuationAndIllegal () {
    
        
//        ["username":"zgc", "styleId":"3361","date":"2015-02-12","milage":"2000"]
        Alamofire.request(.POST, BaseURLString.stringByAppendingString("brand/valuation"), parameters:["username":self.contentArr[1], "styleId":((ZGCOtherDBManager().selectOthers() as NSArray).lastObject! as! Other).styleId!,"date":self.contentArr[7],"milage":self.contentArr[16]] , encoding: .JSON, headers: ["token":UserDefault.objectForKey("token") as! String]).responseJSON {response in
            
            if let json = response.result.value {
                let staticModel = ZGCStaticsModel(contentWithDic:json as! [NSObject : AnyObject])
                if staticModel.success == 1 {
                    let b2cArr = NSMutableArray()
                    (staticModel.data as NSDictionary).objectForKey("B2CLevelPrice")?.enumerateObjectsUsingBlock({ (object, index, stop) -> Void in
                        b2cArr.addObject(object)
                    })
                    b2cArr.addObject((staticModel.data as NSDictionary).objectForKey("newCarPrice")!)
                    
                    
                    
                    let request = NSMutableURLRequest(URL: NSURL(string: BaseURLString.stringByAppendingString("pingche/illegal"))!)
                    request.HTTPMethod = "POST"
//                    let postString = "carnum=冀JKX715&vin=A1D9867B2794016&type=02"
                    let postString = "carnum=\(self.contentArr[3])&vin=\(self.contentArr[5])&type=\(((ZGCOtherDBManager().selectOthers() as NSArray).lastObject! as! Other).licenseTypeNum! as String)"
                    request.setValue(UserDefault.objectForKey("token") as? String, forHTTPHeaderField: "token")
                    request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
                    
                    request.HTTPBody = postString.dataUsingEncoding(NSUTF8StringEncoding)
//                    request.addValue("application/json", forHTTPHeaderField: "Accept")
                    
                    let task = NSURLSession.sharedSession().dataTaskWithRequest(request) { data, response, error in
                        guard error == nil && data != nil else {
                            return
                        }
                        
                        if let httpStatus = response as? NSHTTPURLResponse where httpStatus.statusCode != 200 {
       
                        }
                        
                        do {
                            let json = try NSJSONSerialization.JSONObjectWithData(data!, options: .AllowFragments)
                            let staticsModel = ZGCStaticsModel(contentWithDic: json as! [NSObject : AnyObject])
                            if staticsModel.success == 1 {
                                var demandLoans = ""
                                if ZGCillegalValueDBManager().selectValueOrIllegals().count > 0 {
                                    demandLoans = ((ZGCillegalValueDBManager().selectValueOrIllegals() as NSArray).lastObject as! ValueOrIllegal).demandLoans!
                                }
                                
                                let valueOrIllegalModel = ValueOrIllegal(illegalScore:String((staticsModel.data as NSDictionary).objectForKey("score") as! NSNumber), illegalTimes:String((staticsModel.data as NSDictionary).objectForKey("num") as! NSNumber), illegalPenalty:String((staticsModel.data as NSDictionary).objectForKey("price") as! NSNumber), valueBad: b2cArr[0] as? String, valueNormal: b2cArr[1] as? String, valueGood: b2cArr[2] as? String, valueNew: b2cArr[3] as? String, demandLoans: demandLoans)
                                if ZGCillegalValueDBManager().selectValueOrIllegals().count > 0 {
                                    ZGCillegalValueDBManager().updateValueOrIllegal(valueOrIllegalModel)
                                }else {
                                    ZGCillegalValueDBManager().addValueOrIllegal(valueOrIllegalModel)
                                }
                            }
                        }catch {
                            
                        }
                        
                    }
                    task.resume()
                    
                    
                    
                }
            }
            
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

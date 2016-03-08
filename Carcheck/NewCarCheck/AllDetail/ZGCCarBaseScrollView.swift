//
//  ZGCCarBaseScrollView.swift
//  Carcheck
//
//  Created by GaoCheng.Zou on 16/2/22.
//  Copyright © 2016年 GaoCheng.Zou. All rights reserved.
//

import UIKit
import Alamofire
typealias SetSelfViewBoundsOriginYBlock = (Y:CGFloat) -> Void

class ZGCCarBaseScrollView: UIScrollView, UITextFieldDelegate {

    var setSelfViewBoundsOriginYHandler: SetSelfViewBoundsOriginYBlock!

    
    init(frame: CGRect, tar:AnyObject, sel:Selector) {
        super.init(frame: frame)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:", name: "UIKeyboardWillShowNotification", object: nil)

        let preArr = ["违规扣分", "违章次数","违章罚款", "车况较差","正常磨损", "车况良好","新车价格", "贷款需求"] 
        
        let mPreArr = UserDefault.objectForKey("baseInfoPreTitleArr")?.mutableCopy() as! NSMutableArray
        
        (preArr as NSArray).enumerateObjectsUsingBlock { (object, index, stop) -> Void in
            mPreArr.addObject(object)
        }
        
        let bigTitleArr = ["基本信息", "车辆违章", "参考价格"]
        
        let conArr = ZGCPersonDBManager.shareInstance().selectPersons() as NSArray
        
        
        let editImg = UIImage(named: "detail_edit")
        
        
        let bgView = UIView(frame: CGRectMake(KScreenWidth - 60, 0, 60, 40))
        self.addSubview(bgView)
        bgView.tag = 777
        
        var editImgView = UIImageView()
        editImgView = UIImageView(frame: CGRectMake(bgView.width - (editImg?.size.width)! - 20, (bgView.height - (editImg?.size.height)!)/2, (editImg?.size.width)!, (editImg?.size.height)!))
        editImgView.image = editImg
        editImgView.userInteractionEnabled = true
        bgView.addSubview(editImgView)
        
        let editTap = UITapGestureRecognizer(target: tar, action:sel)
        bgView.addGestureRecognizer(editTap)
                
        var j = 0
        mPreArr.enumerateObjectsUsingBlock { (object, index, stop) -> Void in
          
            if index == 0 || index == 19 || index == 22 {
                let titleLabel = UILabel()
                titleLabel.frame = CGRectMake(0 , 40 * CGFloat(j + 1) + 40*CGFloat(index), KScreenWidth , 40)
                titleLabel.font = UIFont.systemFontOfSize(13.0)
                titleLabel.backgroundColor = UIColor.whiteColor()
                titleLabel.textAlignment = NSTextAlignment.Center
                titleLabel.textColor = UIColor.darkGrayColor()
                titleLabel.text = bigTitleArr[j]
                self.addSubview(titleLabel)
                j = j + 1
                
            }
            
            let preTitleLabel = UILabel()
            preTitleLabel.frame = CGRectMake(0 , 40 * CGFloat(j + 1) + 40*CGFloat(index), KScreenWidth/3, 40)
            preTitleLabel.font = UIFont.systemFontOfSize(13.0)
            
            var color = UIColor(red: 235/255.0, green: 235/255.0, blue: 235/255.0, alpha: 1.0)
            if index % 2 != 0 {
                color = UIColor(red: 245/255.0, green: 246/255.0, blue: 246/255.0, alpha: 1.0)
            }
            
            preTitleLabel.backgroundColor = color
            preTitleLabel.textAlignment = NSTextAlignment.Center
            preTitleLabel.textColor = UIColor.darkGrayColor()
            preTitleLabel.text = mPreArr[index] as? String
            self.addSubview(preTitleLabel)
            
           


            
            let contentLabel = UILabel()
            contentLabel.frame = CGRectMake(preTitleLabel.right , preTitleLabel.top, KScreenWidth*2/3, 40)
            contentLabel.font = UIFont.systemFontOfSize(13.0)
            contentLabel.textAlignment = NSTextAlignment.Center
            var color1 = UIColor(red: 245/255.0, green: 246/255.0, blue: 246/255.0, alpha: 1.0)
            if index % 2 != 0 {
                color1 = UIColor.whiteColor()
            }
            contentLabel.backgroundColor = color1
            contentLabel.numberOfLines = 0
            contentLabel.textColor = UIColor.darkGrayColor()
            if index < conArr.count {
                contentLabel.text = conArr[index] as? String
            }
            self.addSubview(contentLabel)
        }
        

        
        self.contentSize = CGSizeMake(KScreenWidth, CGFloat(mPreArr.count)*40 + 240)
        
        let preTitleLabel = UILabel()
        preTitleLabel.frame = CGRectMake(20 , self.contentSize.height - 60, (KScreenWidth-40)/4, 40)
        preTitleLabel.font = UIFont.systemFontOfSize(13.0)
        preTitleLabel.backgroundColor = UIColor.clearColor()
        preTitleLabel.textAlignment = NSTextAlignment.Right
        preTitleLabel.textColor = UIColor.darkGrayColor()
        preTitleLabel.text = "贷款需求"
        self.addSubview(preTitleLabel)
        
        
        let rightTextField = UITextField.init(frame: CGRectMake(preTitleLabel.right + 10, preTitleLabel.top, 200, preTitleLabel.height))
        rightTextField.delegate = self
        rightTextField.borderStyle = UITextBorderStyle.None
        rightTextField.layer.borderColor = UIColor(red: 212/255.0, green: 213/255.0, blue: 213/255.0, alpha: 1.0).CGColor
        rightTextField.layer.borderWidth = 0.5
        rightTextField.returnKeyType = UIReturnKeyType.Done
        self.addSubview(rightTextField)
        
        
        let suffixTitleLabel = UILabel()
        suffixTitleLabel.frame = CGRectMake(rightTextField.right + 10 , rightTextField.top, 50, 40)
        suffixTitleLabel.font = UIFont.systemFontOfSize(13.0)
        suffixTitleLabel.backgroundColor = UIColor.clearColor()
        suffixTitleLabel.textColor = UIColor.darkGrayColor()
        suffixTitleLabel.text = "万元"
        self.addSubview(suffixTitleLabel)
        
        
        Alamofire.request(.POST, BaseURLString.stringByAppendingString("brand/valuation"), parameters: ["username":"zgc", "styleId":3361,"date":"2015-12-12","milage":2000], encoding: .JSON, headers: ["token":UserDefault.objectForKey("token") as! String]).responseJSON {response in
            if let json = response.result.value {
                print(json.objectForKey("data"))
            }
            
        }
        
    }
    
    //监听键盘显示的方法实现
    func keyboardWillShow(notification: NSNotification!) {
        let keyboardSize = (notification.userInfo![UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.CGRectValue()
        setSelfViewBoundsOriginYHandler(Y: (keyboardSize?.height)! - 49)
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        setSelfViewBoundsOriginYHandler(Y:0)
        self.endEditing(true)
        return true
    }
        
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

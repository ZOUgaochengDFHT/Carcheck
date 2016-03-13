//
//  ZGCCarBaseScrollView.swift
//  Carcheck
//
//  Created by GaoCheng.Zou on 16/2/22.
//  Copyright © 2016年 GaoCheng.Zou. All rights reserved.
//

import UIKit
import Alamofire
class ZGCCarBaseScrollView: UIScrollView {

    let conArr = NSMutableArray()

    init(frame: CGRect, tar:AnyObject, sel:Selector) {
        super.init(frame: frame)
        
        if ZGCillegalValueDBManager().selectValueOrIllegals().count == 0 {
            let valueOrIllegalModel = ValueOrIllegal(illegalScore: "", illegalTimes: "", illegalPenalty: "", valueBad: "", valueNormal: "", valueGood: "", valueNew: "", demandLoans: "")
            ZGCillegalValueDBManager().addValueOrIllegal(valueOrIllegalModel)
            
        }
        
        let preArr = ["违规扣分", "违章次数","违章罚款", "车况较差","正常磨损", "车况良好","新车价格", "贷款需求"] 
        
        let mPreArr = UserDefault.objectForKey("baseInfoPreTitleArr")?.mutableCopy() as! NSMutableArray
        
        (preArr as NSArray).enumerateObjectsUsingBlock { (object, index, stop) -> Void in
            mPreArr.addObject(object)
        }
        
        let bigTitleArr = ["基本信息", "车辆违章", "参考价格"]
        
        
        ZGCPersonDBManager().selectPersons().enumerateObjectsUsingBlock { (object, index, stop) -> Void in
            self.conArr.addObject(object)
        }
        
        conArr.removeLastObject()
        
        let publishArr = ["", "", ""] as NSMutableArray
        
        let valueArr = ["", "", "", ""] as NSMutableArray
        
        
        (publishArr as NSMutableArray).enumerateObjectsUsingBlock { (object, index, stop) -> Void in
            self.conArr.addObject(object)
        }
        

        (valueArr as NSMutableArray).enumerateObjectsUsingBlock { (object, index, stop) -> Void in
            self.conArr.addObject(object)
        }
        
        conArr.addObject("")
        
        
                
        var j = 0
        mPreArr.enumerateObjectsUsingBlock { (object, index, stop) -> Void in
          
            if index == 0 || index == 19 || index == 22 {
                let titleLabel = UILabel()
                titleLabel.frame = CGRectMake(0 , 40 * CGFloat(j) + 40*CGFloat(index), KScreenWidth , 40)
                titleLabel.font = UIFont.systemFontOfSize(13.0)
                titleLabel.backgroundColor = LoginBottomLayerColor
                titleLabel.textAlignment = NSTextAlignment.Center
                titleLabel.textColor = UIColor.darkGrayColor()
                titleLabel.text = bigTitleArr[j]
                self.addSubview(titleLabel)
                j = j + 1
                if index == 0 {
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
                }
                
            }
            
            let preTitleLabel = UILabel()
            preTitleLabel.frame = CGRectMake(0 , 40 * CGFloat(j) + 40*CGFloat(index), KScreenWidth/3, 40)
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
            contentLabel.tag = 500 + index
            contentLabel.textColor = UIColor.darkGrayColor()
            contentLabel.text = self.conArr[index] as? String
            self.addSubview(contentLabel)
        }
        

        
        self.contentSize = CGSizeMake(KScreenWidth, CGFloat(mPreArr.count)*40 + 120)
        
        
        Alamofire.request(.POST, BaseURLString.stringByAppendingString("brand/valuation"), parameters: ["username":"zgc", "styleId":3361,"date":"2015-12-12","milage":2000], encoding: .JSON, headers: ["token":UserDefault.objectForKey("token") as! String]).responseJSON {response in
            if let json = response.result.value {
                let staticModel = ZGCStaticsModel(contentWithDic:json as! [NSObject : AnyObject])
                if staticModel.code == 200 {
                    let b2cArr = NSMutableArray()
                    (staticModel.data as NSDictionary).objectForKey("B2CLevelPrice")?.enumerateObjectsUsingBlock({ (object, index, stop) -> Void in
                        b2cArr.addObject(object)
                    })
                    b2cArr.addObject((staticModel.data as NSDictionary).objectForKey("newCarPrice")!)
                    
                    b2cArr.enumerateObjectsUsingBlock({ (object, index, stop) -> Void in
                        let contentLabel = self.viewWithTag(500 + self.conArr.count - b2cArr.count + index - 1) as! UILabel
                        contentLabel.text = (object as? String)?.stringByAppendingString("万元")
                        valueArr.addObject(contentLabel.text!)
                    })
                    
                    let valueOrIllegalModel = ValueOrIllegal(illegalScore: publishArr[0] as? String, illegalTimes: publishArr[1] as? String, illegalPenalty: publishArr[2] as? String, valueBad: valueArr[0] as? String, valueNormal: valueArr[1] as? String, valueGood: valueArr[2] as? String, valueNew: valueArr[3] as? String, demandLoans: "")
                    
                    ZGCillegalValueDBManager().updateValueOrIllegal(valueOrIllegalModel)
                }
            }
            
        }
        
    }
    
    func setLastStr(str:String) {
        if str != "" {
            let contentLabel = self.viewWithTag(500 + conArr.count - 1) as! UILabel
            contentLabel.text = str.stringByAppendingString("万元")
            
            
        }
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

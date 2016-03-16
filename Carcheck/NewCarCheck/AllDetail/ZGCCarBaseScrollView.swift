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


    init(frame: CGRect, tar:AnyObject, sel:Selector, isEditingOrNot:Bool) {
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
        
        let valueOrIllegalModel = (ZGCillegalValueDBManager().selectValueOrIllegals() as NSArray).lastObject as! ValueOrIllegal
        
//        let array = [, valueOrIllegalModel.illegalTimes, valueOrIllegalModel.illegalPenalty!, valueOrIllegalModel.valueBad!,valueOrIllegalModel.valueNormal!, valueOrIllegalModel.valueGood!, valueOrIllegalModel.valueNew!, valueOrIllegalModel.demandLoans!] as NSArray
        
        self.conArr.addObject("\(valueOrIllegalModel.illegalScore!)\("分")")
        self.conArr.addObject("\(valueOrIllegalModel.illegalTimes!)\("次")")
        self.conArr.addObject("\(valueOrIllegalModel.illegalPenalty!)\("元")")
        self.conArr.addObject("\(valueOrIllegalModel.valueBad!)\("万")")
        self.conArr.addObject("\(valueOrIllegalModel.valueNormal!)\("万")")
        self.conArr.addObject("\(valueOrIllegalModel.valueGood!)\("万")")
        self.conArr.addObject("\(valueOrIllegalModel.valueNew!)\("万")")
        var str = ""
        if valueOrIllegalModel.demandLoans! != "" {
            str = "\(valueOrIllegalModel.demandLoans!)\("万")"
        }
        self.conArr.addObject(str)

        
                
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
                    
                    bgView.hidden = !isEditingOrNot
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
        
        
        
    }
    
    func setLastStr(demandLoans:String) {
        if demandLoans != "" {
            let contentLabel = self.viewWithTag(500 + conArr.count - 1) as! UILabel
            contentLabel.text = "\(demandLoans)\("万")"
        }
        
        let valueOrIllegalModel = (ZGCillegalValueDBManager().selectValueOrIllegals() as NSArray).lastObject as! ValueOrIllegal
        
        ZGCillegalValueDBManager().deleteValueOrIllegal(valueOrIllegalModel)

        let changeValueOrIllegalModel = ValueOrIllegal(illegalScore: valueOrIllegalModel.illegalScore, illegalTimes: valueOrIllegalModel.illegalScore, illegalPenalty: valueOrIllegalModel.illegalPenalty, valueBad: valueOrIllegalModel.valueBad, valueNormal: valueOrIllegalModel.valueNormal, valueGood: valueOrIllegalModel.valueGood, valueNew: valueOrIllegalModel.valueNew, demandLoans: demandLoans)
        
        ZGCillegalValueDBManager().addValueOrIllegal(changeValueOrIllegalModel)

    }

    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }


}

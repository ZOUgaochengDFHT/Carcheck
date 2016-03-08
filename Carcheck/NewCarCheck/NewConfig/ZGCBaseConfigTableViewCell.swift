//
//  ZGCBaseConfigTableViewCell.swift
//  Carcheck
//
//  Created by GaoCheng.Zou on 16/3/1.
//  Copyright © 2016年 GaoCheng.Zou. All rights reserved.
//

import UIKit

class ZGCBaseConfigTableViewCell: UITableViewCell {

    var fieldsModel: ZGCFieldsModel!
    var conDic: NSDictionary!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        for i in 0...1 {
            let conLabel = UILabel(frame: CGRectZero)
            conLabel.tag = 100 + i
            conLabel.font = UIFont.systemFontOfSize(12.0)
            self.contentView.addSubview(conLabel)
            
            let verticalLayer = CALayer()
            verticalLayer.backgroundColor = UIColor(red: 188/255.0, green: 186/255.0, blue: 193/255.0, alpha: 1.0).CGColor
            verticalLayer.setNeedsDisplay()
            verticalLayer.anchorPoint = CGPointZero
            self.contentView.layer.addSublayer(verticalLayer)
            verticalLayer.bounds = CGRectMake(0, 0, 0.5, self.height)
            verticalLayer.position = CGPointMake((KScreenWidth/2)*CGFloat(i), 0)
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        for i in 0...1 {
            let conLabel = self.contentView.viewWithTag(100 + i) as! UILabel
            conLabel.textAlignment = NSTextAlignment.Center
            conLabel.numberOfLines = 0
            conLabel.frame = CGRectMake((KScreenWidth/2) * CGFloat(i), 0, KScreenWidth/2, self.height)
            if i == 0 {
                conLabel.text = fieldsModel.Title
            }else {

                (self.conDic.allKeys as NSArray).enumerateObjectsUsingBlock( { (object: AnyObject!, idx: Int, stop: UnsafeMutablePointer<ObjCBool>) -> Void in
                    let shouldStop: ObjCBool = true
                    if object as! String == self.fieldsModel.Key {
                        conLabel.text = self.conDic.objectForKey(self.fieldsModel.Key) as? String
                        stop.initialize(shouldStop)
                    }else {
                        conLabel.text = ""
                    }
                })
                
            }
        }
        
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

//
//  ZGCCheckBox.swift
//  Carcheck
//
//  Created by GaoCheng.Zou on 16/2/16.
//  Copyright © 2016年 GaoCheng.Zou. All rights reserved.
//

import UIKit

let ZGC_CHECK_ICON_WH:CGFloat = 15.0
let ZGC_ICON_TITLE_MARGIN:CGFloat = 5.0

/**
 *  ZGCCheckBoxDelegate
 */
protocol ZGCCheckBoxDelegate:NSObjectProtocol {
    //- (void)didSelectedCheckBox:(QCheckBox *)checkbox checked:(BOOL)checked;
    @available(iOS 8.0, *)
    func didSelectedCheckBox(checkBox:ZGCCheckBox, checked:Bool) -> Void
}

class ZGCCheckBox: UIButton {

    var _checked:Bool!
    var userInfo:AnyObject!
    var checkBoxDelegate:ZGCCheckBoxDelegate!
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */
    
    func initWithDelegate(delegate:AnyObject) {
        checkBoxDelegate = delegate as! ZGCCheckBoxDelegate
        self.exclusiveTouch = true
        self.setImage(UIImage(named: "checkbox1_unchecked"), forState: UIControlState.Normal)
        self.setImage(UIImage(named: "checkbox1_checked"), forState: UIControlState.Selected)
        self.addTarget(self, action: "checkboxBtnChecked", forControlEvents: UIControlEvents.TouchUpInside)
    }
    
    var checked:Bool {
        get {
            return _checked
        }
        set {
            _checked = checked
            self.selected = checked
            if checkBoxDelegate != nil && checkBoxDelegate.respondsToSelector("didSelectedCheckBox:checked:") {
                checkBoxDelegate.didSelectedCheckBox(self, checked: self.selected)
            }
        }
    }
    
    func checkboxBtnChecked() {
        self.selected = !self.selected
        _checked = self.selected
        if checkBoxDelegate != nil && checkBoxDelegate.respondsToSelector("didSelectedCheckBox:checked:") {
            checkBoxDelegate.didSelectedCheckBox(self, checked: self.selected)
        }
    }
    
    override func imageRectForContentRect(contentRect: CGRect) -> CGRect {
        return CGRectMake(0, (CGRectGetHeight(contentRect) - ZGC_CHECK_ICON_WH)/2.0, ZGC_CHECK_ICON_WH, ZGC_CHECK_ICON_WH)
    }
    
    override func titleRectForContentRect(contentRect: CGRect) -> CGRect {
        return CGRectMake(ZGC_CHECK_ICON_WH + ZGC_ICON_TITLE_MARGIN, 0, CGRectGetWidth(contentRect) - ZGC_CHECK_ICON_WH - ZGC_ICON_TITLE_MARGIN, CGRectGetHeight(contentRect))
    }
    
    

}

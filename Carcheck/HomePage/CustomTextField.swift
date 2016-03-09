//
//  CustomTextField.swift
//  ZrmxCommunity
//
//  Created by GaoCheng.Zou on 15/11/16.
//  Copyright © 2015年 GaoCheng.Zou. All rights reserved.
//

import UIKit

class CustomTextField: UITextField {

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */


    
    override func leftViewRectForBounds(bounds: CGRect) -> CGRect {
        var textRect = super.leftViewRectForBounds(bounds)
        textRect.origin.x = 10;
        return textRect
    }
    
    override func rightViewRectForBounds(bounds: CGRect) -> CGRect {
        var textRect = super.rightViewRectForBounds(bounds)
        textRect.origin.x = self.frame.size.width-25;
        return textRect
    }
}

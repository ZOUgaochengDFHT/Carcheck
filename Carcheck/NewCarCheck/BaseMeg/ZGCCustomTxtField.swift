//
//  ZGCCustomTxtField.swift
//  Carcheck
//
//  Created by GaoCheng.Zou on 16/3/2.
//  Copyright © 2016年 GaoCheng.Zou. All rights reserved.
//

import UIKit

extension UITextField {
    @IBInspectable var gc_borderColor: UIColor? {
        get {
            if let colorRef = layer.borderColor {
                return  UIColor(CGColor: colorRef)
            }
            return nil
        }
        
        set {
            layer.borderColor = newValue?.CGColor
        }
    }
}

//extension UIImageView {
//    @IBInspectable var gc_cornerRadius: CGFloat? {
//        get {
//            if let cornerRadius = layer.cornerRadius {
//                return  4
//            }
//            return nil
//        }
//        
//        set {
//            layer.cornerRadius = newValue!
//        }
//    }
//}

class ZGCCustomTxtField: UITextField {

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */
    override func rightViewRectForBounds(bounds: CGRect) -> CGRect {
        var textRect = super.rightViewRectForBounds(bounds)
        textRect.origin.x -= 5
        return textRect
    }
    

}

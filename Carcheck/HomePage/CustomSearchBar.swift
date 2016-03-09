//
//  CustomSearchBar.swift
//  ZrmxCommunity
//
//  Created by GaoCheng.Zou on 15/11/16.
//  Copyright © 2015年 GaoCheng.Zou. All rights reserved.
//

import UIKit
typealias PassSearchBtnClickedBlock = (String) -> Void
class CustomSearchBar: UIView , UITextFieldDelegate {

    var textField:CustomTextField!
    var searchBtnHandler:PassSearchBtnClickedBlock!

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    func setPlaceholder(placeholder:String, tintColor:UIColor, sel:Selector, target:AnyObject) {
        textField = CustomTextField()
        textField.frame = frame
        textField.backgroundColor = UIColor.whiteColor()
        textField.delegate = self
        textField.font = UIFont.systemFontOfSize(15.0)
        textField.tintColor = tintColor
        textField.tag == 345;
        textField.layer.cornerRadius = self.frame.size.height/2
        textField.becomeFirstResponder()
        let leftImgView = UIImageView.init(frame: CGRectMake(0, 0, 15, 16))
        leftImgView.image = UIImage(named: "ic_action_search_gray")
        textField.leftView = leftImgView
        textField.leftViewMode = UITextFieldViewMode.Always
        
        let rightImgView = UIImageView.init(frame: CGRectMake(0, 0, 15, 20))
        rightImgView.image = UIImage(named: "ic_action_voice_gray")
        textField.rightView = rightImgView
        rightImgView.userInteractionEnabled = true
        textField.rightViewMode = UITextFieldViewMode.Always
        
        textField.placeholder = placeholder
        textField.returnKeyType = UIReturnKeyType.Search
        
        self.addSubview(textField)
        
        let tap = UITapGestureRecognizer()
        tap.addTarget(target, action: sel)
        rightImgView.addGestureRecognizer(tap)
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool  {
        searchBtnHandler(textField.text!)
        return true;
    }// called when 'return' key pressed. return NO to ignore.

    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        return true
    }// return NO to not change text

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

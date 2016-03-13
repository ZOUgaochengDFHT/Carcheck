//
//  Util.m
//  Carcheck
//
//  Created by GaoCheng.Zou on 16/3/11.
//  Copyright © 2016年 GaoCheng.Zou. All rights reserved.
//

#import "Util.h"

@implementation Util
/**
 *  png to jpg
 *
 */
+ (UIImage *)convertPngToJpg:(UIImage *)pngImage {
    NSData *data_jpgfromjpg = UIImageJPEGRepresentation(pngImage, 0.5);
    NSString *documents = [NSHomeDirectory() stringByAppendingString:@"/Documents/"];
    NSString *pathjpgfromjpg = [documents stringByAppendingString:@"license.jpg"];
    [data_jpgfromjpg writeToFile:pathjpgfromjpg atomically:YES];
    UIImage *jpgImage = [UIImage imageNamed:pathjpgfromjpg];
    return jpgImage;
}

/**
 *  验证手机号（手机号是否正确）
 *
 */
+ (BOOL)verificationMobile :(NSString *)phoneText {
    
    //手机号以13， 15，18开头，八个 \d 数字字符
    NSString *phoneRegex = @"^((13[0-9])|(15[^4,\\D])|(18[0,0-9]))\\d{8}$";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneRegex];
    BOOL isTrue = [phoneTest evaluateWithObject:phoneText];
    return isTrue;
}


/**
 *  车牌号验证
 *
 */
+ (BOOL)validateCarNo:(NSString*)carNo {
    NSString *carRegex = @"^[A-Za-z]{1}[A-Za-z_0-9]{5}$";
    NSPredicate *carTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",carRegex];
    return [carTest evaluateWithObject:carNo];
}
@end

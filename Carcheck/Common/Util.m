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
+ (UIImage *)convertPngToJpg:(UIImage *)pngImage path:(NSString *)path imageName:(NSString *)imageName {
    NSData *data_jpgfromjpg = UIImageJPEGRepresentation(pngImage, 0.5);
    NSString *pathjpgfromjpg = [path stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.jpg", imageName]];
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

/**
 *  车辆VIN码验证
 *
 */
+ (BOOL)validateVinNo:(NSString*)vinNo {
    NSString *carRegex = @"^[A-Za-z_0-9]{17}$";
    NSPredicate *carTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",carRegex];
    return [carTest evaluateWithObject:vinNo];
}
/**
  *  获取工单状态
  *
  */
+ (NSString *)getNumWithStatus:(int)num {
    NSString *status = @"pendding";
    if (num == 2) {
        status = @"unpass";
    }else if (num == 3) {
        status = @"pass";
    }
    return status;
}

+ (NSString *)getWordWithStatus:(NSString *)word {
    NSString *status = @"待审核";
    if ([word isEqualToString:@"unpass"]) {
        status = @"审核未通过";
    }else if ([word isEqualToString:@"pass"]) {
        status = @"审核通过";
    }
    return status;
}
@end


//
//  Util.h
//  Carcheck
//
//  Created by GaoCheng.Zou on 16/3/11.
//  Copyright © 2016年 GaoCheng.Zou. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface Util : NSObject

/**
 *  png to jpg
 *
 */
+ (UIImage *)convertPngToJpg:(UIImage *)pngImage path:(NSString *)path imageName:(NSString *)imageName;
/**
 *  验证手机号（手机号是否正确）
 *
 */
+ (BOOL)verificationMobile :(NSString *)phoneText;


/**
 *  车牌号验证
 *

 */
+ (BOOL)validateCarNo:(NSString*)carNo;

/**
 *  车辆VIN码验证
 *
 */
+ (BOOL)validateVinNo:(NSString*)vinNo;
/**
 *  获取工单状态
 *
 */
+ (NSString *)getNumWithStatus:(int)num;
+ (NSString *)getWordWithStatus:(NSString *)word;
@end

//
//  ZGCStaticsModel.m
//  Carcheck
//
//  Created by GaoCheng.Zou on 16/2/23.
//  Copyright © 2016年 GaoCheng.Zou. All rights reserved.
//

#import "ZGCStaticsModel.h"

//根据图片名返回对应的图片
#define PNGImage(N) [UIImage imageNamed:(N)]
//设置是否调试模式
#define MYDEBUG 1
#if MYDEBUG
#define MYLog(xx, ...)  NSLog(@"%s(%d): " xx, __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)
#else
#define MYLog(xx, ...)  ((void)0)
#endif


#define DocumentsDirectory [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES) lastObject]

@implementation ZGCStaticsModel
- (void)setCode:(NSNumber *)code {
    _code = code;
}

@end

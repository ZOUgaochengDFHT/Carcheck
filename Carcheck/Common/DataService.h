//
//  DataService.h
//  Carcheck
//
//  Created by GaoCheng.Zou on 16/3/11.
//  Copyright © 2016年 GaoCheng.Zou. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DataService : NSObject

+ (void)requestWithToken:(NSString *)token;


+ (void)httpPutData:(NSString*)strUrl Data:(NSData*)data FileName:(NSString *)fileName DataType:(NSString*)dataType Token:(NSString *)token;
@end

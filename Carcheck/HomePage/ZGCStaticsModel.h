//
//  ZGCStaticsModel.h
//  Carcheck
//
//  Created by GaoCheng.Zou on 16/2/23.
//  Copyright © 2016年 GaoCheng.Zou. All rights reserved.
//

#import "BaseModel.h"

@interface ZGCStaticsModel : BaseModel
/*    code = 2000;
 data = "{\"rate\":\"33.33%\",\"avgtime\":\"9999\",\"unpass\":1,\"pass\":1,\"collect\":3}";
 message = "";
 success = 1;*/

@property (nonatomic, strong) NSNumber *code;
@property (nonatomic, strong) NSNumber *success;
@property (nonatomic, strong) NSDictionary *data;
@property (nonatomic, copy) NSString *message;

@end

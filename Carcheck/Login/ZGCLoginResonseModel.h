//
//  ZGCLoginResonseModel.h
//  Carcheck
//
//  Created by GaoCheng.Zou on 16/2/18.
//  Copyright © 2016年 GaoCheng.Zou. All rights reserved.
//

#import "BaseModel.h"

@interface ZGCLoginResonseModel : BaseModel

@property (nonatomic, strong) NSNumber *success;
@property (nonatomic, strong) NSNumber *code;
@property (nonatomic, copy) NSString *message;
@property (nonatomic, strong) NSString *data;

@end

//
//  ZGCCarBrandModel.h
//  Carcheck
//
//  Created by GaoCheng.Zou on 16/2/24.
//  Copyright © 2016年 GaoCheng.Zou. All rights reserved.
//

#import "BaseModel.h"

@interface ZGCCarBrandModel : BaseModel
/**
 *     
 GroupName = B;
 Text = "\U6bd4\U4e9a\U8fea";
 Value = 15;
 */

@property (nonatomic, copy) NSString *GroupName;
@property (nonatomic, copy) NSString *Text;
@property (nonatomic, copy) NSString *Value;

@end

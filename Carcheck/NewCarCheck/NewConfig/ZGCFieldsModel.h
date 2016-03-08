//
//  ZGCFieldsModel.h
//  Carcheck
//
//  Created by GaoCheng.Zou on 16/3/1.
//  Copyright © 2016年 GaoCheng.Zou. All rights reserved.
//

#import "BaseModel.h"

@interface ZGCFieldsModel : BaseModel
/* Key = CarReferPrice;
 Title = "\U5382\U5bb6\U6307\U5bfc\U4ef7";
 Units = "";*/

@property (nonatomic, copy) NSString *Key;
@property (nonatomic, copy) NSString *Title;
@property (nonatomic, copy) NSString *Units;

@end

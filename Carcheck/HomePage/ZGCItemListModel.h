//
//  ZGCItemListModel.h
//  Carcheck
//
//  Created by GaoCheng.Zou on 16/3/15.
//  Copyright © 2016年 GaoCheng.Zou. All rights reserved.
//

#import "BaseModel.h"

@interface ZGCItemListModel : BaseModel
/* carnum = "\U4eacqq";
 carspec = "\U5317\U6c7d\U7ec5\U5b9d\U7ec5\U5b9dD601.8T \U81ea\U52a8 \U7cbe\U82f1\U578b";
 date = "2016-03-15 11:29:44";
 id = 004d611a414a454f98a1873b5968fa6a;
 owner = qq;
 status = pendding;*/

@property (copy, nonatomic) NSString *carnum;
@property (copy, nonatomic) NSString *carspec;
@property (copy, nonatomic) NSString *date;
@property (copy, nonatomic) NSString *itemID;
@property (copy, nonatomic) NSString *owner;
@property (copy, nonatomic) NSString *status;
@end

//
//  ZGCItemListModel.m
//  Carcheck
//
//  Created by GaoCheng.Zou on 16/3/15.
//  Copyright © 2016年 GaoCheng.Zou. All rights reserved.
//

#import "ZGCItemListModel.h"

@implementation ZGCItemListModel

- (void)setAttributes:(NSDictionary *)jsonDic {
    self.carnum = [jsonDic objectForKey:@"carnum"];
    self.carspec = [jsonDic objectForKey:@"carspec"];
    self.date = [jsonDic objectForKey:@"date"];
    self.itemID = [jsonDic objectForKey:@"id"];
    self.owner = [jsonDic objectForKey:@"owner"];
    self.status = [jsonDic objectForKey:@"status"];

}

@end

//
//  ZGCInfoModel.h
//  Carcheck
//
//  Created by GaoCheng.Zou on 16/2/18.
//  Copyright © 2016年 GaoCheng.Zou. All rights reserved.
//

#import "BaseModel.h"

@interface ZGCInfoModel : BaseModel
/*
 
 departmentId = 1;
 departmentName = "\U529e\U516c\U5ba4";
 email = "xiaowie@xioawie.com";
 img = "https://uc.zrlh.net/Uploads/201603/9/94c423bf8c3d405193c56c2e299259b3.jpg";
 name = "\U7ba1\U7406\U5458";
 phone = 18888888888;
 positionId = 1;
 positionName = "\U529e\U516c\U5ba4";
 roleId = 1;
 roleName = "\U7ba1\U7406\U5458";
 sex = "\U5973";
 status = 1;
 userId = 1;
 userName = admin;
 
 */

@property (nonatomic, strong) NSNumber *departmentId;
@property (nonatomic, copy) NSString *departmentName;
@property (nonatomic, copy) NSString *email;
@property (nonatomic, copy) NSString *img;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, strong) NSNumber *phone;
@property (nonatomic, strong) NSNumber *positionId;
@property (nonatomic, copy) NSString *positionName;
@property (nonatomic, strong) NSNumber *roleId;
@property (nonatomic, copy) NSString *roleName;
@property (nonatomic, copy) NSString *sex;
@property (nonatomic, strong) NSNumber *status;
@property (nonatomic, strong) NSNumber *userId;
@property (nonatomic, copy) NSString *userName;


@end




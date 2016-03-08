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
 
 返回值字段	字段类型	字段说明
 success	boolean	成功标记
 code	int	响应码,正常返回为200
 message	string	当请求失败时,该字段为错误消息
 data	object	用户信息
 userName	string	用户登录名
 name	string	用户姓名
 sex	string	性别
 status	int	状态
 img	string	用户头像
 roleId	int	角色ID
 roleName	string	角色名
 departmentName	string	部门名称
 departmentId	int	部门ID
 positionId	int	岗位ID
 positionName	string	岗位名称
 email	string	邮箱
 phone	string	手机
 
 departmentId = 1;
 departmentName = "\U529e\U516c\U5ba4";
 email = "xiaowie@xioawie.com";
 img = "https://uc.zrlh.net/Uploads/201602/17/00e14cde766148d0b7c3a60a90d52946.jpg";
 name = "\U7ba1\U7406\U5458";
 phone = 18888888888;
 positionId = 1;
 positionName = "\U529e\U516c\U5ba4";
 roleId = 1;
 roleName = "\U7ba1\U7406\U5458";
 sex = "\U5973";
 status = 1;
 userId = 1;
 userName = admin;*/

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




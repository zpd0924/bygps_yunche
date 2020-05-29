//
//  BYCompanyModel.h
//  BYGPS
//
//  Created by 李志军 on 2018/12/28.
//  Copyright © 2018 miwer. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BYCompanyModel : NSObject
///所属分组名称
@property (nonatomic,strong) NSString *groupName;
///所属分组id
@property (nonatomic,strong) NSString *groupId;
///姓名
@property (nonatomic,strong) NSString *userName;
///登录名
@property (nonatomic,strong) NSString *loginName;
///用户id
@property (nonatomic,strong) NSString *userId;
@end

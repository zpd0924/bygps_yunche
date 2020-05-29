//
//  BYShareUserModel.h
//  BYGPS
//
//  Created by 李志军 on 2018/12/10.
//  Copyright © 2018 miwer. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BYShareUserModel : NSObject
/**************外部员工**************/
///手机号码 或用户名
@property (nonatomic,strong) NSString *mobile;
///是否合法
@property (nonatomic,assign) BOOL isValid;

/**************内部员工**************/
///用户ID
@property (nonatomic,strong) NSString *receiveShareUserId;
///姓名
@property (nonatomic,strong) NSString *receiveShareUserName;
///  登录名
@property (nonatomic,strong) NSString *userName;

@end

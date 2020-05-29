//
//  BYWechatLoginModel.h
//  BYGPS
//
//  Created by 李志军 on 2019/2/18.
//  Copyright © 2019 miwer. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface BYWechatLoginModel : NSObject
@property (nonatomic,strong) NSString *access_token;
@property (nonatomic,strong) NSString *openid;
@property (nonatomic,strong) NSString *refresh_token;
@property (nonatomic,strong) NSString *scope;
@property (nonatomic,strong) NSString *unionid;
@end


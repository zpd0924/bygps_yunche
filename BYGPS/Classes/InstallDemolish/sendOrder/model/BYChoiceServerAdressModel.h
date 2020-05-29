//
//  BYChoiceServerAdressModel.h
//  BYGPS
//
//  Created by 李志军 on 2018/7/24.
//  Copyright © 2018年 miwer. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BYChoiceServerAdressModel : NSObject
///省id
@property (nonatomic,strong) NSString *pid;
@property (nonatomic,strong) NSString *pName;

///首字母
@property (nonatomic,strong) NSString *firstCode;
///首字母是否隐藏
@property (nonatomic,assign) BOOL isHidden;
@end

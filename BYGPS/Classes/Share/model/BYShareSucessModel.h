//
//  BYShareSucessModel.h
//  BYGPS
//
//  Created by 李志军 on 2019/1/7.
//  Copyright © 2019 miwer. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BYShareSucessModel : NSObject
///车牌
@property (nonatomic,strong) NSString *carNum;
///车主
@property (nonatomic,strong) NSString *carOwnerName;
///分享url
@property (nonatomic,strong) NSString *shareUrl;
///分享文本
@property (nonatomic,strong) NSString *Description;
@end

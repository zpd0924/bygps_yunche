//
//  BYCarTypeBrandModel.h
//  BYGPS
//
//  Created by 李志军 on 2018/7/26.
//  Copyright © 2018年 miwer. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BYCarTypeBrandModel : NSObject
///品牌ID
@property (nonatomic,strong) NSString *brand_id;
///品牌名称
@property (nonatomic,strong) NSString *brand_name;
///品牌名称拼音首字母
@property (nonatomic,strong) NSString *initial;
@end

//
//  BYVerUpdateModel.h
//  xsxc
//
//  Created by 李志军 on 2018/7/3.
//  Copyright © 2018年 主沛东. All rights reserved.
//

#import "JSONModel.h"


@interface BYVerUpdateModel : JSONModel
///升级描述
@property (nonatomic,strong) NSString *Description;
///跳转地址
@property (nonatomic,strong) NSString *fileUrl;
///是否要升级 1要 0不要
@property (nonatomic,assign) NSInteger flag;
///是否强制升级
@property (nonatomic,assign) NSInteger isForce;

@end

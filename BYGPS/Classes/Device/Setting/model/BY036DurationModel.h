//
//  BY036DurationModel.h
//  BYGPS
//
//  Created by ZPD on 2017/12/14.
//  Copyright © 2017年 miwer. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface BY036DurationModel : JSONModel

@property (nonatomic,strong) NSString *title;

@property (nonatomic,strong) NSString *duration;

@property (nonatomic,assign) BOOL seleted;

@end

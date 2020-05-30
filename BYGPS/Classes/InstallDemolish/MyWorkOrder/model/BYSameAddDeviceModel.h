//
//  BYSameAddDeviceModel.h
//  BYGPS
//
//  Created by 主沛东 on 2019/4/30.
//  Copyright © 2019 miwer. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface BYSameAddDeviceModel : NSObject

@property (nonatomic , strong) NSString *locationType;

@property (nonatomic , assign) CGFloat deviceAddLon;

@property (nonatomic , assign) CGFloat deviceAddLat;

@property (nonatomic , strong) NSString *deviceAdd;

@property (nonatomic , strong) NSString *locationTime;

@property (nonatomic , assign) CGFloat pop_H;
@end

NS_ASSUME_NONNULL_END

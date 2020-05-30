//
//  BYSameAddInstallModel.h
//  BYGPS
//
//  Created by 主沛东 on 2019/4/30.
//  Copyright © 2019 miwer. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface BYSameAddInstallModel : NSObject


@property (nonatomic , strong) NSString *installTime;

@property (nonatomic , assign) CGFloat installAddLat;

@property (nonatomic , assign) CGFloat installAddLon;

@property (nonatomic , strong) NSString *installAdd;

@property (nonatomic , assign) CGFloat pop_H;

@end

NS_ASSUME_NONNULL_END

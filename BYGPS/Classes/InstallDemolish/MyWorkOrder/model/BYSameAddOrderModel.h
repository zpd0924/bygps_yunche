//
//  BYSameAddOrderModel.h
//  BYGPS
//
//  Created by 主沛东 on 2019/4/30.
//  Copyright © 2019 miwer. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface BYSameAddOrderModel : NSObject


@property (nonatomic , strong) NSString *orderAdd;

@property (nonatomic , assign) CGFloat orderAddLat;

@property (nonatomic , assign) CGFloat orderAddLon;

@property (nonatomic , strong) NSString *orderTime;

@property (nonatomic , assign) CGFloat pop_H;



@end

NS_ASSUME_NONNULL_END

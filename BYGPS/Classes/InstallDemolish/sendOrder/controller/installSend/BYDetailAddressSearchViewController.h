//
//  BYDetailAddressSearchViewController.h
//  BYIntelligentAssistant
//
//  Created by 主沛东 on 2019/4/10.
//  Copyright © 2019 BYKJ. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface BYDetailAddressSearchViewController : UIViewController

@property (nonatomic,copy) void(^detailAddressBlock)(NSDictionary *info);

@end

NS_ASSUME_NONNULL_END

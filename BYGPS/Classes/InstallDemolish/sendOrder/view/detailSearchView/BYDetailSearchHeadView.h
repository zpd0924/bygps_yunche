//
//  BYDetailSearchHeadView.h
//  BYIntelligentAssistant
//
//  Created by 主沛东 on 2019/4/10.
//  Copyright © 2019 BYKJ. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface BYDetailSearchHeadView : UIView
@property (weak, nonatomic) IBOutlet UITextField *searchTextField;

@property (nonatomic,copy) void(^searchBlock)(NSString *searchStr);

@property (nonatomic,copy) void(^inputIngSearchBlock)(NSString *searchStr);
@property (weak, nonatomic) IBOutlet UIView *searchBackView;



@end

NS_ASSUME_NONNULL_END

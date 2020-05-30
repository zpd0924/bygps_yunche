//
//  BYDetailAddressSearchSectionView.h
//  BYIntelligentAssistant
//
//  Created by 主沛东 on 2019/4/11.
//  Copyright © 2019 BYKJ. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface BYDetailAddressSearchSectionView : UIView

@property (weak, nonatomic) IBOutlet UILabel *cityLabel;

@property (weak, nonatomic) IBOutlet UILabel *detailAddressLabel;

@property (nonatomic , strong) NSString *cityStr;


@property (nonatomic , strong) NSString *addressStr;



@property (nonatomic,copy) void(^changeCityBlock)(void);
@property (nonatomic,copy) void(^selectAddressBlock)();
@property (weak, nonatomic) IBOutlet UIButton *changeButton;

@end

NS_ASSUME_NONNULL_END

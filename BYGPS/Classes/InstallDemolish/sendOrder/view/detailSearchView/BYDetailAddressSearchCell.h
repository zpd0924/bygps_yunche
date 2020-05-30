//
//  BYDetailAddressSearchCell.h
//  BYIntelligentAssistant
//
//  Created by 主沛东 on 2019/4/10.
//  Copyright © 2019 BYKJ. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface BYDetailAddressSearchCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UIImageView *locationImgView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leftconstraintW;




@end

NS_ASSUME_NONNULL_END

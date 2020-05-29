//
//  BYInstallMarkCell.h
//  父子控制器
//
//  Created by miwer on 2016/12/23.
//  Copyright © 2016年 miwer. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BYInstallMarkCell : UITableViewCell

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topHCons;
@property(nonatomic,copy) void (^didEndInputBlock) (NSString * input);
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UITextView *textView;
@end

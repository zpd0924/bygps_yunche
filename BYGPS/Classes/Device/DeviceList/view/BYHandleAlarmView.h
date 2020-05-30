//
//  BYHandleAlarmView.h
//  BYGPS
//
//  Created by miwer on 16/9/20.
//  Copyright © 2016年 miwer. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BYHandleAlarmView : UIView

@property(nonatomic,strong) void (^itemBlock) (NSInteger tag);
@property (weak, nonatomic) IBOutlet UITextView *textView;

@end

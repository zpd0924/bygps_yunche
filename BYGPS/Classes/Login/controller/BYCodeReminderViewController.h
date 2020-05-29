//
//  BYCodeReminderViewController.h
//  BYGPS
//
//  Created by 李志军 on 2018/12/10.
//  Copyright © 2018 miwer. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^BYCodeReminderBlock)(BOOL isCorrect);

@interface BYCodeReminderViewController : UIViewController
@property (nonatomic,copy) BYCodeReminderBlock codeReminderBlock;
@end

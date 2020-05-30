//
//  BYSureMarkCell.m
//  父子控制器
//
//  Created by miwer on 2016/12/27.
//  Copyright © 2016年 miwer. All rights reserved.
//

#import "BYSureMarkCell.h"

@interface BYSureMarkCell ()

@property (weak, nonatomic) IBOutlet UITextView *textView;

@end

@implementation BYSureMarkCell

- (void)awakeFromNib {
    [super awakeFromNib];

    self.textView.userInteractionEnabled = NO;
}

-(void)setSubtitle:(NSString *)subtitle{
    self.textView.text = subtitle == nil ? @"无" : subtitle;
}

@end

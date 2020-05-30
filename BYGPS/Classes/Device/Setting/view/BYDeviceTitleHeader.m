//
//  BYDeviceTitleHeader.m
//  BYGPS
//
//  Created by miwer on 16/7/29.
//  Copyright © 2016年 miwer. All rights reserved.
//

#import "BYDeviceTitleHeader.h"

@interface BYDeviceTitleHeader ()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;


@end

@implementation BYDeviceTitleHeader

-(void)setTitle:(NSString *)title{
    
    self.titleLabel.text = title;
}

@end

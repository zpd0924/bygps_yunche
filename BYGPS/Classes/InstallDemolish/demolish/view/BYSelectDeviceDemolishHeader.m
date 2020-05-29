//
//  BYSelectDeviceDemolishHeader.m
//  父子控制器
//
//  Created by miwer on 2016/12/28.
//  Copyright © 2016年 miwer. All rights reserved.
//

#import "BYSelectDeviceDemolishHeader.h"

@interface BYSelectDeviceDemolishHeader ()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@end

@implementation BYSelectDeviceDemolishHeader

-(void)setTitle:(NSString *)title{
    self.titleLabel.text = title;
}

@end

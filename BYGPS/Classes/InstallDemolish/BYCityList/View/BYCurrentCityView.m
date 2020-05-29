//
//  BYCurrentCityView.m
//  carLoanManagerment
//
//  Created by miwer on 2017/3/30.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "BYCurrentCityView.h"

@interface BYCurrentCityView ()

@property (weak, nonatomic) IBOutlet UILabel *currentCityLabel;

@end

@implementation BYCurrentCityView

-(void)setTitle:(NSString *)title{
    self.currentCityLabel.text = [NSString stringWithFormat:@"当前城市: %@",title];
}

@end

//
//  BYAddMoreHeaderView.m
//  BYGPS
//
//  Created by bean on 16/7/30.
//  Copyright © 2016年 miwer. All rights reserved.
//

#import "BYAddMoreHeaderView.h"

@interface BYAddMoreHeaderView ()

@property (weak, nonatomic) IBOutlet UILabel *mostCountLabel;

@end

@implementation BYAddMoreHeaderView

- (IBAction)addMore:(id)sender {
    if (self.addMoreBlock) {
        self.addMoreBlock();
    }
}

-(void)setMostCount:(NSString *)mostCount{
    self.mostCountLabel.text = mostCount;
}

@end

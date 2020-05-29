//
//  BYLookMoreView.m
//  BYGPS
//
//  Created by 李志军 on 2018/7/16.
//  Copyright © 2018年 miwer. All rights reserved.
//

#import "BYLookMoreView.h"

@implementation BYLookMoreView

- (IBAction)lookMoreBtnClick:(UIButton *)sender {
    if(self.lookMoreBtnBlock)
        self.lookMoreBtnBlock();
}


@end

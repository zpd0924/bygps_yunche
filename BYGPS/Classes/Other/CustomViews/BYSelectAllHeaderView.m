//
//  BYSelectAllHeaderView.m
//  BYGPS
//
//  Created by miwer on 16/8/31.
//  Copyright © 2016年 miwer. All rights reserved.
//

#import "BYSelectAllHeaderView.h"

@implementation BYSelectAllHeaderView

- (IBAction)selectAll:(id)sender {
    if (self.selectAllBlock) {
        self.selectAllBlock();
    }
}

@end

//
//  BYShareListSearchView.m
//  BYGPS
//
//  Created by 李志军 on 2018/12/27.
//  Copyright © 2018 miwer. All rights reserved.
//

#import "BYShareListSearchView.h"
@interface BYShareListSearchView()


@end

@implementation BYShareListSearchView


- (IBAction)searchBtnClick:(UIButton *)sender {
    if (self.shareListSearchBlock) {
        self.shareListSearchBlock();
    }
}

@end

//
//  BYInsideListBottomView.m
//  BYGPS
//
//  Created by 李志军 on 2018/12/12.
//  Copyright © 2018 miwer. All rights reserved.
//

#import "BYInsideListBottomView.h"

@interface BYInsideListBottomView()



@end

@implementation BYInsideListBottomView

- (IBAction)addBtnClick:(UIButton *)sender {
    if (self.addBlock) {
        self.addBlock();
    }
}


@end

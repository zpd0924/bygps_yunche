//
//  BYAutoServiceCommitFooterView.m
//  BYGPS
//
//  Created by ZPD on 2018/12/12.
//  Copyright © 2018年 miwer. All rights reserved.
//

#import "BYAutoServiceCommitFooterView.h"

@interface BYAutoServiceCommitFooterView ()

@property (weak, nonatomic) IBOutlet UIButton *commitButton;


@end

@implementation BYAutoServiceCommitFooterView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(void)awakeFromNib{
    [super awakeFromNib];
    
    self.commitButton.layer.cornerRadius = 5.0;
    self.commitButton.layer.masksToBounds = YES;
    
}
- (IBAction)submitClick:(id)sender {
    
    if (self.removeOrRepairSubmitBlock) {
        self.removeOrRepairSubmitBlock();
    }
    
}

@end

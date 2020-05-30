//
//  BYMeHeaderView.m
//  BYGPS
//
//  Created by miwer on 16/7/26.
//  Copyright © 2016年 miwer. All rights reserved.
//

#import "BYMeHeaderView.h"

@interface BYMeHeaderView ()

@property (weak, nonatomic) IBOutlet UILabel *userLabel;
@property (weak, nonatomic) IBOutlet UILabel *groupLabel;


@end

@implementation BYMeHeaderView

-(void)awakeFromNib{
    [super awakeFromNib];
    
    
    self.userLabel.text = [NSString stringWithFormat:@"账号: %@ (%@)",[BYSaveTool valueForKey:BYusername],[BYSaveTool valueForKey:nickName]];
    self.groupLabel.text = [NSString stringWithFormat:@"所属分组: %@",[BYSaveTool valueForKey:groupName]];
    
}

-(void)setNickName:(NSString *)nickName{
}

@end

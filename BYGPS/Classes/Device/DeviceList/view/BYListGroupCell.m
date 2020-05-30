//
//  BYListGroupCell.m
//  BYGPS
//
//  Created by miwer on 16/9/1.
//  Copyright © 2016年 miwer. All rights reserved.
//

#import "BYListGroupCell.h"
#import "BYGroupNode.h"

static CGFloat const indentPointsMargin = 15;

@interface BYListGroupCell ()

@property (weak, nonatomic) IBOutlet UIButton *selectButton;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIButton *arrowButton;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *selectButtonContraint_leading;

@end

@implementation BYListGroupCell

- (IBAction)selectGroup:(id)sender {//左边选择按钮
    
    self.selectButton.selected = !self.selectButton.selected;
    if (self.selectGroupBlock) {
        self.selectGroupBlock(self.selectButton.selected);
    }
    
}

-(void)setGroupNode:(BYGroupNode *)groupNode{
    
    _groupNode = groupNode;
    
    NSArray *arr = groupNode.childs;
    if (_isAddCar) {
        self.titleLabel.text = [BYSaveTool boolForKey:BYIsReadinessKey] ? groupNode.nodeName : [NSString stringWithFormat:@"%@",groupNode.nodeName];
    }else{
        self.titleLabel.text = [BYSaveTool boolForKey:BYIsReadinessKey] ? groupNode.nodeName : [NSString stringWithFormat:@"%@(%zd)",groupNode.nodeName,groupNode.number];
    }
    
    self.arrowButton.selected = groupNode.isExpand;
    
    self.selectButton.selected = groupNode.isSelect;
    
    CGFloat indentPoints = _groupNode.level * indentPointsMargin;
    
    self.selectButtonContraint_leading.constant = indentPoints;
}

//-(void)layoutSubviews{
//    [super layoutSubviews];
//    
//    CGFloat indentPoints = _groupNode.level * indentPointsMargin;
//    self.contentView.frame = CGRectMake(indentPoints, self.contentView.by_y, self.contentView.by_width - indentPoints, self.contentView.by_height);
//}


@end



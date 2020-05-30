//
//  BYShareListGroupCell.m
//  BYGPS
//
//  Created by 李志军 on 2018/12/27.
//  Copyright © 2018 miwer. All rights reserved.
//

#import "BYShareListGroupCell.h"
#import "BYGroupShareNode.h"

static CGFloat const indentPointsMargin = 15;
@interface BYShareListGroupCell ()

@property (weak, nonatomic) IBOutlet UIButton *selectButton;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIButton *arrowButton;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *selectButtonContraint_leading;

@end
@implementation BYShareListGroupCell

- (IBAction)selectGroup:(id)sender {//左边选择按钮
    
    self.selectButton.selected = !self.selectButton.selected;
    if (self.selectGroupBlock) {
        self.selectGroupBlock(self.selectButton.selected);
    }
    
}

-(void)setGroupNode:(BYGroupShareNode *)groupNode{
    
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

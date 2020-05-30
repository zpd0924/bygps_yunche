//
//  BY036DurationCell.m
//  BYGPS
//
//  Created by ZPD on 2017/12/14.
//  Copyright © 2017年 miwer. All rights reserved.
//

#import "BY036DurationCell.h"
#import "BY036DurationModel.h"

@interface BY036DurationCell ()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIButton *selectButton;

@end

@implementation BY036DurationCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(void)setModel:(BY036DurationModel *)model
{
    _model = model;
    self.titleLabel.text = model.title;
    self.selectButton.selected = model.seleted;
}
//-(void)setTitle:(NSString *)title
//{
//    _title = title;
//    self.titleLabel.text = title;
//}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

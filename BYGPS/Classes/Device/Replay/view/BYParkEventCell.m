//
//  BYParkEventCell.m
//  BYGPS
//
//  Created by ZPD on 2017/8/9.
//  Copyright © 2017年 miwer. All rights reserved.
//

#import "BYParkEventCell.h"
#import "BYParkEventModel.h"

@interface BYParkEventCell ()
@property (weak, nonatomic) IBOutlet UILabel *parkTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *startTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *endTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *parkAddressLabel;

@end

@implementation BYParkEventCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(void)setParkModel:(BYParkEventModel *)parkModel
{
    self.startTimeLabel.text = parkModel.beginTime;
    self.endTimeLabel.text = parkModel.endTime;
    self.parkAddressLabel.text = parkModel.address;
    
    self.parkTimeLabel.text = parkModel.parkingTime;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

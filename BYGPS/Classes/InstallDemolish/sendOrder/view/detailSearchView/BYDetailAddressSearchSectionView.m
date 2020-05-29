//
//  BYDetailAddressSearchSectionView.m
//  BYIntelligentAssistant
//
//  Created by 主沛东 on 2019/4/11.
//  Copyright © 2019 BYKJ. All rights reserved.
//

#import "BYDetailAddressSearchSectionView.h"

@interface BYDetailAddressSearchSectionView ()
@property (weak, nonatomic) IBOutlet UIView *addressView;

@end

@implementation BYDetailAddressSearchSectionView

-(void)awakeFromNib{
    [super awakeFromNib];
    
//    UIImage *btnSelImage = [UIImage imageNamed:@"icon_mine_right"];
//    //        CGFloat btnSelImageW = btnSelImage.size.width * 0.5;
//    //        CGFloat btnSelImageH = btnSelImage.size.height * 0.5;
//    UIImage *newBtnSelImage = [btnSelImage stretchableImageWithLeftCapWidth:btnSelImage.size.width topCapHeight:btnSelImage.size.height];
//    //        [loginBtn setBackgroundImage:newBtnSelImage forState:UIControlStateNormal];
//    [self.changeButton setBackgroundImage:newBtnSelImage forState:UIControlStateNormal];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAddressLabel)];
    [self.addressView addGestureRecognizer:tap];
    
}

-(void)tapAddressLabel{
    if (self.selectAddressBlock) {
        self.selectAddressBlock();
    }
}

- (IBAction)changeCity:(id)sender {
    
    if (self.changeCityBlock) {
        self.changeCityBlock();
    }
}

//-(void)setCityStr:(NSString *)cityStr{
//    
//    _cityStr = cityStr;
//    self.cityLabel.text = [NSString stringWithFormat:@"定位地区：%@",cityStr.length > 0 ? cityStr : @"定位中..."];
//    
//}
//
//-(void)setAddressStr:(NSString *)addressStr{
//    _addressStr = addressStr;
//    self.detailAddressLabel.text = [NSString stringWithFormat:@"当前定位地址："];
//}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end

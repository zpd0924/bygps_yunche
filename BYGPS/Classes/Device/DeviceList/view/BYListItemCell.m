//
//  BYListItemCell.m
//  BYGPS
//
//  Created by miwer on 16/9/2.
//  Copyright © 2016年 miwer. All rights reserved.
//

#import "BYListItemCell.h"
#import "BYItemNode.h"
#import "NSString+BYAttributeString.h"

static CGFloat const indentPointsMargin = 15;

@interface BYListItemCell ()

@property (weak, nonatomic) IBOutlet UIButton *selectButton;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *subTitleLabel;
@property (weak, nonatomic) IBOutlet UIButton *carStatusButton;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *selectButtonContrait_leading;

@end

@implementation BYListItemCell

- (IBAction)deviceInfoAction:(id)sender {//点击车辆
    
    if (self.selectCarBlock) {
        self.selectCarBlock();
    }
}

-(void)setItemNode:(BYItemNode *)itemNode{
    
    BYLog(@"%zd", itemNode.iconId);
    BYLog(@"%@", itemNode.online);
    _itemNode = itemNode;
    self.selectButton.selected = itemNode.isSelect;
    
    NSString * wirlessStr = itemNode.wifi ? @"无线" : @"有线";
    self.titleLabel.text = [NSString stringWithFormat:@"%@   (%@ %@)",itemNode.sn,itemNode.alias,wirlessStr];
    
//    if (model.carId > 0) {
//        if (model.carNum.length > 0) {
//            carNumStr = model.carNum;
//            carNumStr = [NSString StringJudgeIsValid:carNumStr isValid:[BYSaveTool boolForKey:BYCarNumberInfo] subIndex:2];
//        }else{
//            if (model.carVin.length > 6) {
//                NSRange range = NSMakeRange(model.carVin.length - 6, 6);
//                carNumStr = [NSString stringWithFormat:@"...%@",[model.carVin substringWithRange:range]];
//            }else{
//                carNumStr = model.carVin;
//            }
//        }
//    }else{
//        carNumStr = model.sn;
//    }
    
    NSString * subTitle = nil;
    
    if (itemNode.carId > 0) {//已装车, 有线
        
        NSString *carNumStr;
        
        if (itemNode.carNum.length > 0) {
            carNumStr = itemNode.carNum;
            carNumStr = [NSString StringJudgeIsValid:carNumStr isValid:[BYSaveTool boolForKey:BYCarNumberInfo] subIndex:2];
        }else{
            if (itemNode.carVin.length > 6) {
                NSRange range = NSMakeRange(itemNode.carVin.length - 6, 6);
                carNumStr = [NSString stringWithFormat:@"...%@",[itemNode.carVin substringWithRange:range]];
            }else{
                carNumStr = itemNode.carVin;
            }
        }
        NSString *ownerNameStr = [NSString StringJudgeIsValid:self.itemNode.ownerName isValid:[BYSaveTool boolForKey:BYCarOwnerInfo] subIndex:1];
        ownerNameStr = ownerNameStr.length > 4 ? [NSString stringWithFormat:@"%@...",[ownerNameStr substringToIndex:4]] : ownerNameStr;
        
        if ([itemNode.online rangeOfString:@"离线"].location == NSNotFound) {//在线
             subTitle = [NSString stringWithFormat:@"%@  %@  %@",carNumStr,ownerNameStr,itemNode.carStatus.length ? itemNode.carStatus : @""];
        }else{
             subTitle = [NSString stringWithFormat:@"%@  %@",carNumStr,ownerNameStr];
        }
    }else{
        subTitle = @"未装车";
    }
    
    self.subTitleLabel.text = subTitle;
    
    NSString * imageStr = nil;
    
    switch (itemNode.iconId) {
        case 0: imageStr = @"list_icon_car_green"; break;
        case 1: imageStr = @"list_icon_car_gray"; break;
        case 2: imageStr = @"list_icon_car_orange"; break;
        case 3: imageStr = @"list_icon_car_blue"; break;
        case 4: imageStr = @"list_icon_car_green"; break;
        case 5: imageStr = @"list_icon_car_red"; break;
        default: imageStr = @"list_icon_car_gray"; break;
    }
    
    [self.carStatusButton setImage:[UIImage imageNamed:imageStr] forState:UIControlStateNormal];
    
    CGFloat indentPoints = _itemNode.level * indentPointsMargin;
    
    self.selectButtonContrait_leading.constant= indentPoints;
    
}
- (IBAction)selectAction:(id)sender {
    
    self.selectButton.selected = !self.selectButton.selected;
    
    if (self.selectItemBlock) {
        self.selectItemBlock(self.selectButton.selected);
    }
}

//- (void)reloadFrame
//{
////    [super awakeFromNib];
//    CGFloat indentPoints = _itemNode.level * indentPointsMargin;
//    self.contentView.frame = CGRectMake(indentPoints, self.contentView.by_y, self.contentView.by_width - indentPoints, self.contentView.by_height);
//}

@end

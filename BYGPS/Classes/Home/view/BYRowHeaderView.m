//
//  BYItemHeaderView.m
//  BYGPS
//
//  Created by miwer on 16/9/13.
//  Copyright © 2016年 miwer. All rights reserved.
//

#import "BYRowHeaderView.h"
#import "NSString+BYAttributeString.h"
#import "BYAlarmModel.h"
#import "NSDate+BYDistanceDate.h"

@interface BYRowHeaderView ()

@property (weak, nonatomic) IBOutlet UIButton *selectButton;
@property (weak, nonatomic) IBOutlet UILabel *SNLabel;
@property (weak, nonatomic) IBOutlet UILabel *alarmTypeLabel;
@property (weak, nonatomic) IBOutlet UILabel *handleLabel;
@property (weak, nonatomic) IBOutlet UILabel *alarmTimeLabel;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *titleLabelContraint_W;

@end

@implementation BYRowHeaderView

-(void)awakeFromNib{
    [super awakeFromNib];
    
    self.backgroundView = [UIView new];//设置header背景颜色
    self.backgroundView.backgroundColor = [UIColor colorWithHex:@"#f1f2f6"];
    if (BYiPhone5_OR_5c_OR_5s) {
        self.SNLabel.font = [UIFont systemFontOfSize:12];
        self.titleLabelContraint_W.constant = 105;
    }else if (BYiPhone6_OR_6s){
        self.titleLabelContraint_W.constant = 130;
    }else if (BYiPhone6Plus_OR_6sPlus){
        self.titleLabelContraint_W.constant = 150;
    }
}
- (IBAction)selectAction:(id)sender {
    
    if (self.selectHeadBlock) {
        self.selectHeadBlock();
    }
}
- (IBAction)frontButtonAction:(id)sender {
    
    if (self.selectRowBlock) {
        self.selectRowBlock();
    }
}

-(void)setModel:(BYAlarmModel *)model{
    
    _model = model;
    self.arrowButton.selected = model.isExpand;
    self.selectButton.selected = model.isSelect;
    
    NSString *carNumStr;
    if (model.carId > 0) {
        if (model.carNum.length > 0) {
            carNumStr = model.carNum;
            carNumStr = [NSString StringJudgeIsValid:carNumStr isValid:[BYSaveTool boolForKey:BYCarNumberInfo] subIndex:2];
        }else{
            if (model.carVin.length > 6) {
                NSRange range = NSMakeRange(model.carVin.length - 6, 6);
                carNumStr = [NSString stringWithFormat:@"...%@",[model.carVin substringWithRange:range]];
            }else{
                carNumStr = model.carVin;
            }
        }
    }else{
        carNumStr = model.sn;
    }
    
//    NSString *carNumStr = [NSString StringJudgeIsValid:model.carNum isValid:[BYSaveTool boolForKey:BYCarNumberInfo] subIndex:2];
    NSString *ownerNameStr = [NSString StringJudgeIsValid:model.ownerName isValid:[BYSaveTool boolForKey:BYCarOwnerInfo] subIndex:1];
//    if ([carNumStr isEqualToString:@" "]) {
//        carNumStr = model.carVin;
//    }
    
    self.SNLabel.text = [NSString stringWithFormat:@"%@(%@)",carNumStr,ownerNameStr];
//    self.SNLabel.text = model.SN;
    
    self.alarmTypeLabel.text = model.alarmName.length > 4 ? (model.alarmName.length > 6 ? [model.alarmName substringToIndex:5] : [model.alarmName substringToIndex:4]) : model.alarmName;
//    self.alarmTypeLabel.text = model.alarmName;
    
    if (model.reviceTime.length) {//如果有恢复时间
        //如果已经处理
        self.handleLabel.text = model.processingUserId.length ? @"已处理" : @"已恢复";
    }else{
        self.handleLabel.text = model.processingUserId.length ? @"已处理" : @"未处理";
    }
    self.handleLabel.textColor = model.reviceTime.length || model.processingUserId.length ? [UIColor grayColor] : [UIColor colorWithHex:@"#F75A53"];
    self.alarmTimeLabel.text = [self createdTitle:model.createTime];
}

/*

今年以前
今年: 今天 : 一小时前 -> 几小时前
            一小时内 : 一分钟前 -> 几分钟前
                      一分钟内 -> 刚刚

     昨天  -> 昨天

     昨天以前 : 当月 -> 几天前
               当月以前 -> 几个月前

*/

- (NSString *)createdTitle:(NSString *)date{
    // 日期格式化类
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    fmt.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    
    NSDate * CreateTime = [fmt dateFromString:date];
    
    // 比较【报警时间】和【当前时间】的差值
    NSDateComponents *cmps = [CreateTime intervalToNow];
    
    if (CreateTime.isToday) { // 今天
        if (cmps.hour >= 1) { // 时间差距 >= 1小时
            return [NSString stringWithFormat:@"%zd小时前", cmps.hour];
        } else if (cmps.minute >= 1) { // 1分钟 =< 时间差距 <= 59分钟
            return [NSString stringWithFormat:@"%zd分钟前", cmps.minute];
        } else {
            return @"刚刚";
        }
    } else if (CreateTime.isYesterday) { // 昨天
        return @"昨天";
    } else { // 今年的其他时间
        if (CreateTime.isThisMonth) {
            return [NSString stringWithFormat:@"%zd天前",cmps.day];
        }else{
            return [NSString stringWithFormat:@"%zd月前",cmps.month];
        }
    }
}


@end

//
//  RecivingCell.m
//  父子控制器
//
//  Created by miwer on 2016/12/20.
//  Copyright © 2016年 miwer. All rights reserved.
//

#import "RecivingCell.h"
#import "BYReceivingModel.h"
#import "DeviceItem.h"

@interface RecivingCell ()
//用于判断已接订单页面的右边按钮的具体操作:已取消->YES,待确认->NO
@property (assign,nonatomic) BOOL isCancel;

@property (weak, nonatomic) IBOutlet UILabel *carNumLabel;
@property (weak, nonatomic) IBOutlet UILabel *deviceListLabel;
@property (weak, nonatomic) IBOutlet UIButton *warnButton;
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *buttonBgViewContraint_H;
@property (weak, nonatomic) IBOutlet UILabel *orderStatusLabel;
@property (weak, nonatomic) IBOutlet UIButton *callDemolishManButton;

@end

@implementation RecivingCell

- (IBAction)callAction:(id)sender {
    
    if (self.callBlcok) {
        self.callBlcok();
    }
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.buttonBgViewContraint_H.constant = BYS_W_H(40);

    self.warnButton.layer.borderWidth = 1;
    self.warnButton.layer.borderColor = BYRGBColor(142, 192, 246).CGColor;
    self.warnButton.layer.cornerRadius = 3;
    self.warnButton.clipsToBounds = YES;
    
    self.cancelButton.layer.borderWidth = 1;
    self.cancelButton.layer.borderColor = BYGrayColor(218).CGColor;
    self.cancelButton.layer.cornerRadius = 3;
    self.cancelButton.clipsToBounds = YES;
}

-(void)setModel:(BYReceivingModel *)model{
    
    self.carNumLabel.text = model.carNum.length > 0 ? model.carNum : ( model.carVin.length > 6 ? [NSString stringWithFormat:@"...%@",[model.carVin substringWithRange:NSMakeRange(model.carVin.length - 6, 6)]] : model.carVin) ;
    switch (model.statu) {
        case 1: self.orderStatusLabel.text = @"待接单"; break;
        case 2: self.orderStatusLabel.text = @"已接单"; break;
        case 3: self.orderStatusLabel.text = @"已取消"; break;
        //当status为4时说明已完成拆机,当flag为1 已回收,2 未回收
        case 4: self.orderStatusLabel.text = model.recycleFlag == 1 ? @"已完成" : @"待确认"; break;
        default:break;
    }
    
    self.callDemolishManButton.hidden = model.isReceving;//拨打电话按钮的隐藏
    self.cancelButton.hidden = !model.isReceving;//左边按钮的隐藏
    if (!model.isReceving) {
        self.warnButton.layer.borderColor = BYGrayColor(218).CGColor;
        [self.warnButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        
        //当状态为2(已抢单)->可以取消订单.
        //当状态为4(已完成),当flag为1(已回收)->按钮隐藏,flag为2(未回收)->可以确认回收
        if (model.statu == 2) {
            
            self.isCancel = YES;
            [self.warnButton setTitle:@"取消订单" forState:UIControlStateNormal];
            self.warnButton.hidden = NO;
            self.buttonBgViewContraint_H.constant = BYS_W_H(40);

        }else if (model.statu == 4){
            if (model.recycleFlag == 2) {
                
                self.isCancel = NO;
                [self.warnButton setTitle:@"确认回收" forState:UIControlStateNormal];
                
                self.warnButton.hidden = NO;
                self.buttonBgViewContraint_H.constant = BYS_W_H(40);
            }else{
                self.buttonBgViewContraint_H.constant = 0;

                self.warnButton.hidden = YES;
            }
        }
    }
    
    NSMutableArray * items = [NSMutableArray array];
    for (DeviceItem * item in model.list) {
        
        NSString * itemStr = [NSString stringWithFormat:@"设备号: %@ (%@%@)",item.sn,item.model,item.wireLess];
        [items addObject:itemStr];
    }
    
    if (model.isReceving) {
        //完成订单item
        NSString * finishTimeStr = [NSString stringWithFormat:@"下单时间: %@",model.createTime];
        [items addObject:finishTimeStr];
        
    }else{
        NSString * demolishManStr = [NSString stringWithFormat:@"拆机技师: %@ %@",model.nickName,model.phone];
        [items addObject:demolishManStr];
        
        NSString * finishTimeStr = model.finishTime.length ? [NSString stringWithFormat:@"完成时间: %@",model.finishTime] : @"完成时间:";
        [items addObject:finishTimeStr];
    }
    
    //拼接字符串
    self.deviceListLabel.attributedText = [self attributedLineSpacingStrWith:[items componentsJoinedByString:@"\n"]];
}

- (IBAction)leftAction:(id)sender {
    if (self.leftActionBlcok) {
        self.leftActionBlcok();
    }
}
- (IBAction)rightAction:(id)sender {
    if (self.rightActionBlcok) {
        self.rightActionBlcok(self.isCancel);
    }
}

-(NSMutableAttributedString *)attributedLineSpacingStrWith:(NSString *)str{
    
    NSMutableAttributedString * attributedString = [[NSMutableAttributedString alloc] initWithString:str];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:BYS_W_H(6)];
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, str.length)];
    return attributedString;
}



@end

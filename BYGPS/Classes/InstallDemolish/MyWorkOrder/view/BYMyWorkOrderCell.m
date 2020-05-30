//
//  BYMyWorkOrderCell.m
//  BYGPS
//
//  Created by 李志军 on 2018/7/10.
//  Copyright © 2018年 miwer. All rights reserved.
//

#import "BYMyWorkOrderCell.h"
#import "BYCheckWorkOrderViewController.h"
#import "BYMyEvaluationCommitViewController.h"

@interface BYMyWorkOrderCell()
///工单编号
@property (weak, nonatomic) IBOutlet UILabel *orderNumberLabel;
///工单时间
@property (weak, nonatomic) IBOutlet UILabel *orderTimeLabel;
///派单用户
@property (weak, nonatomic) IBOutlet UILabel *sendOrderUserLabel;
///联系人
@property (weak, nonatomic) IBOutlet UILabel *mobieUserLabel;
///车牌号
@property (weak, nonatomic) IBOutlet UILabel *carNumberLabel;
///车架号
@property (weak, nonatomic) IBOutlet UILabel *carJiaNumberLabel;
///车辆型号
@property (weak, nonatomic) IBOutlet UILabel *carTypeLabel;
///退审原因label
@property (weak, nonatomic) IBOutlet UILabel *reasonLabel;
///退审原因说明
@property (weak, nonatomic) IBOutlet UILabel *reasonDetailLabel;

///安装状态
@property (weak, nonatomic) IBOutlet UILabel *installStatusLabel;

///安装状态图片
@property (weak, nonatomic) IBOutlet UIImageView *installStatusImageView;

///无线
@property (weak, nonatomic) IBOutlet UIButton *wuXianBtn;

///有线
@property (weak, nonatomic) IBOutlet UIButton *youXianBtn;

///其他
@property (weak, nonatomic) IBOutlet UIButton *otherBtn;

///地址
@property (weak, nonatomic) IBOutlet UIButton *adressBtn;

///右边第一个
@property (weak, nonatomic) IBOutlet UIButton *rightbtn1;

///右边第二个
@property (weak, nonatomic) IBOutlet UIButton *rightBtn2;

@property (nonatomic,weak) UIViewController *cf_viewController;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topConsH;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *numberRightW;

@end
@implementation BYMyWorkOrderCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.rightbtn1.layer.cornerRadius = 13.5;
    self.rightbtn1.layer.masksToBounds = YES;
    self.rightbtn1.layer.borderWidth = 0.5;
    self.rightbtn1.layer.borderColor = BYGlobalBlueColor.CGColor;
    [self.rightbtn1 setTitleColor:BYGlobalBlueColor forState:UIControlStateNormal];
    
    
    self.rightBtn2.layer.cornerRadius = 13.5;
    self.rightBtn2.layer.masksToBounds = YES;
    self.rightBtn2.layer.borderWidth = 0.5;
    self.rightBtn2.layer.borderColor = BYBigSpaceColor.CGColor;
    [self.rightBtn2
     setTitleColor:BYLabelBlackColor forState:UIControlStateNormal];
}

- (void)setModel:(BYMyAllWorkOrderModel *)model{
    _model = model;
    ///工单状态 0待接单 2待审核 3审核不通过 4审核通过
    self.reasonLabel.hidden = YES;
    self.reasonDetailLabel.hidden = YES;
    self.reasonLabel.text = @"";
    self.reasonDetailLabel.text = @"";
    switch (model.status) {
        case 0:
            self.installStatusLabel.text = @"待接单";
            self.rightbtn1.hidden = NO;
            self.rightBtn2.hidden = NO;
            [self.rightbtn1 setTitle:@"撤回" forState:UIControlStateNormal];
            [self.rightBtn2 setTitle:@"编辑" forState:UIControlStateNormal];
            self.topConsH.constant = 57.5;
            break;
        case 1:
            self.installStatusLabel.text = @"已接单";
//            self.rightbtn1.hidden = YES;
//            self.rightBtn2.hidden = YES;
            self.rightbtn1.hidden = YES;
            self.rightBtn2.hidden = YES;
            self.topConsH.constant = 0;
            
            break;
        case 2:
            self.installStatusLabel.text = @"待审核";
            self.rightbtn1.hidden = NO;
            self.rightBtn2.hidden = YES;
            [self.rightbtn1 setTitle:@"审核" forState:UIControlStateNormal];
            self.topConsH.constant = 57.5;
            break;
        case 3:
             self.installStatusLabel.text = @"不通过";
            self.rightbtn1.hidden = YES;
            self.rightBtn2.hidden = YES;
            self.reasonLabel.hidden = NO;
            self.reasonDetailLabel.hidden = NO;
            self.topConsH.constant = 0;
            break;
        case 4:
             self.installStatusLabel.text = @"通过";
            self.rightBtn2.hidden = YES;
            self.rightbtn1.hidden = NO;
            self.topConsH.constant = 57.5;
            if (model.isComment) {
                [self.rightbtn1 setTitle:@"查看评价" forState:UIControlStateNormal];
            }else{
                 [self.rightbtn1 setTitle:@"技师评价" forState:UIControlStateNormal];
            }
            
            
            break;
        case 5:
            self.installStatusLabel.text = @"已撤销";
            self.rightBtn2.hidden = YES;
            self.rightbtn1.hidden = YES;
            self.topConsH.constant = 0;
            
            
            break;
        default:
            self.installStatusLabel.text = @"异常订单";
            self.rightBtn2.hidden = YES;
            self.rightbtn1.hidden = YES;
           self.topConsH.constant = 0;
            break;
    }
    ///服务类别 1:安装,2:检修,3:拆机
    switch (model.serviceType) {
        case 1:
            self.installStatusImageView.image = [UIImage imageNamed:@"anzhuang"];
            break;
        case 2:
            self.installStatusImageView.image = [UIImage imageNamed:@"jianxiu"];
            break;
        case 3:
            self.installStatusImageView.image = [UIImage imageNamed:@"chaiji"];
            break;
        default:
            break;
    }
    self.numberRightW.constant = BYS_W_H(85);
    self.orderNumberLabel.lineBreakMode = NSLineBreakByCharWrapping;
    self.orderNumberLabel.text = model.orderNo;
    self.orderTimeLabel.text = model.createTime;
    self.sendOrderUserLabel.text = model.createUserName;
    self.mobieUserLabel.text = [NSString stringWithFormat:@"%@ %@",model.contactPerson.length?model.contactPerson:@"",model.contactTel.length?model.contactTel:@""];
    self.carNumberLabel.text = model.carNum;
    self.carJiaNumberLabel.text = model.carVin;
    self.carTypeLabel.text =  [NSString stringWithFormat:@"%@%@%@",model.carBrand.length > 0 ? model.carBrand : @"" ,model.carType.length > 0 ? model.carType : @"",model.carModel.length ? model.carModel : @""];
    [self.wuXianBtn setTitle:[NSString stringWithFormat:@"无线%zd台",model.wirelessDeviceCount] forState:UIControlStateNormal];
    [self.youXianBtn setTitle:[NSString stringWithFormat:@"有线%zd台",model.wirelineDeviceCount] forState:UIControlStateNormal];
    [self.otherBtn setTitle:[NSString stringWithFormat:@"其他%zd台",model.otherDeviceCount] forState:UIControlStateNormal];
    NSString *adress = [NSString stringWithFormat:@"%@%@%@%@",model.province.length?model.province:@"",model.city.length?model.city:@"",model.area.length?model.area:@"",model.serviceAddress.length?model.serviceAddress:@""];
    [self.adressBtn setTitle:adress forState:UIControlStateNormal];
}

- (IBAction)rightBtn1Click:(UIButton *)sender {
    if ([sender.titleLabel.text isEqualToString:@"撤回"]) {
        if (self.cellBlock) {
            self.cellBlock(@"撤回");
        }
        MobClickEvent(@"myWork_recall", @"");
    }else if ([sender.titleLabel.text isEqualToString:@"审核"]){
        if (self.cellBlock) {
            self.cellBlock(@"审核");
        }
    }else if ([sender.titleLabel.text isEqualToString:@"技师评价"]){
        MobClickEvent(@"myWork_evaluate", @"");
        if (self.cellBlock) {
            self.cellBlock(@"技师评价");
        }
    }else if([sender.titleLabel.text isEqualToString:@"查看评价"]){//评价列表
        if (self.cellBlock) {
            self.cellBlock(@"查看评价");
        }
    }

    
}
- (IBAction)rightBtn2Click:(UIButton *)sender {
    if ([sender.titleLabel.text isEqualToString:@"编辑"]) {
        if (self.cellBlock) {
            self.cellBlock(@"编辑");
        }
         MobClickEvent(@"myWork_editor", @"");
    }

}
- (IBAction)adressBtnClick:(UIButton *)sender {
    
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (UIViewController*)cf_viewController {
    for (UIView* next = [self superview]; next; next = next.superview) {
        UIResponder* nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            return (UIViewController * )nextResponder;
        }
    }
    return nil;
}

@end

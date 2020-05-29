//
//  BYSendOrderResultViewController.m
//  BYGPS
//
//  Created by 李志军 on 2018/7/10.
//  Copyright © 2018年 miwer. All rights reserved.
//

#import "BYSendOrderResultViewController.h"
#import "EasyNavigation.h"
#import "BYWorkMessageController.h"
#import "BYMyWorkOrderController.h"
@interface BYSendOrderResultViewController ()
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leftW;

@end

@implementation BYSendOrderResultViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initBase];
}

- (void)backAction{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)initBase{
    
    BYWeakSelf;
    
//    dispatch_async(dispatch_get_main_queue(), ^{
//         [self.navigationView setTitle:_titleStr];
//        [self.navigationView.titleLabel setTextColor:[UIColor whiteColor]];
//        [self.navigationView setNavigationBackgroundColor:BYGlobalBlueColor];
//        [self.navigationView removeAllLeftButton];
//        [self.navigationView addLeftButtonWithImage:[UIImage imageNamed:@"icon_arr_left_white"] clickCallBack:^(UIView *view) {
//            [weakSelf backAction];
//        }];
//
//    });
    self.leftBtn.layer.cornerRadius = 5;
    self.leftBtn.layer.masksToBounds = YES;
    self.rightBtn.layer.cornerRadius = 5;
    self.rightBtn.layer.masksToBounds = YES;
    
    switch (_resultType) {
        case 1://评价成功
            {
                self.titleLabel.text = @"评价成功";
                self.statusImageView.image = [UIImage imageNamed:@"sendOrder_sucess"];
                self.titleInfoLabel.text = @"感谢您的评价，期待更好为您服务！";
                [self.leftBtn setTitle:@"查看评价" forState:UIControlStateNormal];
                [self.rightBtn setTitle:@"返回工单" forState:UIControlStateNormal];
            }
            break;
        case 2://评价失败
        {
            self.titleLabel.text = @"评价失败";
            self.statusImageView.image = [UIImage imageNamed:@"sendOrder_fail"];
            self.titleInfoLabel.text = @"感谢您的评价，期待更好为您服务！";
            [self.leftBtn setTitle:@"查看评价" forState:UIControlStateNormal];
            [self.rightBtn setTitle:@"返回工单" forState:UIControlStateNormal];
        }
            break;
        case 3:
        {
            self.titleLabel.text = @"查无此车辆";
            self.statusImageView.image = [UIImage imageNamed:@"sendOrder_fail"];
            self.titleInfoLabel.text = @"请先录入车辆资料，再下工单！";
            [self.leftBtn setTitle:@"点击录入" forState:UIControlStateNormal];
            [self.rightBtn setTitle:@"取消" forState:UIControlStateNormal];
        }
            break;
        case 4:
        {
            self.titleLabel.text = @"派单成功";
            self.statusImageView.image = [UIImage imageNamed:@"sendOrder_sucess"];
            self.titleInfoLabel.text = @"派单成功，等待技师接单！";
            [self.leftBtn setTitle:@"再次派单" forState:UIControlStateNormal];
            [self.rightBtn setTitle:@"查看已派订单" forState:UIControlStateNormal];
        }
            break;
        case 5:
        {
            self.titleLabel.text = @"派单失败";
            self.statusImageView.image = [UIImage imageNamed:@"sendOrder_fail"];
            self.titleInfoLabel.text = @"派单成功，请重新派单！";
            [self.leftBtn setTitle:@"重新派单" forState:UIControlStateNormal];
            [self.rightBtn setTitle:@"取消" forState:UIControlStateNormal];
        }
            break;
        case 6:
        {
            self.titleLabel.text = @"该车已在派单!";
            self.statusImageView.image = [UIImage imageNamed:@"sendOrder_fail"];
            self.titleInfoLabel.text = @"该车已在派单中，不能同时派单！";
            [self.leftBtn setTitle:@"查看派单" forState:UIControlStateNormal];
            self.leftW.constant = 0;
            self.leftBtn.hidden = YES;
            [self.rightBtn setTitle:@"返回" forState:UIControlStateNormal];
        }
            break;
        default:
            break;
    }
}
- (IBAction)leftBtnClick:(UIButton *)sender {
    if (self.leftBtnBlock) {
        self.leftBtnBlock();
    }else{
        
        if (_resultType == BYSendWorkSucessType) {
            BYWorkMessageController *vc = [[BYWorkMessageController alloc] init];
            vc.sendOrderType = _sendOrderType;
            
            switch (_sendOrderType) {
                case BYWorkSendOrderType:
                    vc.titleLabelStr = @"安装派单";
                    break;
                case BYUnpackSendOrderType:
                    vc.titleLabelStr = @"拆机派单";
                    break;
                default:
                    vc.titleLabelStr = @"检修派单";
                    break;
            }
            
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
}

- (IBAction)rightBtnClick:(UIButton *)sender {
    if (self.rightBtnBlock) {
        self.rightBtnBlock();
    }else{
        
        BYMyWorkOrderController *vc = [[BYMyWorkOrderController alloc] init];
        vc.row = 0;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

@end

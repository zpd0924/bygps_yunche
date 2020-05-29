//
//  BYPostBackContinueController.m
//  BYGPS
//
//  Created by miwer on 2017/1/16.
//  Copyright © 2017年 miwer. All rights reserved.
//

#import "BYPostBackContinueController.h"
#import "BYPostBackModel.h"
#import "BYPostBackCell.h"
#import "BYPostBackFooterView.h"
#import "BYSendPostBackParams.h"
#import "BYPushNaviModel.h"
#import "BYDeviceDetailHttpTool.h"
#import "EasyNavigation.h"

@interface BYPostBackContinueController ()

@property(nonatomic,strong) NSMutableArray * dataSource;
@property(nonatomic,strong) BYSendPostBackParams * httpParams;
@property(nonatomic,strong) UITextField * textField;


@end

@implementation BYPostBackContinueController

- (void)viewDidLoad {
    [super viewDidLoad];
//    _is027 = [self.model.model isEqualToString:@"027"];
    _is029 = [self.model.model isEqualToString:@"029"];
    _is036 = [self.model.model isEqualToString:@"036"] || [self.model.model isEqualToString:@"033"] ;
    [self initBase];
}

//  抓车模式(追踪)  :  #60## [5->持续时间(min),60(默认一分钟)->回传间隔时间(s)](027)
/**  常规模式        :   #3600## [3600->回传间隔时间(s)]
*  抓车模式(追踪)    :  10#60## [5->持续时间(min),60(默认一分钟)->回传间隔时间(s)]
*  固定回传点       :   ###09441544 [09点44分]
*  心跳间隔        :   ##001e# [16进制]
*  取消心跳        :   ##0000# */

-(void)initBase{
    
    self.view.backgroundColor = BYGlobalBg;
    [self.navigationView setTitle:@"抓车模式"];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.tableView.scrollEnabled = NO;
    if (@available(iOS 11.0, *)){
        if ([self.tableView respondsToSelector:@selector(setContentInsetAdjustmentBehavior:)]) {
            self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
    }
    UIView *head = [[UIView alloc] initWithFrame:CGRectMake(0, 0, BYSCREEN_W, SafeAreaTopHeight + 10)];
    self.tableView.tableHeaderView = head;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    NSString * firstStr = [self.cmdContent.length>0?self.cmdContent:@" " substringToIndex:1];//5
    NSString * lastTwoStr = [self.cmdContent substringFromIndex:self.cmdContent.length - 2];
    
    NSString * continueTimeStr = @"60";
    if (_is027) {
        if ([firstStr isEqualToString:@"#"] && [lastTwoStr isEqualToString:@"##"]) {//如果第一个字母是#,并且最后两个字母都是##
            NSArray *continueStrArr = [self.cmdContent componentsSeparatedByString:@"#"];
            continueTimeStr = [NSString stringWithFormat:@"已设置时间为%ld",[continueStrArr[1] integerValue] / 60 ];
        }else{
            continueTimeStr = @"默认时间为60";
        }

    }else if (_is036) {
        continueTimeStr = @"默认时间为1200";
    }else{
        if (![firstStr isEqualToString:@"#"] && [lastTwoStr isEqualToString:@"##"]) {//如果第一个字母是#,并且最后两个字母都是##
            NSArray *continueStrArr = [self.cmdContent componentsSeparatedByString:@"#"];
            continueTimeStr = [NSString stringWithFormat:@"已设置时间为%ld",[continueStrArr[0] integerValue] / 60 ];
        }else{
            continueTimeStr = @"默认时间为60";
        }
    }
    
    if (_is036) {
        BYPostBackModel * model0 = [BYPostBackModel createModelWith: @"回传间隔时间" detail:@"1200" placeholder:continueTimeStr unit:@"秒"];
        BYPostBackModel * model1 = [BYPostBackModel createModelWith: @"抓车模式持续时间" detail:@"60" placeholder:@"默认时间为60" unit:@"分钟"];
        [self.dataSource addObject:model0];
        [self.dataSource addObject:model1];
    }else{
        BYPostBackModel * model = [BYPostBackModel createModelWith:_is027 ? @"回传间隔时间" : @"抓车模式持续时间" detail:@"60" placeholder:continueTimeStr unit:@"分钟"];
        model.saveLightSelected = YES;
        [self.dataSource addObject:model];
    }
    
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([BYPostBackCell class]) bundle:nil] forCellReuseIdentifier:@"cell"];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    BYPostBackCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    BYPostBackModel *model = self.dataSource[indexPath.row];
    cell.model = model;
    cell.saveLightButton.hidden = ! self.is029;
    [cell setShouldEndInputBlock:^(NSString *input) {
        NSInteger continueInt = [input integerValue];
        if (_is029) {
            if (continueInt < 5) {
                return [BYProgressHUD by_showErrorWithStatus:@"持续时间须大于等于5分钟"];
            }
        
            if (continueInt > 1440) {
                return [BYProgressHUD by_showErrorWithStatus:@"持续时间须小于等于1440分钟"];
            }
        }
//        else if(_is036){
//            if (indexPath.row == 0) {
//                if (continueInt < 10) {
//                    return [BYProgressHUD by_showErrorWithStatus:@"持续时间须大于等于10秒"];
//                }
//                
//                if (continueInt > 1800) {
//                    return [BYProgressHUD by_showErrorWithStatus:@"持续时间须小于等于1800秒"];
//                }
//            }else{
//                if (continueInt < 5) {
//                    return [BYProgressHUD by_showErrorWithStatus:@"持续时间须大于等于5分钟"];
//                }
//                
//                if (continueInt > 43200) {
//                    return [BYProgressHUD by_showErrorWithStatus:@"持续时间须小于等于43200分钟"];
//                }
//            }
//        }else{
//            if (continueInt < 5) {
//                return [BYProgressHUD by_showErrorWithStatus:@"持续时间须大于5分钟"];
//            }
//            
//            if (continueInt > 720) {
//                return [BYProgressHUD by_showErrorWithStatus:@"持续时间须小于720分钟"];
//            }
//        }
        
        if ([input isEqualToString:@""]) {
            input = indexPath.row == 0 ? @"1200" : @"60";
        }
        model.detail = input;
    }];
    
    [cell setSaveLightBlock:^{
        model.saveLightSelected = !model.saveLightSelected;
//        [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    }];
    
//    self.textField = cell.textField;
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.dataSource.count;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    
    BYPostBackFooterView * footer = [BYPostBackFooterView by_viewFromXib];
    
    [footer setSureActionBlock:^{
        [self.tableView endEditing:YES];
        [self.view endEditing:YES];
        if (_is027) {
            BYPostBackModel *model = self.dataSource.firstObject;
            NSInteger duration = [model.detail integerValue] * 60;
            
            if ([model.detail integerValue] < 1) {
                return [BYProgressHUD by_showErrorWithStatus:@"持续时间须大于等于1分钟"];
            }
            
            if ([model.detail integerValue] > 999) {
                return [BYProgressHUD by_showErrorWithStatus:@"持续时间须小于等于999分钟"];
            }
            
            self.httpParams.content = [NSString stringWithFormat:@"%ld",duration];
            [BYDeviceDetailHttpTool POSTSendPostBackWithParams:self.httpParams success:^{
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    [self.navigationController popToViewController:self animated:YES];
                });
            }];
        }else if(_is036){
            BYPostBackModel * modelBack = self.dataSource.firstObject;
            NSInteger back = [modelBack.detail integerValue];
            
            NSString *bett = nil;
            if (self.model.batteryNotifier.length>0) {
                bett = [self.model.batteryNotifier substringToIndex:self.model.batteryNotifier.length - 1];
            }else{
                bett = @"";
            }
            
            if ([bett integerValue] <= 50) {
                if (back < 1200) {
                    return [BYProgressHUD by_showErrorWithStatus:@"电量等于50%或以下，持续时间须大于等于1200秒"];
                }
            }else{
                if (back < 60) {
                    return [BYProgressHUD by_showErrorWithStatus:@"持续时间须大于等于60秒"];
                }
            }
            
            if (back > 1800) {
                return [BYProgressHUD by_showErrorWithStatus:@"持续时间须小于等于1800秒"];
            }
            
            BYPostBackModel * modelDuration = self.dataSource.lastObject;
            NSInteger duration = [modelDuration.detail integerValue];
            if (duration < 5) {
                return [BYProgressHUD by_showErrorWithStatus:@"持续时间须大于等于5分钟"];
            }
            
            if (duration > 43200) {
                return [BYProgressHUD by_showErrorWithStatus:@"持续时间须小于等于43200分钟"];
            }
            
            self.httpParams.content = [NSString stringWithFormat:@"%ld#%zd",duration,back];
            //当电量大于50%且回传间隔小于1200秒，发送成功给予提示
            [BYDeviceDetailHttpTool POSTSendPostBackWithParams:self.httpParams success:^{
                if ([bett integerValue] > 50 && back < 1200) {
                    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"注意！！" message:@"指令已发送,当设备电量降为50%时，系统将自动发送20分钟回传一次的指令，确保本设备的电量不在短时间内耗光。" preferredStyle:UIAlertControllerStyleAlert];
                    if ([BYObjectTool getIsIpad]){
                        
                        alertVC.popoverPresentationController.sourceView = self.view;
                        alertVC.popoverPresentationController.sourceRect =   CGRectMake(100, 100, 1, 1);
                    }
                    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"返回指令列表" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                        
                        dispatch_async(dispatch_get_main_queue(), ^{
                            
                            [self.navigationController popToViewController:self animated:YES];
                        });
                    }];
                    [alertVC addAction:okAction];
                    
                    //Custom Title,使用富文本来改变title的字体大小
                    
                    NSMutableAttributedString *hogan = [[NSMutableAttributedString alloc] initWithString:@"注意！！"];
                    
                    [hogan addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:20] range:NSMakeRange(0, 4)];
                    [hogan addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(0, 4)];
                    [alertVC setValue:hogan forKey:@"attributedTitle"];
                    
                    NSMutableAttributedString *hogan1 = [[NSMutableAttributedString alloc] initWithString:@"指令已发送，当设备电量降为50%时，系统将自动发送20分钟回传一次的指令，确保本设备的电量不在短时间内耗光。"];
                    
                    [hogan1 addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:20] range:NSMakeRange(28, 8)];
                    [hogan1 addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(28, 8)];
                    
                    [alertVC setValue:hogan1 forKey:@"attributedMessage"];
                    
                    [self presentViewController:alertVC animated:YES completion:nil];
                }else{
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        [self.navigationController popToViewController:self animated:YES];
                    });
                }
            }];
        }else{
            BYPostBackModel *model = self.dataSource.firstObject;
            NSInteger duration = [model.detail integerValue];
            
            if (duration < 5) {
                return [BYProgressHUD by_showErrorWithStatus:@"持续时间须大于5分钟"];
            }
            
            if (duration > 720) {
                return [BYProgressHUD by_showErrorWithStatus:@"持续时间须小于720分钟"];
            }
            if (_is029) {
                self.httpParams.content = [NSString stringWithFormat:@"%ld#%d",(long)duration,model.saveLightSelected ? 1 : 0];
            }else{
                self.httpParams.content = [NSString stringWithFormat:@"%ld",duration];
            }
            
            [BYDeviceDetailHttpTool POSTSendPostBackWithParams:self.httpParams success:^{
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    [self.navigationController popToViewController:self animated:YES];
                });
            }];
        }
        
    }];
    
    if (_is036) {
        footer.title =  @"注：设备电量等于50%或以下时，只可发送1200秒（20分钟）～ 1800秒（30分钟）的指令";
        footer.titleLabel.textColor = [UIColor redColor];
    }else if(_is027)
    {
        footer.title =  @"";
    }else if(_is029){
        footer.title =  @"*智能省电：开启后，车辆行驶时，实时上报；车辆停止时，1小时上报一次";
        footer.subTitle = @"*设置追车模式后，设备将一分钟上传一次定位";
    }else{
        footer.title =  @"*设置抓车模式后,将1分钟上报一次定位";
    }
    
//    footer.title = _is027 ? @"": @"*设置抓车模式后,将1分钟上报一次定位";

    return footer;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return self.is029 ? 85 : 44;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return BYS_W_H(40) + 80 + 50;
}

-(instancetype)init{
    return [self initWithStyle:UITableViewStyleGrouped];
}

-(NSMutableArray *)dataSource{
    if (_dataSource == nil) {
        _dataSource = [[NSMutableArray alloc] init];
    }
    return _dataSource;
}

-(BYSendPostBackParams *)httpParams{
    if (_httpParams == nil) {
        _httpParams = [[BYSendPostBackParams alloc] init];
        _httpParams.deviceId = self.model.deviceId;
        _httpParams.model = self.model.model;
        _httpParams.type = 1;
        _httpParams.mold = _is027? 1 : 2;
    }
    return _httpParams;
}

@end

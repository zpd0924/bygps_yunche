//
//  BYBreakOilController.m
//  BYGPS
//
//  Created by miwer on 16/9/28.
//  Copyright © 2016年 miwer. All rights reserved.
//

#import "BYBreakOilController.h"
#import "BYBreakOilCell.h"
#import "BYPostBackFooterView.h"
//#import "BYSendPostBackParams.h"
#import "BYSendBreakingOilParams.h"
#import "BYAlertView.h"
#import "BYBreakOilContentView.h"
#import "BYDeviceDetailHttpTool.h"
#import "BYPushNaviModel.h"
#import "EasyNavigation.h"

static NSString * const ID = @"cell";

@interface BYBreakOilController ()

@property(nonatomic,strong) NSMutableArray * isSelectArr;
@property(nonatomic,strong) BYSendBreakingOilParams * httpParams;
//@property(nonatomic,strong) BYAlertView * alertView;

@end

@implementation BYBreakOilController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initBase];
}

-(void)initBase{
    [self.navigationView setTitle:@"车辆断油电"];
    self.isSelectArr = [NSMutableArray arrayWithObjects:@"0",@"0", nil];
    self.view.backgroundColor = BYGlobalBg;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.automaticallyAdjustsScrollViewInsets = NO;
    if (@available(iOS 11.0, *)){
        if ([self.tableView respondsToSelector:@selector(setContentInsetAdjustmentBehavior:)]) {
            self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
    }
    UIView *head = [[UIView alloc] initWithFrame:CGRectMake(0, 0, BYSCREEN_W, SafeAreaTopHeight)];
    self.tableView.tableHeaderView = head;
    
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([BYBreakOilCell class]) bundle:nil] forCellReuseIdentifier:ID];

    //  添加观察者，监听键盘弹出
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardDidShow:) name:UIKeyboardWillShowNotification object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardDidHide:) name:UIKeyboardWillHideNotification object:nil];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    BYBreakOilCell * cell = [tableView dequeueReusableCellWithIdentifier:ID];
    cell.isSelect = [self.isSelectArr[indexPath.row] boolValue];
    cell.title = indexPath.row == 0 ? @"断油/断电" : @"恢复油电";
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row == 0) {
        self.isSelectArr[0] = [self.isSelectArr[0] isEqualToString:@"0"] ? @"1" : @"0";
        self.isSelectArr[1] = [self.isSelectArr[0] isEqualToString:@"0"] ? @"1" : @"0";
        self.httpParams.content = @"0";
    }else{
        self.isSelectArr[1] = [self.isSelectArr[1] isEqualToString:@"0"] ? @"1" : @"0";
        self.isSelectArr[0] = [self.isSelectArr[1] isEqualToString:@"0"] ? @"1" : @"0";
        self.httpParams.content = @"1";
    }
    [self.tableView reloadData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return 2;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return BYS_W_H(40);
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return BYS_W_H(50);
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return BYS_W_H(40) + 80 + 50;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, BYSCREEN_W, 40)];
    label.text = @"    设置类型";
    label.backgroundColor = [UIColor clearColor];
    label.textColor = [UIColor grayColor];
    label.font = BYS_T_F(15);
    return label;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    
    BYPostBackFooterView * footer = [BYPostBackFooterView by_viewFromXib];
    footer.title = @"";
    
    BYWeakSelf;
    [footer setSureActionBlock:^{
        if (!weakSelf.httpParams.content) {
            return [BYProgressHUD by_showErrorWithStatus:@"请选择指令类型"];
        }
        [BYDeviceDetailHttpTool POSTSendBreakingOilWith:weakSelf.httpParams success:nil];
//        [weakSelf.alertView show];
        
    }];
    return footer;
}

#pragma mark - lazy
-(BYSendBreakingOilParams *)httpParams{
    if (_httpParams == nil) {
        _httpParams = [[BYSendBreakingOilParams alloc] init];
        _httpParams.deviceId = self.model.deviceId;
        _httpParams.type = 3;
        _httpParams.model = self.model.model;
//        _httpParams.levelPassWord = @"";
    }
    return _httpParams;
}

//-(BYAlertView *)alertView{
//    if (_alertView == nil) {
//
//        _alertView = [BYAlertView viewFromNibWithTitle:@"回传间隔" message:nil];
//        _alertView.alertHeightContraint.constant = BYS_W_H(80 + 60) + 60;
//        _alertView.alertWidthContraint.constant = BYS_W_H(240);
//
//        BYBreakOilContentView * contentView = [BYBreakOilContentView by_viewFromXib];
//        contentView.frame = _alertView.contentView.bounds;
//        contentView.deviceNum = self.model.sn;
//
//        __weak typeof(contentView) weakContentView = contentView;
//        BYWeakSelf;
//        [_alertView setSureBlock:^{
//
////            weakSelf.httpParams.levelPassWord = weakContentView.textField.text;
//            [BYDeviceDetailHttpTool POSTSendBreakingOilWith:weakSelf.httpParams success:nil];
//        }];
//
//        [_alertView setCancelBlock:^{
//            _alertView = nil;
//        }];
//
//        [_alertView.contentView addSubview:contentView];
//    }
//    return _alertView;
//}

//- (void)keyBoardDidShow:(NSNotification*)notifiction {
//
//    if (self.alertView && self.alertView.alert.by_centerY == BYSCREEN_H / 2) {
//
//        // 取得键盘的动画时间，这样可以在视图上移的时候更连贯
//        double duration = [[notifiction.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
//
//        CGRect frame = self.alertView.alert.frame;
//        frame.origin.y -= BYTextFieldPullUpHeight;
//        [UIView animateWithDuration:duration animations:^{
//
//            self.alertView.alert.frame = frame;
//        }];
//    }
//}
//
//- (void)keyBoardDidHide:(NSNotification*)notification {
//    if (self.alertView) {
//
//        CGRect frame = self.alertView.alert.frame;
//        frame.origin.y += BYTextFieldPullUpHeight;
//        [UIView animateWithDuration:0.1 animations:^{
//
//            self.alertView.alert.frame = frame;
//        }];
//    }
//}

-(void)dealloc{
//    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
//    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

@end

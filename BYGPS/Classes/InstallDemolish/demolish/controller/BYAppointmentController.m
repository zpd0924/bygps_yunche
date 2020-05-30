//
//  BYAppointmentController.m
//  父子控制器
//
//  Created by miwer on 2016/12/28.
//  Copyright © 2016年 miwer. All rights reserved.
//

#import "BYAppointmentController.h"
#import "BYAppointmentCell.h"
#import "BYInstallModel.h"
#import "UIButton+BYFooterButton.h"
#import "BYSelectDeviceController.h"
#import "BYInstallDemolishHttpTool.h"
#import "BYRegularTool.h"
#import "EasyNavigation.h"

@interface BYAppointmentController ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong)NSMutableArray * dataSource;
@property(nonatomic,strong) UILabel * headLabel;
@property (nonatomic,strong) UITableView *tableView;

@end

@implementation BYAppointmentController

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //  添加观察者，监听键盘弹出
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardDidShow:) name:UIKeyboardWillShowNotification object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardDidHide:) name:UIKeyboardWillHideNotification object:nil];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
//    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
//    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initBase];
}



-(void)initBase{
    
    [self.navigationView setTitle:@"预约拆机"];
//    self.tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, BYSCREEN_W, 64)];

    BYInstallModel * model1 = [BYInstallModel createModelWith:@"车牌号" placeholder:@"请输入车牌号" isNecessary:YES postKey:@"carNum"];
    BYInstallModel * model2 = [BYInstallModel createModelWith:@"车主姓名" placeholder:@"车主姓名自动带出" isNecessary:YES postKey:@"ownerName"];
    BYInstallModel * model3 = [BYInstallModel createModelWith:@"钥匙保管人" placeholder:@"请输入钥匙保管人姓名" isNecessary:YES postKey:@"keyKeeper"];
    BYInstallModel * model4 = [BYInstallModel createModelWith:@"保管电话" placeholder:@"请输入钥匙保管人电话" isNecessary:YES postKey:@"keeperIphone"];
    BYInstallModel * model5 = [BYInstallModel createModelWith:@"车停靠位置" placeholder:@"请输入车停靠位置" isNecessary:YES postKey:@"carPlace"];
    
    [self.dataSource addObject:model1];
    [self.dataSource addObject:model2];
    [self.dataSource addObject:model3];
    [self.dataSource addObject:model4];
    [self.dataSource addObject:model5];

    self.tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([BYAppointmentCell class]) bundle:nil] forCellReuseIdentifier:@"appointmentCell"];
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 5;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    BYInstallModel * model = self.dataSource[indexPath.row];
    BYAppointmentCell * cell = [tableView dequeueReusableCellWithIdentifier:@"appointmentCell"];
    cell.model = model;
    [cell setShouldEndInputBlock:^(NSString * input) {
        model.subTitle = input;
    }];
    
    if (indexPath.row == 0) {//当是输入车牌时,要通过车牌来请求车主姓名
        [cell setShouldChangeCharsBlock:^(NSString *input) {
            
            BYInstallModel * carNumModel = self.dataSource[1];
            if ([input isEqualToString:@"-1"]) {
                carNumModel.subTitle = nil;
                
                dispatch_async(dispatch_get_main_queue(), ^{
                     [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:1 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
                });
               

            }else{
                [BYInstallDemolishHttpTool POSTLoadUsernameByCarNum:input success:^(id data) {
                    BYLog(@"data : %@",data);
                    NSArray *deviceArr = (NSArray *)data;
                    if (deviceArr.count > 0) {//判断该车牌下有没有车主
                        NSDictionary *deviceDict = deviceArr.firstObject;
                        carNumModel.subTitle = deviceDict[@"ownerName"];
                        
                    }else{
                        carNumModel.subTitle = nil;
                        [BYProgressHUD by_showErrorWithStatus:@"该车牌号下没有设备"];
                    }
                    dispatch_async(dispatch_get_main_queue(), ^{
                         [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:1 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
                    });
                } showError:NO];
            }
        }];
    }
    
    //当是名字栏时不能输入
    cell.isUserInteraction = indexPath.row == 1 ? NO : YES;
    
    return cell;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return self.headLabel;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView * view = [[UIView alloc] init];
    UIButton * button = [UIButton buttonWithMargin:20 backgroundColor:BYGlobalBlueColor title:@"下一步" target:self action:@selector(nextAction)];
    [view addSubview:button];
    return view;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return BYS_W_H(50);
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return BYS_W_H(30);
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.view endEditing:YES];
}

-(void)nextAction{
    [self.view endEditing:YES];
    
    for (BYInstallModel * model in self.dataSource) {
        BYLog(@"title : %@ - subtitle : %@",model.title,model.subTitle);
        
        NSInteger index = [self.dataSource indexOfObject:model];
        if (index <= 1 && !model.subTitle.length) {
            return [BYProgressHUD by_showErrorWithStatus:@"车牌号输入有误"];
        }else if (index == 2){
            if (model.subTitle.length > 10) {
                return [BYProgressHUD by_showErrorWithStatus:@"车钥匙保管人姓名长度不能超过10"];
            }else if(model.subTitle.length <= 0){
                return [BYProgressHUD by_showErrorWithStatus:@"车钥匙保管人姓名不能为空"];
            }
        }else if (index == 3){
            if (model.subTitle.length > 20) {
                return [BYProgressHUD by_showErrorWithStatus:@"车钥匙保管人电话长度不能超过20"];
            }else if (model.subTitle.length){
                if (![BYRegularTool isAllNumWith:model.subTitle]) {
                    
                    return [BYProgressHUD by_showErrorWithStatus:@"请输入正确的保管人电话"];
                }
            }else{
               return [BYProgressHUD by_showErrorWithStatus:@"请输入保管人电话"];
            }
        }else if (index == 4 ){
            if (model.subTitle.length > 30) {
                return [BYProgressHUD by_showErrorWithStatus:@"车停靠位置长度不能超过30"];
            }else if(model.subTitle.length <= 0 ){
                return [BYProgressHUD by_showErrorWithStatus:@"请输入车辆停靠位置"];
            }
            
        }
    }
    
    BYSelectDeviceController * selectVc = [[BYSelectDeviceController alloc] init];
    selectVc.isImages = NO;
    
    selectVc.fillInfoArr = [NSMutableArray array];
    [selectVc.fillInfoArr addObjectsFromArray:self.dataSource];
    
    [self.navigationController pushViewController:selectVc animated:YES];

}

//- (void)keyBoardDidShow:(NSNotification*)notifiction {
//
//    if (self.tableView) {
//
//        // 取得键盘的动画时间，这样可以在视图上移的时候更连贯
//        double duration = [[notifiction.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
//
//        CGRect frame = self.tableView.frame;
//        frame.origin.y -= BYTextFieldPullUpHeight;
//        [UIView animateWithDuration:duration animations:^{
//
//            self.tableView.frame = frame;
//        }];
//    }
//}
//
//- (void)keyBoardDidHide:(NSNotification*)notification {
//    if (self.tableView) {
//        //取出键盘最终的frame
////        CGRect rect = [notification.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
//        CGRect frame = self.tableView.frame;
//        frame.origin.y += BYTextFieldPullUpHeight;
//        [UIView animateWithDuration:0.1 animations:^{
//
//            self.tableView.frame = frame;
//        }];
//    }
//}

-(void)dealloc{
//    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
//    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

//-(instancetype)init{
//    return [self initWithStyle:UITableViewStyleGrouped];
//}

#pragma mark - lazy
-(NSMutableArray *)dataSource{
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}

-(UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, SafeAreaTopHeight, BYSCREEN_W, BYSCREEN_H - SafeAreaTopHeight) style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [self.view addSubview:_tableView];
    }
    return _tableView;
}


-(UILabel *)headLabel{
    if (_headLabel == nil) {
        _headLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, BYSCREEN_W, BYS_W_H(30))];
        _headLabel.textAlignment = NSTextAlignmentCenter;
        _headLabel.backgroundColor = [UIColor colorWithHex:@"#FFEEC8"];
        _headLabel.textColor = [UIColor colorWithHex:@"#E74B1A"];
        _headLabel.font = BYS_T_F(13);
        _headLabel.text = @"* 车架号拆机请联系客服0755-36567158 ";
    }
    return _headLabel;
}



@end

//
//  BYWorkMessageCell.h
//  BYGPS
//
//  Created by 李志军 on 2018/7/9.
//  Copyright © 2018年 miwer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BYWorkMessageModel.h"
typedef enum : NSUInteger {
    serveAdressType,//服务地址
    detailAdressType,//详细地址
    sendType,//派单类型
    serveType,//服务技师
    checkType,//是否审核
    unpackReasonType,//拆机原因
    contactsType//联系人
} MessageType;

typedef void(^BYWorkMessageCellBlock)(MessageType type ,NSString *str);

@interface BYWorkMessageCell : UITableViewCell
@property (nonatomic,strong) NSIndexPath *indexPath;
///输入框block
@property (nonatomic,copy) BYWorkMessageCellBlock messageCellBlock;
@property (nonatomic,strong) BYWorkMessageModel *workMessageModel;
@property (nonatomic,assign) BYSendOrderType sendOrderType;
@end

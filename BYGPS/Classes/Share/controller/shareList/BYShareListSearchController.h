//
//  BYShareListSearchController.h
//  BYGPS
//
//  Created by 李志军 on 2018/12/12.
//  Copyright © 2018 miwer. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    MySendShareType,//我发出的
    MyReceiveShareType//我收到的
} BYSearchType;

@interface BYShareListSearchController : UIViewController
@property (nonatomic,assign) BYSearchType searchType;
@end

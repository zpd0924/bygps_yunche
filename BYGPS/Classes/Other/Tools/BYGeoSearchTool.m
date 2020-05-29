//
//  BYGeoSearchTool.m
//  BYGPS
//
//  Created by miwer on 16/9/19.
//  Copyright © 2016年 miwer. All rights reserved.
//

#import "BYGeoSearchTool.h"

@interface BYGeoSearchTool () <BMKGeoCodeSearchDelegate>

@property(nonatomic,assign) CLLocationCoordinate2D coordinate;
@property(nonatomic,strong) BMKGeoCodeSearch * searcher;
@property(nonatomic,strong) id target;

@end

@implementation BYGeoSearchTool

+(void)geoDecodeWith:(CLLocationCoordinate2D)coordinate target:(id)target success:(void (^)(NSString *address))success{
    
    BYGeoSearchTool * tool = [[BYGeoSearchTool alloc] init];
    tool.coordinate = coordinate;
    tool.geoDecodeBlock = success;
    tool.target = target;
    [tool geoDecode];
    
}

-(void)geoDecode{
    
    //初始化检索对象
    _searcher =[[BMKGeoCodeSearch alloc]init];
    _searcher.delegate = self.target;
    
    //    发起反向地理编码检索
    BMKReverseGeoCodeSearchOption * searchOption = [[BMKReverseGeoCodeSearchOption alloc]init];
    searchOption.location = self.coordinate;
    BOOL flag = [_searcher reverseGeoCode:searchOption];
    
    if(flag){
        BYLog(@"反geo检索发送成功");
    }else{
        BYLog(@"反geo检索发送失败");
    }
    
}

//接收反向地理编码结果
-(void)onGetReverseGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKReverseGeoCodeSearchResult *)result errorCode:(BMKSearchErrorCode)error{
    
    if (error == BMK_SEARCH_NO_ERROR) {
        
        BYLog(@"address:%@",result.address);
        
        if (self.geoDecodeBlock) {
            self.geoDecodeBlock(result.address);
        }
        
    }else {
        BYLog(@"抱歉，未找到结果");
    }
    
}

@end

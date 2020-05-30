//
//  BYSessionManager.m
//
//  Created by miwer on 16/8/3.
//  Copyright © 2016年 miwer. All rights reserved.
//

#import "BYSessionManager.h"

@implementation BYSessionManager

+ (instancetype)shareInstance{
    
    static BYSessionManager * manager;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/html", @"text/xml", @"text/plain", nil];
        manager = [[self alloc] initWithBaseURL:[NSURL URLWithString:[BYSaveTool objectForKey:BYBaseUrl]]];
        manager.requestSerializer.timeoutInterval = BYTimeoutInterval;

    });
    return manager;
}


@end

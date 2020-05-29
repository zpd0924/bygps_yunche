//
//  BYCaculateFileSizeTool.h
//  BYGPS
//
//  Created by miwer on 2017/2/17.
//  Copyright © 2017年 miwer. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BYCaculateFileSizeTool : NSObject

+ (void)caculateFileSize:(NSString *)directoryPath completion:(void(^)(NSInteger))completion;

+ (void)removeDirectoryPath:(NSString *)directoryPath;

@end

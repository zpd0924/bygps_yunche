//
//  BYArchiverManager.m
//  BYGPS
//
//  Created by 李志军 on 2018/7/19.
//  Copyright © 2018年 miwer. All rights reserved.
//

#import "BYArchiverManager.h"
#define Document [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0]
#define ArchiverFile    [Document stringByAppendingPathComponent:@"Archiver"]

@interface BYArchiverManager()

@property(nonatomic, strong) NSFileManager *fileManager;

@end

@implementation BYArchiverManager
+ (BYArchiverManager *)shareManagement
{
   static BYArchiverManager *m_localArchiverMana = nil;
    static dispatch_once_t onceTocken;
    dispatch_once(&onceTocken, ^
                  {
                      m_localArchiverMana = [[BYArchiverManager alloc] init];
                    
                  });
    return m_localArchiverMana;
}

- (id)init
{
    self = [super init];
    if(self)
    {
        self.fileManager = [NSFileManager defaultManager];
    }
    return self;
}

#pragma mark private methods
// 检测path路径文件是否存在
- (BOOL)checkPathIsExist:(NSString *)path
{
    return [_fileManager fileExistsAtPath:path isDirectory:nil];
}

// 创建文件
- (void)createArchiverFile
{
    if (![self checkPathIsExist:ArchiverFile])
    {
        [self addNewFolder:ArchiverFile];
    }
}

//新建目录,path为目录路径(包含目录名)
- (void)addNewFolder:(NSString *)path
{
    [_fileManager createDirectoryAtPath:path
            withIntermediateDirectories:YES
                             attributes:nil
                                  error:nil];
}

#pragma mark public methods

- (void)clearArchiverDataApiKey:(NSString *)key
{
    NSError *error;
    key = [key stringByReplacingOccurrencesOfString:@"/" withString:@"_"];
    NSString *path = [ArchiverFile stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.text",key]];
    if([_fileManager removeItemAtPath:path error:&error])
    {
        
    } else {
        BYLog(@"清除本地序列化的文件失败....:%@",error);
    }
}
// 保存数据
- (void)saveDataArchiver:(id)obj andAPIKey:(NSString *)key
{
    NSMutableData *data = [[NSMutableData alloc] init];
    NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
    [archiver encodeObject:obj forKey:key];
    [archiver finishEncoding];
    [self createArchiverFile];
    key = [key stringByReplacingOccurrencesOfString:@"/" withString:@"_"];
    NSString *path = [ArchiverFile stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.text",key]];
    　BOOL isSuc = [data writeToFile:path atomically:YES];
    if(!isSuc) {
        BYLog(@"本地序列化失败key....:%@",key);
    }
}
// 获取数据
- (id)archiverQueryAPIKey:(NSString *)key
{
    NSString *str = [key stringByReplacingOccurrencesOfString:@"/" withString:@"_"];
    NSString *path = [ArchiverFile stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.text",str]];
    NSMutableData *data = [[NSMutableData alloc] initWithContentsOfFile:path];
    NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
    id content = [unarchiver decodeObjectForKey:key];
    [unarchiver finishDecoding];
    BYLog(@"content.....:%@",content);
    return content;
}

@end

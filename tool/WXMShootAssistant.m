//
//  WXMShootAssistant.m
//  Multi-project-coordination
//
//  Created by wq on 2019/12/29.
//  Copyright © 2019 wxm. All rights reserved.
//

#import "WXMShootAssistant.h"
#import "WXMShootingConfiguration.h"

@implementation WXMShootAssistant

/** 创建缓存的文件夹 */
+ (void)initialize {
    BOOL isDir = NO;
    BOOL isExists = [kFileManager fileExistsAtPath:kFriendShootVideoPath isDirectory:&isDir];
    if (!isExists || !isDir) {
        [kFileManager createDirectoryAtPath:kFriendShootVideoPath
                withIntermediateDirectories:YES
                                 attributes:nil
                                      error:nil];
    }
    NSLog(@"%@",kFriendShootVideoPath);
}



@end

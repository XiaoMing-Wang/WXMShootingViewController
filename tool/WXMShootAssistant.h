//
//  WXMShootAssistant.h
//  Multi-project-coordination
//
//  Created by wq on 2019/12/29.
//  Copyright © 2019 wxm. All rights reserved.
//
#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface WXMShootAssistant : NSObject

/** 创建文件夹 */
+ (void)createCacheFolder;

/** loadingView */
+ (void)wc_showLoadingView:(UIView *)supView;
+ (void)wc_hiddenLoadingView:(UIView *)supView;

/** 按比例重绘图片 */
+ (UIImage *)compressionImage:(UIImage *)image;

/// 压缩视频
/// @param inputString 输入路径
/// @param outString 输出路径
/// @param callback 回调
+ (void)compressedVideo:(NSString *)inputString
              outString:(NSString *)outString
               callback:(void (^)(BOOL success))callback;
@end

NS_ASSUME_NONNULL_END

//
//  WXMShootAssistant.m
//  Multi-project-coordination
//
//  Created by wq on 2019/12/29.
//  Copyright © 2019 wxm. All rights reserved.
//

#import "WXMShootAssistant.h"
#import "WXMVideoCompression.h"
#import "WXMAVAssetExportSession.h"
#import "WXMShootingConfiguration.h"

@implementation WXMShootAssistant

/** 创建缓存的文件夹 */
+ (void)createCacheFolder {
    BOOL isDir = NO;
    BOOL isExists = [kFileManager fileExistsAtPath:kShootVideoPath isDirectory:&isDir];
    if (!isExists || !isDir) {
        [kFileManager createDirectoryAtPath:kShootVideoPath
                withIntermediateDirectories:YES
                                 attributes:nil
                                      error:nil];
    }
    NSLog(@"%@",kShootVideoPath);
}

/** loadingView */
+ (void)wc_showLoadingView:(UIView *)supView {
    if ([supView viewWithTag:1100]) return;
    UIView *hud = [UIView new];
    hud.frame = CGRectMake(0, 0, 78, 78);
    hud.backgroundColor = [UIColor colorWithRed:23/255. green:23/255. blue:23/255. alpha:0.90];
    hud.clipsToBounds = YES;
    hud.layer.cornerRadius = 6;
    hud.tag = 1100;
    UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    [indicator startAnimating];
    indicator.center = CGPointMake(hud.frame.size.width / 2, hud.frame.size.height / 2);
    hud.center = CGPointMake(supView.frame.size.width / 2, supView.frame.size.height / 2);
    [hud addSubview:indicator];
    [supView addSubview:hud];
}

+ (void)wc_hiddenLoadingView:(UIView *)supView {
    [[supView viewWithTag:1100] removeFromSuperview];
}

/** 按比例重绘图片 */
+ (UIImage *)compressionImage:(UIImage *)image {
    
    /**  宽高比 */
    CGFloat ratio = image.size.width / image.size.height;

    /**  目标大小 */
    CGFloat targetW = 1280;
    CGFloat targetH = 1280;

    /**  宽高均 <= 1280，图片尺寸大小保持不变 */
    if (image.size.width < 1280 && image.size.height < 1280) {
        return image;
    } else if (image.size.width > 1280 && image.size.height > 1280) {

        /** 宽大于高 取较小值(高)等于1280，较大值等比例压缩 */
        if (ratio > 1) {
            targetH = 1280;
            targetW = targetH * ratio;
        } else {
            targetW = 1280;
            targetH = targetW / ratio;
        }
    } else {
        /**  宽或高 > 1280 宽图 图片尺寸大小保持不变 */
        if (ratio > 2) {
            targetW = image.size.width;
            targetH = image.size.height;
        } else if (ratio < 0.5) {
            /**   长图 图片尺寸大小保持不变 */
            targetW = image.size.width;
            targetH = image.size.height;
        } else if (ratio > 1) {
            /**  宽大于高 取较大值(宽)等于1280，较小值等比例压缩 */
            targetW = 1280;
            targetH = targetW / ratio;
        } else {
            /**  高大于宽 取较大值(高)等于1280，较小值等比例压缩 */
            targetH = 1280;
            targetW = targetH * ratio;
        }
    }
    return [self scaleToSize:image size:CGSizeMake(targetW, targetH)];
}

/** 修改图片大小 */
+ (UIImage *)scaleToSize:(UIImage *)image size:(CGSize)size {
    if ([[UIScreen mainScreen] scale] == 0.0) {
        UIGraphicsBeginImageContext(size);
    } else {
        UIGraphicsBeginImageContextWithOptions(size, NO, [UIScreen mainScreen].scale);
    }
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return scaledImage;
}

/// 压缩视频
/// @param inputString 输入路径
/// @param outString 输出路径
/// @param callback 回调
+ (void)compressedVideo:(NSString *)inputString
              outString:(NSString *)outString
               callback:(void (^)(BOOL success))callback {
    
    WXMVideoCompression *compression = [[WXMVideoCompression alloc]init];
    compression.inputURL = [NSURL URLWithString:inputString]; /**  视频输入路径 */
    compression.exportURL = [NSURL fileURLWithPath:outString]; /**  视频输出路径 */
    
    WXMAudioConfigurations audioConfigurations;/**  音频压缩配置 */
    audioConfigurations.samplerate = WXMAudioSampleRate_11025Hz; /**  采样率 */
    audioConfigurations.bitrate = WXMAudioBitRate_32Kbps;/** / 音频的码率 */
    audioConfigurations.numOfChannels = 1;/**  声道数 */
    audioConfigurations.frameSize = 8; /**  采样深度 */
    compression.audioConfigurations = audioConfigurations;
    
    WXMVideoConfigurations videoConfigurations;
    videoConfigurations.fps = 25; /**  帧率 一秒中有多少帧 */
    videoConfigurations.videoBitRate = WXM_VIDEO_BITRATE_HIGH; /**  视频质量 码率 */
    videoConfigurations.videoResolution =  WXM_VIDEO_RESOLUTION_SUPER_HIGH; /** 视频尺寸 */
    compression.videoConfigurations = videoConfigurations;
    [compression startCompressionWithCompletionHandler:^(WXMVideoCompressionState State) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (State == WXM_VIDEO_STATE_FAILURE) {
                NSLog(@"压缩失败");
                if (callback) callback(NO);
            } else {
                NSLog(@"压缩成功");
                if (callback) callback(YES);
            }
        });
    }];
}
@end

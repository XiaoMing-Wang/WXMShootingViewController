//
//  WXMShootingConfiguration.h
//  Multi-project-coordination
//
//  Created by wq on 2019/12/29.
//  Copyright © 2019 wxm. All rights reserved.
//
#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#ifndef WXMShootingConfiguration_h
#define WXMShootingConfiguration_h

/** 文件管理类 */
#define kFileManager [NSFileManager defaultManager]

/** Library目录 */
#define kLibraryboxPath \
NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES).firstObject

/** 缓存文件夹 */
#define kFriendPath \
[kLibraryboxPath stringByAppendingPathComponent:@"WXMCaches"]

/** 拍摄视频文件夹 */
#define kShootVideoPath \
[kFriendPath stringByAppendingPathComponent:@"Shootings"]

/** iphoneX */
#define kIPhoneX \
({BOOL isPhoneX = NO;\
if (@available(iOS 11.0, *)) {\
isPhoneX = [[UIApplication sharedApplication] delegate].window.safeAreaInsets.bottom > 0.0;\
}\
(isPhoneX);\
})

/** 底部安全距离 */
#define kSafeDistance (kIPhoneX ? 35 : 0)

/** 视频是默认1920 / 1080输出 */
#define WXMPhotoFullScreen NO

/** 长宽比 */
#define WXMAspect (1920.0 / 1080.0)
#define WXMVideoH (kSWidth * WXMAspect)

/** 屏幕宽高 */
#define kSWidth [UIScreen mainScreen].bounds.size.width
#define kSHeight [UIScreen mainScreen].bounds.size.height

/** tool高度 */
#define WXMShootingNavigationH 44
#define WXMShootingToolH 120

/** 按钮大小 */
#define WXMPhotoButtonWH 85
#define WXMPhotoCancleWH 30
#define WXMPhotoCompleteWH 70

/**  颜色(0xFFFFFF) 不用带 0x 和 @"" */
#define kCOLOR_WITH_HEX(hexValue) \
[UIColor colorWith\
Red:((float)((0x##hexValue & 0xFF0000) >> 16)) / 255.0 \
green:((float)((0x##hexValue & 0xFF00) >> 8)) / 255.0 \
blue:((float)(0x##hexValue & 0xFF)) / 255.0 alpha:1.0f]

typedef NS_ENUM(NSInteger, WXMShootingType) {
    
    /** 拍照 */
    WXMShootingTypePhoto = 0,
    
    /** 视频 */
    WXMShootingTypeVideo,
};

typedef NS_ENUM(NSInteger, WXMShootingResponseType) {
    
    /** 取消 */
    WXMShootingResponseTypeCancle = 0,
    
    /** 确定 */
    WXMShootingResponseTypeSure = 1,
    
    /** 重来 */
    WXMShootingResponseTypeAgain = 2
};

typedef NS_ENUM(NSInteger, WXMShootingTouchType) {
    
    /** 单击 */
    WXMShootingTouchTypeTap = 0,
    
    /** 长按 */
    WXMShootingTouchTypeLongPress,
};

@protocol WXMShootingProtocol <NSObject>
@optional;

/** 回调图片 */
- (void)wx_shootingVControllerWithImage:(UIImage *)image;

/** 回调视频地址 */
- (void)wx_shootingVControllerWithVideo:(NSURL *)videoString;

@end


#endif /* WXMShootingConfiguration_h */

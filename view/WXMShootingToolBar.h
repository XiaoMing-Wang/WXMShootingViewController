//
//  WXMShootingToolBar.h
//  Multi-project-coordination
//
//  Created by wq on 2019/12/29.
//  Copyright © 2019 wxm. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WXMShootingConfiguration.h"

NS_ASSUME_NONNULL_BEGIN

@class WXMShootingToolBar;
@protocol WXMShootingToolBarDelegate <NSObject>
@optional;

/** 开始拍照
 @param toolBar 工具条
 @param actionType 拍摄类型
 @param progress 如果是长按，会有进度值 */
- (void)shooingStart:(WXMShootingToolBar *)toolBar
          actionType:(WXMShootingType)actionType
            progress:(CGFloat)progress;

/** 结束拍摄
 @param toolBar 工具条
 @param actionType 拍摄类型 */
- (void)shootingStop:(WXMShootingToolBar *)toolBar actionType:(WXMShootingType)actionType;


/** 按钮回调
@param toolBar 工具条
@param responseType 回掉类型 */
- (void)shootingAction:(WXMShootingToolBar *)toolBar
          responseType:(WXMShootingResponseType)responseType;

@end

@interface WXMShootingToolBar : UIView

/** 是否支持长按 */
@property (nonatomic, assign) BOOL supportLongTap;

/** 代理 */
@property(nonatomic,weak) id<WXMShootingToolBarDelegate> delegate;

@end

NS_ASSUME_NONNULL_END

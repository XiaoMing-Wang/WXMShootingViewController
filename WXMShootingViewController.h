//
//  WXMShootingViewController.h
//  Multi-project-coordination
//
//  Created by wq on 2019/12/29.
//  Copyright © 2019 wxm. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WXMShootingConfiguration.h"

NS_ASSUME_NONNULL_BEGIN

@interface WXMShootingViewController : UIViewController

/** 是否支持长按 */
@property (nonatomic, assign) BOOL supportLongTap;

/** 协议回调 */
@property (nonatomic, weak) id<WXMShootingProtocol> delegate;

@end

NS_ASSUME_NONNULL_END

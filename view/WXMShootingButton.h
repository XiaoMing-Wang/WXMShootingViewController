//
//  WXMShootingButton.h
//  Multi-project-coordination
//
//  Created by wq on 2019/12/29.
//  Copyright © 2019 wxm. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WXMShootingConfiguration.h"

NS_ASSUME_NONNULL_BEGIN

@interface WXMShootingButton : UIButton
@property (nonatomic, copy) void (^shootingCallStart)(WXMShootingTouchType type, CGFloat progress);
@property (nonatomic, copy) void (^shootingCallEnd)(WXMShootingTouchType type);
@end

NS_ASSUME_NONNULL_END

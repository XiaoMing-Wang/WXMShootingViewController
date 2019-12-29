//
//  WXMShootingNavigationBar.m
//  Multi-project-coordination
//
//  Created by wq on 2019/12/29.
//  Copyright © 2019 wxm. All rights reserved.
//

#import "WXMShootingConfiguration.h"
#import "WXMShootingNavigationBar.h"

@implementation WXMShootingNavigationBar

/** 初始化 */
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) [self initializeInterface];
    return self;
}

- (void)initializeInterface {
    [self addSubview:self.cancleButton];
}

- (UIButton *)cancleButton {
    if (!_cancleButton) {
        _cancleButton = [[UIButton alloc] init];
        _cancleButton.frame = CGRectMake(12.5, 0, WXMPhotoCancleWH, WXMPhotoCancleWH);
        _cancleButton.layer.cornerRadius = WXMPhotoCancleWH / 2.0;
        _cancleButton.layer.masksToBounds = YES;
        _cancleButton.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.35];
        _cancleButton.center = CGPointMake(_cancleButton.center.x, self.frame.size.height / 2);
        
        CGFloat wh = 15;
        UIImageView *icon = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, wh, wh)];
        icon.image = [UIImage imageNamed:@"photo_close_icon"];
        icon.center = CGPointMake(WXMPhotoCancleWH / 2.0, WXMPhotoCancleWH / 2.0);
        [_cancleButton addSubview:icon];
    }
    return _cancleButton;
}


@end

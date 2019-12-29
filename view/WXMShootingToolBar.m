//
//  WXMShootingToolBar.m
//  Multi-project-coordination
//
//  Created by wq on 2019/12/29.
//  Copyright © 2019 wxm. All rights reserved.
//

#import "WXMShootingButton.h"
#import "WXMShootingToolBar.h"

@interface WXMShootingToolBar ()
@property (nonatomic, strong) WXMShootingButton *shootingButton;

/** 功能按钮 */
@property (nonatomic, strong) UIButton *leftButton;
@property (nonatomic, strong) UIButton *rightButton;
@property (nonatomic, strong) UIButton *editorButton;

@end

@implementation WXMShootingToolBar

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setingSubViews];
    }
    return self;
}

/** 设置子控件 */
- (void)setingSubViews {
    CGFloat centerX = self.frame.size.width / 2;
    CGFloat centerY = self.frame.size.height / 2;
    self.shootingButton.center = CGPointMake(centerX, centerY);
    
    self.leftButton.frame = CGRectMake(0, 0, WXMPhotoCompleteWH, WXMPhotoCompleteWH);
    self.rightButton.frame = CGRectMake(0, 0, WXMPhotoCompleteWH, WXMPhotoCompleteWH);
    self.editorButton.frame = CGRectMake(0, 0, WXMPhotoCompleteWH, WXMPhotoCompleteWH);
    
    self.leftButton.center = CGPointMake(centerX, centerY);
    self.rightButton.center = CGPointMake(centerX, centerY);
    self.editorButton.center = CGPointMake(centerX, centerY);
    
    [self addSubview:self.shootingButton];
    [self addSubview:self.leftButton];
    [self addSubview:self.rightButton];
    [self addSubview:self.editorButton];
}

/** 开始 */
- (void (^)(WXMShootingTouchType type, CGFloat progress))shootingCallStart {
    return ^(WXMShootingTouchType type, CGFloat progress) {
        WXMShootingType shootingType = WXMShootingTypePhoto;
        if (type == WXMShootingTouchTypeLongPress) shootingType = WXMShootingTypeVideo;
        if ([self.delegate respondsToSelector:@selector(shooingStart:actionType:progress:)]) {
            [self.delegate shooingStart:self actionType:shootingType progress:progress];
        }
    };
}

/** 结束 */
- (void (^)(WXMShootingTouchType type))shootingCallEnd {
    return ^(WXMShootingTouchType type) {
        [self completeWithAnimation:YES];
        WXMShootingType shootingType = WXMShootingTypePhoto;
        if (type == WXMShootingTouchTypeLongPress) shootingType = WXMShootingTypeVideo;
        if ([self.delegate respondsToSelector:@selector(shootingStop:actionType:)]) {
            [self.delegate shootingStop:self actionType:shootingType];
        }
    };
}


/** 点击事件 */
- (void)clickEvent:(UIButton *)sender {
    
}

/** 小中心录制，拍照按钮 @return ShootingButton */
- (WXMShootingButton *)shootingButton {
    if (!_shootingButton) {
        _shootingButton = [[WXMShootingButton alloc] init];
        _shootingButton.frame = CGRectMake(0, 0, WXMPhotoButtonWH, WXMPhotoButtonWH);
        _shootingButton.shootingCallStart = self.shootingCallStart;
        _shootingButton.shootingCallEnd = self.shootingCallEnd;
    }
    return _shootingButton;
}

/** 左侧按钮 @return UIButton */
- (UIButton *)leftButton {
    if (!_leftButton) {
        _leftButton = [[UIButton alloc] init];
        _leftButton.hidden = YES;
        _leftButton.backgroundColor = [UIColor greenColor];
        _leftButton.layer.cornerRadius = 35;
        _leftButton.layer.masksToBounds = YES;
        [_leftButton setImage:[UIImage imageNamed:@"btn_return"] forState:normal];
        [_leftButton addTarget:self action:@selector(clickEvent:)
              forControlEvents:UIControlEventTouchUpInside];
    }
    return _leftButton;
}

/** 右侧按钮 @return UIButton */
- (UIButton *)rightButton {
    if (!_rightButton) {
        _rightButton = [[UIButton alloc] init];
        _rightButton.hidden = YES;
        _rightButton.layer.cornerRadius = 35;
        _rightButton.layer.masksToBounds = YES;
        [_rightButton setImage:[UIImage imageNamed:@"btn_sure"] forState:normal];
        [_rightButton addTarget:self action:@selector(clickEvent:)
               forControlEvents:UIControlEventTouchUpInside];
    }
    return _rightButton;
}

/** 编辑按钮 @return UIButton */
- (UIButton *)editorButton {
    if (!_editorButton) {
        _editorButton = [[UIButton alloc] init];
        _editorButton.hidden = YES;
        _editorButton.layer.cornerRadius = 35;
        _editorButton.layer.masksToBounds = YES;
        [_editorButton setBackgroundColor:[UIColor lightTextColor]];
        [_editorButton addTarget:self action:@selector(clickEvent:)
                forControlEvents:UIControlEventTouchUpInside];
    }
    return _editorButton;
}

/** 左侧和右侧按钮的动画效果 */
- (void)completeWithAnimation:(BOOL)open {
    _shootingButton.hidden = open;
    _editorButton.hidden = !open;
    _leftButton.hidden = !open;
    _rightButton.hidden = !open;
    
    if (open) {
        [UIView animateWithDuration:0.4 animations:^{
            self.leftButton.transform =
            CGAffineTransformTranslate(self.leftButton.transform, -120, 0);
            self.rightButton.transform =
            CGAffineTransformTranslate(self.rightButton.transform, 120, 0);
        }];
        return;
    }
    
    /**  隐藏 */
    _leftButton.transform = CGAffineTransformIdentity;
    _rightButton.transform = CGAffineTransformIdentity;
}
@end

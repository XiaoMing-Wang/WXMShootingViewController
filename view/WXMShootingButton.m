//
//  WXMShootingButton.m
//  Multi-project-coordination
//
//  Created by wq on 2019/12/29.
//  Copyright © 2019 wxm. All rights reserved.
//

#import "WXMShootingButton.h"
#import "WXMShootingConfiguration.h"

@interface WXMShootingButton ()
/** self */
@property (nonatomic, strong) CAShapeLayer *progressLayer;
@property (nonatomic, strong) CADisplayLink *displayLink;
@property (nonatomic, assign) CGFloat progressValue;

/** centerButton */
@property (nonatomic, strong) UIButton *centerButton;
@property (nonatomic, strong) UIBezierPath *path;
@property (nonatomic, strong) CAShapeLayer *centerLayer;
@property (nonatomic, strong) UILongPressGestureRecognizer *longTap;
@end

@implementation WXMShootingButton

- (void)setFrame:(CGRect)frame {
    [super setFrame:frame];
    [self initializationInterface];
    [self addTapGestureRecognizer];
}

/** 设置子控件 */
- (void)initializationInterface {
    CGFloat wh = self.frame.size.width - 18;
    self.centerButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, wh, wh)];
    self.centerButton.center = CGPointMake(self.frame.size.width / 2, self.frame.size.height / 2);
    [self addSubview:self.centerButton];
    
    self.centerLayer = [CAShapeLayer layer];
    self.centerLayer.frame = self.centerButton.bounds;
    self.centerLayer.path = self.path.CGPath;
    self.centerLayer.strokeColor =  kCOLOR_WITH_HEX(dad9d6).CGColor;
    self.centerLayer.fillColor = [UIColor whiteColor].CGColor;
    self.centerLayer.lineWidth = 13;
    self.centerLayer.strokeEnd = 1;
    [self.centerButton.layer addSublayer:self.centerLayer];
    
    self.progressLayer = [CAShapeLayer layer];
    self.progressLayer.strokeColor = kCOLOR_WITH_HEX(1aad19).CGColor;
    self.progressLayer.fillColor = [UIColor clearColor].CGColor;
    self.progressLayer.lineWidth = 3;
    self.progressLayer.strokeStart = 0;
    self.progressLayer.strokeEnd = 0;
    self.progressLayer.transform = CATransform3DMakeRotation(-M_PI / 2, 0, 0, 1);
    [self.layer addSublayer:self.progressLayer];
}

/** 手势 */
- (void)addTapGestureRecognizer {
    
    /** 单击手势 */
    UITapGestureRecognizer *singeTap =
    [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleClick)];
    [self.centerButton addGestureRecognizer:singeTap];
    
    /** 长按 */
    _longTap =
    [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longClick:)];
    [self.centerButton addGestureRecognizer:_longTap];
}

/** 单击事件 */
- (void)singleClick {
    if (self.shootingCallStart) self.shootingCallStart(WXMShootingTouchTypeTap,_progressValue);
    if (self.shootingCallEnd) self.shootingCallEnd(WXMShootingTouchTypeTap);
}

/** 长按事件 @param tap UILongPressGestureRecognizer */
- (void)longClick:(UILongPressGestureRecognizer*)tap {
    
    /**  手势开始 */
    if (tap.state == UIGestureRecognizerStateBegan) {
        self.centerLayer.lineWidth = 20;
        self.progressLayer.strokeColor = [UIColor greenColor].CGColor;
        self.displayLink =
        [CADisplayLink displayLinkWithTarget:self selector:@selector(changeProgerss)];
        [self.displayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
    }
    
    /** 判断手势结束 视频结束拍摄 */
    if (tap.state == UIGestureRecognizerStateEnded) {
        self.centerLayer.lineWidth = 10;
        
        [self stopProress];
        if (self.shootingCallEnd) {
            self.shootingCallEnd(WXMShootingTouchTypeLongPress);
        }
    }
}

/** 修改进度要的状态（定时器实时调用的方法） */
- (void)changeProgerss {
    double speed = (1.0 / 15.0) / 60.0; //拍摄的时间
    self.progressValue = self.progressValue + speed;
    self.progressLayer.strokeEnd = self.progressValue;
    if (self.progressValue >= 1.05) {
        [self stopProress];
    }

    if (self.shootingCallStart) {
        self.shootingCallStart(WXMShootingTouchTypeLongPress,self.progressValue);
    }
}

/** 结束视频的拍摄 */
- (void)stopProress {
    self.progressValue = 0;
    self.progressLayer.strokeEnd = self.progressValue;
    self.progressLayer.strokeColor = [UIColor clearColor].CGColor;
    [self.displayLink invalidate];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.progressLayer.frame = self.bounds;
    self.progressLayer.path = [UIBezierPath bezierPathWithOvalInRect:self.bounds].CGPath;
    
    self.centerLayer.frame = self.centerButton.bounds;
    self.centerLayer.path = [UIBezierPath bezierPathWithOvalInRect:self.centerButton.bounds].CGPath;
}
@end

//
//  WXMPlayerViewController.m
//  Multi-project-coordination
//
//  Created by wq on 2019/12/29.
//  Copyright © 2019 wxm. All rights reserved.
//
#import "WXMPlayerViewController.h"
#import "WXMShootingConfiguration.h"

@implementation WXMPlayerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor clearColor];
    
    /** 注册通知 */
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(runLoopTheMovie:)
                                                 name:AVPlayerItemDidPlayToEndTimeNotification
                                               object:nil];
}

/** 视频结束后重新播放 */
- (void)runLoopTheMovie:(NSNotification *)n {
    AVPlayerItem *p = [n object];
    [p seekToTime:kCMTimeZero];
    [self.player play];
}

- (void)setUrl:(NSURL *)url {

    NSLog(@"%@",url);
    
    /** 1、得到视频的URL */
    NSURL *movieURL = url;
    
    /** 2、根据URL创建AVPlayerItem */
    self.playerItem = [AVPlayerItem playerItemWithURL:movieURL];
    
    /** 3、把AVPlayerItem 提供给 AVPlayer */
    self.player = [AVPlayer playerWithPlayerItem:self.playerItem];
    
    /** 4、AVPlayerLayer 显示视频。 */
    _playerLayer = [AVPlayerLayer playerLayerWithPlayer:self.player];
    _playerLayer.frame = self.view.bounds;
    
    /** 设置边界显示方式 */
    _playerLayer.videoGravity = AVLayerVideoGravityResizeAspect;
    if (WXMPhotoFullScreen && self.fullScreen) {
        _playerLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    }
    
    [self.view.layer insertSublayer:_playerLayer atIndex:0];
    self.view.clipsToBounds = YES;
    [self.player play];
}

- (void)setImage:(UIImage *)image {
    self.imageView = [[UIImageView alloc] init];
    self.imageView.frame = self.view.bounds;
    self.imageView.image = image;
    self.imageView.contentMode = UIViewContentModeScaleAspectFill;
    if (WXMPhotoFullScreen && self.fullScreen) {
        self.imageView.contentMode = UIViewContentModeScaleAspectFill;
    }
    self.imageView.clipsToBounds = YES;
    [self.view addSubview:self.imageView];
}

- (void)removeSubViews {
    [self.player pause];
    [self.imageView removeFromSuperview];
    [self.player replaceCurrentItemWithPlayerItem:nil];
    [self.playerLayer removeFromSuperlayer];
    
    self.player = nil;
    self.playerItem = nil;
    [self.view removeFromSuperview];
}

- (void)dealloc {
    NSLog(@"WXPlayerContro销毁了");
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

@end

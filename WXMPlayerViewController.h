//
//  WXMPlayerViewController.h
//  Multi-project-coordination
//
//  Created by wq on 2019/12/29.
//  Copyright © 2019 wxm. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface WXMPlayerViewController : UIViewController

@property (nonatomic, strong) NSURL *url;
@property (nonatomic, strong) UIImage *image;
@property (nonatomic, strong) AVPlayerItem *playerItem;
@property (nonatomic, strong) AVPlayer *player;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) AVPlayerLayer *playerLayer;

- (void)removeSubViews;
@end

NS_ASSUME_NONNULL_END

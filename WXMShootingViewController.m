//
//  WXMShootingViewController.m
//  Multi-project-coordination
//
//  Created by wq on 2019/12/29.
//  Copyright © 2019 wxm. All rights reserved.
//
#import "WXMShootAssistant.h"
#import "WXMShootingToolBar.h"
#import "WXMPlayerViewController.h"
#import "WXMShootingConfiguration.h"
#import "WXMShootingViewController.h"

@interface WXMShootingViewController ()
<AVCaptureFileOutputRecordingDelegate,WXMShootingToolBarDelegate>

/** 拍摄条 */
@property (nonatomic, strong) WXMShootingToolBar *toolBar;

/** 播放VC */
@property (nonatomic, strong) WXMPlayerViewController *palyerVc;

/** 负责输入和输出设置之间的数据传递 */
@property (strong, nonatomic) AVCaptureSession *captureSession;

/** 负责从AVCaptureDevice获得输入数据 */
@property (strong, nonatomic) AVCaptureDeviceInput *captureDeviceInput;

/** 照片输出流 */
@property (strong, nonatomic) AVCaptureStillImageOutput *captureStillImageOutput;

/** 视频输出流 */
@property (strong, nonatomic) AVCaptureMovieFileOutput *captureMovieFileOutput;

/** 相机拍摄预览图层 */
@property (strong, nonatomic) AVCaptureVideoPreviewLayer *captureVideoPreviewLayer;

/** 后台任务标示符 */
@property (nonatomic, assign) UIBackgroundTaskIdentifier backgroundTaskIdentifier;

/** 显示视频的内容 */
@property (nonatomic, strong) UIView *userCamera;

/** 保存的Url */
@property (nonatomic, strong) NSURL *localMovieUrl;

/** 拍照的照片 */
@property (nonatomic, strong) UIImage *image;

/** 类型 */
@property (nonatomic, assign) WXMShootingType actionType;

/** 时间戳 */
@property (nonatomic, strong) NSString *timeStemp;

@end

@implementation WXMShootingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [WXMShootAssistant createCacheFolder];
    [self initializationInterface];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.captureSession startRunning];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self.captureSession stopRunning];
}

/** 设置子控件 */
- (void)initializationInterface {
    [self.view addSubview:self.userCamera];
    [self.view addSubview:self.toolBar];
    self.view.backgroundColor = [UIColor blackColor];
    
    [self addChildViewController:self.palyerVc];
    self.navigationController.navigationBar.hidden = YES;
    [self seingUserCamera];
}

/** 设置相机设备 */
- (void)seingUserCamera {
    
    /** 初始化会话 */
    self.captureSession = [[AVCaptureSession alloc]init];
    
    /** 设置分辨率 */
    if ([self.captureSession canSetSessionPreset:AVCaptureSessionPreset1920x1080]) {
        self.captureSession.sessionPreset = AVCaptureSessionPreset1920x1080;
    }
    
    /** 获得输入设备 */
    AVCaptureDevice *capDevice = [self getCameraDeviceWithPosition:AVCaptureDevicePositionBack];
    if (!capDevice) {
        NSLog(@"取得后置摄像头时出现问题.");
        return;
    }
        
    /**  添加一个音频输入设备 */
    AVCaptureDevice *audioDe = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeAudio];
    NSError *error = nil;
    
    /** 根据输入设备初始化设备输入对象，用于获得输入数据 */
    _captureDeviceInput = [[AVCaptureDeviceInput alloc]initWithDevice:capDevice error:&error];
    if (error) {
        NSLog(@"取得设备输入对象时出错，错误原因：%@",error.localizedDescription);
        return;
    }
    
    AVCaptureDeviceInput *audioCaptureDeviceInput = nil;
    audioCaptureDeviceInput = [[AVCaptureDeviceInput alloc]initWithDevice:audioDe error:&error];
    if (error) {
        NSLog(@"取得设备输入对象时出错，错误原因：%@",error.localizedDescription);
        return;
    }
    
    /** 初始化设备输出对象，用于获得输出数据 */
    self.captureMovieFileOutput = [[AVCaptureMovieFileOutput alloc]init];
    
    /** 将设备输入添加到会话中 */
    if ([self.captureSession canAddInput:self.captureDeviceInput]) {
        [self.captureSession addInput:self.captureDeviceInput];
        [self.captureSession addInput:audioCaptureDeviceInput];
        AVCaptureConnection *captureConnet = nil;
        captureConnet = [_captureMovieFileOutput connectionWithMediaType:AVMediaTypeVideo];
        if ([captureConnet isVideoStabilizationSupported]) {
            captureConnet.preferredVideoStabilizationMode = AVCaptureVideoStabilizationModeAuto;
        }
    }
    
    /** 将设备输出添加到会话中 */
    if ([self.captureSession canAddOutput:self.captureMovieFileOutput]) {
        [self.captureSession addOutput:self.captureMovieFileOutput];
    }
    
    /** 输出设置 */
    NSDictionary *outputSettings =
    [[NSDictionary alloc] initWithObjectsAndKeys: AVVideoCodecJPEG, AVVideoCodecKey, nil];
    self.captureStillImageOutput = [[AVCaptureStillImageOutput alloc] init];
    [self.captureStillImageOutput setOutputSettings:outputSettings];
    
    /** 将设备输出添加到会话中 */
    if ([self.captureSession canAddOutput:self.captureStillImageOutput]) {
        [self.captureSession addOutput:self.captureStillImageOutput];
    }
  
    /** 创建视频预览层，用于实时展示摄像头状态 */
    self.captureVideoPreviewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:self.captureSession];

    CALayer *layer = self.userCamera.layer;
    layer.masksToBounds = YES;
    
    /** 填充模式 */
    self.captureVideoPreviewLayer.frame = layer.bounds;
    self.captureVideoPreviewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;

    /** 将视频预览层添加到界面中 */
    [layer addSublayer:self.captureVideoPreviewLayer];
}

/** 取得指定位置的摄像头 */
- (AVCaptureDevice *)getCameraDeviceWithPosition:(AVCaptureDevicePosition)position {
    [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    AVCaptureDevice *camera = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    return camera;
}

/** 捕获区域改变 @param notification 通知对象 */
- (void)areaChange:(NSNotification *)notification {
    NSLog(@"捕获区域改变...");
}

#pragma mark  AVCaptureFileOutputRecordingDelegate

- (void)captureOutput:(AVCaptureFileOutput *)captureOutput
didStartRecordingToOutputFileAtURL:(NSURL *)fileURL
      fromConnections:(NSArray *)connections {
    NSLog(@"开始录制");
}

- (void)captureOutput:(AVCaptureFileOutput *)captureOutput
didFinishRecordingToOutputFileAtURL:(NSURL *)outputFileURL
      fromConnections:(NSArray *)connections error:(NSError *)error {
    /** NSLog(@"完成录制"); */
}

/** 开始拍照 */
- (void)takePhoto:(WXMPlayerViewController *)playerViewController {
    AVCaptureConnection *captureConnection = nil;
    captureConnection = [self.captureStillImageOutput connectionWithMediaType:AVMediaTypeVideo];
    
    /** 根据连接取得设备输出的数据 */
    [self.captureStillImageOutput captureStillImageAsynchronouslyFromConnection:captureConnection completionHandler:^(CMSampleBufferRef ibffer, NSError *error) {
        if (ibffer) {
            NSData *data = [AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:ibffer];
            UIImage *image = [UIImage imageWithData:data];
            playerViewController.image = image;
            self.image = image;
            NSLog(@"===========");
        }
    }];
    //是否是自拍的情况下，如果是话镜像进行调换。
    //if (_isFront) {
    //resultImage = [UIImage imageWithCGImage:image.CGImage scale:1.0 orientation:UIImageOrientationLeftMirrored];
    //
    //} else {
    //resultImage=image;
    //}
    //[self presentImg:resultImage video:nil];
}

#pragma mark WXMShootingToolBar delegate

/** 开始拍照
 @param toolBar 工具条
 @param actionType 拍摄类型
 @param progress 如果是长按，会有进度值 */
- (void)shooingStart:(WXMShootingToolBar *)toolBar
          actionType:(WXMShootingType)actionType
            progress:(CGFloat)progress {
    if (actionType == WXMShootingTypeVideo) {
        [self startRecordVideo];
        NSLog(@"%f",progress);
    }
}

/** 结束拍摄
 @param toolBar 工具条
 @param actionType 拍摄类型 */
- (void)shootingStop:(WXMShootingToolBar *)toolBar actionType:(WXMShootingType)actionType {
    self.actionType = actionType;
    WXMPlayerViewController *playerViewController = self.childViewControllers[0];
    [self.view insertSubview:playerViewController.view aboveSubview:self.userCamera];
    if (self.actionType == WXMShootingTypePhoto) {
        [self takePhoto:playerViewController];
    } else {
        NSLog(@"222222222222");
        [self stopRecordVideo];
        playerViewController.url = self.localMovieUrl;
    }
}

/** 按钮回调
@param toolBar 工具条
@param responseType 回掉类型 */
- (void)shootingAction:(WXMShootingToolBar *)toolBar
          responseType:(WXMShootingResponseType)responseType {
    
    if (responseType == WXMShootingResponseTypeCancle) {
        [self dismissViewControllerAnimated:YES completion:nil];
    } else if (responseType == WXMShootingResponseTypeSure) {
        
        if (self.actionType == WXMShootingTypePhoto && self.image) {
            
            /** 压缩图片 */
            [self compressedImage];
            
        } else if (self.actionType == WXMShootingTypeVideo ) {
            
            /** 压缩视频 */
            NSLog(@"1111111111");
            [self stopRecordVideo];
            [self compressedVideo];
            
        } else {
            [self dismissViewControllerAnimated:YES completion:nil];
        }
        
    } else if (responseType == WXMShootingResponseTypeAgain) {
        [self.captureSession startRunning];
        [self.palyerVc removeSubViews];
        [self.palyerVc.player pause];
    }
}

/** 压缩图片 */
- (void)compressedImage {
    [WXMShootAssistant wc_showLoadingView:self.view];
    UIImage *conversionImage = [WXMShootAssistant compressionImage:self.image];
    if ([self.delegate respondsToSelector:@selector(wx_shootingVControllerWithImage:)]) {
        [self.delegate wx_shootingVControllerWithImage:conversionImage];
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

/** 压缩视频 */
- (void)compressedVideo {
    NSString *originalPath = self.localMovieUrl.absoluteString;
    NSString *outputFilePath = [NSString stringWithFormat:@"%@_cp.mp4", self.timeStemp];
    NSString *newPath = [kShootVideoPath stringByAppendingPathComponent:outputFilePath];
     
    [WXMShootAssistant wc_showLoadingView:self.view];
    [WXMShootAssistant compressedVideo:originalPath outString:newPath callback:^(BOOL success) {
        if (success) {
            if ([self.delegate respondsToSelector:@selector(wx_shootingVControllerWithVideo:)]) {
                [self.delegate wx_shootingVControllerWithVideo:[NSURL fileURLWithPath:newPath]];
                [self dismissViewControllerAnimated:YES completion:nil];
                NSLog(@"%@",newPath);
            } else {
                [self dismissViewControllerAnimated:YES completion:nil];
            }
        }
        [WXMShootAssistant wc_hiddenLoadingView:self.view];
    }];
}

/**  准备录制视频 */
- (void)startRecordVideo {
    AVCaptureConnection *connection = nil;
    connection = [self.captureMovieFileOutput connectionWithMediaType:AVMediaTypeVideo];
    
    /** 如果捕获会话没有运行 */
    if (![self.captureSession isRunning]) {
        [self.captureSession startRunning];
    }
    
    /**  根据连接取得设备输出的数据 */
    if (![self.captureMovieFileOutput isRecording]) {
       
        /**  如果输出 没有录制 */
        /**  如果支持多任务则则开始多任务 */
        if ([[UIDevice currentDevice] isMultitaskingSupported]) {
            self.backgroundTaskIdentifier =
            [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:nil];
            [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:nil];
        }
        
        /** 预览图层和视频方向保持一致 */
        connection.videoOrientation = [self.captureVideoPreviewLayer connection].videoOrientation;
        
        /** 开始录制视频使用到了代理 AVCaptureFileOutputRecordingDelegate 同时还有录制视频保存的文件地址的 */
        [self.captureMovieFileOutput startRecordingToOutputFileURL:self.localMovieUrl
                                                 recordingDelegate:self];
    }
}

/** 停止录制 */
- (void)stopRecordVideo {
    if ([self.captureMovieFileOutput isRecording]) {
        [self.captureMovieFileOutput stopRecording];
    }
    
    if ([self.captureSession isRunning]) {
        [self.captureSession stopRunning];
    }
}

/** 用来显示录像内容 */
- (UIView *)userCamera {
    if (!_userCamera) {
        CGRect rect = CGRectMake(0, (kSHeight - WXMVideoH) / 2, kSWidth, WXMVideoH);
        if (self.fullScreen && WXMPhotoFullScreen) rect = self.view.bounds;
        _userCamera = [[UIView alloc] initWithFrame:rect];
        _userCamera.backgroundColor = [UIColor blackColor];
    }
    return _userCamera;
}

/**  拍摄工具条 @return ShootingToolBar */
- (WXMShootingToolBar *)toolBar {
    if (!_toolBar) {
        CGFloat maxY = CGRectGetMaxY(self.userCamera.frame);
        CGFloat y = maxY - WXMShootingToolH - 10;
        if (maxY == kSHeight) y -= kSafeDistance;
        CGRect rect = CGRectMake(0, y, kSWidth, WXMShootingToolH);
        _toolBar = [[WXMShootingToolBar alloc] initWithFrame:rect];
        _toolBar.delegate = self;
        _toolBar.supportLongTap = self.supportLongTap;
        _toolBar.backgroundColor = [UIColor clearColor];
    }
    return _toolBar;
}

/** 展示Vc @return WXPlayerContro */
- (WXMPlayerViewController *)palyerVc {
    if (!_palyerVc) {
        _palyerVc = [[WXMPlayerViewController alloc] init];
        _palyerVc.fullScreen = self.fullScreen;
    }
    return _palyerVc;
}

#pragma mark 设置视频保存地址
#pragma mark 设置视频保存地址
- (NSURL *)localMovieUrl {
    if (_localMovieUrl == nil) {
        _timeStemp = [NSString stringWithFormat:@"%zd", (long)[[NSDate date] timeIntervalSince1970]];
        NSString *outputFilePath = [NSString stringWithFormat:@"%@.mp4", _timeStemp];
        outputFilePath = [kShootVideoPath stringByAppendingPathComponent:outputFilePath];
        _localMovieUrl = [NSURL fileURLWithPath:outputFilePath];
    }
    return _localMovieUrl;
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

@end

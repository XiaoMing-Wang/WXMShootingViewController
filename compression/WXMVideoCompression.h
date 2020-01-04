//
//  JJVideoCompression.h
//  JJVideoManager
//
//  Created by lujunjie on 2019/3/27.
//  Copyright © 2019 JJ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WXMAVAssetExportSession.h"
typedef enum WXMVideoResolution{
    WXM_VIDEO_RESOLUTION_LOW,           // 352 * 288
    WXM_VIDEO_RESOLUTION_MEDIUM,        // 480 * 360
    WXM_VIDEO_RESOLUTION_HIGH,          // 640 * 480
    WXM_VIDEO_RESOLUTION_SUPER,         // 960 * 540
    WXM_VIDEO_RESOLUTION_SUPER_HIGH,    // 1280 * 720
}WXMVideoResolution;

typedef enum JJVideoBitRate{
    WXM_VIDEO_BITRATE_LOW,           // （width * height * 3）/ 4
    WXM_VIDEO_BITRATE_MEDIUM,        // （width * height * 3）/ 2
    WXM_VIDEO_BITRATE_HIGH,          // （width * height * 2)
    WXM_VIDEO_BITRATE_SUPER,         // （width * height * 3)
    WXM_VIDEO_BITRATE_SUPER_HIGH,    // （width * height * 3）* 2
}WXMVideoBitRate;

typedef struct WXMVideoConfigurations{
    /* indicates the interval which the video composition, when enabled, should render composed video frames */
    int fps; // (0~30)
    WXMVideoBitRate videoBitRate; /* bits per second, H.264 only */
    WXMVideoResolution videoResolution;    // resolution
    
}WXMVideoConfigurations;


typedef enum WXMAudioSampleRate{
    ///  8KHz
    WXMAudioSampleRate_8000Hz  = 8000,
    ///  11KHz
    WXMAudioSampleRate_11025Hz = 11025,
    ///  16KHz
    WXMAudioSampleRate_16000Hz = 16000,
    ///  22KHz
    WXMAudioSampleRate_22050Hz = 22050,
    ///  32KHz
    WXMAudioSampleRate_32000Hz = 32000,
    ///  44.1KHz
    WXMAudioSampleRate_44100Hz = 44100,
    ///  48KHz
    WXMAudioSampleRate_48000Hz = 48000
}WXMAudioSampleRate;

typedef enum WXMAudioBitRate {
    /// 32Kbps
    WXMAudioBitRate_32Kbps = 32000,
    /// 64Kbps
    WXMAudioBitRate_64Kbps = 64000,
    /// 96Kbps
    WXMAudioBitRate_96Kbps = 96000,
    /// 128Kbps
    WXMAudioBitRate_128Kbps = 128000,
    /// 192Kbps
    WXMAudioBitRate_192Kbps = 192000,
    //  224kbps
    WXMAudioBitRate_224Kbps = 224000
    
}WXMAudioBitRate;

typedef struct WXMAudioConfigurations{
    WXMAudioSampleRate samplerate;
    WXMAudioBitRate bitrate;
    int numOfChannels; //(1~2)
    int frameSize; /* value is an integer, one of: 8, 16, 24, 32 */
}WXMAudioConfigurations;


typedef enum JJVideoCompressionState{
    WXM_VIDEO_STATE_FAILURE,
    WXM_VIDEO_STATE_SUCCESS
}WXMVideoCompressionState;



NS_ASSUME_NONNULL_BEGIN

@interface WXMVideoCompression :WXMAVAssetExportSession

/**
 * The URL of the export session’s output.
 *
 * You can observe this property using key-value observing.
 */
@property (nonatomic, copy) NSURL *exportURL;
/**
 * The URL of the writer session’s input.
 *
 * You can observe this property using key-value observing.
 */
@property (nonatomic, copy) NSURL *inputURL;

/**
 * The settings used for encoding the video track.
 */
@property (nonatomic, assign) WXMVideoConfigurations videoConfigurations;
/**
 * The settings used for encoding the audio track.
 */
@property (nonatomic, assign) WXMAudioConfigurations audioConfigurations;

- (void)startCompressionWithCompletionHandler:(void (^)(WXMVideoCompressionState State))handler;

@end

NS_ASSUME_NONNULL_END

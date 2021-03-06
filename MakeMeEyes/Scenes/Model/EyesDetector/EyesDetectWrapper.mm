//
//  EyesCvVideoCameraWrapper.mm
//  MakeMeEyes
//

#import "EyesDetectWrapper.h"
#import "MakeMeEyes-Swift.h"
#import "CppUtils.hpp"
#import "EyesVideoCamera.h"
#import <opencv2/videoio/cap_ios.h>
#import <opencv2/objdetect/objdetect.hpp>
#import <opencv2/imgproc/imgproc_c.h>

///// opencv
#import <opencv2/opencv.hpp>
///// C++
#include <iostream>
///// user
#include "FaceARDetectIOS.h"
//

using namespace cv;

@interface EyesDetectWrapper () {
}
@end

@implementation EyesDetectWrapper
{
    FaceARDetectIOS* facear;
    EyesVideoCamera* videoCamera;
}

- (id) initWithCamera: (EyesVideoCamera*) _videoCamera
{
    if (self = [super init]) {
        videoCamera = _videoCamera;
        facear = [[FaceARDetectIOS alloc] init];
        [self setUpEyeLenseImage];
    }
    
    return self;
}

#ifdef __cplusplus

- (void) detectEyesOnImage: (UIImage*) image
{
    CppUtils* utils = new CppUtils;
    cv::Mat frame;
    utils->imageToMat(image, frame);
    [self detectEyesOnCvImage: frame frameCount: 1];
}

- (void) detectEyesOnCvImage: (cv::Mat&) image frameCount: (int) frameCount
{
    cv::Mat targetImage(image.cols, image.rows, CV_8UC3);
    cv::cvtColor(image, targetImage, cv::COLOR_BGRA2BGR);
    if(targetImage.empty()) {
        std::cout << "targetImage empty" << std::endl;
    }
    else
    {
        float fx, fy, cx, cy;
        cx = 1.0 * targetImage.cols / 2.0;
        cy = 1.0 * targetImage.rows / 2.0;
        
        fx = 500 * (targetImage.cols / [videoCamera camHeight]);
        fy = 500 * (targetImage.rows / [videoCamera camWidth]);
        
        fx = (fx + fy) / 2.0;
        fy = fx;
        
        [facear run_FaceAR: targetImage
                   frame__: frameCount
                      fx__: fx
                      fy__: fy
                      cx__: cx
                      cy__: cy];
    }
    cv::cvtColor(targetImage, image, cv::COLOR_BGRA2RGB);
}

#endif

- (void) showBox {
    [facear showBox];
}

- (void) setNeedDrawEyes: (BOOL) newValue {
    [facear setNeedShowEyes: newValue];
}

- (void) setUpEyeLenseImage {
    NSString* imagePath = [[NSBundle mainBundle] pathForResource: @"lense_white" ofType: @"png"];
    UIImage* image = [UIImage imageWithContentsOfFile: imagePath];
    cv::Mat frame;
    CppUtils* utils = new CppUtils;
    utils->imageToMat(image, frame);
    [facear setEyeLenseImage: frame];
}

- (void) setLenseColorAlpha: (double) alpha {
    [facear setLenseColorAlpha: alpha];
}

- (void) setPupilPercent: (double) percent {
    [facear setPupilPercent: percent];
}

@end

//
//  CvVideoCameraWrapper.m
//  OpenCVproject
//
//  Created by Сергей Кротких on 10/11/2018.
//  Copyright © 2018 Сергей Кротких. All rights reserved.
//

#import "CvVideoCameraWrapper.h"

#import <opencv2/videoio/cap_ios.h>
#import <opencv2/objdetect/objdetect.hpp>
#import <opencv2/imgproc/imgproc_c.h>

using namespace cv;

@interface CvVideoCameraWrapper () <CvVideoCameraDelegate> {
}
@end

@implementation CvVideoCameraWrapper
{
    VideoViewController* viewController;
    UIImageView* imageView;
    CvVideoCamera* videoCamera;
}

- (id) initWithController: (VideoViewController*) viewController andImageView: (UIImageView*) imageView
{
    viewController = viewController;
    imageView = imageView;
    
    videoCamera = [[CvVideoCamera alloc] initWithParentView:imageView];
    videoCamera.defaultAVCaptureDevicePosition = AVCaptureDevicePositionFront;
    videoCamera.defaultAVCaptureSessionPreset = AVCaptureSessionPreset352x288;
    videoCamera.defaultAVCaptureVideoOrientation = AVCaptureVideoOrientationPortrait;
    videoCamera.defaultFPS = 30;
    videoCamera.grayscaleMode = NO;
    videoCamera.delegate = self;
    return self;
}

#ifdef __cplusplus

// CvVideoCameraDelegate protocol

- (void) processImage: (Mat&) frame
{
    EyeIrisDetector* detectEyeIris = new EyeIrisDetector;
    detectEyeIris->detectFace(frame);
}

#endif

#pragma mark - UI Actions

- (void) startCamera
{
    [videoCamera start];
}

- (void) stopCamera
{
    [videoCamera stop];
}

@end

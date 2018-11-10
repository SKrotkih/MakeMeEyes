//
//  CvVideoCameraWrapper.m
//  OpenCVproject
//
//  Created by Сергей Кротких on 10/11/2018.
//  Copyright © 2018 Сергей Кротких. All rights reserved.
//

#import "CvVideoCameraWrapper.h"
#import "OpenCVproject-Swift.h"
#import "CppUtils.hpp"
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
    FaceDetector* faceDetector;
}

- (id) initWithController: (VideoViewController*) viewController andImageView: (UIImageView*) imageView
{
    viewController = viewController;
    imageView = imageView;
    faceDetector = [[FaceDetector alloc] init];
    faceDetector.imageView = imageView;
    
    // Assuming camera input is 352x288 (set using AVCaptureSessionPreset)
    // float cam_width = 288; float cam_height = 352;
    //float cam_width = 480; float cam_height = 640;
    //float cam_width = 720; float cam_height = 1280;

    videoCamera = [[CvVideoCamera alloc] initWithParentView: imageView];
    videoCamera.defaultAVCaptureDevicePosition = AVCaptureDevicePositionFront;
    videoCamera.defaultAVCaptureSessionPreset = AVCaptureSessionPreset352x288;
    videoCamera.defaultAVCaptureVideoOrientation = AVCaptureVideoOrientationPortrait;
    videoCamera.defaultFPS = 30;
    videoCamera.grayscaleMode = NO;
    videoCamera.rotateVideo = NO;
    videoCamera.delegate = self;
    
    return self;
}

#ifdef __cplusplus

// CvVideoCameraDelegate protocol

- (void) processImage: (Mat&) frame
{

    EyeIrisDetector* detectEyeIris = new EyeIrisDetector;
    detectEyeIris->detectFace(frame);
    
//    CppUtils* utils = new CppUtils;
//    UIImage* image = utils->matToImage(frame);
//    [faceDetector runRecognize: image];
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

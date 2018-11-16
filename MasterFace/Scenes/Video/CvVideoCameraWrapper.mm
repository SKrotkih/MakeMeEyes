//
//  CvVideoCameraWrapper.m
//  MasterFace
//
//  Created by Сергей Кротких on 10/11/2018.
//  Copyright © 2018 Сергей Кротких. All rights reserved.
//

#import "CvVideoCameraWrapper.h"
#import "FaceDetectWrapper.h"

#import "MasterFace-Swift.h"
#import "CppUtils.hpp"
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

@interface CvVideoCameraWrapper () <CvVideoCameraDelegate> {
}
@end

@implementation CvVideoCameraWrapper
{
    VideoViewController* viewController;
    UIImageView* imageView;
    CvVideoCamera* videoCamera;
    FaceDetectWrapper* faceDetector;
}

- (id) initWithController: (VideoViewController*) _viewController andImageView: (UIImageView*) _imageView
{
    viewController = _viewController;
    imageView = _imageView;
    faceDetector = [[FaceDetectWrapper alloc] init];
    
    [self setupVideoCamera];
    return self;
}

- (void) setupVideoCamera {
    // Assuming camera input is 640x480 (set using AVCaptureSessionPreset)
    // float cam_width = 288; float cam_height = 352;
    //float cam_width = 480; float cam_height = 640;
    //float cam_width = 720; float cam_height = 1280;
    
    videoCamera = [[CvVideoCamera alloc] initWithParentView: imageView];
    videoCamera.defaultAVCaptureDevicePosition = AVCaptureDevicePositionFront;
    videoCamera.defaultAVCaptureSessionPreset = AVCaptureSessionPreset352x288;  // AVCaptureSessionPreset640x480;
    videoCamera.defaultAVCaptureVideoOrientation = AVCaptureVideoOrientationPortrait;
    videoCamera.defaultFPS = 30;
    videoCamera.grayscaleMode = NO;
    videoCamera.rotateVideo = NO;
    videoCamera.delegate = self;
}

#ifdef __cplusplus

// MARK: - CvVideoCameraDelegate protocol

- (void) processImage: (cv::Mat &) image
{
    [faceDetector detectFacesOnImage: image];
    [self drawMask];
}

#endif

- (void) drawMask {
    cv::Point leftPupil;
    cv::Point rightPupil;
    if ([faceDetector getPupilsCoordinate: leftPupil rightPupil: rightPupil]) {
        [viewController updatePupilsCoordinate: leftPupil.x
                                        _leftY: leftPupil.y
                                       _rightX: rightPupil.x
                                       _rightY: rightPupil.y];
    }
}

- (void) showBox {
    [faceDetector showBox];
}

- (void) setNeedDrawEyes: (BOOL) newValue {
    [faceDetector setNeedDrawEyes: newValue];
}

- (void) setLenseColorAlpha: (double) alpha {
    [faceDetector setLenseColorAlpha: alpha];
}

- (void) setPupilPercent: (double) percent {
    [faceDetector setPupilPercent: percent];
}

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

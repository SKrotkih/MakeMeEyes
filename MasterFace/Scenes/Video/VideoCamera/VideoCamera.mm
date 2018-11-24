//
//  VideoCamera.m
//  MasterFace
//
//  Created by Сергей Кротких on 19/11/2018.
//  Copyright © 2018 Сергей Кротких. All rights reserved.
//

#import "VideoCamera.h"
#import "MasterFace-Swift.h"

#import <opencv2/objdetect/objdetect.hpp>
#import <opencv2/imgproc/imgproc_c.h>

///// opencv
#import <opencv2/opencv.hpp>
///// C++
#include <iostream>
///// user
#include "FaceARDetectIOS.h"
//

@interface VideoCamera ()
@end

@implementation VideoCamera

@synthesize delegate;

- (id) initWithParentView: (UIView*) _parentView delegate: (id<CvVideoCameraDelegate>) _delegate
{
    if (self = [super initWithParentView: _parentView])
    {
        self.delegate = _delegate;
        [self setupVideoCamera];
    }
    return self;
}

- (void) setupVideoCamera {
    self.defaultAVCaptureDevicePosition = AVCaptureDevicePositionFront;
    switch ([VideoCamera camWidth]) {
        case 288:
            self.defaultAVCaptureSessionPreset = AVCaptureSessionPreset352x288;
            break;
        case 480:
            self.defaultAVCaptureSessionPreset = AVCaptureSessionPreset640x480;
            break;
        case 720:
            self.defaultAVCaptureSessionPreset = AVCaptureSessionPreset1280x720;
            break;
        default:
            break;
    }
    self.defaultAVCaptureVideoOrientation = AVCaptureVideoOrientationPortrait;
    self.defaultFPS = [VideoCamera camFPS];
    self.grayscaleMode = NO;
    self.rotateVideo = NO;
    self.delegate = self.delegate;
}

- (void) startCamera
{
    [self start];
}

- (void) stopCamera
{
    [self stop];
}

- (int) imageWidth
{
    AVCaptureVideoDataOutput* output = [self.captureSession.outputs lastObject];
    NSDictionary* videoSettings = [output videoSettings];
    int videoWidth = [[videoSettings objectForKey: @"Width"] intValue];
    return videoWidth;
}

+ (int) camWidth
{
    return 288;  // 288 480 720
}

+ (int) camHeight
{
    return 352;  // 352 640 1280
}

+ (int) camFPS
{
    return 25;  // 30
}

+ (int) takeFrame
{
    return 2;
}

@end

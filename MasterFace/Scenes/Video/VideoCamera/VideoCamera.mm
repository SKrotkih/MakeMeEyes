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

- (id) initWithParentView: (UIView*) _parentView
                 delegate: (id<CvVideoCameraDelegate>) _delegate
{
    if (self = [super initWithParentView: _parentView])
    {
        self.delegate = _delegate;
        [self setupVideoCamera];
    }
    return self;
}

- (void) setupVideoCamera {
    //  Frontal camera
    self.defaultAVCaptureDevicePosition = AVCaptureDevicePositionFront;
    //  Portrait orientation
    self.defaultAVCaptureVideoOrientation = AVCaptureVideoOrientationPortrait;
    //  Concrete resolution
    switch ([self camWidth]) {
        case lowResolution:
            self.defaultAVCaptureSessionPreset = AVCaptureSessionPreset352x288;
            break;
        case middleResolution:
            self.defaultAVCaptureSessionPreset = AVCaptureSessionPreset640x480;
            break;
        case heighResolutopn:
            self.defaultAVCaptureSessionPreset = AVCaptureSessionPreset1280x720;
            break;
        default:
            break;
    }
    //  Concrete speed
    self.defaultFPS = [self camFPS];
    self.grayscaleMode = NO;
    self.rotateVideo = NO;
    self.delegate = self.delegate;
}

- (int) imageWidth
{
    AVCaptureVideoDataOutput* output = [self.captureSession.outputs lastObject];
    NSDictionary* videoSettings = [output videoSettings];
    int videoWidth = [[videoSettings objectForKey: @"Width"] intValue];
    return videoWidth;
}

- (int) camHeight
{
    switch ([self camWidth]) {
        case lowResolution:
            return 352;
        case middleResolution:
            return 640;
        case heighResolutopn:
            return 1280;
    }
}

// The following methods have to be inherited!
- (VideoResolution) camWidth
{
    NSAssert(false, @"This method should be implemented in a concrete class!");
    return lowResolution;
}

- (int) camFPS
{
    NSAssert(false, @"This method should be implemented in a concrete class!");
    return 25;
}

- (int) takeFrame
{
    NSAssert(false, @"This method should be implemented in a concrete class!");
    return 2;
}

@end

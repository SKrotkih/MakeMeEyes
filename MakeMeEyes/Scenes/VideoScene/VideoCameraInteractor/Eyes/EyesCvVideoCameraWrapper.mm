//
//  EyesCvVideoCameraWrapper.m
//  MakeMeEyes
//
//  Created by Sergey Krotkih on 10/11/2018.
//  Copyright © 2018 Sergey Krotkih. All rights reserved.
//

#import "EyesCvVideoCameraWrapper.h"
#import "EyesVideoCamera.h"
#import "MakeMeEyes-Swift.h"
#import "EyesDetectWrapper.h"
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

@interface EyesCvVideoCameraWrapper () <CvVideoCameraDelegate> {
}
@end

@implementation EyesCvVideoCameraWrapper
{
    EyesDrawingView* eyesDrawingView;
    EyesDetectWrapper* eyesDetector;
    CppUtils* utils;
    EyesVideoCamera* videoCamera;
    CGFloat scale;
    int frame_count;
}

- (id) initWithVideoParentView: (UIImageView*) _videoParentView
                   drawingView: (UIView*) _eyesDrawingView
{
    eyesDrawingView = (EyesDrawingView*)_eyesDrawingView;
    videoCamera = [[EyesVideoCamera alloc] initWithParentView: _videoParentView
                                                     delegate: self];
    eyesDetector = [[EyesDetectWrapper alloc] initWithCamera: videoCamera];
    utils = new CppUtils();
    scale = 0.0;

    return self;
}

#ifdef __cplusplus

// MARK: - CvVideoCameraDelegate protocol

- (void) processImage: (cv::Mat &) image
{
    frame_count = frame_count + 1;
    if (frame_count % [videoCamera takeFrame] != 0) {
        return;
    }
    
    [eyesDetector detectEyesOnCvImage: image
                           frameCount: frame_count];

    dispatch_async(dispatch_get_main_queue(), ^{
        UIImage* _image = self->utils->matToImage(image);
        self->eyesDrawingView.imageView.image = _image;
        self->scale = self->eyesDrawingView.frame.size.width / CGFloat([self->videoCamera imageWidth]);
    });

    [self didImageProcessed];
}

#endif

- (void) didImageProcessed {
    [eyesDrawingView drawEyes];
}

- (void) showBox {
    [eyesDetector showBox];
}

- (void) setNeedDrawEyes: (BOOL) newValue {
    [eyesDetector setNeedDrawEyes: newValue];
}

- (void) setLenseColorAlpha: (double) alpha {
    [eyesDetector setLenseColorAlpha: alpha];
}

- (void) setPupilPercent: (double) percent {
    [eyesDetector setPupilPercent: percent];
}

#pragma mark - UI Actions

- (void) startCamera
{
    [videoCamera start];
}

- (void) stopCamera
{
    [self->videoCamera stop];
    [self->videoCamera setParentView: nil];
    self->videoCamera = nil;
    self->eyesDetector = nil;
    dispatch_async(dispatch_get_main_queue(), ^{
        self->eyesDrawingView.imageView.image = nil;
    });
}

- (int) camWidth
{
    return [videoCamera camWidth];
}

- (int) camHeight
{
    return [videoCamera camHeight];
}

@end

//
//  EyesCvVideoCameraWrapper.m
//  MasterFace
//
//  Created by Сергей Кротких on 10/11/2018.
//  Copyright © 2018 Сергей Кротких. All rights reserved.
//

#import "EyesCvVideoCameraWrapper.h"
#import "EyesVideoCamera.h"
#import "MasterFace-Swift.h"
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
    VideoViewController* viewController;
    UIImageView* imageView;
    FaceView* faceView;
    EyesDetectWrapper* faceDetector;
    CppUtils* utils;
    EyesVideoCamera* videoCamera;
    CGFloat scale;
    int frame_count;
}

- (id) initWithController: (VideoViewController*) _viewController andImageView: (UIImageView*) _imageView foreground: (UIView*) _faceView
{
    viewController = _viewController;
    imageView = _imageView;
    faceView = (FaceView*)_faceView;
    videoCamera = [[EyesVideoCamera alloc] initWithParentView: imageView
                                                     delegate: self];
    faceDetector = [[EyesDetectWrapper alloc] initWithCamera: videoCamera];
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
    
    [faceDetector detectEyesOnCvImage: image
                          frameCount: frame_count];

    dispatch_async(dispatch_get_main_queue(), ^{
        UIImage* _image = self->utils->matToImage(image);
        self->faceView.imageView.image = _image;
        self->scale = self->faceView.frame.size.width / CGFloat([self->videoCamera imageWidth]);
    });

    [self didImageProcessed];
}

#endif

- (void) didImageProcessed {
    [viewController drawFaceWithScale: scale];
    [faceView drawFace];
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

- (int) camWidth
{
    return [videoCamera camWidth];
}

- (int) camHeight
{
    return [videoCamera camHeight];
}

@end

//
//  CvVideoCameraWrapper.m
//  MasterFace
//
//  Created by Сергей Кротких on 10/11/2018.
//  Copyright © 2018 Сергей Кротких. All rights reserved.
//

#import "CvVideoCameraWrapper.h"
#import "VideoCamera.h"
#import "MasterFace-Swift.h"
#import "FaceDetectWrapper.h"
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
    UIImageView* foregroundImageView;
    FaceDetectWrapper* faceDetector;
    CppUtils* utils;
    VideoCamera* videoCamera;
    double scale;
    int frame_count;
}

- (id) initWithController: (VideoViewController*) _viewController andImageView: (UIImageView*) _imageView foreground: (UIImageView*) _foregroundView
{
    viewController = _viewController;
    imageView = _imageView;
    foregroundImageView = _foregroundView;
    videoCamera = [[VideoCamera alloc] initWithParentView: imageView
                                                 delegate: self];
    faceDetector = [[FaceDetectWrapper alloc] init];
    utils = new CppUtils();
    scale = 0.0;
    return self;
}

#ifdef __cplusplus

// MARK: - CvVideoCameraDelegate protocol

- (void) processImage: (cv::Mat &) image
{
    frame_count = frame_count + 1;
    if (frame_count%[VideoCamera takeFrame] != 0) {
        return;
    }
    
    [faceDetector detectFacesOnImage: image
                          frameCount: frame_count];

    dispatch_async(dispatch_get_main_queue(), ^{
        UIImage* _image = self->utils->matToImage(image);
        self->foregroundImageView.image = _image;
        self->scale = self->foregroundImageView.frame.size.width / CGFloat([self->videoCamera imageWidth]);
    });

    [self didImageProcessed];
}

#endif

- (void) didImageProcessed {
    cv::Point leftPupil;
    cv::Point rightPupil;
    if ([faceDetector getPupilsCoordinate: leftPupil rightPupil: rightPupil]) {
        [self->viewController updatePupilsCoordinate: leftPupil.x * scale
                                              _leftY: leftPupil.y * scale
                                             _rightX: rightPupil.x * scale
                                             _rightY: rightPupil.y * scale];
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
    [videoCamera startCamera];
}

- (void) stopCamera
{
    [videoCamera stopCamera];
}

- (int) camWidth
{
    return [VideoCamera camWidth];
}

- (int) camHeight
{
    return [VideoCamera camHeight];
}


@end

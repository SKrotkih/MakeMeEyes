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
    FaceDetectWrapper* faceDetector;
    CppUtils* utils;
    VideoCamera* videoCamera;
    int frame_count;
}

@synthesize foregroundImageView;

- (id) initWithController: (VideoViewController*) _viewController andImageView: (UIImageView*) _imageView
{
    viewController = _viewController;
    imageView = _imageView;
    videoCamera = [[VideoCamera alloc] initWithParentView: imageView
                                                 delegate: self];
    faceDetector = [[FaceDetectWrapper alloc] init];
    utils = new CppUtils();
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
        UIImage* image_ = self->utils->matToImage(image);
        self.foregroundImageView.image = image_;
    });

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

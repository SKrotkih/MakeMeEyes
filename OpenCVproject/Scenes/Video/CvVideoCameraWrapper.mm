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
    FaceARDetectIOS* facear;
    int frame_count;
}

- (id) initWithController: (VideoViewController*) _viewController andImageView: (UIImageView*) _imageView
{
    viewController = _viewController;
    imageView = _imageView;
    
    facear =[[FaceARDetectIOS alloc] init];
    
    // Assuming camera input is 640x480 (set using AVCaptureSessionPreset)
    // float cam_width = 288; float cam_height = 352;
    //float cam_width = 480; float cam_height = 640;
    //float cam_width = 720; float cam_height = 1280;

    videoCamera = [[CvVideoCamera alloc] initWithParentView: imageView];
    videoCamera.defaultAVCaptureDevicePosition = AVCaptureDevicePositionFront;
    videoCamera.defaultAVCaptureSessionPreset = AVCaptureSessionPreset640x480;
    videoCamera.defaultAVCaptureVideoOrientation = AVCaptureVideoOrientationPortrait;
    videoCamera.defaultFPS = 30;
    videoCamera.grayscaleMode = NO;
    videoCamera.rotateVideo = NO;
    videoCamera.delegate = self;
    
    return self;
}

#ifdef __cplusplus

// MARK: - CvVideoCameraDelegate protocol

- (void) processImage: (cv::Mat &) image
{
    cv::Mat targetImage(image.cols,image.rows,CV_8UC3);
    cv::cvtColor(image, targetImage, cv::COLOR_BGRA2BGR);
    if(targetImage.empty()){
        std::cout << "targetImage empty" << std::endl;
    }
    else
    {
        float fx, fy, cx, cy;
        cx = 1.0*targetImage.cols / 2.0;
        cy = 1.0*targetImage.rows / 2.0;
        
        fx = 500 * (targetImage.cols / 640.0);
        fy = 500 * (targetImage.rows / 480.0);
        
        fx = (fx + fy) / 2.0;
        fy = fx;
        
        [facear run_FaceAR: targetImage frame__:frame_count fx__:fx fy__:fy cx__:cx cy__:cy];
        frame_count = frame_count + 1;
    }
    cv::cvtColor(targetImage, image, cv::COLOR_BGRA2RGB);
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

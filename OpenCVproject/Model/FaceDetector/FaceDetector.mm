//
//  FaceDetector.m
//  OpenCVproject
//
//  Created by Сергей Кротких on 10/11/2018.
//  Copyright © 2018 Сергей Кротких. All rights reserved.
//

#import "FaceDetector.hpp"
#import "CppUtils.hpp"
#include <iostream>
#import <opencv2/videoio/cap_ios.h>
#import <opencv2/objdetect/objdetect.hpp>
#import <opencv2/imgproc/imgproc_c.h>

NSString* const faceCascadeFilename = @"haarcascade_frontalface_alt2";
const int HaarOptions = CV_HAAR_FIND_BIGGEST_OBJECT | CV_HAAR_DO_ROUGH_SEARCH;

void FaceDetector::configure(UIImageView* imageView) {

    videoCamera = [[CvVideoCamera alloc] initWithParentView:imageView];
    videoCamera.defaultAVCaptureDevicePosition = AVCaptureDevicePositionFront;
    videoCamera.defaultAVCaptureSessionPreset = AVCaptureSessionPreset352x288;
    videoCamera.defaultAVCaptureVideoOrientation = AVCaptureVideoOrientationPortrait;
    videoCamera.defaultFPS = 30;
    videoCamera.grayscaleMode = NO;
    videoCamera.delegate = this;
    
    NSString* faceCascadePath = [[NSBundle mainBundle] pathForResource:faceCascadeFilename ofType:@"xml"];
    faceCascade.load([faceCascadePath UTF8String]);
    
}

#pragma mark - Protocol CvVideoCameraDelegate

void FaceDetector::processImage(cv::Mat& image)
{
    cv::Mat grayscaleFrame;
    cvtColor(image, grayscaleFrame, CV_BGR2GRAY);
    cv::equalizeHist(grayscaleFrame, grayscaleFrame);
    
    std::vector<cv::Rect> faces;
    faceCascade.detectMultiScale(grayscaleFrame, faces, 1.1, 2, HaarOptions, cv::Size(60, 60));
    
    for (int i = 0; i < faces.size(); i++)
    {
        cv::Point pt1(faces[i].x + faces[i].width, faces[i].y + faces[i].height);
        cv::Point pt2(faces[i].x, faces[i].y);
        
        cv::rectangle(image, pt1, pt2, cvScalar(0, 255, 0, 0), 1, 8 ,0);
    }
}

void FaceDetector::startCamera() {
    videoCamera.start();
}

void FaceDetector::stopCamera() {
    videoCamera.stop();
}

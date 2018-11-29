//
//  FaceCvVideoCameraWrapper.m
//  MasterFace
//
//  Created by Сергей Кротких on 10/11/2018.
//  Copyright © 2018 Сергей Кротких. All rights reserved.
//

#import "FaceCvVideoCameraWrapper.h"
#import "FaceVideoCamera.h"
#import "MasterFace-Swift.h"
#import "CppUtils.hpp"
#import "FaceCoords.h"

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

#define Storage FaceCoords::getInstance()

using namespace cv;

@interface FaceCvVideoCameraWrapper () <CvVideoCameraDelegate> {
}
@end

@implementation FaceCvVideoCameraWrapper
{
    VideoViewController* viewController;
    UIImageView* imageView;
    FaceView* faceView;
    CppUtils* utils;
    FaceVideoCamera* videoCamera;
    CGFloat scale;
    int frame_count;
}

- (id) initWithController: (VideoViewController*) _viewController andImageView: (UIImageView*) _imageView foreground: (UIView*) _faceView
{
    viewController = _viewController;
    imageView = _imageView;
    faceView = (FaceView*)_faceView;
    videoCamera = [[FaceVideoCamera alloc] initWithParentView: imageView
                                                     delegate: self];
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
    
    std::vector<cv::Rect> faces = detectFace(image);
    Storage->saveFace(faces);
    
    dispatch_async(dispatch_get_main_queue(), ^{
        UIImage* _image = self->utils->matToImage(image);
        self->faceView.imageView.image = _image;
        self->scale = self->faceView.frame.size.width / CGFloat([self->videoCamera imageWidth]);
    });
    
    [viewController drawFaceWithScale: scale];
}

std::vector<cv::Rect> detectFace(cv::Mat &frame)
{
    const int HaarOptions = CV_HAAR_FIND_BIGGEST_OBJECT | CV_HAAR_DO_ROUGH_SEARCH;
    
    cv::Mat grayscale;
    cv::cvtColor(frame, grayscale, CV_BGR2GRAY);    // convert image to grayscale
    cv::equalizeHist(grayscale, grayscale);         // enhance image contrast
    std::vector<cv::Rect> faces;
    
    // Face detector
    
    //    Where the parameters are:
    //
    //    1. image : Matrix of the type CV_8U containing an image where objects are detected.
    //    2. scaleFactor : Parameter specifying how much the image size is reduced at each image scale.
    //    ImageScale.png
    //    Picture source: Viola-Jones Face Detection
    //    This scale factor is used to create scale pyramid as shown in the picture. Suppose, the scale factor is 1.03, it means we're using a small step for resizing, i.e. reduce size by 3 %, we increase the chance of a matching size with the model for detection is found, while it's expensive.
    //    3. minNeighbors : Parameter specifying how many neighbors each candidate rectangle should have to retain it. This parameter will affect the quality of the detected faces: higher value results in less detections but with higher quality. We're using 5 in the code.
    //    4. flags : Parameter with the same meaning for an old cascade as in the function cvHaarDetectObjects. It is not used for a new cascade.
    //        5. minSize : Minimum possible object size. Objects smaller than that are ignored.
    //        6. maxSize : Maximum possible object size. Objects larger than that are ignored.
    // 1.1 2
    // 1.3 5
    // haarcascade_frontalface_default
    getFaceCascade()->detectMultiScale(grayscale, faces, 1.3, 5, HaarOptions, cv::Size(60, 60));

    return faces;
}

static cv::CascadeClassifier* faceCascade;

cv::CascadeClassifier* getFaceCascade() {
    if (faceCascade == nil) {
        faceCascade = getCascade(@"/classifiers/haarcascade_frontalface_default"); // @"haarcascade_frontalface_alt"
    }
    return faceCascade;
}

cv::CascadeClassifier* getCascade(NSString* model) {
    NSBundle* appBundle = [NSBundle mainBundle];
    NSString* cascadePathInBundle = [appBundle pathForResource: model ofType: @"xml"];
    std::string cascadePath([cascadePathInBundle UTF8String]);
    cv::CascadeClassifier* cascade = new cv::CascadeClassifier();
    if (!cascade->load(cascadePath)) {
        printf("Load error");
        return nil;
    }
    return cascade;
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

- (int) camWidth
{
    return [videoCamera camWidth];
}

- (int) camHeight
{
    return [videoCamera camHeight];
}

@end

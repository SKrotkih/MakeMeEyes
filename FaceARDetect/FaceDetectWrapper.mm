//
//  CvVideoCameraWrapper.m
//  MasterFace
//

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

@interface FaceDetectWrapper () {
}
@end

@implementation FaceDetectWrapper
{
    FaceARDetectIOS* facear;
    int frame_count;
}

- (id) init
{
    facear = [[FaceARDetectIOS alloc] init];
    [self setUpEyeLenseImage];
    
    return self;
}

#ifdef __cplusplus

- (void) detectFacesOnUIImage: (UIImage*) image
{
    CppUtils* utils = new CppUtils;
    cv::Mat frame;
    utils->imageToMat(image, frame);
    [self detectFacesOnImage: frame];
}

- (void) detectFacesOnImage: (cv::Mat &) image
{
    cv::Mat targetImage(image.cols, image.rows, CV_8UC3);
    cv::cvtColor(image, targetImage, cv::COLOR_BGRA2BGR);
    if(targetImage.empty()) {
        std::cout << "targetImage empty" << std::endl;
    }
    else
    {
        float fx, fy, cx, cy;
        cx = 1.0 * targetImage.cols / 2.0;
        cy = 1.0 * targetImage.rows / 2.0;
        
        fx = 500 * (targetImage.cols / 640.0);
        fy = 500 * (targetImage.rows / 480.0);
        
        fx = (fx + fy) / 2.0;
        fy = fx;
        
        [facear run_FaceAR: targetImage
                   frame__: frame_count
                      fx__: fx
                      fy__: fy
                      cx__: cx
                      cy__: cy];
        frame_count = frame_count + 1;
    }
    cv::cvtColor(targetImage, image, cv::COLOR_BGRA2RGB);
}

#endif

- (void) showBox {
    [facear showBox];
}

- (bool) getPupilsCoordinate: (cv::Point&) _leftPupil rightPupil: (cv::Point&) _rightPupil {
    std::vector<cv::Point> pupils = facear.eyePupils;
    if (pupils.size() == 2) {
        _leftPupil = pupils[0];
        _rightPupil = pupils[1];
        return true;
    }
    return false;
}

- (void) setNeedDrawEyes: (BOOL) newValue {
    [facear setNeedShowEyes: newValue];
}

- (void) setUpEyeLenseImage {
    NSString *imagePath = [[NSBundle mainBundle] pathForResource: @"lense_white" ofType: @"png"];
    UIImage *image = [UIImage imageWithContentsOfFile: imagePath];
    cv::Mat frame;
    CppUtils* utils = new CppUtils;
    utils->imageToMat(image, frame);
    [facear setEyeLenseImage: frame];
}

@end

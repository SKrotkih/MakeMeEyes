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

- (BOOL) detectFacesOnImage: (cv::Mat &) image
{
    frame_count = frame_count + 1;
    if (frame_count%2 != 0) {
        return false;
    }
    double rowsScreen = 352.0;  // S.K. 352.0   640.0
    double colsScreen = 288.0;  //      288.0   480.0
    
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
        
        fx = 500 * (targetImage.cols / rowsScreen);
        fy = 500 * (targetImage.rows / colsScreen);
        
        fx = (fx + fy) / 2.0;
        fy = fx;
        
        [facear run_FaceAR: targetImage
                   frame__: frame_count
                      fx__: fx
                      fy__: fy
                      cx__: cx
                      cy__: cy];
    }
    cv::cvtColor(targetImage, image, cv::COLOR_BGRA2RGB);
    return true;
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

- (void) setLenseColorAlpha: (double) alpha {
    [facear setLenseColorAlpha: alpha];
}

- (void) setPupilPercent: (double) percent {
    [facear setPupilPercent: percent];
}

@end

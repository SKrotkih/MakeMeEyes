//
//  CvVideoCameraWrapper.m
//  MasterFace
//

#import "FaceDetectWrapper2.h"
#import "FaceDetectWrapper.h"
#import "MasterFace-Swift.h"
#import "CppUtils.hpp"

@implementation FaceDetectWrapper2
{
    FaceDetectWrapper* faceDetector;
}

- (id) init {
    faceDetector = [[FaceDetectWrapper alloc] init];
    return self;
}

- (void) detectFacesOnUIImage: (UIImage*) image
{
    CppUtils* utils = new CppUtils;
    cv::Mat frame;
    utils->imageToMat(image, frame);
    [faceDetector detectFacesOnImage: frame frameCount: 0];
}

@end

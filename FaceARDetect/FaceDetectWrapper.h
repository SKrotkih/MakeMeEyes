//
//  FaceDetectWrapper.h
//  OpenCVproject
//

#import <UIKit/UIKit.h>

@interface FaceDetectWrapper: NSObject

- (void) detectFacesOnImage: (cv::Mat &) image;
- (void) detectFacesOnUIImage: (UIImage*) image;
- (void) showBox;
- (bool) getPupilsCoordinate: (cv::Point&) _leftPupil rightPupil: (cv::Point&) _rightPupil;

@end

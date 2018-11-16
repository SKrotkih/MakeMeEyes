//
//  FaceDetectWrapper.h
//  MasterFace
//

#import <UIKit/UIKit.h>

@interface FaceDetectWrapper: NSObject

- (void) detectFacesOnImage: (cv::Mat &) image;
- (void) detectFacesOnUIImage: (UIImage*) image;
- (void) showBox;
- (void) setNeedDrawEyes: (BOOL) newValue;
- (bool) getPupilsCoordinate: (cv::Point&) _leftPupil rightPupil: (cv::Point&) _rightPupil;
- (void) setLenseTransparent: (double) alpha;

@end

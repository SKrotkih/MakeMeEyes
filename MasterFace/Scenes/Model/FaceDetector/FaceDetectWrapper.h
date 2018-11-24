//
//  FaceDetectWrapper.h
//  MasterFace
//

#import <UIKit/UIKit.h>
#import "FaceCoords.h"

@interface FaceDetectWrapper: NSObject

- (void) detectFacesOnImage: (cv::Mat&) image frameCount: (int) frameCount;
- (void) detectFacesOnUIImage: (UIImage*) image;
- (void) showBox;
- (void) setNeedDrawEyes: (BOOL) newValue;
- (void) setLenseColorAlpha: (double) alpha;
- (void) setPupilPercent: (double) percent;

@end

//
//  EyesDetectWrapper.h
//  MasterFace
//

#import <UIKit/UIKit.h>
#import "FaceCoords.h"

@class EyesVideoCamera;

@interface EyesDetectWrapper: NSObject

- (id) initWithCamera: (EyesVideoCamera*) _videoCamera;

- (void) detectEyesOnCvImage: (cv::Mat&) image frameCount: (int) frameCount;
- (void) detectEyesOnImage: (UIImage*) image;
- (void) showBox;
- (void) setNeedDrawEyes: (BOOL) newValue;
- (void) setLenseColorAlpha: (double) alpha;
- (void) setPupilPercent: (double) percent;

@end

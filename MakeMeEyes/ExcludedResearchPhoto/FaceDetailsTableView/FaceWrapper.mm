//
//  FaceWrapper.mm
//  MakeMeEyes
//

#import "FaceWrapper.h"
#import "EyesDetectWrapper.h"
#import "MakeMeEyes-Swift.h"

@implementation FaceWrapper
{
    EyesDetectWrapper* eyesDetector;
}

- (id) init {
    eyesDetector = [[EyesDetectWrapper alloc] init];
    return self;
}

- (void) detectEyesOnImage: (UIImage*) image
{
    [eyesDetector detectEyesOnImage: image];
}

@end

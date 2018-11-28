//
//  FaceWrapper.m
//  MasterFace
//

#import "FaceWrapper.h"
#import "EyesDetectWrapper.h"
#import "MasterFace-Swift.h"

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

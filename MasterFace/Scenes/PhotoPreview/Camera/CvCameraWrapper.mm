//
//  CvCameraWrapper.mm
//  MasterFace
//
//  Created by Сергей Кротких on 10/11/2018.
//  Copyright © 2018 Сергей Кротких. All rights reserved.
//

#import "CvCameraWrapper.h"
#import "MasterFace-Swift.h"
#import "EyesDetectWrapper.h"

@interface CvCameraWrapper () {
}
@end

@implementation CvCameraWrapper
{
    FaceView* faceView;
    EyesDetectWrapper* eyesDetector;
}

- (id) initWithFaceView: (FaceView*) _faceView
{
    faceView = _faceView;
    eyesDetector = [[EyesDetectWrapper alloc] initWithCamera: nil];
    return self;
}

#ifdef __cplusplus

- (void) processImage: (UIImage*) image
{
    [eyesDetector detectEyesOnImage: image];
    [faceView drawFace];
}

#endif

@end

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
    EyesDrawingView* faceView;
    EyesDetectWrapper* eyesDetector;
}

- (id) initWithEyesDrawingView: (EyesDrawingView*) _faceView
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

//
//  CvCameraWrapper.mm
//  MasterFace
//
//  Created by Сергей Кротких on 10/11/2018.
//  Copyright © 2018 Сергей Кротких. All rights reserved.
//

#import "CvCameraWrapper.h"
#import "MasterFace-Swift.h"
#import "FaceDetectWrapper.h"

@interface CvCameraWrapper () {
}
@end

@implementation CvCameraWrapper
{
    FaceView* faceView;
    FaceDetectWrapper* faceDetector;
}

- (id) initWithFaceView: (FaceView*) _faceView
{
    faceView = _faceView;
    faceDetector = [[FaceDetectWrapper alloc] init];
    return self;
}

#ifdef __cplusplus

- (void) processImage: (UIImage*) image
{
    [faceDetector detectFacesOnUIImage: image];
    [faceView drawFace];
}

#endif

@end

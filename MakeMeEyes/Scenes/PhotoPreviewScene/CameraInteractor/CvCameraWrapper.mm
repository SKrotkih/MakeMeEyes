//
//  CvCameraWrapper.mm
//  MakeMeEyes
//
//  Created by Sergey Krotkih on 10/11/2018.
//  Copyright © 2018 Sergey Krotkih. All rights reserved.
//

#import "CvCameraWrapper.h"
#import "MakeMeEyes-Swift.h"
#import "EyesDetectWrapper.h"

@interface CvCameraWrapper () {
}
@end

@implementation CvCameraWrapper
{
    EyesDrawingView* drawingView;
    EyesDetectWrapper* eyesDetector;
}

- (id) initWithEyesDrawingView: (EyesDrawingView*) _drawingView
{
    drawingView = _drawingView;
    eyesDetector = [[EyesDetectWrapper alloc] initWithCamera: nil];

    return self;
}

#ifdef __cplusplus

- (void) processImage: (UIImage*) image
{
    [eyesDetector detectEyesOnImage: image];
    [drawingView drawEyes];
}

#endif

@end

//
//  CvCameraWrapper.h
//  MasterFace
//
//  Created by Сергей Кротких on 10/11/2018.
//  Copyright © 2018 Сергей Кротких. All rights reserved.
//

#import <UIKit/UIKit.h>

@class EyesDrawingView;

@interface CvCameraWrapper: NSObject

- (id) initWithEyesDrawingView: (EyesDrawingView*) _faceView;
- (void) processImage: (UIImage*) image;

@end

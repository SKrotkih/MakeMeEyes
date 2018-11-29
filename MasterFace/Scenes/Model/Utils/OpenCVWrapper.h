//
//  OpenCVWrapper.h
//  MasterFace
//
//  Created by Сергей Кротких on 05/11/2018.
//  Copyright © 2018 Сергей Кротких. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface OpenCVWrapper : NSObject

+ (NSString*) openCVVersionString;
+ (UIImage*) toGray: (UIImage*) source;
+ (UIImage*) callCPP: (UIImage*) image;
+ (UIImage*) detectEyeIris: (UIImage*) image;

+ (NSArray*) face;

+ (NSArray*) leftEyeBorder;
+ (NSArray*) rightEyeBorder;
+ (NSArray*) leftIrisBorder;
+ (NSArray*) rightIrisBorder;
+ (NSArray*) leftPupilBorder;
+ (NSArray*) rightPupilBorder;

+ (int) frameWidth;
+ (int) frameHeight;

+ (void) didDrawFinish;

+ (NSString*) irisImageName;
+ (BOOL) needEyesDrawing;
+ (void) setIrisImageName: (NSString*) _newValue;
+ (void) setNeedEyesDrawing: (BOOL) _newValue;

@end

NS_ASSUME_NONNULL_END

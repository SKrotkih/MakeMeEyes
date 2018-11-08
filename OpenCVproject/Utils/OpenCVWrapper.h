//
//  OpenCVWrapper.h
//  OpenCVproject
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

@end

NS_ASSUME_NONNULL_END

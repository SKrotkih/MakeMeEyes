//
//  CvVideoCameraWrapper.h
//  OpenCVproject
//
//  Created by Сергей Кротких on 10/11/2018.
//  Copyright © 2018 Сергей Кротких. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EyeIrisDetector.hpp"


@class VideoViewController;

@interface CvVideoCameraWrapper: NSObject

- (id) initWithController: (VideoViewController*) viewController andImageView: (UIImageView*) imageView;
- (void) startCamera;
- (void) stopCamera;

@end

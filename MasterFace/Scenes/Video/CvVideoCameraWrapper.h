//
//  CvVideoCameraWrapper.h
//  MasterFace
//
//  Created by Сергей Кротких on 10/11/2018.
//  Copyright © 2018 Сергей Кротких. All rights reserved.
//

#import <UIKit/UIKit.h>

@class VideoViewController;

@interface CvVideoCameraWrapper: NSObject

- (id) initWithController: (VideoViewController*) _viewController andImageView: (UIImageView*) _imageView;
- (void) showBox;
- (void) setNeedDrawEyes: (BOOL) newValue;
- (void) startCamera;
- (void) stopCamera;

@end

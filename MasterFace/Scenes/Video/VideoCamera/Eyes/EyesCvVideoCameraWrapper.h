//
//  EyesCvVideoCameraWrapper.h
//  MasterFace
//
//  Created by Сергей Кротких on 10/11/2018.
//  Copyright © 2018 Сергей Кротких. All rights reserved.
//

#import <UIKit/UIKit.h>

@class VideoViewController;

@interface EyesCvVideoCameraWrapper: NSObject

- (id) initWithController: (VideoViewController*) _viewController andImageView: (UIImageView*) _imageView foreground: (UIView*) _foregroundView;
- (void) showBox;
- (void) setNeedDrawEyes: (BOOL) newValue;
- (void) setLenseColorAlpha: (double) alpha;
- (void) setPupilPercent: (double) percent;
- (void) startCamera;
- (void) stopCamera;
- (int) camWidth;
- (int) camHeight;

@end

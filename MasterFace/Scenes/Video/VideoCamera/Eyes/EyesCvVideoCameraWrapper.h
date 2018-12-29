//
//  EyesCvVideoCameraWrapper.h
//  MasterFace
//
//  Created by Сергей Кротких on 10/11/2018.
//  Copyright © 2018 Сергей Кротких. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VideoCameraProtocol.h"

@class VideoViewController;

@interface EyesCvVideoCameraWrapper : NSObject <VideoCameraProtocol>

- (id) initWithVideoParentView: (UIImageView*) _videoParentView
                   drawingView: (UIView*) _eyesDrawingView;
- (void) showBox;
- (void) setNeedDrawEyes: (BOOL) newValue;
- (void) setLenseColorAlpha: (double) alpha;
- (void) setPupilPercent: (double) percent;

@end

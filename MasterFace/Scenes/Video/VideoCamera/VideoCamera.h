//
//  VideoCamera.h
//  MasterFace
//
//  Created by Сергей Кротких on 19/11/2018.
//  Copyright © 2018 Сергей Кротких. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <opencv2/videoio/cap_ios.h>

NS_ASSUME_NONNULL_BEGIN

typedef enum : NSUInteger {
    lowResolution = 288,
    middleResolution = 480,
    heighResolutopn = 720,
} VideoResolution;

@interface VideoCamera : CvVideoCamera

- (VideoResolution) camWidth;
- (int) camHeight;
- (int) camFPS;
- (int) takeFrame;

- (id) initWithParentView: (UIView*) _parentView delegate: (id<CvVideoCameraDelegate>) _delegate;

- (int) imageWidth;

@property (nonatomic, weak) id<CvVideoCameraDelegate> delegate;

@end

NS_ASSUME_NONNULL_END

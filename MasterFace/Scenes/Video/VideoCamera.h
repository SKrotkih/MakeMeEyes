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

@interface VideoCamera : CvVideoCamera

+ (int) camWidth;
+ (int) camHeight;

- (id) initWithParentView: (UIView*) _parentView delegate: (id<CvVideoCameraDelegate>) _delegate;
- (void) startCamera;
- (void) stopCamera;
- (int) imageWidth;
+ (int) takeFrame;

@property (nonatomic, weak) id<CvVideoCameraDelegate> delegate;

@end

NS_ASSUME_NONNULL_END

//
//  FaceCvVideoCameraWrapper.h
//  MakeMeEyes
//
//  Created by Sergey Krotkih on 10/11/2018.
//  Copyright © 2018 Sergey Krotkih. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VideoCameraProtocol.h"

@class SceneInteractor;

@interface FaceCvVideoCameraWrapper : NSObject <VideoCameraProtocol>

- (id) initWithVideoParentView: (UIImageView*) _videoParentView
                   drawingView: (UIView*) _eyesDrawingView
               sceneInteractor: (SceneInteractor*) _sceneInteractor;

@end

//
//  FaceCvVideoCameraWrapper.h
//  MasterFace
//
//  Created by Сергей Кротких on 10/11/2018.
//  Copyright © 2018 Сергей Кротких. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SceneInteractor;

@interface FaceCvVideoCameraWrapper: NSObject

- (id) initWithVideoParentView: (UIImageView*) _videoParentView
                   drawingView: (UIView*) _eyesDrawingView
               sceneInteractor: (SceneInteractor*) _sceneInteractor;
- (void) startCamera;
- (void) stopCamera;
- (int) camWidth;
- (int) camHeight;

@end

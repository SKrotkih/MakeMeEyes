//
//  FaceVideoCamera.m
//  MakeMeEyes
//
//  Created by Sergey Krotkih on 19/11/2018.
//  Copyright © 2018 Sergey Krotkih. All rights reserved.
//

#import "FaceVideoCamera.h"

@interface FaceVideoCamera ()
@end

@implementation FaceVideoCamera

- (VideoResolution) camWidth
{
    return middleResolution;
}

- (int) camFPS
{
    return 30;  // 30
}

- (int) takeFrame
{
    return 0;
}

@end

//
//  EyesVideoCamera.m
//  MakeMeEyes
//
//  Created by Sergey Krotkih on 19/11/2018.
//  Copyright © 2018 Sergey Krotkih. All rights reserved.
//

#import "EyesVideoCamera.h"

@interface EyesVideoCamera ()
@end

@implementation EyesVideoCamera

- (VideoResolution) camWidth
{
    return lowResolution;  // 288 480 720
}

- (int) camFPS
{
    return 25;  // 30
}

- (int) takeFrame
{
    return 2;
}

@end

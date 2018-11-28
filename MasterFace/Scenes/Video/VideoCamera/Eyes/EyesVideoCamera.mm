//
//  EyesVideoCamera.m
//  MasterFace
//
//  Created by Сергей Кротких on 19/11/2018.
//  Copyright © 2018 Сергей Кротких. All rights reserved.
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

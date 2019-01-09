//
//  FaceVideoCamera.m
//  MasterFace
//
//  Created by Сергей Кротких on 19/11/2018.
//  Copyright © 2018 Сергей Кротких. All rights reserved.
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

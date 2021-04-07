//
//  VideoCameraProtocol.h
//  MakeMeEyes
//
//  Created by Sergey Krotkih on 28/12/2018.
//  Copyright © 2018 Sergey Krotkih. All rights reserved.
//

#ifndef VideoCameraProtocol_h
#define VideoCameraProtocol_h

@protocol VideoCameraProtocol <NSObject>

- (void) startCamera;
- (void) stopCamera;
- (int) camWidth;
- (int) camHeight;

@end

#endif /* VideoCameraProtocol_h */

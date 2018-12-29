//
//  VideoCameraProtocol.h
//  MasterFace
//
//  Created by Сергей Кротких on 28/12/2018.
//  Copyright © 2018 Сергей Кротких. All rights reserved.
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

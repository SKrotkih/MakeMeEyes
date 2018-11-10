//
//  FaceDetector.h
//  OpenCVproject
//
//  Created by Сергей Кротких on 10/11/2018.
//  Copyright © 2018 Сергей Кротких. All rights reserved.
//

#import <UIKit/UIKit.h>

#ifdef __cplusplus

class FaceDetector: cv::CvVideoCameraDelegate {
public:
    void configure(UIImageView* imageView);
    void startCamera();
    void stopCamera();
private:
    //CvVideoCamera* videoCamera;
    cv::CascadeClassifier faceCascade;
    void processImage(cv::Mat& image);
};

#endif

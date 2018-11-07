//
//  Utils.h
//  OpenCVproject
//

#import <UIKit/UIKit.h>

#ifdef __cplusplus

class CppUtils {
public:
    UIImage* makeGray(UIImage* image);
    UIImage* matToImage(const cv::Mat& image);
    void imageToMat(const UIImage* image, cv::Mat& m, bool alphaExist = false);
};

#endif

//
//  Utils.h
//  OpenCVproject
//

#import <UIKit/UIKit.h>

#ifdef __cplusplus

class CppUtils {
public:
    UIImage* makeGray(UIImage* image);
    UIImage* MatToUIImage(const cv::Mat& image);
    void UIImageToMat(const UIImage* image, cv::Mat& m, bool alphaExist = false);
};

#endif

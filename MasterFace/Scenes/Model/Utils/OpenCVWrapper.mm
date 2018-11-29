//
//  OpenCVWrapper.m
//  MasterFace
//
//  Created by Сергей Кротких on 05/11/2018.
//  Copyright © 2018 Сергей Кротких. All rights reserved.
//

#ifdef __cplusplus
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdocumentation"

#import "OpenCVWrapper.h"
#import "CppUtils.hpp"
#import "EyeIrisDetector.hpp"
#import "FaceCoords.h"
#import "SceneConf.h"

#pragma clang pop
#endif

using namespace std;
using namespace cv;

#pragma mark - OpenCVWrapper

#define Coords FaceCoords::getInstance()
#define Config SceneConf::getInstance()

@implementation OpenCVWrapper

#pragma mark Public

+ (UIImage *)toGray:(UIImage *)source {
    cout << "OpenCV: ";
    return [OpenCVWrapper _imageFrom:[OpenCVWrapper _grayFrom:[OpenCVWrapper _matFrom:source]]];
}

#pragma mark Private

+ (Mat)_grayFrom:(Mat)source {
    cout << "-> grayFrom ->";
    
    Mat result;
    cvtColor(source, result, CV_BGR2GRAY);
    
    return result;
}

+ (Mat)_matFrom:(UIImage *)source {
    cout << "matFrom ->";
    
    CGImageRef image = CGImageCreateCopy(source.CGImage);
    CGFloat cols = CGImageGetWidth(image);
    CGFloat rows = CGImageGetHeight(image);
    Mat result(rows, cols, CV_8UC4);
    
    CGBitmapInfo bitmapFlags = kCGImageAlphaNoneSkipLast | kCGBitmapByteOrderDefault;
    size_t bitsPerComponent = 8;
    size_t bytesPerRow = result.step[0];
    CGColorSpaceRef colorSpace = CGImageGetColorSpace(image);
    
    CGContextRef context = CGBitmapContextCreate(result.data, cols, rows, bitsPerComponent, bytesPerRow, colorSpace, bitmapFlags);
    CGContextDrawImage(context, CGRectMake(0.0f, 0.0f, cols, rows), image);
    CGContextRelease(context);
    
    return result;
}

+ (UIImage *)_imageFrom:(Mat)source {
    cout << "-> imageFrom\n";
    
    NSData *data = [NSData dataWithBytes:source.data length:source.elemSize() * source.total()];
    CGDataProviderRef provider = CGDataProviderCreateWithCFData((__bridge CFDataRef)data);
    
    CGBitmapInfo bitmapFlags = kCGImageAlphaNone | kCGBitmapByteOrderDefault;
    size_t bitsPerComponent = 8;
    size_t bytesPerRow = source.step[0];
    CGColorSpaceRef colorSpace = (source.elemSize() == 1 ? CGColorSpaceCreateDeviceGray() : CGColorSpaceCreateDeviceRGB());
    
    CGImageRef image = CGImageCreate(source.cols, source.rows, bitsPerComponent, bitsPerComponent * source.elemSize(), bytesPerRow, colorSpace, bitmapFlags, provider, NULL, false, kCGRenderingIntentDefault);
    UIImage *result = [UIImage imageWithCGImage:image];
    
    CGImageRelease(image);
    CGDataProviderRelease(provider);
    CGColorSpaceRelease(colorSpace);
    
    return result;
}

+ (NSString *)openCVVersionString {
    return [NSString stringWithFormat:@"OpenCV Version %s",  CV_VERSION];
}

// https://docs.opencv.org/2.4/doc/tutorials/ios/image_manipulation/image_manipulation.html
// In OpenCV all the image processing operations are usually carried out on the Mat structure. In iOS however, to render an image on screen it have to be an instance of the UIImage class. To convert an OpenCV Mat to an UIImage we use the Core Graphics framework available in iOS. Below is the code needed to covert back and forth between Mat’s and UIImage’s.

+ (cv::Mat)cvMatFromUIImage:(UIImage *)image
{
    CGColorSpaceRef colorSpace = CGImageGetColorSpace(image.CGImage);
    CGFloat cols = image.size.width;
    CGFloat rows = image.size.height;
    
    cv::Mat cvMat(rows, cols, CV_8UC4); // 8 bits per component, 4 channels (color channels + alpha)
    
    CGContextRef contextRef = CGBitmapContextCreate(cvMat.data,                 // Pointer to  data
                                                    cols,                       // Width of bitmap
                                                    rows,                       // Height of bitmap
                                                    8,                          // Bits per component
                                                    cvMat.step[0],              // Bytes per row
                                                    colorSpace,                 // Colorspace
                                                    kCGImageAlphaNoneSkipLast |
                                                    kCGBitmapByteOrderDefault); // Bitmap info flags
    
    CGContextDrawImage(contextRef, CGRectMake(0, 0, cols, rows), image.CGImage);
    CGContextRelease(contextRef);
    
    return cvMat;
}


+ (cv::Mat)cvMatGrayFromUIImage:(UIImage *)image
{
    CGColorSpaceRef colorSpace = CGImageGetColorSpace(image.CGImage);
    CGFloat cols = image.size.width;
    CGFloat rows = image.size.height;
    
    cv::Mat cvMat(rows, cols, CV_8UC1); // 8 bits per component, 1 channels
    
    CGContextRef contextRef = CGBitmapContextCreate(cvMat.data,                 // Pointer to data
                                                    cols,                       // Width of bitmap
                                                    rows,                       // Height of bitmap
                                                    8,                          // Bits per component
                                                    cvMat.step[0],              // Bytes per row
                                                    colorSpace,                 // Colorspace
                                                    kCGImageAlphaNoneSkipLast |
                                                    kCGBitmapByteOrderDefault); // Bitmap info flags
    
    CGContextDrawImage(contextRef, CGRectMake(0, 0, cols, rows), image.CGImage);
    CGContextRelease(contextRef);
    
    return cvMat;
}

// After the processing we need to convert it back to UIImage. The code below can handle both gray-scale and color image conversions (determined by the number of channels in the if statement).

// cv::Mat greyMat;
// cv::cvtColor(inputMat, greyMat, CV_BGR2GRAY);

// After the processing we need to convert it back to UIImage.

+ (UIImage*) UIImageFromCVMat: (cv::Mat) cvMat
{
    NSData *data = [NSData dataWithBytes:cvMat.data length:cvMat.elemSize()*cvMat.total()];
    CGColorSpaceRef colorSpace;
    
    if (cvMat.elemSize() == 1) {
        colorSpace = CGColorSpaceCreateDeviceGray();
    } else {
        colorSpace = CGColorSpaceCreateDeviceRGB();
    }
    
    CGDataProviderRef provider = CGDataProviderCreateWithCFData((__bridge CFDataRef)data);
    
    // Creating CGImage from cv::Mat
    CGImageRef imageRef = CGImageCreate(cvMat.cols,                                 //width
                                        cvMat.rows,                                 //height
                                        8,                                          //bits per component
                                        8 * cvMat.elemSize(),                       //bits per pixel
                                        cvMat.step[0],                            //bytesPerRow
                                        colorSpace,                                 //colorspace
                                        kCGImageAlphaNone|kCGBitmapByteOrderDefault,// bitmap info
                                        provider,                                   //CGDataProviderRef
                                        NULL,                                       //decode
                                        false,                                      //should interpolate
                                        kCGRenderingIntentDefault                   //intent
                                        );
    
    
    // Getting UIImage from CGImage
    UIImage *finalImage = [UIImage imageWithCGImage:imageRef];
    CGImageRelease(imageRef);
    CGDataProviderRelease(provider);
    CGColorSpaceRelease(colorSpace);
    
    return finalImage;
}

+ (UIImage *) callCPP: (UIImage*) image {
    CppUtils* utils = new CppUtils;
    return utils->makeGray(image);
}

+ (UIImage *) detectEyeIris: (UIImage*) image {
    EyeIrisDetector* detectEyeIris = new EyeIrisDetector;
    return detectEyeIris->detectEyeIris(image);
}

// MARK: - Interface to the FaceCoords

+ (int) frameWidth {
    return Coords->getFrameWidth();
}

+ (int) frameHeight {
    return Coords->getFrameHeight();
}

+ (NSArray*) face {
    return [self copyRectsToObjCArray: Coords->getFace()];
}

+ (NSArray*) leftEyeBorder {
    return [self copyToObjCArray: Coords->getLeftEyeBorder()];
}

+ (NSArray*) rightEyeBorder {
    return [self copyToObjCArray: Coords->getRightEyeBorder()];
}

+ (NSArray*) leftIrisBorder {
    return [self copyToObjCArray: Coords->getLeftIrisBorder()];
}

+ (NSArray*) rightIrisBorder {
    return [self copyToObjCArray: Coords->getRightIrisBorder()];
}

+ (NSArray*) leftPupilBorder {
    return [self copyToObjCArray: Coords->getLeftPupilBorder()];
}

+ (NSArray*) rightPupilBorder {
    return [self copyToObjCArray: Coords->getRightPupilBorder()];
}

+ (void) didDrawFinish {
    Coords->cleanStorage();
}

+ (NSArray*) copyToObjCArray: (std::vector<cv::Point>) vec {
    NSMutableArray* x = [[NSMutableArray alloc] initWithCapacity: vec.size()];
    NSMutableArray* y = [[NSMutableArray alloc] initWithCapacity: vec.size()];
    for (int i = 0; i < vec.size(); i++) {
        [x addObject: @(vec[i].x)];
        [y addObject: @(vec[i].y)];
    }
    return @[x, y];
}

+ (NSArray*) copyRectsToObjCArray: (std::vector<cv::Rect>) vec {
    NSMutableArray* x = [[NSMutableArray alloc] initWithCapacity: vec.size()];
    NSMutableArray* y = [[NSMutableArray alloc] initWithCapacity: vec.size()];
    for (int i = 0; i < vec.size(); i++) {
        [x addObject: @(vec[i].x)];
        [y addObject: @(vec[i].y)];
    }
    return @[x, y];
}

// Scene Configuration property

+ (NSString*) irisImageName {
    return [NSString stringWithCString: Config->getIrisImageName().c_str()
                              encoding: [NSString defaultCStringEncoding]];
}

+ (BOOL) needEyesDrawing {
    return Config->getNeedFaceDrawing();
}

+ (void) setIrisImageName: (NSString*) _newValue {
    std::string str = std::string([_newValue UTF8String]);
    Config->setIrisImageName(str);
}

+ (void) setNeedEyesDrawing: (BOOL) _newValue {
    Config->setNeedEyesDrawing(_newValue);
}

@end

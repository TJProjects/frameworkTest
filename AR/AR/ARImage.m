//
//  ARImage.m
//  AR
//
//  Created by YangTengJiao on 2018/11/9.
//  Copyright © 2018年 YangTengJiao. All rights reserved.
//

#import "ARImage.h"

@implementation ARImage

+ (UIImage *)imageNamed:(NSString *)imgName {
    NSString *bundlePath = [[NSBundle mainBundle] pathForResource:BundleName ofType:@"bundle"];
    NSBundle *bundle = [NSBundle bundleWithPath:bundlePath];
    NSString *file = [bundle pathForResource:imgName ofType:@"tiff"];
    UIImage *img = [UIImage imageWithContentsOfFile:file];
    if (!img) {
        file = [bundle pathForResource:imgName ofType:@"png"];
        img = [UIImage imageWithContentsOfFile:file];
    }
    if (!img) {
        file = [bundle pathForResource:imgName ofType:@"@3xpng"];
        img = [UIImage imageWithContentsOfFile:file];
    }
    if (!img) {
        file = [bundle pathForResource:imgName ofType:@"@2xpng"];
        img = [UIImage imageWithContentsOfFile:file];
    }
    NSLog(@"%@ %lf %lf",file,img.size.width,img.size.height);
    return img;
}
+ (NSString *)getEzpPath:(NSString *)name {
    NSString *bundlePath = [[NSBundle mainBundle] pathForResource:BundleName ofType:@"bundle"];
    NSBundle *bundle = [NSBundle bundleWithPath:bundlePath];
    NSString *path = [bundle pathForResource:name ofType:@"ezp"];
    return path;
}
+ (NSString *)getGifPath:(NSString *)name {
    NSString *bundlePath = [[NSBundle mainBundle] pathForResource:BundleName ofType:@"bundle"];
    NSBundle *bundle = [NSBundle bundleWithPath:bundlePath];
    NSString *path = [bundle pathForResource:name ofType:@"gif"];
    return path;
}

@end

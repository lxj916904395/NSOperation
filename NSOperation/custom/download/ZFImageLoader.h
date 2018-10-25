//
//  ZFImageLoader.h
//  NSOperation
//
//  Created by zhongding on 2018/10/24.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef void(^CompleteHandleBlock)(UIImage *image,NSString *urlString);

@interface ZFImageLoader : NSObject

+ (instancetype)loader;

- (void)loadImageWithUrl:(NSString*)urlstring complement:(CompleteHandleBlock)complementBlock title:(NSString*)title;

@end


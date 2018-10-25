//
//  UIImageView+ImageCache.m
//  NSOperation
//
//  Created by zhongding on 2018/10/24.
//

#import "UIImageView+ImageCache.h"
#import "ZFImageLoader.h"

@implementation UIImageView (ImageCache)

- (void)zf_setImageWithURL:(NSString*)urlString title:(NSString*)title{
    
    self.image = nil;
    [[ZFImageLoader loader] loadImageWithUrl:urlString complement:^(UIImage *image, NSString *urlString) {
        if ( image) {
            self.image = image;
        }
    } title:title];
    
}


@end

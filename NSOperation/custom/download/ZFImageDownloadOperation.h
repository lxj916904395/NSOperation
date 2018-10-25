//
//  ZFImageDownloadOperation.h
//  NSOperation
//
//  Created by zhongding on 2018/10/24.
//

#import <Foundation/Foundation.h>

typedef void(^ZFCompleteHandle)(NSData *imageData,NSString *urlString);
typedef void(^ErrorBlock)(NSString *urlString);


@interface ZFImageDownloadOperation : NSOperation

- (instancetype)initWithUrl:(NSString *)url complementHandle:(ZFCompleteHandle)complementHandle title:(NSString*)title error:(ErrorBlock)errorBlock;

@end



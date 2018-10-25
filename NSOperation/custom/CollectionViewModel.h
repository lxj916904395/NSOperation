//
//  CollectionViewModel.h
//  NSOperation
//
//  Created by zhongding on 2018/10/24.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface CollectionViewModel : NSObject

- (void)loadData:(void(^)(NSArray *datas))block;

@end

@interface CollectionModel : NSObject

@property (nonatomic, copy) NSString  *imageUrl;
@property (nonatomic, copy) NSString  *title;
@property (nonatomic, copy) NSString  *money;
// 缓存下载的图片
@property (nonatomic, strong) UIImage *image;

@end

//
//  CollectionViewProxy.h
//  NSOperation
//
//  Created by zhongding on 2018/10/24.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#import "CollectionCell.h"
#import "CollectionViewModel.h"


static NSString *const iden = @"CollectionCell";

@interface CollectionViewProxy : NSObject<UICollectionViewDataSource,UICollectionViewDelegate>

@property(strong ,nonatomic) NSArray *datas;

@end

